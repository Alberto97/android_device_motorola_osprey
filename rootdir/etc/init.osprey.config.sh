#!/vendor/bin/sh

# Copyright (c) 2018 Alberto97
#
# Device configuration for osprey variants
#
PATH=/sbin:/vendor/sbin:/vendor/bin:/vendor/xbin
export PATH

carrier=`getprop ro.boot.carrier`
radio=`getprop ro.boot.radio`
sku=`getprop ro.boot.hardware.sku`
ram=`cat /sys/ram/size`

set_device_props ()
{
    setprop ro.build.product $1
}

set_device_name ()
{
    case $ram in
        # 1GB
        1024 )
            set_device_props $1
        ;;
        # 2GB
        * )
            set_device_props $2
        ;;
    esac
}

set_config_props ()
{
    case $sku in
        # Single SIM Devices
        XT154[0-2] )
            set_device_name "osprey_umts" "osprey_u2"

            setprop ro.telephony.default_network 9
        ;;
        # Dual SIM Devices
        XT154[3-4]|XT1550 )
            set_device_name "osprey_uds" "osprey_ud2"

            setprop persist.radio.force_get_pref 1
            setprop persist.radio.multisim.config dsds

            setprop ro.telephony.default_network 9
        ;;
        # CDMA Variants
        XT1548 )
            set_device_props "osprey_cdma"

            case $carrier in
                sprint )
                    setprop ro.cdma.home.operator.alpha Sprint
                    setprop ro.cdma.home.operator.numeric 310120
                ;;
                * )
                    setprop ro.cdma.home.operator.alpha "U.S. Cellular"
                    setprop ro.cdma.home.operator.numeric 311580
                ;;
            esac

            setprop ro.product.locale.region US
            setprop gsm.sim.operator.iso-country US
            setprop gsm.operator.iso-country US
            setprop ril.subscription.types "NV,RUIM"
            setprop ro.telephony.default_cdma_sub 0
            setprop ro.telephony.get_imsi_from_sim true
            setprop telephony.lteOnCdmaDevice 1

            setprop ro.telephony.default_network 8
        ;;
    esac

    case $radio in
        # ro.boot.hardware.sku is not populated on some XT1543 devices
        0x6 )
            set_device_name "osprey_uds" "osprey_ud2"

            setprop persist.radio.force_get_pref 1
            setprop persist.radio.multisim.config dsds

            setprop ro.telephony.default_network 9
        ;;
    esac
}

set_dalvik_props ()
{
    case $ram in
        # 1GB
        1024 )
            setprop dalvik.vm.heapstartsize "8m"
            setprop dalvik.vm.heapgrowthlimit "96m"
            setprop dalvik.vm.heapsize "256m"
            setprop dalvik.vm.heaptargetutilization "0.75"
            setprop dalvik.vm.heapminfree "2m"
            setprop dalvik.vm.heapmaxfree "8m"
        ;;
        # 2GB
        * )
            setprop dalvik.vm.heapstartsize "8m"
            setprop dalvik.vm.heapgrowthlimit "192m"
            setprop dalvik.vm.heapsize "512m"
            setprop dalvik.vm.heaptargetutilization "0.75"
            setprop dalvik.vm.heapminfree "512k"
            setprop dalvik.vm.heapmaxfree "8m"
        ;;
    esac
}

# Main
set_dalvik_props
set_config_props

return 0

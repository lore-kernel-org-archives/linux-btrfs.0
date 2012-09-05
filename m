Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:49589 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab2IER1o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Sep 2012 13:27:44 -0400
Message-ID: <50478BC9.1030409@libero.it>
Date: Wed, 05 Sep 2012 19:28:41 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Joeri Vanthienen <mail@joerivanthienen.be>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS thinks device is busy [kernel 3.5.3]
References: <CAPsrAuCxYz0jncrtEgcget0MskXxaQ_3UW6ywWNDdZcraEvcNg@mail.gmail.com>
In-Reply-To: <CAPsrAuCxYz0jncrtEgcget0MskXxaQ_3UW6ywWNDdZcraEvcNg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 09/05/2012 03:29 PM, Joeri Vanthienen wrote:
> Hi,
> I'm running OpenSuse 12.2 with kernel 3.5.3
> HBA= LSI 1068e using the MPTSAS driver (patched)
> (https://patchwork.kernel.org/patch/1379181/)
>
> SANOS1:/media # uname -a
> Linux SANOS1 3.5.3 #3 SMP Sun Sep 2 18:44:37 CEST 2012 x86_64 x86_64
> x86_64 GNU/Linux
>
> I've tried to simulate a disk replacement but it seems that now
> /dev/sdg is stuck in the btrfs pool (RAID10)
>
> SANOS1:/media # btrfs device scan
> Scanning for Btrfs filesystems
> ERROR: unable to scan the device '/dev/sdg' - Device or resource busy

Please could you send the strace of the command above ?

> I've ran the btrfs device delete missing command before.
> /dev/sdg is connected, but not mounted, is not in use and there is no
> scrub running.

I am not sure to have understood correctly: did you physically 
disconnected the device after or before you did "btrfs device delete ..." ?

When you do a "btrfs dev rem" btrfs moves all the data to the others 
disks, then it zeroes the superblock signature invaliding the devices. 
To do that btrfs needs to access the devices.

>
> ANOS1:/media # btrfs  device delete /dev/sdg /btrfs/
> ERROR: error removing the device '/dev/sdg' - No such file or directory
>
> SANOS1:/media # cat /etc/mtab /proc/mounts | grep btrfs
> /dev/sde /btrfs btrfs rw,noatime,space_cache,inode_
> cache 0 0
> /dev/sde /btrfs btrfs rw,noatime,space_cache,inode_cache 0 0
>
> SANOS1:/media # cat /etc/mtab /proc/mounts | grep /dev/sdg
> SANOS1:/media #
> SANOS1:/media # lsof /dev/sdg
> SANOS1:/media #
>
>
> SANOS1:/media # btrfs filesystem show
> Label: 'firstpool'  uuid: 517e8cfa-4275-4589-8da4-6a46ad613daa
>          Total devices 13 FS bytes used 242.82GB
>          devid    3 size 931.51GB used 90.28GB path /dev/sdg
>          devid   14 size 931.51GB used 91.33GB path /dev/sdr
>          devid   13 size 931.51GB used 90.50GB path /dev/sdq
>          devid   12 size 931.51GB used 90.50GB path /dev/sdp
>          devid   11 size 931.51GB used 90.50GB path /dev/sdo
>          devid   10 size 931.51GB used 90.50GB path /dev/sdn
>          devid    9 size 931.51GB used 90.50GB path /dev/sdm
>          devid    8 size 931.51GB used 90.50GB path /dev/sdl
>          devid    7 size 931.51GB used 91.50GB path /dev/sdk
>          devid    6 size 931.51GB used 91.49GB path /dev/sdj
>          devid    5 size 931.51GB used 91.33GB path /dev/sdi
>          devid    4 size 931.51GB used 91.50GB path /dev/sdh
>          devid    2 size 931.51GB used 91.33GB path /dev/sdf
>          devid    1 size 931.51GB used 90.52GB path /dev/sde

The output of the command above is wrong: 14 devices are listed, but 
btrfs report that only 13 devices are used. Please do a sync before the 
command "btrfs filesystem show"


> Also tried to again remove (physical) the disk drive, but the result
> is the same.
> dmesg:
> [92728.516346] device label firstpool devid 1 transid 31965 /dev/sde
> [92728.516378] device label firstpool devid 2 transid 31965 /dev/sdf
> [92728.516406] device label firstpool devid 4 transid 31965 /dev/sdh
> [92728.516432] device label firstpool devid 5 transid 31965 /dev/sdi
> [92728.516458] device label firstpool devid 6 transid 31965 /dev/sdj
> [92728.516484] device label firstpool devid 7 transid 31965 /dev/sdk
> [92728.516510] device label firstpool devid 8 transid 31965 /dev/sdl
> [92728.516535] device label firstpool devid 9 transid 31965 /dev/sdm
> [92728.516589] device label firstpool devid 10 transid 31965 /dev/sdn
> [92728.516617] device label firstpool devid 11 transid 31965 /dev/sdo
> [92728.516643] device label firstpool devid 12 transid 31965 /dev/sdp
> [92728.516669] device label firstpool devid 13 transid 31965 /dev/sdq
> [92728.516695] device label firstpool devid 14 transid 31965 /dev/sdr
> [92728.551786] device label firstpool devid 3 transid 31490 /dev/sdg
> [92750.177157]  end_device-4:0:19: mptsas: ioc0: removing sata device:
> fw_channel 0, fw_id 12, phy 12,sas_addr 0x50030480008a364c
> [92750.177163]  phy-4:0:20: mptsas: ioc0: delete phy 12, phy-obj
> (0xffff8803ab81d400)
> [92750.177170]  port-4:0:19: mptsas: ioc0: delete port 19, sas_addr
> (0x50030480008a364c)
> [92750.178149] sd 4:0:18:0: [sdg] Synchronizing SCSI cache
> [92750.178326] sd 4:0:18:0: [sdg]
> [92750.178331] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [92750.178441] scsi target4:0:18: mptsas: ioc0: delete device:
> fw_channel 0, fw_id 12, phy 12, sas_addr 0x50030480008a364c
> [92766.761077] mptsas: ioc0: attaching sata device: fw_channel 0,
> fw_id 12, phy 12, sas_addr 0x50030480008a364c
> [92766.764242] scsi 4:0:19:0: Direct-Access     ATA      WDC
> WD1002FBYS-0 0C06 PQ: 0 ANSI: 5
> [92766.766302] sd 4:0:19:0: Attached scsi generic sg6 type 0
> [92766.769374] sd 4:0:19:0: [sdg] 1953525168 512-byte logical blocks:
> (1.00 TB/931 GiB)
> [92766.778433] sd 4:0:19:0: [sdg] Write Protect is off
> [92766.778438] sd 4:0:19:0: [sdg] Mode Sense: 73 00 00 08
> [92766.780583] sd 4:0:19:0: [sdg] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [92766.797777]  sdg:
> [92766.813296] sd 4:0:19:0: [sdg] Attached SCSI disk
> [92773.288107] device label singleBTRFS devid 1 transid 43 /dev/sdc
> [92773.288807] device label firstpool devid 1 transid 31967 /dev/sde
> [92773.288845] device label firstpool devid 2 transid 31967 /dev/sdf
> [92773.288877] device label firstpool devid 4 transid 31967 /dev/sdh
> [92773.288904] device label firstpool devid 5 transid 31967 /dev/sdi
> [92773.288927] device label firstpool devid 6 transid 31967 /dev/sdj
> [92773.288949] device label firstpool devid 7 transid 31967 /dev/sdk
> [92773.288971] device label firstpool devid 8 transid 31967 /dev/sdl
> [92773.288993] device label firstpool devid 9 transid 31967 /dev/sdm
> [92773.289014] device label firstpool devid 10 transid 31967 /dev/sdn
> [92773.289036] device label firstpool devid 11 transid 31967 /dev/sdo
> [92773.289058] device label firstpool devid 12 transid 31967 /dev/sdp
> [92773.289080] device label firstpool devid 13 transid 31967 /dev/sdq
> [92773.289102] device label firstpool devid 14 transid 31967 /dev/sdr
> [92773.313675] device label firstpool devid 3 transid 31490 /dev/sdg
>
> Can someone help me?
>
>
> It seems there is still some btrfs structure on the disk. Is this the
> cause of the error? Why can't BTRFS rebuild this "online"?

It seems that BTRFS was never aware of the /dev/sdg disconnection....

>
> SANOS1:/media # btrfs-find-root /dev/sdg | head
> ERROR: unable to scan the device '/dev/sdg' - Device or resource busy
> Well block 905192472576 seems great, but generation doesn't match,
> have=31490, want=32015
> Super think's the tree root is at 906491981824, chunk root 628100251648
> Generation: 31490 Root bytenr: 905192484864 Root objectid: 2
> Generation: 31490 Root bytenr: 905543114752 Root objectid: 4
> Generation: 31490 Root bytenr: 905641820160 Root objectid: 5
> Generation: 31490 Root bytenr: 905689354240 Root objectid: 7
> Generation: 31490 Root bytenr: 905688096768 Root objectid: 554
> Generation: 31490 Root bytenr: 905687691264 Root objectid: 561
> Generation: 31490 Root bytenr: 905642328064 Root objectid: 565
> Generation: 31490 Root bytenr: 905642332160 Root objectid: 566
> Generation: 31490 Root bytenr: 905678802944 Root objectid: 568
> Couldn't map the block 433225728
> Well block 905192542208 seems great, but generation doesn't match,
> have=31416, want=32015

Pay attention that when a device is removed, the superblock signature is 
zeroed to mark the device as not valid any more. So the generation of a 
removed device doesn't make sense.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
>


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:43963 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbcEBSnK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 14:43:10 -0400
Date: Mon, 2 May 2016 21:43:05 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID6, errors at missing device replacement
Message-ID: <20160502184305.GL21960@jeknote.loshitsa1.net>
References: <CAKWEGV65rRmpuRnUejCqVpdS+S5nbzrQnFAdy+y3X5EYZJgqpw@mail.gmail.com>
 <pan$8aea5$883c2a2a$18248a42$c1560bd9@cox.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mxv5cy4qt+RJ9ypb"
In-Reply-To: <pan$8aea5$883c2a2a$18248a42$c1560bd9@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 16, 2016 at 07:37:48AM +0000, Duncan wrote:
> Yauhen Kharuzhy posted on Fri, 15 Apr 2016 12:49:36 -0700 as excerpted:
> 
> > I have discovered case when replacement of missing devices causes
> > metadata corruption. Does anybody know anything about this?
> > 
> > I use 4.4.5 kernel with latest global spare patches.
> > 
> > If we have RAID6 (may be reproducible on RAID5 too) and try to replace
> > one missing drive by other and after this try to remove another drive
> > and replace it, plenty of errors are shown in the log:

I have reproduced this with vanilla 4.6-rc4 kernel and RAID5.

Script used to reproduce is attached, run as "./test-replace.sh <mount point> <disk1 disk2...>"

Kernel log:

[  402.878389] BTRFS: device fsid eabede3e-1e50-46cd-92ec-f9476b321f63 devid 1 transid 3 /dev/sdc
[  402.911820] BTRFS: device fsid eabede3e-1e50-46cd-92ec-f9476b321f63 devid 2 transid 3 /dev/sdd
[  402.972031] BTRFS: device fsid eabede3e-1e50-46cd-92ec-f9476b321f63 devid 3 transid 3 /dev/sde
[  403.020067] BTRFS: device fsid eabede3e-1e50-46cd-92ec-f9476b321f63 devid 4 transid 3 /dev/sdf
[  404.042312] BTRFS info (device sdf): disk space caching is enabled
[  404.051338] BTRFS: has skinny extents
[  404.056805] BTRFS: flagging fs with big metadata feature
[  404.149815] BTRFS: creating UUID tree
[  407.321146] sd 5:0:0:0: [sdf] Synchronizing SCSI cache
[  407.349530] sd 5:0:0:0: [sdf] Stopping disk
[  407.376682] ata6.00: disabled
[  407.695945] BTRFS error (device sdf): bdev /dev/sdf errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
[  407.703760] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
[  407.726179] BTRFS error (device sdf): bdev /dev/sdf errs: wr 1, rd 0, flush 1, corrupt 0, gen 0
[  407.733718] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
[  407.739873] BTRFS error (device sdf): bdev /dev/sdf errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
[  410.631220] ata6: hard resetting link
[  411.041672] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  411.090105] ata6.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[  411.153739] ata6.00: 16777216 sectors, multi 128: LBA48 NCQ (depth 31/32)
[  411.189534] ata6.00: configured for UDMA/133
[  411.225526] ata6: EH complete
[  411.229002] scsi 5:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
[  411.278584] sd 5:0:0:0: [sdg] 16777216 512-byte logical blocks: (8.59 GB/8.00 GiB)
[  411.297341] sd 5:0:0:0: [sdg] Write Protect is off
[  411.300054] sd 5:0:0:0: Attached scsi generic sg5 type 0
[  411.350875] sd 5:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  411.371402] sd 5:0:0:0: [sdg] Attached SCSI disk
[  413.663624] BTRFS error (device sdf): bdev /dev/sdf errs: wr 2, rd 0, flush 2, corrupt 0, gen 0
[  413.714417] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
[  413.719450] BTRFS error (device sdf): bdev /dev/sdf errs: wr 3, rd 0, flush 2, corrupt 0, gen 0
[  413.728705] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
[  413.734030] BTRFS error (device sdf): bdev /dev/sdf errs: wr 4, rd 0, flush 2, corrupt 0, gen 0
[  413.841946] BTRFS info (device sde): allowing degraded mounts
[  413.848622] BTRFS info (device sde): disk space caching is enabled
[  413.877470] BTRFS: has skinny extents
[  413.942027] BTRFS info (device sde): bdev /dev/sdf errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
[  414.076571] BTRFS info (device sde): dev_replace from <missing disk> (devid 4) to /dev/sdg started
[  420.402126] BTRFS info (device sde): dev_replace from <missing disk> (devid 4) to /dev/sdg finished
[  420.646768] sd 4:0:0:0: [sde] Synchronizing SCSI cache
[  420.653786] sd 4:0:0:0: [sde] Stopping disk
[  420.707224] ata5.00: disabled
[  420.991219] BTRFS error (device sde): bdev /dev/sde errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
[  421.006803] BTRFS warning (device sde): lost page write due to IO error on /dev/sde
[  421.013813] BTRFS error (device sde): bdev /dev/sde errs: wr 1, rd 0, flush 1, corrupt 0, gen 0
[  421.022001] BTRFS warning (device sde): lost page write due to IO error on /dev/sde
[  421.032855] BTRFS error (device sde): bdev /dev/sde errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
[  423.943549] ata5: hard resetting link
[  424.264086] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  424.270354] ata5.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[  424.303915] ata5.00: 41943040 sectors, multi 128: LBA48 NCQ (depth 31/32)
[  424.312418] ata5.00: configured for UDMA/133
[  424.317876] ata5: EH complete
[  424.346139] scsi 4:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
[  424.389067] sd 4:0:0:0: [sdf] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
[  424.389110] sd 4:0:0:0: Attached scsi generic sg4 type 0
[  424.453500] sd 4:0:0:0: [sdf] Write Protect is off
[  424.460923] sd 4:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  424.526381] sd 4:0:0:0: [sdf] Attached SCSI disk
[  426.636182] BTRFS error (device sde): bdev /dev/sde errs: wr 2, rd 0, flush 2, corrupt 0, gen 0
[  426.641741] BTRFS warning (device sde): lost page write due to IO error on /dev/sde
[  426.691659] BTRFS error (device sde): bdev /dev/sde errs: wr 3, rd 0, flush 2, corrupt 0, gen 0
[  426.698723] BTRFS warning (device sde): lost page write due to IO error on /dev/sde
[  426.710799] BTRFS error (device sde): bdev /dev/sde errs: wr 4, rd 0, flush 2, corrupt 0, gen 0
[  426.834307] BTRFS info (device sdg): allowing degraded mounts
[  426.842495] BTRFS info (device sdg): disk space caching is enabled
[  426.860045] BTRFS: has skinny extents
[  426.875105] BTRFS info (device sdg): bdev /dev/sdg errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
[  426.886143] BTRFS info (device sdg): bdev /dev/sde errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
[  427.146338] BTRFS info (device sdg): dev_replace from <missing disk> (devid 3) to /dev/sdf started
[  427.936021] BTRFS error (device sdg): failed to rebuild valid logical 3279355904 for dev /dev/sde
[  428.076806] BTRFS error (device sdg): failed to rebuild valid logical 3267567616 for dev /dev/sde
[  428.189681] BTRFS error (device sdg): failed to rebuild valid logical 3277004800 for dev /dev/sde
[  428.768747] BTRFS error (device sdg): failed to rebuild valid logical 3279372288 for dev /dev/sde
[  429.411867] BTRFS error (device sdg): failed to rebuild valid logical 3269947392 for dev /dev/sde
[  429.438711] BTRFS error (device sdg): failed to rebuild valid logical 3271520256 for dev /dev/sde
[  429.499210] BTRFS error (device sdg): failed to rebuild valid logical 3268378624 for dev /dev/sde
[  429.870200] BTRFS error (device sdg): failed to rebuild valid logical 3276255232 for dev /dev/sde
[  429.967750] BTRFS error (device sdg): failed to rebuild valid logical 3266834432 for dev /dev/sde
[  430.028623] BTRFS error (device sdg): failed to rebuild valid logical 3274698752 for dev /dev/sde
[  430.488825] BTRFS info (device sdg): dev_replace from <missing disk> (devid 3) to /dev/sdf finished
[  430.620438] sd 3:0:0:0: [sdd] Synchronizing SCSI cache
[  430.692664] sd 3:0:0:0: [sdd] Stopping disk
[  430.760882] ata4.00: disabled
[  430.958960] BTRFS error (device sdg): bdev /dev/sdd errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
[  430.982233] BTRFS warning (device sdg): lost page write due to IO error on /dev/sdd
[  430.999441] BTRFS error (device sdg): bdev /dev/sdd errs: wr 1, rd 0, flush 1, corrupt 0, gen 0
[  431.036540] BTRFS warning (device sdg): lost page write due to IO error on /dev/sdd
[  431.074314] BTRFS error (device sdg): bdev /dev/sdd errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
[  433.961963] ata4: hard resetting link
[  434.287424] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  434.292584] ata4.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[  434.302767] ata4.00: 41943040 sectors, multi 128: LBA48 NCQ (depth 31/32)
[  434.342383] ata4.00: configured for UDMA/133
[  434.354685] ata4: EH complete
[  434.364789] scsi 3:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
[  434.440122] sd 3:0:0:0: Attached scsi generic sg3 type 0
[  434.448358] sd 3:0:0:0: [sde] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
[  434.448481] sd 3:0:0:0: [sde] Write Protect is off
[  434.448517] sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  434.589187] sd 3:0:0:0: [sde] Attached SCSI disk
[  436.639464] BTRFS error (device sdg): bdev /dev/sdd errs: wr 2, rd 0, flush 2, corrupt 0, gen 0
[  436.701947] BTRFS warning (device sdg): lost page write due to IO error on /dev/sdd
[  436.713283] BTRFS error (device sdg): bdev /dev/sdd errs: wr 3, rd 0, flush 2, corrupt 0, gen 0
[  436.723682] BTRFS warning (device sdg): lost page write due to IO error on /dev/sdd
[  436.731662] BTRFS error (device sdg): bdev /dev/sdd errs: wr 4, rd 0, flush 2, corrupt 0, gen 0
[  436.761114] BTRFS error (device sdg): bdev /dev/sdd errs: wr 4, rd 0, flush 3, corrupt 0, gen 0
[  436.783619] BTRFS warning (device sdg): lost page write due to IO error on /dev/sdd
[  436.790353] BTRFS error (device sdg): bdev /dev/sdd errs: wr 5, rd 0, flush 3, corrupt 0, gen 0
[  436.828784] BTRFS warning (device sdg): lost page write due to IO error on /dev/sdd
[  436.840279] BTRFS error (device sdg): bdev /dev/sdd errs: wr 6, rd 0, flush 3, corrupt 0, gen 0
[  436.963086] BTRFS info (device sdf): allowing degraded mounts
[  436.977520] BTRFS info (device sdf): disk space caching is enabled
[  436.982720] BTRFS: has skinny extents
[  436.998246] BTRFS info (device sdf): bdev /dev/sdf errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
[  437.023059] BTRFS info (device sdf): bdev /dev/sdg errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
[  437.040400] BTRFS info (device sdf): bdev /dev/sdd errs: wr 4, rd 0, flush 2, corrupt 0, gen 0
[  437.241595] BTRFS info (device sdf): dev_replace from <missing disk> (devid 2) to /dev/sde started
[  438.185590] scrub_missing_raid56_worker: 2 callbacks suppressed
[  438.188229] BTRFS error (device sdf): failed to rebuild valid logical 3279421440 for dev /dev/sdd
[  438.300493] BTRFS error (device sdf): failed to rebuild valid logical 3267633152 for dev /dev/sdd
[  438.703672] BTRFS error (device sdf): failed to rebuild valid logical 3277070336 for dev /dev/sdd
[  439.157045] BTRFS error (device sdf): failed to rebuild valid logical 3279437824 for dev /dev/sdd
[  439.373168] BTRFS error (device sdf): failed to rebuild valid logical 3270012928 for dev /dev/sdd
[  439.423270] BTRFS error (device sdf): failed to rebuild valid logical 3271585792 for dev /dev/sdd
[  439.601332] BTRFS error (device sdf): failed to rebuild valid logical 3268444160 for dev /dev/sdd
[  440.043626] BTRFS error (device sdf): failed to rebuild valid logical 3276320768 for dev /dev/sdd
[  440.205525] BTRFS error (device sdf): failed to rebuild valid logical 3266899968 for dev /dev/sdd
[  440.249055] BTRFS error (device sdf): failed to rebuild valid logical 3274764288 for dev /dev/sdd
[  440.351454] BTRFS info (device sdf): dev_replace from <missing disk> (devid 2) to /dev/sde finished


-- 
Yauhen Kharuzhy

--mxv5cy4qt+RJ9ypb
Content-Type: application/x-sh
Content-Disposition: attachment; filename="test-replace.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0AMNT=3D$1=0Ashift=0ADISKS=3D( $@ )=0A=0Adev_removed=3D0=0Ar=
emoved_dev_htl=3D""=0Adev=3D""=0A=0A_fail () {=0A	echo $@=0A	_cleanup=0A	ex=
it 1=0A}=0A=0A# arg 1 is dev to remove and is output of the below eg.=0A# l=
s -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev=0A_devmgt_remove()=
=0A{=0A	local lun=3D$1=0A	local disk=3D$2=0A=0A	echo 1 > /sys/class/scsi_de=
vice/${lun}/device/delete || _fail "Remove disk failed"=0A=0A	stat $disk > =
/dev/null 2>&1=0A	while [ $? -eq 0 ]; do=0A		sleep 1=0A		stat $disk > /dev/=
null 2>&1=0A	done=0A}=0A=0A# arg 1 is dev to add and is output of the below=
 eg.=0A# ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev=0A_devmgt=
_add()=0A{=0A	local h=0A	local tdl=0A	local i=0A	local j=0A	# arg 1 will be=
 in h:t:d:l format now in the h and "t d l" format=0A	h=3D`echo ${1} | cut =
-d":" -f 1`=0A	tdl=3D`echo ${1} | cut -d":" -f 2-|sed 's/:/ /g'`=0A=0A	echo=
 ${tdl} >  /sys/class/scsi_host/host${h}/scan || _fail "Add disk failed"=0A=
=0A	# ensure the device comes online=0A	dev_back_oneline=3D0=0A	for i in `s=
eq 1 10`; do=0A		if [ -d /sys/class/scsi_device/${1}/device/block ]; then=
=0A			dev=3D`ls /sys/class/scsi_device/${1}/device/block`=0A			for j in `se=
q 1 10`;=0A			do=0A				stat /dev/$dev > /dev/null 2>&1=0A				if [ $? -eq 0 =
]; then=0A					dev_back_oneline=3D1=0A					break=0A				fi=0A				sleep 1=0A	=
		done=0A			break=0A		else=0A			sleep 1=0A		fi=0A	done=0A	if [ $dev_back_on=
eline -eq 0 ]; then=0A		echo "/dev/$dev online failed"=0A	else=0A		echo "/d=
ev/$dev is back online"=0A	fi=0A}=0A=0A=0A=0A=0Atrap "_cleanup; exit \$stat=
us" 0 1 2 3 15=0A=0A_cleanup() {=0A	umount $MNT >/dev/null 2>&1=0A=0A	if [ =
$dev_removed =3D=3D 1 ]; then=0A		_devmgt_add "${removed_dev_htl}"=0A	fi=0A=
}=0A=0A=0A=0Await_for() {=0A	cmd=3D$1=0A	substr=3D$2=0A	interval=3D$3=0A=0A=
	if [ -z "$interval" ]; then=0A		interval=3D1=0A	fi=0A=0A	echo -n "Waiting =
for '$substr' in output of '$cmd' command..."=0A=0A	while ! ($cmd | grep -q=
 -e "$substr"); do=0A		[ $interval -gt 0 ] && sleep $interval=0A	done=0A	ec=
ho " found"=0A}=0A=0A=0Aif [ $# -lt 2 ]; then=0A	echo "Usage: $0 <FS mountp=
oint> <disks>" >&2=0A	exit 1;=0Afi=0A=0An=3D${#DISKS[@]}=0A=0Aumount $MNT >=
/dev/null 2>&1=0A=0Aecho "${DISKS[@]} -> $MNT"=0A=0Afor i in ${DISKS[@]}; d=
o=0A	wipefs -a $i >/dev/null 2>&1=0Adone=0A=0A# Create FS=0Amkfs.btrfs -d r=
aid5 -m raid5 ${DISKS[@]}=0A=0Amount ${DISKS[0]} $MNT=0Add if=3D/dev/zero o=
f=3D$MNT/test.dat bs=3D10M count=3D4=0Async=0A=0Afor i in `seq $n -1 $((n-2=
))`; do=0A	d=3D`basename ${DISKS[$((i-1))]}`=0A=0A	echo "Remove $d"=0A=0A	r=
emoved_dev_htl=3D`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev=
`=0A	_devmgt_remove ${removed_dev_htl} ${failed_disk}=0A	dev_removed=3D1=0A=
	btrfs fi sync $MNT=0A	sleep 3=0A#	wait_for "btrfs fi show $MNT" "degraded"=
=0A=0A	echo "Insert $d"=0A=0A	_devmgt_add "${removed_dev_htl}"=0A	d=3D$dev=
=0A	dev_removed=3D0=0A=0A	sleep 1=0A=0A	wipefs -a /dev/$d=0A=0A	umount $MNT=
=0A	mount -o degraded ${DISKS[0]} $MNT || exit 1=0A=0A	echo "Start replacin=
g DEVID $i by /dev/$d"=0A=0A	btrfs replace start -B $i /dev/$d $MNT=0A	echo=
 "Replace finished"=0A=0A#	btrfs fi sync $MNT=0A#	umount $MNT=0A#	rmmod btr=
fs=0A#	modprobe btrfs=0A#	btrfs device scan=0A#	mount -o degraded ${DISKS[0=
]} $MNT || exit 1=0A=0A#	btrfs balance start $MNT=0A#	echo "Balance finishe=
d"=0Adone=0A=0Aecho "Done."=0A
--mxv5cy4qt+RJ9ypb--

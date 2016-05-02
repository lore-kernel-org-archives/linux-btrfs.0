Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:44091 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbcEBTTZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 15:19:25 -0400
Date: Mon, 2 May 2016 22:19:21 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID6, errors at missing device replacement
Message-ID: <20160502191921.GA13612@jeknote.loshitsa1.net>
References: <CAKWEGV65rRmpuRnUejCqVpdS+S5nbzrQnFAdy+y3X5EYZJgqpw@mail.gmail.com>
 <pan$8aea5$883c2a2a$18248a42$c1560bd9@cox.net>
 <20160502184305.GL21960@jeknote.loshitsa1.net>
 <CAJCQCtRNK9-29DnkKfCCOjygXc7p++kobexs2DamFN5LviWn_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRNK9-29DnkKfCCOjygXc7p++kobexs2DamFN5LviWn_Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 02, 2016 at 01:04:30PM -0600, Chris Murphy wrote:
> On Mon, May 2, 2016 at 12:43 PM, Yauhen Kharuzhy
> <yauhen.kharuzhy@zavadatar.com> wrote:
> > On Sat, Apr 16, 2016 at 07:37:48AM +0000, Duncan wrote:
> >> Yauhen Kharuzhy posted on Fri, 15 Apr 2016 12:49:36 -0700 as excerpted:
> >>
> >> > I have discovered case when replacement of missing devices causes
> >> > metadata corruption. Does anybody know anything about this?
> >> >
> >> > I use 4.4.5 kernel with latest global spare patches.
> >> >
> >> > If we have RAID6 (may be reproducible on RAID5 too) and try to replace
> >> > one missing drive by other and after this try to remove another drive
> >> > and replace it, plenty of errors are shown in the log:
> >
> > I have reproduced this with vanilla 4.6-rc4 kernel and RAID5.
> >
> > Script used to reproduce is attached, run as "./test-replace.sh <mount point> <disk1 disk2...>"
> >
> > Kernel log:
> >
> > [  402.878389] BTRFS: device fsid eabede3e-1e50-46cd-92ec-f9476b321f63 devid 1 transid 3 /dev/sdc
> > [  402.911820] BTRFS: device fsid eabede3e-1e50-46cd-92ec-f9476b321f63 devid 2 transid 3 /dev/sdd
> > [  402.972031] BTRFS: device fsid eabede3e-1e50-46cd-92ec-f9476b321f63 devid 3 transid 3 /dev/sde
> > [  403.020067] BTRFS: device fsid eabede3e-1e50-46cd-92ec-f9476b321f63 devid 4 transid 3 /dev/sdf
> > [  404.042312] BTRFS info (device sdf): disk space caching is enabled
> > [  404.051338] BTRFS: has skinny extents
> > [  404.056805] BTRFS: flagging fs with big metadata feature
> > [  404.149815] BTRFS: creating UUID tree
> > [  407.321146] sd 5:0:0:0: [sdf] Synchronizing SCSI cache
> > [  407.349530] sd 5:0:0:0: [sdf] Stopping disk
> > [  407.376682] ata6.00: disabled
> 
> Why is ata6 disabled?

To emulate of failed drive, I detach it from SCSI host (see script) by
'echo 1 > /sys/class/scsi_device/<dev>/device/delete' command.

> 
> > [  407.695945] BTRFS error (device sdf): bdev /dev/sdf errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
> > [  407.703760] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
> > [  407.726179] BTRFS error (device sdf): bdev /dev/sdf errs: wr 1, rd 0, flush 1, corrupt 0, gen 0
> > [  407.733718] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
> > [  407.739873] BTRFS error (device sdf): bdev /dev/sdf errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
> > [  410.631220] ata6: hard resetting link
> 
> And now reset?
> 
> 
> > [  411.041672] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [  411.090105] ata6.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
> > [  411.153739] ata6.00: 16777216 sectors, multi 128: LBA48 NCQ (depth 31/32)
> > [  411.189534] ata6.00: configured for UDMA/133
> > [  411.225526] ata6: EH complete
> > [  411.229002] scsi 5:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
> > [  411.278584] sd 5:0:0:0: [sdg] 16777216 512-byte logical blocks: (8.59 GB/8.00 GiB)
> 
> sd 5:0:0:0 was sdf but now it's sdg

Yes, I reinserted drive again, wipe btrfs from it, and start
replace of missing device by it. sdf block device will be released by
btrfs at unmount (without Anand's global spare patchset there is no way
to close failed or removed device and make it missing).

> 
> 
> 
> > [  411.297341] sd 5:0:0:0: [sdg] Write Protect is off
> > [  411.300054] sd 5:0:0:0: Attached scsi generic sg5 type 0
> > [  411.350875] sd 5:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > [  411.371402] sd 5:0:0:0: [sdg] Attached SCSI disk
> > [  413.663624] BTRFS error (device sdf): bdev /dev/sdf errs: wr 2, rd 0, flush 2, corrupt 0, gen 0
> > [  413.714417] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
> > [  413.719450] BTRFS error (device sdf): bdev /dev/sdf errs: wr 3, rd 0, flush 2, corrupt 0, gen 0
> > [  413.728705] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
> > [  413.734030] BTRFS error (device sdf): bdev /dev/sdf errs: wr 4, rd 0, flush 2, corrupt 0, gen 0
> > [  413.841946] BTRFS info (device sde): allowing degraded mounts
> > [  413.848622] BTRFS info (device sde): disk space caching is enabled
> > [  413.877470] BTRFS: has skinny extents
> > [  413.942027] BTRFS info (device sde): bdev /dev/sdf errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
> > [  414.076571] BTRFS info (device sde): dev_replace from <missing disk> (devid 4) to /dev/sdg started
> > [  420.402126] BTRFS info (device sde): dev_replace from <missing disk> (devid 4) to /dev/sdg finished
> > [  420.646768] sd 4:0:0:0: [sde] Synchronizing SCSI cache
> > [  420.653786] sd 4:0:0:0: [sde] Stopping disk
> > [  420.707224] ata5.00: disabled
> 
> sde is stopped? ata5 is disabled

Second replace, 'failed to rebuild logical...' messages appear only at
sencond replace of another device than in first replace.

> 
> > [  420.991219] BTRFS error (device sde): bdev /dev/sde errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
> > [  421.006803] BTRFS warning (device sde): lost page write due to IO error on /dev/sde
> > [  421.013813] BTRFS error (device sde): bdev /dev/sde errs: wr 1, rd 0, flush 1, corrupt 0, gen 0
> > [  421.022001] BTRFS warning (device sde): lost page write due to IO error on /dev/sde
> > [  421.032855] BTRFS error (device sde): bdev /dev/sde errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
> > [  423.943549] ata5: hard resetting link
> 
> and now reset
> 
> 
> > [  424.264086] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [  424.270354] ata5.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
> > [  424.303915] ata5.00: 41943040 sectors, multi 128: LBA48 NCQ (depth 31/32)
> > [  424.312418] ata5.00: configured for UDMA/133
> > [  424.317876] ata5: EH complete
> > [  424.346139] scsi 4:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
> > [  424.389067] sd 4:0:0:0: [sdf] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
> > [  424.389110] sd 4:0:0:0: Attached scsi generic sg4 type 0
> > [  424.453500] sd 4:0:0:0: [sdf] Write Protect is off
> 
> sd 4:0:0:0: was sde now it's sdf
> 
> 
> I think there's another bug here instigating all of this. I'm not sure
> it's a Btrfs bug at all.

-- 
Yauhen Kharuzhy

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f53.google.com ([209.85.216.53]:36763 "EHLO
	mail-vn0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbFVQDZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 12:03:25 -0400
Received: by vnbg1 with SMTP id g1so8723472vnb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2015 09:03:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi757StwNda-8y-zvjB-8cVrWLd=R8xuZnvzdwhhmxbTuXw@mail.gmail.com>
References: <556457b8.e72b980a.ee08.ffffce60@mx.google.com>
	<CAJCQCtQFyCEn3kdeYOrOyk_vqekNH_MiOyA=WSOxLCoQS6PV1w@mail.gmail.com>
	<CAGqmi75OK8ofM7p0SqUsy8WhW3ZveQ_3NMtQCAchmHnUP7KoPg@mail.gmail.com>
	<CAGqmi757StwNda-8y-zvjB-8cVrWLd=R8xuZnvzdwhhmxbTuXw@mail.gmail.com>
Date: Mon, 22 Jun 2015 10:03:24 -0600
Message-ID: <CAJCQCtROb83vdCcv=GHG+eOB99u+LAgSUARPX0FedL8hn2Be2w@mail.gmail.com>
Subject: Re: RAID1: system stability
From: Chris Murphy <lists@colorremedies.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 5:35 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> Okay, logs, i did release disk /dev/sde1 and get:
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Read(10): 28 00 11 1d 69
> 00 00 00 08 00
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: blk_update_request: I/O
> error, dev sde, sector 287140096
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
> LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
> SubCode(0x0011) cb_idx mptscsih_io_done
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] FAILED
> Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] CDB:
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Read(10): 28 00 11 1d 69
> 00 00 00 08 00
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: blk_update_request: I/O
> error, dev sde, sector 287140096

So what's up with this? This only happens after you try to (software)
remove /dev/sde1? Or is it happening also before that? Because this
looks like some kind of hardware problem when the drive is reporting
an error for a particular sector on read, as if it's a bad sector.




> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Buffer I/O error on dev
> sde1, logical block 35892256, async page read
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
> LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
> SubCode(0x0011) cb_idx mptscsih_io_done
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
> LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
> SubCode(0x0011) cb_idx mptscsih_io_done
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] FAILED
> Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] CDB:
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Read(10): 28 00 11 1d 69
> 00 00 00 08 00
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: blk_update_request: I/O
> error, dev sde, sector 287140096

Again same sector as before. This is not a Btrfs error message, it's
coming from the block layer.


> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Buffer I/O error on dev
> sde1, logical block 35892256, async page read

I'm not a dev so take it with a grain of salt but because this
references a logical block, this is the layer in between Btrfs and the
physical device. Btrfs works on logical blocks and those have to be
translated to device and physical sector. Maybe what's happening is
there's confusion somewhere about this device not actually being
unavailable so Btrfs or something else is trying to read this logical
block again, which causes a read attempt to happen instead of a flat
out "this device doesn't exist" type of error. So I don't know if this
is a problem strictly in Btrfs missing device error handling, or if
there's something else that's not really working correctly.

You could test by physically removing the device, if you have hot plug
support (be certain all the hardware components support it), you can
see if you get different results. Or you could try to reproduce the
software delete of the device with mdraid or lvm raid with XFS and no
Btrfs at all, and see if you get different results.

It's known that the btrfs multiple device failure use case is weak
right now. Data isn't lost, but the error handling, notification, all
that is almost non-existent compared to mdadm.


> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
> LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
> SubCode(0x0011) cb_idx mptscsih_io_done
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
> LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
> SubCode(0x0011) cb_idx mptscsih_io_done
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] FAILED
> Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: sd 0:0:5:0: [sde] CDB:
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Read(10): 28 00 11 1d 69
> 00 00 00 08 00
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: blk_update_request: I/O
> error, dev sde, sector 287140096
> Jun 22 14:28:40 srv-lab-ceph-node-01 kernel: Buffer I/O error on dev
> sde1, logical block 35892256, async page read
> Jun 22 14:28:41 srv-lab-ceph-node-01 kernel: mptbase: ioc0:
> LogInfo(0x31010011): Originator={PL}, Code={Open Failure},
> SubCode(0x0011) cb_idx mptscsih_io_done
> Jun 22 14:28:41 srv-lab-ceph-node-01 kernel:  end_device-0:0:6:
> mptsas: ioc0: removing ssp device: fw_channel 0, fw_id 16, phy
> 5,sas_addr 0x5000cca00d0514bd
> Jun 22 14:28:41 srv-lab-ceph-node-01 kernel:  phy-0:0:9: mptsas: ioc0:
> delete phy 5, phy-obj (0xffff880449541400)
> Jun 22 14:28:41 srv-lab-ceph-node-01 kernel:  port-0:0:6: mptsas:
> ioc0: delete port 6, sas_addr (0x5000cca00d0514bd)
> Jun 22 14:28:41 srv-lab-ceph-node-01 kernel: scsi target0:0:5: mptsas:
> ioc0: delete device: fw_channel 0, fw_id 16, phy 5, sas_addr
> 0x5000cca00d0514bd

OK it looks like not until here does it actually get deleted (?) and
then that results in piles of write errors to this device by btrfs:


> Jun 22 14:28:44 srv-lab-ceph-node-01 kernel: BTRFS: lost page write
> due to I/O error on /dev/sde1
> Jun 22 14:28:44 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
> Jun 22 14:28:44 srv-lab-ceph-node-01 kernel: BTRFS: lost page write
> due to I/O error on /dev/sde1
> Jun 22 14:28:44 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
> Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
> Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
> Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
> Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
> Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
> Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
> Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
> Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 11, rd 0, flush 0, corrupt 0, gen 0
> Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 12, rd 0, flush 0, corrupt 0, gen 0
> Jun 22 14:29:13 srv-lab-ceph-node-01 kernel: BTRFS: bdev /dev/sde1
> errs: wr 13, rd 0, flush 0, corrupt 0, gen 0

So this makes sense in that it tries to write but can't because the
device is now missing. So it's a case of Btrfs not doing very well
handling suddenly missing device, I think.



> Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: BTRFS info (device
> md127): csum failed ino 1039 extent 390332416 csum 2059524288 wanted
> 343582415 mirror 0
> Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: BUG: unable to handle
> kernel paging request at ffff87fa7ff53430
> Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: IP: [<ffffffffc04709d9>]
> __btrfs_map_block+0x2d9/0x1180 [btrfs]
> Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: PGD 0
> Jun 22 14:29:22 srv-lab-ceph-node-01 kernel: Oops: 0000 [#1] SMP


And then oops. Not good. So yeah it's definitely a Btrfs bug that it
oopses instead of gracefully handling the failure. The question is
whether (and what) other mitigating circumstances contribute to this
bad handling, there may be other bugs that instigate this. I've tested
this in a ridiculously rudimentary way (with USB drives) just by
hanging them during usage, and I don't get an oops. But I do get piles
of read and or write errors and it seems Btrfs never really becomes
aware of the fact there's a missing device until there's a remount or
even a reboot. I haven't quantified what amount of data is lost, but
the file system itself still works degraded in this case with the
remaining drive (actually both drives work fine, but once they're each
written to separately with degraded mount option, they can't be
rejoined together; if you try it, serious fs corruption results.)

-- 
Chris Murphy
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bitfolk.com ([85.119.80.223]:34691 "EHLO mail.bitfolk.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbcBNWOF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 17:14:05 -0500
Received: from andy by mail.bitfolk.com with local (Exim 4.72)
	(envelope-from <andy@strugglers.net>)
	id 1aV4dg-0006H3-0g
	for linux-btrfs@vger.kernel.org; Sun, 14 Feb 2016 21:55:32 +0000
Date: Sun, 14 Feb 2016 21:55:31 +0000
From: Andy Smith <andy@strugglers.net>
To: linux-btrfs@vger.kernel.org
Subject: Problems with "btrfs dev remove" of dead disk
Message-ID: <20160214215531.GQ4290@bitfolk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

One of my drives died earlier in a fairly emphatic way in that not
only did it show IO errors and got removed as a device by the
kernel, but it was also making audible grinding/screeching noises
until I hot unplugged it.

Feb 14 18:29:36 specialbrew kernel: [27576156.070961] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
Feb 14 18:29:37 specialbrew kernel: [27576157.215312] ata6.00: hard resetting link
Feb 14 18:29:37 specialbrew kernel: [27576157.555369] ata6.00: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Feb 14 18:29:37 specialbrew kernel: [27576157.560028] ata6.01: hard resetting link
Feb 14 18:29:38 specialbrew kernel: [27576157.915797] ata6.01: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Feb 14 18:29:38 specialbrew kernel: [27576157.920591] ata6.02: hard resetting link
Feb 14 18:29:38 specialbrew kernel: [27576158.275759] ata6.02: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Feb 14 18:29:38 specialbrew kernel: [27576158.280603] ata6.03: hard resetting link
Feb 14 18:29:38 specialbrew kernel: [27576158.603658] ata6.03: SATA link down (SStatus 0 SControl 320)
Feb 14 18:29:38 specialbrew kernel: [27576158.608844] ata6.04: hard resetting link
Feb 14 18:29:39 specialbrew kernel: [27576158.947805] ata6.04: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Feb 14 18:29:39 specialbrew kernel: [27576158.953058] ata6.05: hard resetting link
Feb 14 18:29:39 specialbrew kernel: [27576159.291801] ata6.05: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Feb 14 18:29:39 specialbrew kernel: [27576159.297143] ata6.06: hard resetting link
Feb 14 18:29:39 specialbrew kernel: [27576159.639850] ata6.06: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Feb 14 18:29:39 specialbrew kernel: [27576159.645411] ata6.07: hard resetting link
Feb 14 18:29:40 specialbrew kernel: [27576159.971581] ata6.07: SATA link down (SStatus 0 SControl 320)
Feb 14 18:29:40 specialbrew kernel: [27576159.977251] ata6.08: hard resetting link
Feb 14 18:29:40 specialbrew kernel: [27576160.303533] ata6.08: SATA link down (SStatus 0 SControl 320)
Feb 14 18:29:40 specialbrew kernel: [27576160.310056] ata6.09: hard resetting link
Feb 14 18:29:40 specialbrew kernel: [27576160.635541] ata6.09: SATA link down (SStatus 0 SControl 320)
Feb 14 18:29:40 specialbrew kernel: [27576160.641371] ata6.10: hard resetting link
Feb 14 18:29:41 specialbrew kernel: [27576160.967639] ata6.10: SATA link down (SStatus 0 SControl 320)
Feb 14 18:29:41 specialbrew kernel: [27576160.973591] ata6.11: hard resetting link
Feb 14 18:29:41 specialbrew kernel: [27576161.299570] ata6.11: SATA link down (SStatus 0 SControl 320)
Feb 14 18:29:41 specialbrew kernel: [27576161.305670] ata6.12: hard resetting link
Feb 14 18:29:41 specialbrew kernel: [27576161.631589] ata6.12: SATA link down (SStatus 0 SControl 320)
Feb 14 18:29:41 specialbrew kernel: [27576161.637725] ata6.13: hard resetting link
Feb 14 18:29:42 specialbrew kernel: [27576161.963597] ata6.13: SATA link down (SStatus 0 SControl 320)
Feb 14 18:29:42 specialbrew kernel: [27576161.969538] ata6.14: hard resetting link
Feb 14 18:29:42 specialbrew kernel: [27576162.295657] ata6.14: SATA link down (SStatus 0 SControl 320)
Feb 14 18:29:42 specialbrew kernel: [27576162.303094] ata6.00: configured for UDMA/100
Feb 14 18:29:42 specialbrew kernel: [27576162.310674] ata6.01: configured for UDMA/100
Feb 14 18:29:42 specialbrew kernel: [27576162.317928] ata6.02: configured for UDMA/100
Feb 14 18:29:42 specialbrew kernel: [27576162.326589] ata6.04: configured for UDMA/100
Feb 14 18:29:42 specialbrew kernel: [27576162.337178] ata6.05: configured for UDMA/100
Feb 14 18:29:42 specialbrew kernel: [27576162.344438] ata6.06: configured for UDMA/100
Feb 14 18:29:43 specialbrew kernel: [27576163.607145] ata6.03: hard resetting link
Feb 14 18:29:44 specialbrew kernel: [27576163.935962] ata6.03: SATA link down (SStatus 0 SControl 320)
Feb 14 18:29:44 specialbrew kernel: [27576163.942835] ata6.03: limiting SATA link speed to 1.5 Gbps
Feb 14 18:29:49 specialbrew kernel: [27576168.939422] ata6.03: hard resetting link
Feb 14 18:29:49 specialbrew kernel: [27576169.264031] ata6.03: SATA link down (SStatus 0 SControl 310)
Feb 14 18:29:49 specialbrew kernel: [27576169.270519] ata6.03: disabled
Feb 14 18:29:49 specialbrew kernel: [27576169.276874] end_request: I/O error, dev sdh, sector 0
Feb 14 18:29:49 specialbrew kernel: [27576169.282908] btrfs_dev_stat_print_on_error: 965 callbacks suppressed
Feb 14 18:29:49 specialbrew kernel: [27576169.282929] ata6: EH complete
Feb 14 18:29:49 specialbrew kernel: [27576169.294246] BTRFS: bdev /dev/sdh errs: wr 125, rd 8, flush 1, corrupt 0, gen 0
Feb 14 18:29:49 specialbrew kernel: [27576169.300987] sd 5:3:0:0: rejecting I/O to offline device
Feb 14 18:29:49 specialbrew kernel: [27576169.307016] BTRFS: lost page write due to I/O error on /dev/sdh
Feb 14 18:29:49 specialbrew kernel: [27576169.312976] BTRFS: bdev /dev/sdh errs: wr 126, rd 8, flush 1, corrupt 0, gen 0
Feb 14 18:29:49 specialbrew kernel: [27576169.319049] ata6.03: detaching (SCSI 5:3:0:0)
Feb 14 18:29:49 specialbrew kernel: [27576169.319433] sd 5:3:0:0: rejecting I/O to offline device
Feb 14 18:29:49 specialbrew kernel: [27576169.319443] BTRFS: lost page write due to I/O error on /dev/sdh
Feb 14 18:29:49 specialbrew kernel: [27576169.319448] BTRFS: bdev /dev/sdh errs: wr 127, rd 8, flush 1, corrupt 0, gen 0
Feb 14 18:29:49 specialbrew kernel: [27576169.319521] sd 5:3:0:0: rejecting I/O to offline device
Feb 14 18:29:49 specialbrew kernel: [27576169.319523] BTRFS: lost page write due to I/O error on /dev/sdh
Feb 14 18:29:49 specialbrew kernel: [27576169.319526] BTRFS: bdev /dev/sdh errs: wr 128, rd 8, flush 1, corrupt 0, gen 0
Feb 14 18:29:49 specialbrew kernel: [27576169.426264] sd 5:3:0:0: [sdh] Synchronizing SCSI cache
Feb 14 18:29:49 specialbrew kernel: [27576169.432734] sd 5:3:0:0: [sdh]  
Feb 14 18:29:49 specialbrew kernel: [27576169.438653] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Feb 14 18:29:49 specialbrew kernel: [27576169.444590] sd 5:3:0:0: [sdh] Stopping disk
Feb 14 18:29:49 specialbrew kernel: [27576169.450961] sd 5:3:0:0: [sdh] START_STOP FAILED
Feb 14 18:29:49 specialbrew kernel: [27576169.456838] sd 5:3:0:0: [sdh]  
Feb 14 18:29:49 specialbrew kernel: [27576169.462622] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Feb 14 18:30:21 specialbrew kernel: [27576201.178630] BTRFS: bdev /dev/sdh errs: wr 128, rd 8, flush 2, corrupt 0, gen 0
Feb 14 18:30:21 specialbrew kernel: [27576201.309583] BTRFS: lost page write due to I/O error on /dev/sdh
Feb 14 18:30:21 specialbrew kernel: [27576201.315761] BTRFS: bdev /dev/sdh errs: wr 129, rd 8, flush 2, corrupt 0, gen 0
Feb 14 18:30:21 specialbrew kernel: [27576201.322086] BTRFS: lost page write due to I/O error on /dev/sdh

…and those BTRFS: messages continue now even though the system no
longer has a /dev/sdh.

Now:

$ sudo btrfs fi sh /srv/tank
Label: 'tank'  uuid: 472ee2b3-4dc3-4fc1-80bc-5ba967069ceb
        Total devices 6 FS bytes used 1.57TiB
        devid    3 size 1.82TiB used 383.00GiB path /dev/sdg
        devid    4 size 1.82TiB used 384.00GiB path /dev/sdf
        devid    5 size 2.73TiB used 1.25TiB path /dev/sdk
        devid    6 size 1.82TiB used 347.00GiB path /dev/sdj
        devid    7 size 2.73TiB used 464.00GiB path /dev/sde
        *** Some devices missing
$ sudo btrfs dev usage /srv/tank
/dev/sde, ID: 7
   Device size:             2.73TiB
   Data,RAID1:            464.00GiB
   Unallocated:             2.28TiB

/dev/sdf, ID: 4
   Device size:             1.82TiB
   Data,RAID1:            383.00GiB
   Metadata,RAID1:          1.00GiB
   Unallocated:             1.44TiB

/dev/sdg, ID: 3
   Device size:             1.82TiB
   Data,RAID1:            382.00GiB
   Metadata,RAID1:          1.00GiB
   Unallocated:             1.45TiB

/dev/sdh, ID: 2
   Device size:               0.00B
   Data,RAID1:            383.00GiB
   Metadata,RAID1:          1.00GiB
   System,RAID1:           32.00MiB
   Unallocated:             1.44TiB

/dev/sdj, ID: 6
   Device size:             1.82TiB
   Data,RAID1:            347.00GiB
   Unallocated:             1.48TiB

/dev/sdk, ID: 5
   Device size:             2.73TiB
   Data,RAID1:              1.25TiB
   Metadata,RAID1:          3.00GiB
   System,RAID1:           32.00MiB
   Unallocated:             1.48TiB

So, ideally I'd like to remove the missing device sdh (id 2) to have
redundant copies of the data until I can insert a new drive. But
"remove" doesn't seem to want to work:

$ sudo btrfs dev remove /dev/sdh /srv/tank
ERROR: not a block device: /dev/sdh
$ sudo btrfs dev remove 2 /srv/tank
ERROR: not a block device: 2
$ btrfs --version
btrfs-progs v4.4

I expect my kernel might be too old as it is a Debian backports
version on wheezy (linux-image-3.16.0-0.bpo.4-amd64
3.16.7-ckt20-1+deb8u3~bpo70+1).

If I upgrade the kernel then should one of those remove commands
above work?

I would rather not reboot just now if I can achieve redundancy in
some other way. Would a rebalance like:

$ sudo btrfs balance -f -v -sdevid=2 -mdevid=2 /srv/tank

reconstruct redundant copies elsewhere?

With this btrfs-progs and kernel version, will a later "btrfs
replace start -r /dev/sdh /dev/sdl" work without me rebooting into a
newer kernel, even though /dev/sdh doesn't exist as a device to the
kernel right now?

Any information/advice appreciated.

Cheers,
Andy

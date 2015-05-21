Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36807 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974AbbEUVuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 17:50:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YvYLs-0002kc-5R
	for linux-btrfs@vger.kernel.org; Thu, 21 May 2015 23:50:04 +0200
Received: from 93.96-242-81.adsl-dyn.isp.belgacom.be ([81.242.96.93])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2015 23:50:04 +0200
Received: from jan.voet by 93.96-242-81.adsl-dyn.isp.belgacom.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2015 23:50:04 +0200
To: linux-btrfs@vger.kernel.org
From: Jan Voet <jan.voet@gmail.com>
Subject: BTRFS RAID5 filesystem corruption during balance
Date: Thu, 21 May 2015 21:43:36 +0000 (UTC)
Message-ID: <loom.20150521T231006-840@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I recently upgraded a quite old home NAS system (Celeron M based) to Ubuntu
14.04 with an upgraded linux kernel (3.19.8) and BTRFS tools v3.17.  This
system has 5 brand new 6TB drives (HGST) with all drives directly handled by
BTRFS, both data and metadata in RAID5.
After loading up the system with 12.5TB data (took some time :-) ), a btrfs
balance was done to see how it would behave.   After 3 days into it and
still 48% to go, the system locked up and didn't respond anymore to ssh, usb
keyboard, nor did the VGA output work anymore.  Only pings worked (IP/ICMP
Echo Request/Reply) so the kernel IP stack was still active, nothing else
did however and no disk activity was seen at all.
So I did a hard reset, hoping that on restart it would resume the balance. 
It actually seemed to restart the balance but showed only a few extents
remaining (11 or so, instead of the 3000+ that were shown originally) and
after a small amount of time seemed to have completed the balance ???
The result seems to be a mess however, with the filesystem being remounted
read-only after a few minutes, with lots of btrfs-related stackdumps in the
kernel message dump. Rebooting doesn't seem to help.  It always ends up in
the same situation after some time.
The data is still visible, but I'm a bit of a loss as to how I should
continue.  Any advice would be welcome.

Some data:

$ sudo btrfs fi show /dev/sdb
Label: none  uuid: d278e7df-e26d-4a9b-99fb-71fbef819dd1
        Total devices 5 FS bytes used 11.58TiB
        devid    1 size 5.46TiB used 2.92TiB path /dev/sdb
        devid    2 size 5.46TiB used 2.92TiB path /dev/sdc
        devid    3 size 5.46TiB used 2.92TiB path /dev/sdd
        devid    4 size 5.46TiB used 2.92TiB path /dev/sde
        devid    5 size 5.46TiB used 2.92TiB path /dev/sdf

Btrfs v3.17

One of the stackdumps:

[  328.224417] ------------[ cut here ]------------
[  328.224446] WARNING: CPU: 0 PID: 1633 at
/home/kernel/COD/linux/fs/btrfs/disk-io.c:513 csum_dirty_buffer+0x6f/0xa0
[btrfs]()
[  328.224448] Modules linked in: ppdev i915 video net2280 udc_core
drm_kms_helper lpc_ich drm serio_raw shpchp i2c_algo_bit 8250_fintek
parport_pc mac_hid lp parport btrfs xor raid6_pq hid_generic usbhid sata_mv
e1000 pata_acpi floppy hid
[  328.224473] CPU: 0 PID: 1633 Comm: kworker/u2:12 Tainted: G        W    
 3.19.8-031908-generic #201505110938
[  328.224476] Hardware name:    /i854GML-LPC47M182, BIOS 6.00 PG 06/21/2007
[  328.224508] Workqueue: btrfs-worker btrfs_worker_helper [btrfs]
[  328.224510]  00000000 00000000 c0ae5e40 c16e4a4d 00000000 c0ae5e70
c106250e c1907948
[  328.224518]  00000000 00000661 f89c3444 00000201 f893142f f893142f
d6f3a8f0 f72b1ac8
[  328.224525]  f6d5d800 c0ae5e80 c1062572 00000009 00000000 c0ae5e9c
f893142f 187ced34
[  328.224532] Call Trace:
[  328.224537]  [<c16e4a4d>] dump_stack+0x41/0x52
[  328.224541]  [<c106250e>] warn_slowpath_common+0x8e/0xd0
[  328.224570]  [<f893142f>] ? csum_dirty_buffer+0x6f/0xa0 [btrfs]
[  328.224598]  [<f893142f>] ? csum_dirty_buffer+0x6f/0xa0 [btrfs]
[  328.224603]  [<c1062572>] warn_slowpath_null+0x22/0x30
[  328.224631]  [<f893142f>] csum_dirty_buffer+0x6f/0xa0 [btrfs]
[  328.224660]  [<f893149f>] btree_csum_one_bio.isra.121+0x3f/0x50 [btrfs]
[  328.224688]  [<f89314c3>] __btree_submit_bio_start+0x13/0x20 [btrfs]
[  328.224715]  [<f892f81d>] run_one_async_start+0x3d/0x60 [btrfs]
[  328.224750]  [<f896e2b2>] normal_work_helper+0x62/0x180 [btrfs]
[  328.224778]  [<f8930630>] ? __btree_submit_bio_done+0x50/0x50 [btrfs]
[  328.224812]  [<f896e3e0>] btrfs_worker_helper+0x10/0x20 [btrfs]
[  328.224817]  [<c1077cb1>] process_one_work+0x121/0x3a0
[  328.224822]  [<c16f057c>] ? apic_timer_interrupt+0x34/0x3c
[  328.224826]  [<c107854d>] worker_thread+0xed/0x390
[  328.224831]  [<c1099fbf>] ? __wake_up_locked+0x1f/0x30
[  328.224835]  [<c1078460>] ? create_worker+0x1b0/0x1b0
[  328.224840]  [<c107d09b>] kthread+0x9b/0xb0
[  328.224845]  [<c16efb81>] ret_from_kernel_thread+0x21/0x30
[  328.224850]  [<c107d000>] ? flush_kthread_worker+0x80/0x80
[  328.224853] ---[ end trace e8386011b87476a4 ]---

There's plenty more of those as well as other messages such as:

[  329.354420] BTRFS: error (device sdf) in btrfs_run_delayed_refs:2792:
errno=-5 IO failure
[  329.354522] BTRFS info (device sdf): forced readonly
[  476.620532] perf interrupt took too long (2512 > 2500), lowering
kernel.perf_event_max_sample_rate to 50000
[  549.412065] BTRFS (device sdf): bad tree block start 17003380002271197777
19274981785600
[  549.425057] BTRFS (device sdf): bad tree block start 17003380002271197777
19274981785600
[  549.425415] BTRFS (device sdf): bad tree block start 17003380002271197777
19274981785600
[  549.425641] BTRFS (device sdf): bad tree block start 17003380002271197777
19274981785600
[  549.425655] BTRFS info (device sdf): no csum found for inode 15963 start 0
[  549.425943] BTRFS (device sdf): bad tree block start 17003380002271197777
19274981785600
[  549.426154] BTRFS (device sdf): bad tree block start 17003380002271197777
19274981785600
[  549.426165] BTRFS info (device sdf): no csum found for inode 15963 start 4096
[  549.426443] BTRFS (device sdf): bad tree block start 17003380002271197777
19274981785600
[  549.426653] BTRFS (device sdf): bad tree block start 17003380002271197777
19274981785600
[  549.426663] BTRFS info (device sdf): no csum found for inode 15963 start 8192
[  549.426944] BTRFS (device sdf): bad tree block start 17003380002271197777
19274981785600
[  549.427153] BTRFS (device sdf): bad tree block start 17003380002271197777
19274981785600
[  549.427163] BTRFS info (device sdf): no csum found for inode 15963 start
12288
[  549.427655] BTRFS info (device sdf): no csum found for inode 15963 start
16384
[  549.428447] BTRFS info (device sdf): no csum found for inode 15963 start
20480
[  549.429175] BTRFS info (device sdf): no csum found for inode 15963 start
24576

.....

I can provide more info on request, and don't mind trying out different
things (the data was fully backed up before I started this experiment).

Kind regards,
Jan



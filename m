Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46902 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab2KVTOa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Nov 2012 14:14:30 -0500
Date: Thu, 22 Nov 2012 20:14:28 +0100
From: Petr Janecek <janecek@ucw.cz>
To: linux-btrfs@vger.kernel.org
Subject: raid10 data fs full after degraded mount
Message-ID: <20121122191428.GA3389@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

  on a fs with 4 disks, raid 10 for data, one drive was failing and has
been removed. After reboot and 'mount -o degraded...', the fs looks
full, even though before removal of the failed device it was almost
80% free.

root@fs0:~# df -h /mnt/b
Filesystem      Size  Used Avail Use% Mounted on
/dev/sde         11T  2.5T   41M 100% /mnt/b
root@fs0:~# btrfs fi df /mnt/b
Data, RAID10: total=1.20TB, used=1.20TB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=168.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=224.00GB, used=6.43GB
Metadata: total=8.00MB, used=0.00
root@fs0:~# btrfs fi show BTR0
Label: 'BTR0'  uuid: a319a7c8-cdef-407d-a215-140920d5af60
        Total devices 4 FS bytes used 1.21TB
        devid    3 size 2.73TB used 727.01GB path /dev/sdf
        devid    4 size 2.73TB used 727.01GB path /dev/sdg
        devid    2 size 2.73TB used 727.00GB path /dev/sde
        *** Some devices missing

Btrfs v0.20-rc1-37-g91d9eec


  Trying to write resulted in the following oops:


[ 2756.911339] btrfs: allowing degraded mounts
[ 2756.911342] btrfs: disk space caching is enabled
[ 2756.953571] btrfs: bdev (null) errs: wr 53951563, rd 602, flush 2694, corrupt 0, gen 0
[ 2898.699564] btrfs: block rsv returned -28
[ 2898.699568] ------------[ cut here ]------------
[ 2898.699594] WARNING: at fs/btrfs/extent-tree.c:6297 btrfs_alloc_free_block+0xeb/0x2a0 [btrfs]()
[ 2898.699596] Hardware name: X9SCL/X9SCM
[ 2898.699597] Modules linked in: nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc xfs loop raid10 md_mod coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 xts snd_pcm snd_page_alloc lrw i2c_i801 psmouse serio_raw gf128mul ablk_helper cryptd snd_timer snd soundcore iTCO_wdt microcode iTCO_vendor_support i2c_core joydev pcspkr evdev lpc_ich mfd_core video acpi_cpufreq mperf button processor btrfs crc32c libcrc32c zlib_deflate usb_storage uas hid_generic usbhid hid sg sd_mod crc_t10dif mpt2sas raid_class scsi_transport_sas e1000e ahci libahci fan thermal thermal_sys ehci_hcd libata scsi_mod usbcore usb_common
[ 2898.699644] Pid: 3021, comm: btrfs-endio-wri Not tainted 3.7.0-rc4 #2
[ 2898.699646] Call Trace:
[ 2898.699654]  [<ffffffff8103cd4c>] ? warn_slowpath_common+0x76/0x8a
[ 2898.699668]  [<ffffffffa0192181>] ? btrfs_alloc_free_block+0xeb/0x2a0 [btrfs]
[ 2898.699687]  [<ffffffffa01b76fc>] ? read_extent_buffer_pages+0x1fb/0x247 [btrfs]
[ 2898.699703]  [<ffffffffa019ab85>] ? btree_readpage_end_io_hook+0x1d9/0x1d9 [btrfs]
[ 2898.699715]  [<ffffffffa0184461>] ? __btrfs_cow_block+0xf2/0x372 [btrfs]
[ 2898.699726]  [<ffffffffa018480d>] ? btrfs_cow_block+0xf1/0x141 [btrfs]
[ 2898.699738]  [<ffffffffa01873e5>] ? btrfs_search_slot+0x234/0x660 [btrfs]
[ 2898.699752]  [<ffffffffa0196aa6>] ? btrfs_lookup_csum+0x64/0x104 [btrfs]
[ 2898.699766]  [<ffffffffa0197879>] ? btrfs_csum_file_blocks+0x9d/0x4c4 [btrfs]
[ 2898.699783]  [<ffffffffa01a25c4>] ? add_pending_csums.isra.40+0x33/0x4e [btrfs]
[ 2898.699799]  [<ffffffffa01a74ae>] ? btrfs_finish_ordered_io+0x1e8/0x303 [btrfs]
[ 2898.699816]  [<ffffffffa01bfc70>] ? worker_loop+0x175/0x4ad [btrfs]
[ 2898.699832]  [<ffffffffa01bfafb>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
[ 2898.699846]  [<ffffffffa01bfafb>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
[ 2898.699850]  [<ffffffff81056d28>] ? kthread+0x81/0x89
[ 2898.699854]  [<ffffffff81056ca7>] ? __kthread_parkme+0x5c/0x5c
[ 2898.699859]  [<ffffffff81373f7c>] ? ret_from_fork+0x7c/0xb0
[ 2898.699862]  [<ffffffff81056ca7>] ? __kthread_parkme+0x5c/0x5c
[ 2898.699864] ---[ end trace 330239e32cfc6b00 ]---


Thanks,

Petr

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48186 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755408AbaGWBe7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 21:34:59 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49349 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1X9lSN-002Car-9D
	for linux-btrfs@vger.kernel.org; Tue, 22 Jul 2014 19:34:59 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: BUGS: bogus out of space reported when mounted raid1 degraded, btrfs replace failure, then oops
Message-Id: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com>
Date: Tue, 22 Jul 2014 19:34:58 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

3.16.0-0.rc6.git0.1.fc21.1.x86_64
btfs-progs 3.14.2

Fortunately this is a test system so it is dispensable. But in just an hour I ran into 5 bugs, and managed to apparently completely destroy a btrfs file system beyond repair, and it wasn't intentional. 


1. mkfs.btrfs /dev/sda6  ## volume's life starts as single device, on an SSD
2. btrfs device add /dev/sdb1 /  ## added an HDD partition
3. btrfs balance start -dconvert=raid1 -mconvert=raid1
4. clean shutdown, remove device 1 (leaving device 0)
5. poweron, mount degraded
6. gdm/gnome comes up very slowly, then I see a sad face graphic, with a message that there's only 60MB of space left.

# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda6        26G   13G   20M 100% /
/dev/sda6        26G   13G   20M 100% /home
/dev/sda6        26G   13G   20M 100% /var
/dev/sda6        26G   13G   20M 100% /boot

# btrfs fi df
Data, RAID1: total=6.00GiB, used=5.99GiB
System, RAID1: total=32.00MiB, used=32.00KiB
Metadata, RAID1: total=768.00MiB, used=412.41MiB
unknown, single: total=160.00MiB, used=0.00

# btrfs fi show
Label: 'Rawhide2'  uuid: f857c336-b8f5-4f5d-9500-a705ee1b6977
	Total devices 2 FS bytes used 6.39GiB
	devid    1 size 12.58GiB used 6.78GiB path /dev/sda6
	*** Some devices missing

Btrfs v3.14.2

BUG 1: The df command is clearly bogus six ways to Sunday. It's a 12.58 GiB partition, only 6.78GiB used, thus 5.8GiB free, yet df and apparently gvfs think it's full, maybe systemd too because the journal wigged out and stopped logging events while also kept stopping and starting. So whatever changes occurred to clean up the df reporting, are very problematic at best when mounting degraded.



============so then he gets curious about replacing the missing disk==============


7. btrfs replace start 2 /dev/sdb1 /   ## this is a ~13GB partition that matches the size of the missing device

This completes, no disk activity for a little over a minute, and then I see a call trace with btrfs_replace implicated. Unfortunately the system becomes so unstable at this point, I can't even capture a dmesg to a separate volume. After 30 minutes of unresponsive local shells, I force a poweroff.

8. Power on. Dropped to a dracut shell, as the btrfs volume  will not mount:
[   53.890761] rawhide kernel: BTRFS: failed to read the system array on sda6
[   53.905058] rawhide kernel: BTRFS: open_ctree failed

9. mount with -o recovery, same message

10. Reboot using vbox pointed to these partitions as raw devices so I can better capture data, and not use a degraded fs as root; the devices are sdb and sdc.

# mount -o ro /dev/sdb /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

[  216.819927] BTRFS: failed to read the system array on sdc
[  216.835570] BTRFS: open_ctree failed

So it's the same message as in dracut shell. Same message with ro,recovery.

11.  mount -o degraded,ro /dev/sdb /mnt

This works. Somehow the replace hasn't completed on some level. Very weird. And not intuitive.

[root@localhost ~]# btrfs fi show
Label: 'Rawhide2'  uuid: f857c336-b8f5-4f5d-9500-a705ee1b6977
	Total devices 2 FS bytes used 6.39GiB
	devid    0 size 12.58GiB used 6.78GiB path /dev/sdc
	devid    1 size 12.58GiB used 6.78GiB path /dev/sdb

Btrfs v3.14.2

Does not show any missing devices.  I vaguely recall in the dracut shell when booted baremetal that btrfs fi show did still show a missing devices along with the original and replacement devices, i.e. the replace didn't complete. I suspect that my 'btrfs replace start 2' is wrong, that devid 2 did not exist, it was actually devid 0 and 1 like above; but the problem is that btrfs fi show does not show devid for missing devices. I only saw the devid 1 for the remaining device, and assumed the missing one was 2. So that's why I did 'btrfs replace start 2' yet I didn't get an error message. The replace started, but apparently didn't complete.


BUG 2: btrfs fi show needs to show the devid of the missing device.
BUG 3: btrfs replace start should fail when specifying a non-existent devid.
BUG 4: btrfs replace start can fail to complete (possibly related to bug 2 and 3). 

BUG 4: When mounting -degraded (rw), I get a major oops resulting in a completely unresponsive system.

# mount -o degraded /dev/sdb /mnt

[   16.466995] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   55.081687] BTRFS info (device sdb): allowing degraded mounts
[   55.082107] BTRFS info (device sdb): disk space caching is enabled
[   55.117702] SELinux: initialized (dev sdb, type btrfs), uses xattr
[   55.117717] BTRFS: continuing dev_replace from <missing disk> (devid 2) to /dev/sdc @72%
[   55.530810] BTRFS: dev_replace from <missing disk> (devid 2) to /dev/sdc) finished
[   55.532149] BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
[   55.533087] IP: [<ffffffffa0268551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
[   55.533087] PGD 0 
[   55.533087] Oops: 0000 [#1] SMP 
[   55.533087] Modules linked in: cfg80211 rfkill btrfs snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device ppdev xor raid6_pq snd_pcm microcode snd_timer serio_raw parport_pc snd i2c_piix4 parport soundcore i2c_core xfs libcrc32c virtio_net virtio_pci virtio_ring ata_generic virtio pata_acpi
[   55.533087] CPU: 2 PID: 821 Comm: btrfs-devrepl Not tainted 3.16.0-0.rc6.git0.1.fc21.1.x86_64 #1
[   55.533087] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   55.533087] task: ffff880099b5eca0 ti: ffff88009983c000 task.ti: ffff88009983c000
[   55.533087] RIP: 0010:[<ffffffffa0268551>]  [<ffffffffa0268551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
[   55.533087] RSP: 0018:ffff88009983fe08  EFLAGS: 00010286
[   55.533087] RAX: 0000000000000000 RBX: 0000000000000000 RCX: bbb3527a6b299586
[   55.533087] RDX: ffff880036b6e410 RSI: ffff88009b4a2800 RDI: ffff880035f6cac0
[   55.533087] RBP: ffff88009983fe10 R08: ffff880036b6e410 R09: 0000000000000234
[   55.533087] R10: ffffe8ffffd01090 R11: ffffffff818675c0 R12: ffff880099a2cdc8
[   55.533087] R13: ffff88009b4a2800 R14: ffff880099eaa000 R15: ffff880036acf200
[   55.533087] FS:  0000000000000000(0000) GS:ffff88009fb00000(0000) knlGS:0000000000000000
[   55.533087] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   55.533087] CR2: 0000000000000088 CR3: 000000009aefe000 CR4: 00000000000006e0
[   55.533087] Stack:
[   55.533087]  ffff880099a2c000 ffff88009983fe90 ffffffffa02bf93d ffff880099a2c100
[   55.533087]  ffff880099a2ce38 00000006baa50000 ffffffff00000028 ffff88009983fea0
[   55.533087]  ffff88009983fe58 000000002909d417 ffff880099a2c000 000000002909d417
[   55.533087] Call Trace:
[   55.533087]  [<ffffffffa02bf93d>] btrfs_dev_replace_finishing+0x32d/0x5c0 [btrfs]
[   55.533087]  [<ffffffffa02c0130>] ? btrfs_dev_replace_status+0x110/0x110 [btrfs]
[   55.533087]  [<ffffffffa02c019d>] btrfs_dev_replace_kthread+0x6d/0x130 [btrfs]
[   55.533087]  [<ffffffff810b311a>] kthread+0xea/0x100
[   55.533087]  [<ffffffff810b3030>] ? insert_kthread_work+0x40/0x40
[   55.533087]  [<ffffffff8172253c>] ret_from_fork+0x7c/0xb0
[   55.533087]  [<ffffffff810b3030>] ? insert_kthread_work+0x40/0x40
[   55.533087] Code: 5f 5d c3 0f 1f 80 00 00 00 00 66 66 66 66 90 55 48 89 e5 53 48 8b bf f0 09 00 00 48 85 ff 74 20 31 db 48 85 f6 74 14 48 8b 46 78 <48> 8b 80 88 00 00 00 48 8b 70 38 e8 2f 23 01 e1 89 d8 5b 5d c3 
[   55.533087] RIP  [<ffffffffa0268551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
[   55.533087]  RSP <ffff88009983fe08>
[   55.533087] CR2: 0000000000000088
[   55.533087] ---[ end trace a34670f31a1db59e ]---


[root@localhost ~]# btrfs check /dev/sdb
warning, device 2 is missing
warning devid 2 not found already
Checking filesystem on /dev/sdb
UUID: f857c336-b8f5-4f5d-9500-a705ee1b6977
checking extents
checking free space cache
Error reading 22597402624, -1
failed to load free space cache for block group 21619867648
Error reading 25839001600, -1
failed to load free space cache for block group 22693609472
free space inode generation (0) did not match free space cache generation (858)
Error reading 22597664768, -1
failed to load free space cache for block group 24841093120
Error reading 28045934592, -1
failed to load free space cache for block group 25914834944
Error reading 25849696256, -1
failed to load free space cache for block group 26988576768
Error reading 22595305472, -1
failed to load free space cache for block group 28095873024
Error reading 25688473600, -1
failed to load free space cache for block group 28364308480
checking fs roots
checking csums
checking root refs
found 1449851186 bytes used err is 0
total csum bytes: 6233932
total tree bytes: 432472064
total fs tree bytes: 415531008
total extent tree bytes: 9240576
btree space waste bytes: 68632283
file data blocks allocated: 10542505984
 referenced 8114642944
Btrfs v3.14.2


BUG 5:

# btrfs-image -c9 -t3 /dev/sdb image.bin
warning, device 2 is missing
warning devid 2 not found already
btrfs-image: disk-io.c:155: readahead_tree_block: Assertion `!(ret)' failed.
Aborted (core dumped)


Chris Murphy



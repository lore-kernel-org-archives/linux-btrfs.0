Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kim.monte-stello.com ([91.121.114.170]:44179 "EHLO
	kim.monte-stello.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2IOO2P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Sep 2012 10:28:15 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by kim.monte-stello.com (Postfix) with ESMTP id F3FA92944D
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Sep 2012 15:17:42 +0100 (BST)
Received: from kim.monte-stello.com ([127.0.0.1])
	by localhost (kim.monte-stello.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 8LzmiIq78buR for <linux-btrfs@vger.kernel.org>;
	Sat, 15 Sep 2012 15:17:42 +0100 (BST)
Received: from kabis (cpc2-oxfd21-2-0-cust87.4-3.cable.virginmedia.com [86.8.154.88])
	by kim.monte-stello.com (Postfix) with ESMTPSA id DBE6C20AD7
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Sep 2012 15:17:41 +0100 (BST)
Date: Sat, 15 Sep 2012 15:17:38 +0100
From: Antoine Sirinelli <antoine@monte-stello.com>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Oops with a "degraded" volume
Message-ID: <20120915141737.GA4784@kabis>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

I have experienced a very reproducible Oops within the btrfs driver. On
a linux 3.5.4, if I mount a volume with the option "degraded" because
one of the device is missing, I would get an Oops when I unmount it (or
even before). You can see attached the kernel log.

Here is how I create my btrfs volume:

# mkfs.btrfs /dev/vdb /dev/vdc
# mount /dev/vdb /mnt
# dd if=/dev/zero of=/mnt/zeros count=1M
# umount /mnt
# shutdown -h now

I am then wiping one volume (/dev/vdc) and restarting the system. To
get a crash, here is what I am doing:

# mount -o degraded /dev/vdb /mnt
# umount /mnt

I recognise the volume is not usable after having erased one drive but I
would expect no to crash the kernel in such circumstances. I am not an
expert, I am just reporting a crash from an user point of view.

Antoine


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="Oops_btrfs_3.5.4.txt"

[   15.171761] btrfs: error reading free space cache
[   15.171969] btrfs: failed to load free space cache for block group 29360128
[   15.173078] btrfs: error reading free space cache
[   15.173587] btrfs: failed to load free space cache for block group 351404032
[   15.175348] btrfs: error reading free space cache
[   15.175734] btrfs: failed to load free space cache for block group 136708096
[   15.181790] btrfs: error reading free space cache
[   15.182240] btrfs: failed to load free space cache for block group 566099968
[   15.189808] btrfs: error reading free space cache
[   15.190270] btrfs: failed to load free space cache for block group 780795904
[   15.485925] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[   15.487131] IP: [<ffffffffa014018f>] rcu_string_strdup.constprop.64+0xd/0x3d [btrfs]
[   15.487915] PGD 37218067 PUD 3732e067 PMD 0 
[   15.489022] Oops: 0000 [#1] SMP 
[   15.489132] CPU 0 
[   15.489132] Modules linked in:[   15.489132]  netconsole configfs nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc loop joydev hid_generic usbhid hid microcode virtio_balloon snd_pcm snd_page_alloc snd_timer processor psmouse serio_raw i2c_piix4 thermal_sys i2c_core snd soundcore pcspkr evdev button ext4 crc16 jbd2 mbcache btrfs crc32c libcrc32c zlib_deflate sg sr_mod cdrom ata_generic virtio_net virtio_blk floppy ata_piix uhci_hcd ehci_hcd libata usbcore scsi_mod virtio_pci virtio_ring virtio usb_common [last unloaded: scsi_wait_scan]

[   15.489132] Pid: 2255, comm: umount Not tainted 3.5.4 #2 Bochs Bochs
[   15.489132] RIP: 0010:[<ffffffffa014018f>]  [<ffffffffa014018f>] rcu_string_strdup.constprop.64+0xd/0x3d [btrfs]
[   15.489132] RSP: 0018:ffff880037213dd8  EFLAGS: 00010286
[   15.489132] RAX: 0000000000000000 RBX: ffff88003747cc00 RCX: ffffffffffffffff
[   15.489132] RDX: 00000000000001d8 RSI: ffff88003747cdd8 RDI: 0000000000000010
[   15.489132] RBP: ffff880037356900 R08: 0000000000000050 R09: 0000000000000800
[   15.489132] R10: ffff880037628a38 R11: ffff8800376289f0 R12: 0000000000000010
[   15.489132] R13: ffff880037356958 R14: ffff880037356978 R15: ffff880037213f38
[   15.489132] FS:  00007fbc72b877e0(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[   15.489132] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   15.489132] CR2: 0000000000000010 CR3: 000000003b8c7000 CR4: 00000000000006f0
[   15.489132] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   15.489132] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   15.489132] Process umount (pid: 2255, threadinfo ffff880037212000, task ffff8800376289f0)
[   15.489132] Stack:
[   15.489132]  ffff88003747cc00 ffff880037356900 ffff88003747ca00 ffffffffa01406af
[   15.489132]  0000000000000000 ffff880037356900 ffffffffa0168230 ffff88003b6801e0
[   15.489132]  ffff88003b6801c0 ffffffffa0141931 ffff88003759e000 ffff88003ca85400
[   15.489132] Call Trace:
[   15.489132]  [<ffffffffa01406af>] ? __btrfs_close_devices+0xb1/0x192 [btrfs]
[   15.489132]  [<ffffffffa0141931>] ? btrfs_close_devices+0x1d/0x70 [btrfs]
[   15.489132]  [<ffffffffa011da62>] ? close_ctree+0x2a3/0x2d4 [btrfs]
[   15.489132]  [<ffffffff81112833>] ? dispose_list+0x27/0x31
[   15.489132]  [<ffffffff811134c7>] ? evict_inodes+0xe7/0xf4
[   15.489132]  [<ffffffff811018f5>] ? generic_shutdown_super+0x4d/0xc5
[   15.489132]  [<ffffffff811019d3>] ? kill_anon_super+0x9/0x11
[   15.489132]  [<ffffffffa0100697>] ? btrfs_kill_super+0xd/0x13 [btrfs]
[   15.489132]  [<ffffffff811014a8>] ? deactivate_locked_super+0x1c/0x4a
[   15.489132]  [<ffffffff81116483>] ? sys_umount+0x304/0x31f
[   15.489132]  [<ffffffff81049a91>] ? __set_current_blocked+0x2d/0x43
[   15.489132]  [<ffffffff81363a39>] ? system_call_fastpath+0x16/0x1b
[   15.489132] Code: eb 05 bd f4 ff ff ff 48 83 c4 38 89 e8 5b 5d 41 5c 41 5d c3 be 50 80 00 00 e9 90 19 fb e0 41 54 31 c0 48 83 c9 ff 49 89 fc 55 53 <f2> ae 48 89 cb 48 f7 d3 48 8d 7b 10 e8 d8 ff ff ff 48 85 c0 48 
[   15.489132] RIP  [<ffffffffa014018f>] rcu_string_strdup.constprop.64+0xd/0x3d [btrfs]
[   15.489132]  RSP <ffff880037213dd8>
[   15.489132] CR2: 0000000000000010
[   15.545817] ---[ end trace ae1b95a7dc8c0612 ]---

--mYCpIKhGyMATD0i+--

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbaGWCwS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 22:52:18 -0400
Message-ID: <53CF235D.1040703@redhat.com>
Date: Tue, 22 Jul 2014 21:52:13 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BUGS: bogus out of space reported when mounted raid1 degraded,
 btrfs replace failure, then oops
References: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com>
In-Reply-To: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This one (your bug #4) was likely caused by:

commit 99994cde9c59c2b8bb67d46d531b26cc73e39747
Author: Anand Jain <Anand.Jain@oracle.com>
Date:   Tue Jun 3 11:36:00 2014 +0800

    btrfs: dev delete should remove sysfs entry

and hopefully fixed by:

commit 0bfaa9c5cb479cebc24979b384374fe47500b4c9
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Jul 7 12:34:49 2014 -0500

    btrfs: test for valid bdev before kobj removal in btrfs_rm_device

-Eric

On 7/22/14, 8:34 PM, Chris Murphy wrote:
> BUG 4: When mounting -degraded (rw), I get a major oops resulting in a completely unresponsive system.
> 
> # mount -o degraded /dev/sdb /mnt
> 
> [   16.466995] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [   55.081687] BTRFS info (device sdb): allowing degraded mounts
> [   55.082107] BTRFS info (device sdb): disk space caching is enabled
> [   55.117702] SELinux: initialized (dev sdb, type btrfs), uses xattr
> [   55.117717] BTRFS: continuing dev_replace from <missing disk> (devid 2) to /dev/sdc @72%
> [   55.530810] BTRFS: dev_replace from <missing disk> (devid 2) to /dev/sdc) finished
> [   55.532149] BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
> [   55.533087] IP: [<ffffffffa0268551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
> [   55.533087] PGD 0 
> [   55.533087] Oops: 0000 [#1] SMP 
> [   55.533087] Modules linked in: cfg80211 rfkill btrfs snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device ppdev xor raid6_pq snd_pcm microcode snd_timer serio_raw parport_pc snd i2c_piix4 parport soundcore i2c_core xfs libcrc32c virtio_net virtio_pci virtio_ring ata_generic virtio pata_acpi
> [   55.533087] CPU: 2 PID: 821 Comm: btrfs-devrepl Not tainted 3.16.0-0.rc6.git0.1.fc21.1.x86_64 #1
> [   55.533087] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   55.533087] task: ffff880099b5eca0 ti: ffff88009983c000 task.ti: ffff88009983c000
> [   55.533087] RIP: 0010:[<ffffffffa0268551>]  [<ffffffffa0268551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
> [   55.533087] RSP: 0018:ffff88009983fe08  EFLAGS: 00010286
> [   55.533087] RAX: 0000000000000000 RBX: 0000000000000000 RCX: bbb3527a6b299586
> [   55.533087] RDX: ffff880036b6e410 RSI: ffff88009b4a2800 RDI: ffff880035f6cac0
> [   55.533087] RBP: ffff88009983fe10 R08: ffff880036b6e410 R09: 0000000000000234
> [   55.533087] R10: ffffe8ffffd01090 R11: ffffffff818675c0 R12: ffff880099a2cdc8
> [   55.533087] R13: ffff88009b4a2800 R14: ffff880099eaa000 R15: ffff880036acf200
> [   55.533087] FS:  0000000000000000(0000) GS:ffff88009fb00000(0000) knlGS:0000000000000000
> [   55.533087] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   55.533087] CR2: 0000000000000088 CR3: 000000009aefe000 CR4: 00000000000006e0
> [   55.533087] Stack:
> [   55.533087]  ffff880099a2c000 ffff88009983fe90 ffffffffa02bf93d ffff880099a2c100
> [   55.533087]  ffff880099a2ce38 00000006baa50000 ffffffff00000028 ffff88009983fea0
> [   55.533087]  ffff88009983fe58 000000002909d417 ffff880099a2c000 000000002909d417
> [   55.533087] Call Trace:
> [   55.533087]  [<ffffffffa02bf93d>] btrfs_dev_replace_finishing+0x32d/0x5c0 [btrfs]
> [   55.533087]  [<ffffffffa02c0130>] ? btrfs_dev_replace_status+0x110/0x110 [btrfs]
> [   55.533087]  [<ffffffffa02c019d>] btrfs_dev_replace_kthread+0x6d/0x130 [btrfs]
> [   55.533087]  [<ffffffff810b311a>] kthread+0xea/0x100
> [   55.533087]  [<ffffffff810b3030>] ? insert_kthread_work+0x40/0x40
> [   55.533087]  [<ffffffff8172253c>] ret_from_fork+0x7c/0xb0
> [   55.533087]  [<ffffffff810b3030>] ? insert_kthread_work+0x40/0x40
> [   55.533087] Code: 5f 5d c3 0f 1f 80 00 00 00 00 66 66 66 66 90 55 48 89 e5 53 48 8b bf f0 09 00 00 48 85 ff 74 20 31 db 48 85 f6 74 14 48 8b 46 78 <48> 8b 80 88 00 00 00 48 8b 70 38 e8 2f 23 01 e1 89 d8 5b 5d c3 
> [   55.533087] RIP  [<ffffffffa0268551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
> [   55.533087]  RSP <ffff88009983fe08>
> [   55.533087] CR2: 0000000000000088
> [   55.533087] ---[ end trace a34670f31a1db59e ]---


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:36573 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbbALX3w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 18:29:52 -0500
Received: from [192.168.9.10] (85-222-54-52.dynamic.chello.pl [85.222.54.52])
	by zlom.siedziba.pl (Postfix) with ESMTPSA id C3FA35261E7
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Jan 2015 00:22:25 +0100 (CET)
Message-ID: <54B45639.4080207@siedziba.pl>
Date: Tue, 13 Jan 2015 00:18:17 +0100
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: filesystem unmountable and btrfsck fails to repair after SATA link
 hiccup
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Situation: btrfs on LVM on RAID5, formatted with default options, 
mounted with noatime,compress=lzo, kernel 3.18.1. While recovering RAID 
after drive failure, another drive gets a couple of SATA link errors, 
and it corrupts the FS:

http://pp.siedziba.pl/tmp/btrfs-corruption/kern.log.txt

After unmounting, it no longer mounts:

Jan 12 23:25:46 dev1 kernel: [462597.674793] BTRFS info (device dm-3): 
disk space caching is enabled
Jan 12 23:25:55 dev1 kernel: [462606.331759] BTRFS critical (device 
dm-3): corrupt leaf, bad key order: block=9090221506560,root=1, slot=0
Jan 12 23:25:55 dev1 kernel: [462606.333262] BTRFS critical (device 
dm-3): corrupt leaf, bad key order: block=9090221555712,root=1, slot=0
Jan 12 23:25:55 dev1 kernel: [462606.373448] BTRFS critical (device 
dm-3): corrupt leaf, bad key order: block=9090221555712,root=1, slot=0
Jan 12 23:25:55 dev1 kernel: [462606.374744] BTRFS: Failed to read block 
groups: -5
Jan 12 23:25:55 dev1 kernel: [462606.396025] BTRFS: open_ctree failed

Running "btrfsck --repair" segfaults and doesn't do anything:
http://pp.siedziba.pl/tmp/btrfs-corruption/repair.txt

Adding "--init-extent-tree" makes it run for a bit longer, and then it 
hits an assertion:
http://pp.siedziba.pl/tmp/btrfs-corruption/repair-init-extent-tree.txt

After that the FS is mountable, but switches to read-only:
http://pp.siedziba.pl/tmp/btrfs-corruption/mount-after-repair-init-extent-tree.txt

Information about used space is wrong:

root@dev1:~/btrfs-progs# ./btrfs fi df /mnt/tmp/
Data, single: total=9.09TiB, used=0.00B
System, DUP: total=8.00MiB, used=0.00B
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=21.00GiB, used=560.00KiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=16.00MiB, used=0.00B
root@dev1:~/btrfs-progs# ./btrfs fi show /dev/mapper/dev1-vol3snap2
Label: none  uuid: d01c6984-8194-426d-b007-e20deb02d107
	Total devices 1 FS bytes used 560.00KiB
	devid    1 size 14.52TiB used 9.13TiB path /dev/mapper/dev1-vol3snap2

Btrfs v3.18

This volume contained backups. After replacing the hardware it will be 
reformatted, but in the meantime I can experiment on it and try various 
repair methods. Any ideas what else I could try? I try repairs on LVM 
snapshots, so the original volume is still untouched.

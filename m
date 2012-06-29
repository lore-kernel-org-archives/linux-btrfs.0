Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:42570 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2F2KaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 06:30:25 -0400
Received: from mac-mini.config (87-194-60-202.bethere.co.uk [87.194.60.202])
	by smtp.webfaction.com (Postfix) with ESMTP id 68EAB211FA24
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 05:11:31 -0500 (CDT)
From: Richard Cooper <richard@richardcooper.net>
Content-Type: text/plain; charset=us-ascii
Subject: Kernel panic from "btrfs subvolume delete"
Date: Fri, 29 Jun 2012 11:11:29 +0100
Message-Id: <B53F1BEB-C285-4A01-A61A-4B324CB6FA7F@richardcooper.net>
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I have two machines where I've been testing various btrfs based backup strategies. They are both Cent OS 6 with the standard kernel and btrfs-progs RPMs from the CentOS repos.

- kernel-2.6.32-220.17.1.el6.x86_64
- btrfs-progs-0.19-12.el6.x86_64

Both are currently in a state when trying to delete a subvolume results in the following kernel panic.

----------

[root@backup2 ~]# btrfs subvolume delete /srv/backup_history/2012-06-28-1342
Delete subvolume '/srv/backup_history/2012-06-28-1342'
[root@backup2 ~]# 
Message from syslogd@backup2 at Jun 29 08:53:06 ...
 kernel:------------[ cut here ]------------

Message from syslogd@backup2 at Jun 29 08:53:06 ...
 kernel:invalid opcode: 0000 [#1] SMP 

Message from syslogd@backup2 at Jun 29 08:53:06 ...
 kernel:last sysfs file: /sys/devices/virtual/block/md1/md/metadata_version

Message from syslogd@backup2 at Jun 29 08:53:06 ...
 kernel:Stack:

Message from syslogd@backup2 at Jun 29 08:53:06 ...
 kernel:Call Trace:

Message from syslogd@backup2 at Jun 29 08:53:06 ...
 kernel:Code: 89 ef e8 84 f5 fe ff 48 89 df 89 45 d8 e8 99 86 fe ff 8b 45 d8 48 8b 5d e0 4c 8b 65 e8 4c 8b 6d f0 4c 8b 75 f8 c9 c3 0f 0b eb fe <0f> 0b eb fe 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 eb f4 66 66 66 

Message from syslogd@backup2 at Jun 29 08:53:06 ...
 kernel:Kernel panic - not syncing: Fatal exception

----------

Sometimes the kernel:last sysfs file line says "/sys/kernel/kexec_crash_loaded" instead.

My setup is that /srv is a btrfs sat on /dev/md4 which is a 4 drive software RAID5 array. /srv/backups/data is a subvolume containing 65GB worth of test data. I've "btrfs subvolume snapshot"ed that data to a few new subvolumes under  /srv/backup_history/. Now whenever I try to delete any of the snapshots on either machine I get a kernel panic.

btrfsck look like this:

[root@backup2 ~]# btrfsck /dev/md4
found 72254246912 bytes used err is 0
total csum bytes: 66815432
total tree bytes: 3835244544
total fs tree bytes: 3581440000
btree space waste bytes: 1187313778
file data blocks allocated: 68419002368
 referenced 68418383872
Btrfs Btrfs v0.19


What should I do now? Do I need to upgrade to a more recent btrfs? If so, how? Can I provide any more information to help debug and fix the problem?

Regards,

- Rich


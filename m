Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37990 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab3CUVL5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 17:11:57 -0400
Received: by mail-wg0-f42.google.com with SMTP id 12so1642610wgh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 14:11:56 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 Mar 2013 15:11:56 -0600
Message-ID: <CAGR7nwePCTCF0nz7rNqqS9x=UqLugtPL2wp7rA1SgU81R0mDcA@mail.gmail.com>
Subject: Problems with compiling btrfs
From: Joseph Moore <japlha@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to compile the btrfs source code but I'm getting an error.
Any suggestions?

Thanks
Joe

[root@ol6 btrfs-progs]# uname -a
Linux ol6.localdomain 2.6.39-400.17.2.el6uek.x86_64 #1 SMP Wed Mar 13
12:31:05 PDT 2013 x86_64 x86_64 x86_64 GNU/Linux

[root@ol6 src]# git clone
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
Initialized empty Git repository in /usr/local/src/btrfs-progs/.git/
remote: Counting objects: 3539, done.
remote: Compressing objects: 100% (1289/1289), done.
remote: Total 3539 (delta 2633), reused 3015 (delta 2246)
Receiving objects: 100% (3539/3539), 1.02 MiB | 613 KiB/s, done.
Resolving deltas: 100% (2633/2633), done.

[root@ol6 src]# cd btrfs-progs
[root@ol6 btrfs-progs]# pwd
/usr/local/src/btrfs-progs

[root@ol6 btrfs-progs]# make
    [LD]     mkfs.btrfs
mkfs.o: In function `is_ssd':
/usr/local/src/btrfs-progs/mkfs.c:1234: undefined reference to
`blkid_probe_get_wholedisk_devno'
collect2: ld returned 1 exit status
make: *** [mkfs.btrfs] Error 1

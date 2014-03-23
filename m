Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57023 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaCWSJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 14:09:15 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:39663 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WRmpY-0006VI-Dn by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 11:09:14 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WRmpX-0006Vs-Lc
	for linux-btrfs@vger.kernel.org; Sun, 23 Mar 2014 11:09:07 -0700
Date: Sun, 23 Mar 2014 11:09:07 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140323180907.GA22171@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Cannot add device "is mounted" for unmounted drive that used to be
 in raidset that is mounted
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I found out that a drive that used to be part of a raid system that is mounted
and running without it, btrfs apparently decides that the drive is part of the mounted
raidset and in use.
As a result, I had to eventually dd 0's over it, btrfs device scan, and finally
I was able to use it again.

btrfs should probably improve its check to see that the drive is not really used
and let me format it.


Longer details:
On a running system, I re-added a drive, it showed up as /dev/sdm1
I decrypted it
cryptsetup luksOpen /dev/sdm1 crypt_sdm1

But I can't add it:
polgara:/mnt/btrfs_backupcopy# btrfs device add -f /dev/mapper/crypt_sdm1 .
/dev/mapper/crypt_sdm1 is mounted

however, I can format it as ext4, mount it, write to it, unmount it, and
I still get the same error:
polgara:/mnt/btrfs_backupcopy# mke2fs -t ext4 /dev/mapper/crypt_sdm1
polgara:/mnt/btrfs_backupcopy# mount /dev/mapper/crypt_sdm1 /mnt/mnt
polgara:/mnt/btrfs_backupcopy# Mar 23 10:48:31 polgara kernel: [38645.955263] EXT4-fs (dm-10): mounted filesystem with ordered data mode. Opts: (null)
polgara:/mnt/btrfs_backupcopy# umount /mnt/mnt
polgara:/mnt/btrfs_backupcopy# btrfs device add -f /dev/mapper/crypt_sdm1 .
/dev/mapper/crypt_sdm1 is mounted

polgara:/mnt/btrfs_backupcopy# fuser -v /dev/mapper/crypt_sdm1
polgara:/mnt/btrfs_backupcopy# lsof -n | grep -E '(dm-10|sdm)'
polgara:/mnt/btrfs_backupcopy# mkfs.btrfs -f /dev/mapper/crypt_sdm1 
Error: /dev/mapper/crypt_sdm1 is mounted
polgara:/mnt/btrfs_backupcopy# 

In the end, I had to run
dd if=/dev/zero of=/dev/mapper/crypt_sdm1 bs=1M
for btrfs to stop telling me the filesystem was mounted.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

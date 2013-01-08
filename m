Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:49142 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3AHFkP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 00:40:15 -0500
Received: by mail-ea0-f179.google.com with SMTP id i12so7934eaa.38
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jan 2013 21:40:14 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 8 Jan 2013 16:10:13 +1030
Message-ID: <CACCfv7ouftvEwAg0HWxCVSaOh+Q=K0+T65n0L4KJRqVa-e2_NA@mail.gmail.com>
Subject: Btrfs fs not mounting or being identified after power loss.
From: Jordan Windsor <jordanw2@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
The power to my computer was suddenly cut, one of my btrfs fs (not the
root) has somewhat disappeared, I can't mount it or use any of the
available btrfs tools on it.
Here's some command output:

[root@archpc ~]# fdisk -l /dev/sdb

Disk /dev/sdb: 808.9 GB, 808888614912 bytes, 1579860576 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000db8c9

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              63  1567571967   783785952+  83  Linux
/dev/sdb4      1567571968  1579859967     6144000   82  Linux swap / Solaris


/dev/sdb1 is the lost btrfs fs.

[root@archpc ~]# btrfs-find-root -v /dev/sdb1
No valid Btrfs found on /dev/sdb1

[root@archpc ~]# btrfsck /dev/sdb1
No valid Btrfs found on /dev/sdb1

[root@archpc ~]# mount /dev/sdb1 /mnt/restore/
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so

[ 1767.655429] JBD2: no valid journal superblock found
[ 1767.655432] EXT4-fs (sdb1): error loading journal


If you need anymore information please ask.
Thanks.

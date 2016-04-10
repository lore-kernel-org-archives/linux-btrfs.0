Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34164 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbcDJOrq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Apr 2016 10:47:46 -0400
Received: by mail-wm0-f53.google.com with SMTP id l6so115818795wml.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Apr 2016 07:47:45 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 10 Apr 2016 15:47:44 +0100
Message-ID: <CAK1feJAqOgucajbGQmZMzrdaw=BmXV9ht=Rt16Kk+X3A7Xs_oA@mail.gmail.com>
Subject: btrfstune -u makes filesystem unmountable
From: Richard C <mailing-lists@racitup.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm writing a backup script that images a btrfs using btrfs-image,
then restores to a file on a loop device. Since I had trouble mounting
the original and copied btrfs filesystems with the same UUID on the
same machine, I decided to try btrfstune -fu. However, this appears to
corrupt the copied filesystem altogether making fsck and mount fail.
Details below.
Is this a bug?

$ uname -a
Linux adventure 3.16.0-67-generic #87~14.04.1-Ubuntu SMP Fri Mar 11
00:26:02 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
$ btrfs --version
btrfs-progs v4.4

$ btrfstune -fu /dev/loop2
Current fsid: 36012b08-1e33-4d3c-ac23-5ccffd3295cd
New fsid: 8f70d0af-8ffa-4c82-a817-941e6abfaf9a
Set superblock flag CHANGING_FSID
Change fsid in extents
Change fsid on devices
Clear superblock flag CHANGING_FSID
Fsid change finished

$ btrfs check /dev/loop2
fsid mismatch, want=36012b08-1e33-4d3c-ac23-5ccffd3295cd,
have=8f70d0af-8ffa-4c82-a817-941e6abfaf9a
Couldn't read chunk root
Couldn't open file system
$ echo $?
251

$ mount /dev/loop2 /mnt
 mount: wrong fs type, bad option, bad superblock on /dev/loop2,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so
$ echo $?
32

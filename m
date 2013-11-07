Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54326 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab3KGOmb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 09:42:31 -0500
Received: by mail-ea0-f179.google.com with SMTP id q15so314390ead.24
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Nov 2013 06:42:30 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 7 Nov 2013 06:42:30 -0800
Message-ID: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com>
Subject: How to fix/remove "csum failed ino" error
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I use Linux Arch, kernel 3.11.6.

Recently I had a disk crash and number of my files got corrupted. To
avoid this situation again I added more disks I trying to convert the
data to raid1:

# btrfs balance start -dconvert=raid1 -mconvert=raid1 /

But unfortunately it fails with IO erro. In dmesg I see

[ 5374.216320] BTRFS info (device sda3): csum failed ino 362 off
4993024 csum 1283121890 private 3720296651
[ 5374.219656] BTRFS info (device sda3): csum failed ino 362 off
5242880 csum 857237386 private 2562492866
[ 5374.222628] BTRFS info (device sda3): csum failed ino 362 off
5767168 csum 645194099 private 3149624654
[ 5374.223068] BTRFS info (device sda3): csum failed ino 362 off
4993024 csum 1283121890 private 3720296651

I looks like some files are corrupted. I would like either
fix/regenerate those files (e.g. reinstall from packages) or remove
them (as they corrupted anyway).

But I need to know what are these files. "ino 362" mentioned in the
message does not exist on the file system:

# find / -mount -inum 362
finds nothing.

So I assume this ino is some internal identifier. I checked function
btrfs_ino() from btrfs_inode.h and the output value can be either
BTRFS_I(inode)->location.objectid
or
inode->i_ino

I believe 362 is BTRFS_I(inode)->location.objectid

So my question is how to find a file that has this id corresponding?
How to remove this object and finally make the raid1 conversion? Also
is it possible to improve the error message so users can find failing
objects (e.g. include the real inode number)?

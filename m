Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:42916 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3KGQlp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 11:41:45 -0500
Received: by mail-ve0-f174.google.com with SMTP id pa12so584151veb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Nov 2013 08:41:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com>
References: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com>
Date: Thu, 7 Nov 2013 11:41:44 -0500
Message-ID: <CAC4gV=7FgL=wixYf6w-yfuZNbz8QCt5t9T8_jStjpkKgTBc+Vw@mail.gmail.com>
Subject: Re: How to fix/remove "csum failed ino" error
From: Frank Holton <fholton@gmail.com>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Anatol,

I just checked and on my filesystem inode number 362 corresponds to
part of the free space cache. You can check this yourself by running
(as root)

btrfs-debug-tree /dev/sdb | grep "(362 " -A 3 -B 1

where /dev/sdb is one of the devices from your filesystem.

It printed the following for me, note the location key (362
INODE_ITEM) under the FREE_SPACE key. Yours might be different but if
you see FREE_SPACE that points to the free space cache.

item 100 key (362 INODE_ITEM 0) itemoff 21857 itemsize 160
                inode generation 2004 transid 2004 size 262144 block
group 0 mode 100600 links 1
        item 101 key (362 EXTENT_DATA 0) itemoff 21804 itemsize 53
                extent data disk byte 41903296512 nr 262144
                extent data offset 0 nr 262144 ram 262144
                extent compression 0
--
        item 148 key (FREE_SPACE UNTYPED 113845993472) itemoff 23807 itemsize 41
                location key (362 INODE_ITEM 0)
                cache generation 2004 entries 2 bitmaps 0

I would try to mount the filesystem with the clear_cache option, which
should clear the current space cache and force a rebuild.

Hope that helps,
Frank



On Thu, Nov 7, 2013 at 9:42 AM, Anatol Pomozov <anatol.pomozov@gmail.com> wrote:
> Hi
>
> I use Linux Arch, kernel 3.11.6.
>
> Recently I had a disk crash and number of my files got corrupted. To
> avoid this situation again I added more disks I trying to convert the
> data to raid1:
>
> # btrfs balance start -dconvert=raid1 -mconvert=raid1 /
>
> But unfortunately it fails with IO erro. In dmesg I see
>
> [ 5374.216320] BTRFS info (device sda3): csum failed ino 362 off
> 4993024 csum 1283121890 private 3720296651
> [ 5374.219656] BTRFS info (device sda3): csum failed ino 362 off
> 5242880 csum 857237386 private 2562492866
> [ 5374.222628] BTRFS info (device sda3): csum failed ino 362 off
> 5767168 csum 645194099 private 3149624654
> [ 5374.223068] BTRFS info (device sda3): csum failed ino 362 off
> 4993024 csum 1283121890 private 3720296651
>
> I looks like some files are corrupted. I would like either
> fix/regenerate those files (e.g. reinstall from packages) or remove
> them (as they corrupted anyway).
>
> But I need to know what are these files. "ino 362" mentioned in the
> message does not exist on the file system:
>
> # find / -mount -inum 362
> finds nothing.
>
> So I assume this ino is some internal identifier. I checked function
> btrfs_ino() from btrfs_inode.h and the output value can be either
> BTRFS_I(inode)->location.objectid
> or
> inode->i_ino
>
> I believe 362 is BTRFS_I(inode)->location.objectid
>
> So my question is how to find a file that has this id corresponding?
> How to remove this object and finally make the raid1 conversion? Also
> is it possible to improve the error message so users can find failing
> objects (e.g. include the real inode number)?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

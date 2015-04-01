Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:37313 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbbDARDi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 13:03:38 -0400
Received: by igcxg11 with SMTP id xg11so52041502igc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 10:03:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACPiFCKKb6SGZubGRMka3JmvFvtC64PxQ5PpJ6VR56gKcjXwdA@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
	<CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
	<CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com>
	<CAJCQCtRy4gzXYqHeoqdtv+Q-3Js7pthXMPa5X_gGHbSynktbBQ@mail.gmail.com>
	<CACPiFCKKb6SGZubGRMka3JmvFvtC64PxQ5PpJ6VR56gKcjXwdA@mail.gmail.com>
Date: Wed, 1 Apr 2015 11:03:37 -0600
Message-ID: <CAJCQCtSDSW3ZB5LE=Y5AJgWWgP=Lo6XFXTGZMLVQMwd36QQNMA@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
To: Martin Langhoff <martin.langhoff@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2015 at 9:42 AM, Martin Langhoff
<martin.langhoff@gmail.com> wrote:
# mount /dev/sda6 /mysysroot
>
> Apr 01 11:26:51 localhost kernel: BTRFS info (device sda6): disk space
> caching is enabled
> Apr 01 11:26:56 localhost kernel: BTRFS: checking UUID tree
> Apr 01 11:26:56 localhost kernel: SELinux: initialized (dev sda6, type
> btrfs), uses xattr

Right so it mounts fine with no errors from live media, but won't
mount at boot time. Same problem I was having.


# btrfs check /dev/sda6
> Checking filesystem on /dev/sda6
> UUID: 94637b35-a294-4be2-aa47-82c52d6d53ef
> checking extents
> checking free space cache
> checking fs roots
> root 256 inode 39841 errors 400, nbytes wrong

mount /dev/sda6 /mnt
btrfs inspect-internal inode-resolve 39841 /mnt

It should resolve a path to file for that inode. Chances are you can
just use cp to make a new copy of it, delete the original, and rename
the copy to match the original file name. Unmount. And now the btrfs
check error won't happen.



> [root@localhost liveuser]# btrfs check --repair /dev/sda6
> enabling repair mode
> Fixed 0 roots.
> Checking filesystem on /dev/sda6
> UUID: 94637b35-a294-4be2-aa47-82c52d6d53ef
> checking extents
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> root 256 inode 39841 errors 400, nbytes wrong
> found 7747100703 bytes used err is 1
> total csum bytes: 11912932
> total tree bytes: 476725248
> total fs tree bytes: 434733056
> total extent tree bytes: 22986752
> btree space waste bytes: 83962424
> file data blocks allocated: 30820143104
>  referenced 11997040640
> Btrfs v3.17

Yeah I don't know what this errors 400 nbytes wrong means, but at the
moment btrfs-progs doesn't fix it.


-- 
Chris Murphy

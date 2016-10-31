Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56971 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760027AbcJaGZK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 02:25:10 -0400
Date: Sun, 30 Oct 2016 23:25:09 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
Message-ID: <20161031062509.GO28648@merlins.org>
References: <20161030183437.GA3287@merlins.org> <062d36da-197f-6a58-0b6e-208a5ca9fef3@cn.fujitsu.com> <20161031020616.GH28648@merlins.org> <60a0ce1f-7b2f-325e-51f7-ccad054fab8b@cn.fujitsu.com> <20161031054719.GN28648@merlins.org> <b31eaf2d-b339-6163-0108-28d1586c05e5@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b31eaf2d-b339-6163-0108-28d1586c05e5@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2016 at 02:04:10PM +0800, Qu Wenruo wrote:
> >Sorry for asking, am I doing this wrong?
> >myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32
> >skip=26367830208
> >dd: reading `/dev/mapper/crypt_bcache0': Invalid argument
> >0+0 records in
> >0+0 records out
> >0 bytes (0 B) copied, 0.000401393 s, 0.0 kB/s
> 
> So, the underlying MD RAID5 are complaining about some wrong data, and 
> refuse to read out.
> 
> It seems that btrfs-progs can't handle read failure?
> Maybe dm-error could emulate it.
> 
> And what about the 2nd range?

they both fail the same, but I wasn' tsure if I typed the wrong dd command
or not.

myth:~# btrfs fi df /mnt/mnt
Data, single: total=13.22TiB, used=13.19TiB
System, DUP: total=32.00MiB, used=1.42MiB
Metadata, DUP: total=74.00GiB, used=72.82GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
myth:~# btrfs fi show
Label: 'DS5'  uuid: 6692cf4c-93d9-438c-ac30-5db6381dc4f2
        Total devices 1 FS bytes used 13.26TiB
        devid    1 size 14.55TiB used 13.36TiB path /dev/mapper/crypt_bcache0

For now, I mounted the filesystem and I'm running scrub on it to see how
much damage there is. It will take all night:
BTRFS warning (device dm-0): checksum error at logical 27886878720 on dev /dev/mapper/crypt_bcache0, sector 56580096, root 9461, inode 45837, offset 15460089856, length 4096, links 1 (path: system/mlocate/mlocate.db)
BTRFS error (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
BTRFS error (device dm-0): unable to fixup (regular) error at logical 27887009792 on dev /dev/mapper/crypt_bcache0
BTRFS error (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
BTRFS error (device dm-0): unable to fixup (regular) error at logical 27886878720 on dev /dev/mapper/crypt_bcache0
BTRFS warning (device dm-0): checksum error at logical 27885961216 on dev /dev/mapper/crypt_bcache0, sector 56578304, root 9461, inode 45837, offset 15459172352, length 4096, links 1 (path: system/mlocate/mlocate.db)
BTRFS warning (device dm-0): checksum error at logical 27885830144 on dev /dev/mapper/crypt_bcache0, sector 56578048, root 9461, inode 45837, offset 15459041280, length 4096, links 1 (path: system/mlocate/mlocate.db)
BTRFS error (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
BTRFS error (device dm-0): unable to fixup (regular) error at logical 27885830144 on dev /dev/mapper/crypt_bcache0
BTRFS error (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
BTRFS error (device dm-0): unable to fixup (regular) error at logical 27885961216 on dev /dev/mapper/crypt_bcache0
BTRFS warning (device dm-0): checksum error at logical 27887013888 on dev /dev/mapper/crypt_bcache0, sector 56580360, root 9461, inode 45837, offset 15460225024, length 4096, links 1 (path: system/mlocate/mlocate.db)
BTRFS error (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
BTRFS error (device dm-0): unable to fixup (regular) error at logical 27887013888 on dev /dev/mapper/crypt_bcache0
BTRFS warning (device dm-0): checksum error at logical 27885834240 on dev /dev/mapper/crypt_bcache0, sector 56578056, root 9461, inode 45837, offset 15459045376, length 4096, links 1 (path: system/mlocate/mlocate.db)
BTRFS error (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
BTRFS error (device dm-0): unable to fixup (regular) error at logical 27885834240 on dev /dev/mapper/crypt_bcache0
BTRFS warning (device dm-0): checksum error at logical 27887017984 on dev /dev/mapper/crypt_bcache0, sector 56580368, root 9461, inode 45837, offset 15460229120, length 4096, links 1 (path: system/mlocate/mlocate.db)
BTRFS error (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
BTRFS error (device dm-0): unable to fixup (regular) error at logical 27887017984 on dev /dev/mapper/crypt_bcache0

So far, it looks like mnior damage limited to one file, I'll see tomorrow morning after it's done reading the whole array

> And further more, all backup chunk root are in facts pointing to current 
> chunk root, so --chunk-root doesn't work at all.

Ah, ok, so there is nothing I can do at the moment until I get a new btrfs-progs, correct?

Thanks for your answers
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

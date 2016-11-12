Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39745 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933912AbcKLDRg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 22:17:36 -0500
Date: Fri, 11 Nov 2016 19:17:08 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.com>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Message-ID: <20161112031708.aylnevv657w2x3dg@merlins.org>
References: <cf75cc57-62f9-2d88-a544-72a45aadd674@cn.fujitsu.com>
 <20161108003950.GD13371@merlins.org>
 <63a1964d-f8df-413d-c088-20163f824e3d@cn.fujitsu.com>
 <20161108010600.GE13371@merlins.org>
 <977bbf2a-5d9f-f5aa-084c-4ca1d891eb72@cn.fujitsu.com>
 <20161108152429.GC24297@merlins.org>
 <f17792e9-498a-4ff0-2cc5-674ae10a01ad@cn.fujitsu.com>
 <20161109020519.GN13371@merlins.org>
 <20161111034805.svs33jawobogpzrc@merlins.org>
 <f9757f37-ab2b-87d8-3f72-80dcc968f6e8@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f9757f37-ab2b-87d8-3f72-80dcc968f6e8@cn.fujitsu.com>
Subject: Re: when btrfs scrub reports errors and btrfs check --repair does not
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 11, 2016 at 11:55:21AM +0800, Qu Wenruo wrote:
> It seems to be orphan inodes.
> Btrfs doesn't remove all the contents of an inode at rm time.
> It just unlink the inode and put it into a state called orphan inodes.(Can't
> be referred from any directory).

BTRFS warning (device dm-6): checksum error at logical 269783928832 on dev /dev/mapper/crypt_bcache2, sector 529035272, root 17564, inode 1225897, offset 20480: path resolving failed with ret=-2
BTRFS warning (device dm-6): checksum error at logical 269783932928 on dev /dev/mapper/crypt_bcache2, sector 529035280, root 17564, inode 1225897, offset 24576: path resolving failed with ret=-2
 
Do you mean I should be using find /mnt/mnt -inum ?
Well, how about that, you're right:
gargamel:/mnt/mnt/DS2/backup# find /mnt/mnt -inum 1225897
/mnt/mnt/DS2/backup/debian64_rw.20160713_03:21:57/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y678z6.jpg
So basically the breakage in my filesystem is enough that the backlink
from the inode to the pathname is gone? That's not good :-/

> And then free their data extents in next several trans.
> 
> Try to find these inodes using inode number in specified subvolume.
> If not found, then they are orphan inodes, nothing to worry.
> These wrong data extent will disappear soon or later.
> 
> Or you can use "btrfs fi sync" to make sure orphan inodes are really removed
> from tree.
 
So, I ran btrfi fi sync /mnt/mnt, butit returned instantly.

scrub after that, still returns:
btrfs scrub start -Bd /mnt/mnt
BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1793, gen 0
BTRFS error (device dm-6): unable to fixup (regular) error at logical 269785628672 on dev /dev/mapper/crypt_bcache2
BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1794, gen 0
BTRFS error (device dm-6): unable to fixup (regular) error at logical 269784580096 on dev /dev/mapper/crypt_bcache2
BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1795, gen 0
BTRFS error (device dm-6): unable to fixup (regular) error at logical 269785632768 on dev /dev/mapper/crypt_bcache2
BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1796, gen 0
BTRFS error (device dm-6): unable to fixup (regular) error at logical 269785104384 on dev /dev/mapper/crypt_bcache2
BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1797, gen 0
BTRFS error (device dm-6): unable to fixup (regular) error at logical 269784584192 on dev /dev/mapper/crypt_bcache2
BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1798, gen 0
BTRFS error (device dm-6): unable to fixup (regular) error at logical 269785636864 on dev /dev/mapper/crypt_bcache2
BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1799, gen 0
BTRFS error (device dm-6): unable to fixup (regular) error at logical 269785108480 on dev /dev/mapper/crypt_bcache2
BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1800, gen 0
BTRFS error (device dm-6): unable to fixup (regular) error at logical 269784588288 on dev /dev/mapper/crypt_bcache2
BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1801, gen 0
BTRFS error (device dm-6): unable to fixup (regular) error at logical 269784055808 on dev /dev/mapper/crypt_bcache2
BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 1802, gen 0
BTRFS error (device dm-6): unable to fixup (regular) error at logical 269785640960 on dev /dev/mapper/crypt_bcache2

What am I supposed to do about these, I'm not even clear where this
corruption is located and how to clear it.

I understand you're saying that this does not seem to affect any
remaining data, but if scrub is not clean, it can't even see what
file an inode is linked to, and that inode doesn't get cleaned 2 days
later, my filesystem is in a bad state that check --repair should fix,
is it not?

Yes, I can wipe it and start over, but I'm trying to use this as a
learning experience as well as seeing if the tools are working as they
should.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

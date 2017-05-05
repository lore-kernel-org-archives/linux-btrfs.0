Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42413 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754358AbdEECkw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 May 2017 22:40:52 -0400
Date: Thu, 4 May 2017 19:40:41 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        bo.li.liu@oracle.com, fdmanana@suse.com, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20170505024041.4jdfponlichetnwm@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6ffe31a5-286e-756e-723c-38eca5c43d35@cn.fujitsu.com>
 <cc4ffae2-73d2-70bb-3c6c-0ec6a2bbaf13@cn.fujitsu.com>
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem by
 X hours?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 05, 2017 at 09:19:29AM +0800, Qu Wenruo wrote:
> Sorry for not noticing the link.
 
no problem, it was only one line amongst many :)
Thanks much for having had a look.

> [Conclusion]
> After checking the full result, some of fs/subvolume trees are corrupted.
> 
> [Details]
> Some example here:
> 
> ---
> ref mismatch on [6674127745024 32768] extent item 0, found 1
> Backref 6674127745024 parent 7566652473344 owner 0 offset 0 num_refs 0 not
> found in extent tree
> Incorrect local backref count on 6674127745024 parent 7566652473344 owner 0
> offset 0 found 1 wanted 0 back 0x5648afda0f20
> backpointer mismatch on [6674127745024 32768]
> ---
> 
> The extent at 6674127745024 seems to be an *DATA* extent.
> While current default nodesize is 16K and ancient default node is 4K.
> 
> Unless you specified -n 32K at mkfs time, it's a DATA extent.

I did not, so you must be right about DATA, which should be good, right,
I don't mind losing data as long as the underlying metadata is correct.

I should have given more data on the FS:

gargamel:/var/local/src/btrfs-progs# btrfs fi df /mnt/btrfs_pool2/
Data, single: total=6.28TiB, used=6.12TiB
System, DUP: total=32.00MiB, used=720.00KiB
Metadata, DUP: total=97.00GiB, used=94.39GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

gargamel:/var/local/src/btrfs-progs# btrfs fi usage /mnt/btrfs_pool2
Overall:
    Device size:                   7.28TiB
    Device allocated:              6.47TiB
    Device unallocated:          824.48GiB
    Device missing:                  0.00B
    Used:                          6.30TiB
    Free (estimated):            994.45GiB      (min: 582.21GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:6.28TiB, Used:6.12TiB
   /dev/mapper/dshelf2     6.28TiB

Metadata,DUP: Size:97.00GiB, Used:94.39GiB
   /dev/mapper/dshelf2   194.00GiB

System,DUP: Size:32.00MiB, Used:720.00KiB
   /dev/mapper/dshelf2    64.00MiB

Unallocated:
   /dev/mapper/dshelf2   824.48GiB


> Further more, it's a shared data backref, it's using its parent tree block
> to do backref walk.
> 
> And its parent tree block is 7566652473344.
> While such bytenr can't be found anywhere (including csum error output),
> that's to say either we can't find that tree block nor can't reach the tree
> root for it.
> 
> Considering it's data extent, its owner is either root or fs/subvolume tree.
> 
> 
> Such cases are everywhere, as I found other extent sized from 4K to 44K, so
> I'm pretty sure there must be some fs/subvolume tree corrupted.
> (Data extent in root tree is seldom 4K sized)
> 
> So unfortunately, your fs/subvolume trees are also corrupted.
> And almost no chance to do a graceful recovery.
 
So I'm confused here. You're saying my metadata is not corrupted (and in
my case, I have DUP, so I should have 2 copies), but with data blocks
(which are not duped) corrupted, it's also possible to lose the
filesystem in a way that it can't be taken back to a clean state, even
by deleting some corrupted data?

> [Alternatives]
> I would recommend to use "btrfs restore -f <subvolid>" to restore specified
> subvolume.

I don't need to restore data, the data is a backup. It will just take
many days to recreate (plus many hours of typing from me because the
backup updates are automated, but recreating everything, is not
automated)

So if I understand correctly, my metadata is fine (and I guess I have 2
copies, so it would have been unlucky to get both copies corrupted), but
enough data blocks got corrupted that btrfs cannot recover, even by
deleting the corrupted data blocks. Correct?

And is it not possible to clear the corrupted blocks like this?
./btrfs-corrupt-block -l  2899180224512 /dev/mapper/dshelf2
and just accept the lost data but get btrfs check repair to deal with
the deleted blocks and bring the rest back to a clean state?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

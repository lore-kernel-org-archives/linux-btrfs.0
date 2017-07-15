Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49500 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdGOXMy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Jul 2017 19:12:54 -0400
Date: Sat, 15 Jul 2017 16:12:45 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Kai Krakow <hurikhan77@gmail.com>, bepi@adria.it, matt@techsquare.com,
        mh@zugschlus.de, mkaganer@gmail.com, david@codepoets.co.uk,
        tch@virtall.com, somethingsome2000@gmail.com
Cc: Chris Mason <clm@fb.com>, bo.li.liu@oracle.com, fdmanana@suse.com,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists (since 3.4 / 2012)
Message-ID: <20170715231245.GA28281@merlins.org>
References: <20170715004828.f4bom5wq34abe4lz@merlins.org> <20170711062155.hvlx5ud4zphpzjnp@merlins.org> <20170715012216.njq6az3y34qyomtb@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170715012216.njq6az3y34qyomtb@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 14, 2017 at 06:22:16PM -0700, Marc MERLIN wrote:
> Dear Chris and other developers,
> 
> Can you look at this bug which has been happening since 2012 on apparently all kernels between at least
> 3.4 and 4.11.
> I didn't look in detail at each thread (took long enough to even find them all and paste here), but they seem pretty
> similar although the reasons how they got there may be different, or at least not as benign as a race condition
> between snapshot creation and deletion for those who do hourly snapshot rotations like me.

I just finished 2 check repairs, one with each mode, they both come back
clean.
Yet my FS still remounts read only with the same
BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2967: errno=-17 Object already exists
BTRFS info (device dm-2): forced readonly
BTRFS warning (device dm-2): failed setting block group ro, ret=-30 

So, given that I can reproduce this almost at will (actually I wish I could
stop it, for now I've turned off snapshots), and that the filesystem is deemed
clean, is there any patch/fix I can try?

Others on this thread with the same error: did anyone recover from this
without wiping the filesystem?

Is there a chance a balance might work around the bug so that whatever
layout I have, changes, and stops the bug from occuring?


gargamel:~# btrfs check --repair  /dev/mapper/dshelf1
enabling repair mode
Checking filesystem on /dev/mapper/dshelf1
UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 11454147125248 bytes used, no error found
total csum bytes: 11169793608
total tree bytes: 13468549120
total fs tree bytes: 715669504
total extent tree bytes: 478838784
btree space waste bytes: 1159606020
file data blocks allocated: 11917231079424
 referenced 11938096029696

gargamel:~# btrfs check --mode=lowmem /dev/mapper/dshelf1
Checking filesystem on /dev/mapper/dshelf1
UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 11454147158016 bytes used, no error found
total csum bytes: 11169793608
total tree bytes: 13506461696
total fs tree bytes: 753549312
total extent tree bytes: 478871552
btree space waste bytes: 1165617982
file data blocks allocated: 13203054301184
 referenced 13229588148224

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

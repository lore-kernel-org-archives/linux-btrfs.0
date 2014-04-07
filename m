Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47406 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbaDGUAE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 16:00:04 -0400
Date: Mon, 7 Apr 2014 13:00:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs on 3.14rc5 stuck on "btrfs_tree_read_lock           sync"
Message-ID: <20140407200002.GL1809@merlins.org>
References: <20140407160506.GG10789@merlins.org> <5342CE0C.3070707@fb.com> <20140407185121.GI10222@merlins.org> <5342FD3D.3090905@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5342FD3D.3090905@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 07, 2014 at 03:32:13PM -0400, Chris Mason wrote:
> >You're recommending that I try btrfs-next on a 3.15 pre kernel, correct?
> >If so would it be likely to fix my filesystem and let me go back to a
> >stable 3.14? (I'm a bit warry about running some unstable 3.15 on it :).
> 
> Right now the fixes for this are in the integration branch on my git 
> tree.  I think we've shaken  out all the problems, but if you want to 
> wait until tomorrow I'll have it in my next branch (for linux-next).

I can wait, even a few more days if needed.
But just to be clear: will this new kernel be something that will be
required for me to run from there on to avoid all those deadlocks and very
poor performance I'm seeing, or the new kernel will fix things up, and then
if other stuff isn't quite stable, I can downgrade back to 3.14 stable?

By the way, I think I know which filesystem is causing this, and one unusual
thing is that it uses a lot of hardlinks.

In case that helps, there are only 40 snapshots on it, but many inodes, of
which many are hardlinked together:

gargamel:/mnt/btrfs_pool2# btrfs filesystem df `pwd`
Data, single: total=3.28TiB, used=2.30TiB
System, DUP: total=8.00MiB, used=384.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=74.50GiB, used=70.11GiB
Metadata, single: total=8.00MiB, used=0.00
gargamel:/mnt/btrfs_pool2# btrfs filesystem show `pwd`
Label: btrfs_pool2  uuid: cb9df6d3-a528-4afc-9a45-4fed5ec358d6
	Total devices 1 FS bytes used 2.37TiB
	devid    1 size 7.28TiB used 3.43TiB path /dev/mapper/dshelf2

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

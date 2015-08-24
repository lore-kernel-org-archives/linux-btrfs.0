Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46626 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbbHXOKk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 10:10:40 -0400
Date: Mon, 24 Aug 2015 07:10:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, dsterba@suse.com, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
Message-ID: <20150824141013.GM5602@merlins.org>
References: <55CB631B.2080404@fb.com>
 <20150812160936.GK29259@merlins.org>
 <55CB71E5.1070302@fb.com>
 <20150812171912.GL29259@merlins.org>
 <55D1406C.9040607@cn.fujitsu.com>
 <20150817144904.GT29259@merlins.org>
 <20150822143746.GG5602@merlins.org>
 <55DA6F06.7030605@cn.fujitsu.com>
 <20150824042800.GJ5602@merlins.org>
 <55DAA77E.10105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55DAA77E.10105@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 24, 2015 at 01:11:26PM +0800, Qu Wenruo wrote:
> So, my last bet will be, using "btrfs-find-root -a" to find the root
> with highest generation, and use the new root to exec "btrfsck -b
> <bytenr of highest gen root>".
 
> The latest btrfs-find-root would output possible tree root by
> descending order of its generation. You'll find proper bytenr quite
> easy.
> But be prepared as "btrfs-find-root -a" will iterate all metadata
> space, so it will takes a long long time to finish.
> And until it scanned all the space, it won't output anything.

This is what I got:

myth:~# btrfs-find-root -a /dev/mapper/crypt_sdd1
Superblock thinks the generation is 39538
Superblock thinks the level is 1
Well block 4243456(gen: 3 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
Well block 4194304(gen: 2 level: 0) seems good, but generation/level doesn't match, want gen: 39538 level: 1
myth:~# 

Does it mean there is no other block I can/should use?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

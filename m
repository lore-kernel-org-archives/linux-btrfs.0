Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46671 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbbKOVid (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Nov 2015 16:38:33 -0500
Date: Sun, 15 Nov 2015 13:38:08 -0800
From: Marc MERLIN <marc@merlins.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20151115213808.GC23057@merlins.org>
References: <20151113174101.GC19249@merlins.org>
 <20151115063539.GC16363@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151115063539.GC16363@localhost.localdomain>
Subject: Re: Where is the disk space?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 14, 2015 at 10:35:39PM -0800, Liu Bo wrote:
> Since you said you have some snapshots in between...I can think of one
> case to prove where the space goes,
> 
> Say, you have a file with size=10M on a freshly created partition(the total used data space is 10M), and you have a snapshot which owns this file, then you modify the original file by overwrite the range [3M, 5M], and right now you can find that the total used data space increases to 15M or maybe more (because of unaliged write and extent pads to 4K length).
> 
> This comes from our COW and extent references implementation, so you get
> the benefit of COW, meanwhile have to live with the un-reclaimed space.
> 
> It's sort of something I was trying to fix, but I found that my approach
> led to other problems so I decided to give it up.

That's an interesting scenario. Thanks for explaining this.

MArc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

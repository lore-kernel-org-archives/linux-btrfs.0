Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43936 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaLGVif (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 16:38:35 -0500
Date: Sun, 7 Dec 2014 13:38:11 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20141207213811.GJ8916@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2014.11.23.22.49.01@googlemail.com>
 <pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 23, 2014 at 07:52:29AM +0000, Duncan wrote:
> > Right. So, why would you rebalance empty chunks or near empty chunks?
> > Don't you want to rebalance almost full chunks first, and work you way
> > to less and less full as needed?
> 
> No, the closer to empty a chunk is, the more effect you can get in 
> rebalancing it along with others of the same fullness.

On Sun, Nov 23, 2014 at 10:49:01PM +0000, Holger Hoffstätte wrote:
> Maybe also add that as of 3.18 empty block groups are automatically
> collected, so balancing to prevent ENOSPC-by-empty-chunks is no longer
> necessary. This works pretty well; I haven't run balance in weeks,
> and my total-vs.-used overhead has always been <10 GB.

Sorry for the delay in confirming this.
I've corrected both 
https://btrfs.wiki.kernel.org/index.php/Balance_Filters#Balancing_to_fix_filesystem_full_errors
and
http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
with your input.

Thanks much for that.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

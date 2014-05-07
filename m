Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37050 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaEGHvf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 03:51:35 -0400
Date: Wed, 7 May 2014 00:51:26 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Copying related snapshots to another server with btrfs
 send/receive?
Message-ID: <20140507075126.GA19238@merlins.org>
References: <20140504031231.GG9061@merlins.org>
 <5365E932.20602@swiftspirit.co.za>
 <20140504072829.GK9061@merlins.org>
 <5365F23E.8070009@swiftspirit.co.za>
 <pan$10f8$1751c450$6f6d3a98$57d04ce1@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$10f8$1751c450$6f6d3a98$57d04ce1@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 05, 2014 at 03:24:45AM +0000, Duncan wrote:
> *However*: snapshotting a read-only snapshot and making the new one 
> writable is easy enough[1].  Just keep the originals read-only so they 
> can be used as parents/clones, and make a second, writable snapshot of 
> the first, to do your writable stuff in.
> 
> ---
> [1]  Snapshotting a snapshot: I'm getting a metaphorical flashing light 

I already snapshot ro snapshots as rw snapshots and that works fine.
It's actually rely on this in my script:
http://marc.merlins.org/perso/btrfs/post_2014-03-22_Btrfs-Tips_-Doing-Fast-Incremental-Backups-With-Btrfs-Send-and-Receive.html
(skip to the bottom)
# We make a read-write snapshot in case you want to use it for a chroot
# and some testing with a writeable filesystem or want to boot from a
# last good known snapshot.
btrfs subvolume snapshot "$src_newsnap" "$src_newsnaprw"
$ssh btrfs subvolume snapshot "$dest_pool/$src_newsnap" "$dest_pool/$src_newsnaprw"

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35801 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaELX0i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 19:26:38 -0400
Date: Mon, 12 May 2014 16:26:09 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Filipe David Manana <fdmanana@gmail.com>
Subject: Re: 3.15-rc5 btrfs send/receive corruption errors? Does scrub warn
 of silent corruption?
Message-ID: <20140512232609.GI14174@merlins.org>
References: <E1WiphR-0003MN-50@legolas.merlins.org>
 <20140510224249.GA15909@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 10, 2014 at 04:57:18PM -0700, Marc MERLIN wrote:
> On Sat, May 10, 2014 at 03:42:49PM -0700, Marc MERLIN wrote:
> > I tried with 3.14.3 and it went further, however it died with
> > legolas:/mnt/btrfs_pool2# btrfs send  home_ro.20140507_10:00:01 | btrfs receive /mnt/btrfs_pool1/
> > At subvol home_ro.20140507_10:00:01
> > At subvol home_ro.20140507_10:00:01
> > ERROR: send ioctl failed with -5: Input/output error
> > ERROR: unexpected EOF in stream.
> > 
> > I'll look up -5 later when I have time, but I guess there is a problem
> > on the source that is causing copies to fail with both kernels?
> 
> This brings me back to the earlier question:
> 
> When my other FS died, scrub ran ok just earlier.
> 
> Now, having 2 btrfs sends (not incremental, full) fail with 2 kernels
> would indicate that something might be wrong on the source filesystem.

So I copied the entire FS back to the SSD using rsync instead of btrfs
send/receive and as far as I can tell all the data got over fine.

Is there anything you'd like from the subvolumes on the source that
btrfs cannot process and that I'm going to delete so that I can start
syncing back from the SSD to the HDD?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

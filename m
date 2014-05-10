Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45387 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaEJX5k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 19:57:40 -0400
Date: Sat, 10 May 2014 16:57:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Filipe David Manana <fdmanana@gmail.com>
Subject: Re: 3.15-rc5 btrfs send/receive corruption errors? Does scrub
Message-ID: <20140510235717.GB15909@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

warn of silent corruption?
Reply-To: 
In-Reply-To: <E1WiphR-0003MN-50@legolas.merlins.org>
 <20140510224249.GA15909@merlins.org>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/

On Sat, May 10, 2014 at 03:42:49PM -0700, Marc MERLIN wrote:
> I tried with 3.14.3 and it went further, however it died with
> legolas:/mnt/btrfs_pool2# btrfs send  home_ro.20140507_10:00:01 | btrfs receive /mnt/btrfs_pool1/
> At subvol home_ro.20140507_10:00:01
> At subvol home_ro.20140507_10:00:01
> ERROR: send ioctl failed with -5: Input/output error
> ERROR: unexpected EOF in stream.
> 
> I'll look up -5 later when I have time, but I guess there is a problem
> on the source that is causing copies to fail with both kernels?

This brings me back to the earlier question:

When my other FS died, scrub ran ok just earlier.

Now, having 2 btrfs sends (not incremental, full) fail with 2 kernels
would indicate that something might be wrong on the source filesystem.

Yet, last night's scrub ran fine too:

On Fri, May 09, 2014 at 11:39:13AM -0700, Anacron wrote:
> /etc/cron.daily/btrfs-scrub:
> scrub device /dev/mapper/cryptroot (id 1) done
> 	scrub started at Fri May  9 06:09:14 2014 and finished after 19153 seconds
> 	total bytes scrubbed: 646.15GiB with 0 errors

So, does scrub actually make sure everything on my filesystem is sane,
or can it miss some kinds of corruptions?

I can't run btrfsck on the filesystem because it's mounted and I have no
backup FS to boot from now until I fix my SSD.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46311 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaEKCaG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 22:30:06 -0400
Date: Sat, 10 May 2014 19:29:54 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Filipe David Manana <fdmanana@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: 3.15-rc5 btrfs send/receive corruption errors? Does scrub warn
 of silent corruption?
Message-ID: <20140511022954.GA14398@merlins.org>
References: <20140510220710.GA6772@merlins.org>
 <20140510224249.GA15909@merlins.org>
 <D55BDA6A-5DFA-4981-AC69-3156317ED169@colorremedies.com>
 <E1WiphR-0003MN-50@legolas.merlins.org>
 <20140510224249.GA15909@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D55BDA6A-5DFA-4981-AC69-3156317ED169@colorremedies.com>
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
> 
> Yet, last night's scrub ran fine too:
> 
> On Fri, May 09, 2014 at 11:39:13AM -0700, Anacron wrote:
> > /etc/cron.daily/btrfs-scrub:
> > scrub device /dev/mapper/cryptroot (id 1) done
> > 	scrub started at Fri May  9 06:09:14 2014 and finished after 19153 seconds
> > 	total bytes scrubbed: 646.15GiB with 0 errors
> 
> So, does scrub actually make sure everything on my filesystem is sane,
> or can it miss some kinds of corruptions?

I'm thinking that there must be some corruption on btrfs_pool2,
because:

On Sat, May 10, 2014 at 06:06:46PM -0600, Chris Murphy wrote:
> I think the issue might be there are still problems and changing code on the receive side (btrfs-progs). The kernel side code responsible for send is probably working correctly.

I tried
3.15 and progs 3.12
3.15 and progs 3.14
3.14 and progs 3.12
3.14 and progs 3.14

All 4 failed to run
legolas:/mnt/btrfs_pool2# btrfs send home_ro.20140507_10:00:01 | btrfs receive /mnt/btrfs_pool1/

3.14 gives:
ERROR: send ioctl failed with -5: Input/output error
ERROR: unexpected EOF in stream.

3.15 gives a more detailled message how it can't rename some corrupted
filename (regardless of whether I use progs 3.12 or 3.14).

So, since scrub tells me my FS is ok, is scrub right, or do I have a
file pattern that is causing a bug in btrfs send ?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

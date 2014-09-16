Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44621 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaIPX5r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 19:57:47 -0400
Date: Tue, 16 Sep 2014 16:57:42 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: btrfs differential receive has become excrutiatingly slow with
 COW files
Message-ID: <20140916235742.GG8530@merlins.org>
References: <20140908015124.GA21441@merlins.org>
 <CAL3q7H70SGvWamdeuvF1id-pnP0o4PskgJMb7qE+CfGBB5vd1w@mail.gmail.com>
 <20140915001836.GU8530@merlins.org>
 <20140915175747.GZ8530@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140915175747.GZ8530@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 15, 2014 at 10:57:47AM -0700, Marc MERLIN wrote:
> Unfortunately, due to my stupidity, the strace logging failed, but it looks 
> like I got about 12H worth of the following below. Interestingly that directory
> is nocow (VM images).
> Does btrfs send get unhappy with NOCOW?

So I ran another differential send/receive last night and it took another 10 or 12H
again.
Strace shows most of the time was spent on my virtualbox images which
did not change at all.

The diff itself wasn't big and only took 2mn to generate:
legolas:/mnt/btrfs_pool1# time btrfs send -p var_ggm_daily_ro.20140913_14:50:24 var_ggm_daily_ro.20140915_22:57:33 > /tmp/diff
At subvol var_ggm_daily_ro.20140915_22:57:33
real	2m14.365s
user	0m0.400s
sys	1m10.192s
legolas:/mnt/btrfs_pool1# du -sh /tmp/diff
11G	/tmp/diff

I have a filtered log showing any system call that took more than 1 sec,
that list is small:
http://marc.merlins.org/tmp/btrfs_receive.log

Most of the time is apparently just death by a thousand cuts of many
many system calls spent around receiving my virtual images that didn't
change.

Here's the full strace log if you wish
http://marc.merlins.org/tmp/btrfs_receive.log.xz

What do you think?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

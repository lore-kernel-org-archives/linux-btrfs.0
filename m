Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:34672 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824AbcGHVrg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 17:47:36 -0400
Date: Fri, 8 Jul 2016 23:47:11 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>
Cc: Gabriel C <nix.or.die@gmail.com>, linux-btrfs@vger.kernel.org,
        quwenruo@cn.fujitsu.com
Subject: Re: A lot warnings in dmesg while running thunderbird
Message-ID: <20160708214711.GA10544@angband.pl>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <ab5cc111-7ed7-3209-7411-6c656892d4a3@fb.com>
 <CAEJqkgiWOnyk8AzROc-tGTqKiDJkCt364tgFT5P-2Sa+XwjeMA@mail.gmail.com>
 <b84d72ce-3221-1f0d-7f63-ae02fe0d776b@fb.com>
 <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com>
 <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
 <20160708182116.GA30214@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160708182116.GA30214@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 08, 2016 at 08:21:16PM +0200, Adam Borowski wrote:
> On Fri, Jul 08, 2016 at 12:02:35PM -0400, Chris Mason wrote:
> > On 07/08/2016 11:02 AM, Gabriel C wrote:
> > > [btrfs_destroy_inode again]
> 
> > Can you please run the attached test program:
> > 
> > gcc -o short-write short-write.c -lpthread
> > ./short-write some-new-file-on-btrfs
> > 
> > I want to see if you're triggering the same problem we've tried to fix, or
> > something else.
> 
> Looks like same, 4.6.3:
[...]
> ... and sda1 is goes ro.
> Single device, noatime,compress=lzo,ssd.
> 
> It's somewhat puzzling that back in the day applying 56244ef15 stopped this
> reproducer for me, yet somehow it triggers again.

The above on 4.6.3 triggered pretty immediately.  I then compiled fresh
4.7-rc6+ (today's Linus' master), which did trigger only after a lot of time
and effort.  First I tried on freshly formatted 2TB spinning rust, no luck.
Then on 1GB rust, almost full of a mixture of crap.  Then on my regular ssd
-- it survived an hour of so with little concurrent use, then went boom only
late of a kernel compile on that filesystem.

Same backtrace.

-- 
An imaginary friend squared is a real enemy.

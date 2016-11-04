Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40861 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934840AbcKDR7b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Nov 2016 13:59:31 -0400
Date: Fri, 4 Nov 2016 10:59:21 -0700
From: Marc MERLIN <marc@merlins.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
Message-ID: <20161104175921.w5usn2voa2pfsx4c@merlins.org>
References: <20161031062509.GO28648@merlins.org>
 <0c9e25b1-c8e1-6300-0c79-e9e3e8fd0f52@cn.fujitsu.com>
 <20161031063737.GP28648@merlins.org>
 <81e30812-be45-b4ff-3bf2-c79e805d445a@cn.fujitsu.com>
 <20161031084412.GI16645@carfax.org.uk>
 <20161031150422.GQ28648@merlins.org>
 <38fa8b04-ec2d-884f-e03c-8bc2fb888efb@cn.fujitsu.com>
 <20161101042140.atn73lqehgpqslgz@merlins.org>
 <20161104080113.GG3529@merlins.org>
 <20161104140043.5d739dc9@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20161104140043.5d739dc9@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 04, 2016 at 02:00:43PM +0500, Roman Mamedov wrote:
> On Fri, 4 Nov 2016 01:01:13 -0700
> Marc MERLIN <marc@merlins.org> wrote:
> 
> > Basically I have this:
> > sde                            8:64   0   3.7T  0 
> > └─sde1                         8:65   0   3.7T  0 
> >   └─md5                        9:5    0  14.6T  0 
> >     └─bcache0                252:0    0  14.6T  0 
> >       └─crypt_bcache0 (dm-0) 253:0    0  14.6T  0 
> > 
> > I'll try dd'ing the md5 directly now, but that's going to take another 2 days :(
> > 
> > That said, given that almost half the device is not readable from user space
> > for some reason, that would explain why btrfs check is failing. Obviously it
> > can't do its job if it can't read blocks.
> 
> I don't see anything to support the notion that "half is unreadable", maybe
> just a 512-byte sector is unreadable -- but that would be enough to make
> regular dd bail out -- which is why you should be using dd_rescue for this,
> not regular dd. Assuming you just want to copy over as much data as possible,
> and not simply test if dd fails or not (but in any case dd_rescue at least
> would not fail instantly and would tell you precise count of how much is
> unreadable).

Thanks for the plug on ddrescue, I have used it to rescue drives in the
past.
Here, however, everything after the 8.8TB mark, is unreadable, so there
is nothing to skip.

Because the underlying drives are fine, I'm not entirely sure where the
issue is although it has to be on the mdadm side and not related to
btrfs.

And of course the mdadm array shows clean, and I have already disabled
the mdadm per drive bad block (mis-)feature which probably is
responsible for all the problems I've had here.
myth:~# mdadm --examine-badblocks /dev/sd[defgh]1
No bad-blocks list configured on /dev/sdd1
No bad-blocks list configured on /dev/sde1
No bad-blocks list configured on /dev/sdf1
No bad-blocks list configured on /dev/sdg1
No bad-blocks list configured on /dev/sdh1

I'm also still perplexed as to why despite the rear error I'm getting,
absolutely nothing is logged in the kernel :-/

I'll pursue that further and post a summary on the thread here if I find
something interesting.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

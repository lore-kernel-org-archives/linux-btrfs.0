Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36386 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752095AbaIPVUQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 17:20:16 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: unable to mount, tools segfault
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAPDSe6s2_bk18wakrjUb5+z+2fmVu3jjFpPEE63dM_rmeMEOeA@mail.gmail.com>
Date: Tue, 16 Sep 2014 15:20:14 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <3D5AA11E-78E2-4C5E-A333-887AA32418E0@colorremedies.com>
References: <CAPDSe6sip7UR3kge=aNedn6T1xhQmcEQHFCSm=JGDEibtRkOLw@mail.gmail.com> <5F01E283-D95E-4F81-B358-6470ABD58C0D@colorremedies.com> <45CDD4CC-7486-4074-A8E1-4573C40F8462@colorremedies.com> <CAPDSe6s2_bk18wakrjUb5+z+2fmVu3jjFpPEE63dM_rmeMEOeA@mail.gmail.com>
To: Tony Murray <murraytony@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 16, 2014, at 1:36 PM, Tony Murray <murraytony@gmail.com> wrote:

> Sorry, that was really just a sample of output rather then a
> run-through of my steps.  Also, I captured an image of the partition
> so I could re-install my OS.
> 
> I did try btrfs-zero-log first, but not btrfs rescue super-recover (as
> I was afraid it might break my superblock).

You could still try:
btrfs rescue super-recover -v <dev>
It will show you whether they are good or bad and which is which. And if they're good it won't fix anything. If one is bad it'll first ask you if it's a Btrfs fs before it tries to fix it. You can answer n if you don't want to try fixing it. At least, I get a crash, but it does fix corrupt csum before that.

It's also possible to use:
btrfs-show-super -afF <dev>
This will show all supers, even if any are bad, it won't fix anything. But it's going to spit out a lot more info.

Then it's possible to try:
btrfs check -s0 <dev>
btrfs check -s1 <dev>
to see if you get any different result; the first one will still be really bad because it's the same as default, but if the second one looks better then it might be that you either have a bad superblock, or a good one pointing to a bad root tree. In which case it may still be possible to fix.



Chris Murphy


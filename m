Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49380 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbcAARlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 12:41:39 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: John Center <jlcenter15@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub failing
Date: Fri, 01 Jan 2016 18:41:37 +0100
Message-ID: <2990858.uJLD34QYPg@merkaba>
In-Reply-To: <26CBABB7-7744-4833-A37B-C2380304223F@gmail.com>
References: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com> <pan$1f21$8d293d0$5b6cd545$34c90ade@cox.net> <26CBABB7-7744-4833-A37B-C2380304223F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 1. Januar 2016, 11:41:20 CET schrieb John Center:

Happy New Year!

> > On Jan 1, 2016, at 12:55 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> > 
> >
> > John Center posted on Thu, 31 Dec 2015 11:20:28 -0500 as excerpted:
> > 
> >
> >> I run a weekly scrub, using Marc Merlin's btrfs-scrub script.
> >> Usually, it completes without a problem, but this week it failed.  I ran
> >>
> >> the scrub manually & it stops shortly:
> >> 
> >>
> >> john@mariposa:~$ sudo /sbin/btrfs scrub start -BdR /dev/md124p2
> >> ERROR: scrubbing /dev/md124p2 failed for device id 1:
> >> ret=-1, errno=5 (Input/output error)
> >> scrub device /dev/md124p2 (id 1) canceled
> >> scrub started at Thu Dec 31 00:26:34 2015
> >> and was aborted after 00:01:29 [...]
> >
> > 
> >
> >> My Ubuntu 14.04 workstation is using the 4.2 kernel (Wily).
> >> I'm using btrfs-tools v4.3.1. [...]
> >
> > 
> >
> > A couple months ago, which would have made it around the 4.2 kernel 
> > you're running (with 4.3 being current and 4.4 nearly out), there were a 
> > number of similar scrub aborted reports on the list.
> >
> > 
> 
> I must have missed that, I'll check the list again to try & understand the
> issue better. 

I had repeatedly failing scrubs as mentioned in another thread here, until I 
used 4.4 kernel. With 4.3 kernel scrub also didn´t work. I didn´t use the 
debug options you used above and I am not sure whether I had this scrub issue 
with 4.2 already, so I am not sure it has been the same issue. But you may 
need to run 4.4 kernel in order to get scrub working again.

See my thread "[4.3-rc4] scrubbing aborts before finishing" for details.

Thanks,
-- 
Martin

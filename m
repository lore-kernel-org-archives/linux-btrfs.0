Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41808 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbcAATym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 14:54:42 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: John Center <jlcenter15@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub failing
Date: Fri, 01 Jan 2016 20:54:40 +0100
Message-ID: <2768984.nV98oqQhYy@merkaba>
In-Reply-To: <91318630-E23C-495D-B70E-BB484B3721C6@gmail.com>
References: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com> <2990858.uJLD34QYPg@merkaba> <91318630-E23C-495D-B70E-BB484B3721C6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 1. Januar 2016, 13:20:49 CET schrieb John Center:
> > On Jan 1, 2016, at 12:41 PM, Martin Steigerwald <martin@lichtvoll.de>
> > wrote:
> > Am Freitag, 1. Januar 2016, 11:41:20 CET schrieb John Center:
[…]
> >>> On Jan 1, 2016, at 12:55 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> >>> 
> >>> A couple months ago, which would have made it around the 4.2 kernel
> >>> you're running (with 4.3 being current and 4.4 nearly out), there were a
> >>> number of similar scrub aborted reports on the list.
> >> 
> >> I must have missed that, I'll check the list again to try & understand
> >> the
> >> issue better.
> > 
> > I had repeatedly failing scrubs as mentioned in another thread here, until
> > I used 4.4 kernel. With 4.3 kernel scrub also didn´t work. I didn´t use
> > the debug options you used above and I am not sure whether I had this
> > scrub issue with 4.2 already, so I am not sure it has been the same
> > issue. But you may need to run 4.4 kernel in order to get scrub working
> > again.
> > 
> > See my thread "[4.3-rc4] scrubbing aborts before finishing" for details.
> 
> I was afraid of this. I just read your thread. I generally try to stay away
> from kernels so new, but I may have to try it. Was there any reason you
> didn't go to 4.1 instead?  (I run win8.1 in VirtualBox 5.0.12, when I need
> to run somethings under Windows. I'd have to wait until 4.4 is released &
> supported to do that.)

So far 4.4-rc6 is pretty stable for me. And I think its almost before release 
as rc7 is out already.

Reason for not going with 4.1? Ey, that would be downgrading, wouldn´t it? But 
sure it is also an option.

Virtualbox 5.0.12-dfsg-2 as packaged by Debian runs fine here with 4.4-rc6.

Thanks,
-- 
Martin

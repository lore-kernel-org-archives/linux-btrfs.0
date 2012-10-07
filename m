Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47127 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2JGKxp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 06:53:45 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Subject: Re: btrfs send/receive review by vfs folks
Date: Sun, 7 Oct 2012 12:53:43 +0200
Cc: linux-btrfs@vger.kernel.org
References: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com> <201210061140.26936.Martin@lichtvoll.de> <CAHf9xvb8Oz+9TOQ_HJk8Qh5W==RKRme=u=QVvnBd-7E0oBW-gg@mail.gmail.com> (sfid-20121007_124846_782088_3512D00A)
In-Reply-To: <CAHf9xvb8Oz+9TOQ_HJk8Qh5W==RKRme=u=QVvnBd-7E0oBW-gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210071253.43538.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 7. Oktober 2012 schrieb Alex Lyakas:
> Matrin,

Martin, but bet was just a typo.

> On Sat, Oct 6, 2012 at 11:40 AM, Martin Steigerwald 
<Martin@lichtvoll.de> wrote:
> > Am Donnerstag, 4. Oktober 2012 schrieb Alex Lyakas:
> >> Hi Jan,
> >> as I promised, here is some code for you to look at.
> >> 
> >> First I will describe the approach in general.
> >> 
> >> # Get rid of the pipe. Instead, user-space passes a buffer and
> >> kernel fills the specified user-space buffer with commands.
> >> # When the buffer is full, kernel stops generating commands and
> >> returns a checkpoint to the user-space.
> > 
> > Can it just fill a second buffer while userspace command handles the
> > first?
> 
> No, at this point kernel receives only one buffer and fills it up.
> Can you pls elaborate more what improvement you have in mind? Like
> user-space sending a list of buffers to the kernel in one shot? Or
> that user-space handles kind of producer-consumer pool of buffers and
> works on full buffers while kernel fills the empty ones (this, of
> course, can work).
> 
> In general, my direction was to make the kernel call stateless, which
> makes the user-space part more flexible.

Hmmm, okay. So the kernel has only one buffer.

Well I had some kind of double buffering in mind. The kernel fills one buffer 
while the userspace application handles the other buffer. Then kernel and 
userspace swap buffers.

Just an idea of mine. I do not do kernel development, so I do not know 
whether its feasible. Was happy enough that I wrote a C program that uses 
some kernel functions some weeks ago that actually worked :)

So would using two buffers and swapping them make sense?

I do not understand what you mean by producer-consumer, but it seems like 
thats basically what I described as double buffering here.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

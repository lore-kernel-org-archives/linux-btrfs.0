Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57787 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2JGM7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 08:59:42 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive review by vfs folks
Date: Sun, 7 Oct 2012 14:59:40 +0200
Cc: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
References: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com> <201210071253.43538.Martin@lichtvoll.de> <CAHf9xvadjFfBXnVnBVMTuO4Cm62QMRwZD2c9KEANeLfW3Lkxug@mail.gmail.com> (sfid-20121007_142214_745086_F79370E9)
In-Reply-To: <CAHf9xvadjFfBXnVnBVMTuO4Cm62QMRwZD2c9KEANeLfW3Lkxug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210071459.40362.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 7. Oktober 2012 schrieb Alex Lyakas:

> On Sun, Oct 7, 2012 at 12:53 PM, Martin Steigerwald 
<Martin@lichtvoll.de> wrote:
> > Am Sonntag, 7. Oktober 2012 schrieb Alex Lyakas:
[…]
> >> On Sat, Oct 6, 2012 at 11:40 AM, Martin Steigerwald
> > 
> > <Martin@lichtvoll.de> wrote:
> >> > Am Donnerstag, 4. Oktober 2012 schrieb Alex Lyakas:
> >> >> Hi Jan,
> >> >> as I promised, here is some code for you to look at.
> >> >> 
> >> >> First I will describe the approach in general.
> >> >> 
> >> >> # Get rid of the pipe. Instead, user-space passes a buffer and
> >> >> kernel fills the specified user-space buffer with commands.
> >> >> # When the buffer is full, kernel stops generating commands and
> >> >> returns a checkpoint to the user-space.
> >> > 
> >> > Can it just fill a second buffer while userspace command handles
> >> > the first?
> >> 
> >> No, at this point kernel receives only one buffer and fills it up.
> >> Can you pls elaborate more what improvement you have in mind? Like
> >> user-space sending a list of buffers to the kernel in one shot? Or
> >> that user-space handles kind of producer-consumer pool of buffers
> >> and works on full buffers while kernel fills the empty ones (this,
> >> of course, can work).
> >> 
> >> In general, my direction was to make the kernel call stateless,
> >> which makes the user-space part more flexible.
> > 
> > Hmmm, okay. So the kernel has only one buffer.
> > 
> > Well I had some kind of double buffering in mind. The kernel fills
> > one buffer while the userspace application handles the other buffer.
> > Then kernel and userspace swap buffers.
> > 
> > Just an idea of mine. I do not do kernel development, so I do not
> > know whether its feasible. Was happy enough that I wrote a C program
> > that uses some kernel functions some weeks ago that actually worked
> > :)
> > 
> > So would using two buffers and swapping them make sense?

> Martin,
> I apologize for misspelling your name.

No problem.

> Yes, user-space can handle a buffer pool of any number of buffers,
> like one thread fetching a free buffer, handling it to the kernel,
> then putting it on some ready-buffer queue and signalling to a another
> thread that fetches ready (full) buffers and handles them. After it is
> done with the buffer, it puts it back on a free-buffer queue and
> signals the first thread. This is exactly producer-consumer.

Ah, so the kernel does not need to have anything to do with it. Nice.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

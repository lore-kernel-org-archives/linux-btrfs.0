Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:36571 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbbGCHvp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 03:51:45 -0400
Received: by iecvh10 with SMTP id vh10so72289450iec.3
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2015 00:51:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CADurGxx719dLB5my02r0ssM16BdW8kL5U5DrVM5PjA=u6zAcBA@mail.gmail.com>
References: <CADurGxx719dLB5my02r0ssM16BdW8kL5U5DrVM5PjA=u6zAcBA@mail.gmail.com>
Date: Fri, 3 Jul 2015 08:51:45 +0100
Message-ID: <CAL3q7H7xyuDNXeb97qkE+mxW7mMixcfyw=Fo5cADhbdH8e7OiA@mail.gmail.com>
Subject: Re: linux 4.1 - memory leak (possibly dedup related)
From: Filipe David Manana <fdmanana@gmail.com>
To: Marcel Ritter <ritter.marcel@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 3, 2015 at 7:58 AM, Marcel Ritter <ritter.marcel@gmail.com> wrote:
> Hi,
>
> I've been running some btrfs tests (mainly duperemove related) with
> linux kernel 4.1 for the last few days.
>
> Now I noticed by accident (dying processes), that all my memory (128
> GB!) is gone.
> "Gone" meaning, there's no user space process allocating this memory.
>
> Digging deeper I found the missing memory using slabtop (see output of
> /proc/slabinfo is attached): Looks like I got a lot of kernel memory
> allocated by kmalloc-1024 (memory leak?).
> Given the fact that the test machine does little more than btrfs
> testing I think this may be btrfs related.
>
> I was running duperemove on a 1.5 TB volume around the time the first
> "Out of memory" error were logged, so maybe the memory leak can be
> found somewhere in this code path.
>
> I'm still waiting for a scrub run to finish, after that I'll reboot
> the machine and try to reproduce this behaviour with a fresh btrfs
> filesystem.
>
> Have there been any fixes concerning memory leaks since 4.1 release I could try?
> Any other ideas how to track down this potential memory leak?

Hi,

We had Julian Taylor reporting the same on IRC a couple days ago (he
also found what was being leaked). I just sent a fix and cc'ed you
(https://patchwork.kernel.org/patch/6713301/).

thanks

>
> Bye,
>    Marcel



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

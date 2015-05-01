Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40475 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbbEAKN5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 May 2015 06:13:57 -0400
Received: from merkaba.localnet (host-188-174-203-177.customer.m-online.net [188.174.203.177])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id EEEB533B
	for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2015 12:13:55 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [REGRESSION] Hang during backup with rsync
Date: Fri, 01 May 2015 12:13:55 +0200
Message-ID: <2075166.qtr43mmylJ@merkaba>
In-Reply-To: <pan$b4d5f$f3e14022$274533d9$ff98a48f@cox.net>
References: <1943792.PglQ59K4TH@merkaba> <pan$b4d5f$f3e14022$274533d9$ff98a48f@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 1. Mai 2015, 01:48:23 schrieb Duncan:
> Martin Steigerwald posted on Thu, 30 Apr 2015 19:29:57 +0200 as 
excerpted:
> > The hang was: Mouse pointer in KDE not movable anymore, Ctrl-Alt-F1
> > had
> > no effect. I waited for a minute at least. Maybe it would have reacted
> > after a longer time, but I wanted my machine back. Disks where idle,
> > if
> > I remember correctly. After reboot both filesystems mount okay.
> 
> This response is in regard to what to do at an apparent hang, and has
> nothing directly to do with btrfs...
> 
> Two comments:
> 
> 1) Depending on your graphics hardware and driver config, a modern
> "KMS" (kernel modesetting) setup is more likely to "soft" hang in X mode
> and not switch back to text mode, even when the system is otherwise not
> hung and a VT switch would have worked fine pre-KMS-era.
> 
> While I'm no kernel or graphics expert, the problem from here /seems/ to
> be that a modern KMS kernel generally uses high-res framebuffer mode at
> the CLI as well, and because the basic kernel handling is unified
> framebuffer and kernel-mode-switching for both X and CLI modes,
> switching from X to CLI doesn't involve switching to the entirely
> separate VGA mode driver and with it the forced hardware reset that it
> used to.  Without that driver switch and forced reset, even if the
> switch actually occurs successfully in terms of what you might type,
> what is actually displayed may remain frozen, such that if you only
> have a local session, you generally have to reboot anyway, but if you
> already have a CLI login going in the VT you tried to switch to or can
> login blind, sometimes you can at least manage a controlled reboot, by
> doing an init 6 or systemctl reboot or whatever, even if the display is
> frozen and shows nothing.  Of course it doesn't always work, but given
> the chance to avoid an unclean shutdown, try it and see.
> 
> So no response at an attempted VT switch (your ctrl-alt-F1) doesn't mean
> what it used to...

I never read this. Also it is not obvious to me why a hardware reset would 
be needed if the embedded Intel gfx is initialized properly already. I do 
not believe that it was the GPU that hang.

I assume a simpler explaination: that X.org process was in D state and 
thus not able to respond to the keypress anymore. Or that the kernel was 
stuck in a way that it didn´t do anything anymore. Next time I may try a 
ping to the machine from my other laptop, cause from my experience in that 
case it doesn´t even respond to a ping anymore.

> 2) Along the same lines, there's the kernel's magic-sysrequest
> (sysrq/srq) functionality.  Assuming you have it enabled in your
> kernel, you can try a series of alt-sysrq-key sequences and very
> possibly use that to avoid an entirely uncontrolled shutdown, even when
> major functionality upto and including all of userspace is
> non-functional.

I didn´t try these, although I am aware they exist. I didn´t think of it 
and I didn´t memorize them. Maybe I dig for some kind of a reference card 
to stick to somewhere I can look up in that case.

Thing is, I wanted to have the machine back. Now. So I did the quickest 
way out. Yet, I still wanted to report what I could gather easily enough 
in a short time.

Thank you for your detailed explaination. I may just print your mail as a 
reference :)

But I had the plan that for the next backup attempt, I will quit X11 and 
have it running on TTY1, while also logging into TTY2 and TTY3 or to 
possible be able to issue some commands to gather further debug 
information. For that those sysrq combinations may be helpful.

> So, when I see descriptions of apparent system hangs such as yours,
> above, a big thing I look for is whether the K/REISUB magic-srq
> sequences were tried, and if so, at which step, if any, the kernel
> responded.
> 
> * If the user was in X and the secure-term K sequence worked, the
> problem wasn't too bad, and may have been a graphics system issue.
> 
> * If the S and R sequences worked, then the problem was worse, but
> either wasn't storage related, or at least was minor enough that the
> kernel felt it safe to sync and remount.
> 
> * If only the B sequence responded, then at least the kernel was still
> alive, but it considered the situation serious enough that it dare not
> do the sync/remount writes lest it risk scribbling on other partitions,
> etc.
> 
> * If not even the B sequence responded, then the kernel was effectively
> dead as well, and the problem was very serious indeed!
> 
> Unfortunately, the above hang description doesn't mention trying magic
> sysrq at all, and assuming you didn't try them, not only did you
> potentially needlessly endanger your data (if the S/R steps would have
> worked), but now we are missing that key bit of information about how
> badly the kernel /itself/ thought things were.

While I do think that these key combination can be helpful for further 
debugging I doubt they would have done anything for ensuring data 
integrity, cause…

… BTRFS was hung. And from my past experiences a issueing "sync" command 
from the shell, when it was still possible, just got the process of the 
"sync" command into D state and that was it.

When this happens usually after some time various parts of the KDE desktop 
stop responding as their processes try to write data to the BTRFS 
filesystem and get stuck in uninterruptible sleep.

Journaling and copy on write filesystems are supposed to deal with sudden 
interruption write operation just fine and it is a bug if they are 
corrupted afterwards. Only risk would be unwritten stuff, but, well, as I 
assumed BTRFS was frozen, and the backtraces seem to suggest that as well, 
it probably wouldn´t have written a single bit anyway anymore, unless I 
wait for it to eventually come out of the hang after some time. And this 
is the time I didn´t want to invest at that moment.

What was new this time compared to a regular BTRFS hang as they still 
happen when BTRFS allocated all space of the devices into chunks, that 
even the mouse pointer was frozen. Also here, clearly not all space of the 
devices was allocated into chunks, so what I have seen is a different 
issue.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

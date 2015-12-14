Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35441 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbbLNMGt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 07:06:49 -0500
Received: by mail-ig0-f176.google.com with SMTP id to4so2912220igc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 04:06:48 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <566DF757.8020807@birds-are-nice.me>
References: <566DF757.8020807@birds-are-nice.me>
Date: Mon, 14 Dec 2015 12:06:48 +0000
Message-ID: <CAL3q7H6Rd-Te2OCaLMswj3X3Zgy456jwMbgMeNy_+sP_=sAcpg@mail.gmail.com>
Subject: Re: Kernel lockup, might be helpful log.
From: Filipe Manana <fdmanana@gmail.com>
To: Birdsarenice <Quail@birds-are-nice.me>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 13, 2015 at 10:55 PM, Birdsarenice <Quail@birds-are-nice.me> wrote:
> I've finally finished deleting all those nasty unreliable Seagate drives
> from my array. During the process I crashed my server - over, and over, and
> over. Completely gone - screen blank, controls unresponsive, no network
> activity (no, I don't have root on btrfs - data only). Most annoying, but I
> think btrfs survived it all somehow - it's scrubbing now.
>
> Meanwhile, I did get lucky: At one crash I happened to be logged in and was
> able to hit dmesg seconds before it went completely. So what I have here is
> information that looks like it'll help you track down a rarely-encountered
> and hard-to-reproduce bug which can cause the system to lock up completely
> in event of certain types of hard drive failure. It might be nothing, but
> perhaps someone will find it of use - because it'd be a tricky one to both
> reproduce and get a good error report if it did occur.
>
> I see an 'invalid opcode' error in here, that's pretty unusual - and again
> it even gives a file name and line number to look at. The root cause of all
> my issues is the NCQ issue with Seagate 8TB archive drives, which is Someone
> Else's Problem - but I think some good can come of this, as these exotic
> forms of corruption and weird drive semi-failures have revealed ways in
> which btrfs's error handling could be made more graceful.
>
> Meanwhile I remain impressed that btrfs appears to have kept all my data
> intact even though all these issues.

Regarding the trace you got, from a BUG_ON, it's due a regression
present in 4.2 and 4.3 kernels that got fixed in 4.4-rc. The fixes are
scheduled for the next stable releases of 4.2.x and 4.3.x. A ton of
people have hit this (one example report
http://www.spinics.net/lists/linux-btrfs/msg49766.html).



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

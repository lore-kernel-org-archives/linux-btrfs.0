Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35116 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbcCGToV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 14:44:21 -0500
Received: by mail-io0-f169.google.com with SMTP id g203so143505648iof.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 11:44:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160307084235.GB6939@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160305200909.GJ1902@torres.zugschlus.de>
	<pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
	<CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
	<20160307084235.GB6939@torres.zugschlus.de>
Date: Mon, 7 Mar 2016 12:44:20 -0700
Message-ID: <CAJCQCtTfmh6rLfB0kg0HjAwoHsjaR3m1LygBaVTjirMyenwa8g@mail.gmail.com>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
From: Chris Murphy <lists@colorremedies.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 7, 2016 at 1:42 AM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> And this is really something to be proud of? I mean, this is a file
> system that is part of the vanilla linux kernel, not marked as
> experimental or something, and you're still concerned about file
> systems that were made a year ago? This is a new experience for me.

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/Documentation/filesystems/btrfs.txt?id=refs/tags/v4.4.4

"Btrfs is under heavy development, and is not suitable for
any uses other than benchmarking and review. The Btrfs disk format is
not yet finalized."

I thought the 2nd sentence was removed a long time ago but I'm seeing
it in the current branch and 4.1.y. Is this a bug?


-- 
Chris Murphy

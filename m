Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38744 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbcCGTH2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 14:07:28 -0500
Received: by mail-ig0-f174.google.com with SMTP id ig19so25413610igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 11:07:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56DDCEF6.4050308@gmail.com>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160305200909.GJ1902@torres.zugschlus.de>
	<pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
	<CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
	<20160307084235.GB6939@torres.zugschlus.de>
	<CAJCQCtTbfexN9UKRrHTs6yDkSxP3G7qsX-TMR8qZi=x1ef6vSg@mail.gmail.com>
	<56DDCEF6.4050308@gmail.com>
Date: Mon, 7 Mar 2016 12:07:26 -0700
Message-ID: <CAJCQCtSVSZ86LTFxgUH4gHuGiSLGLK2s1G3eGZ=p4ai1Krm4TA@mail.gmail.com>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 7, 2016 at 11:56 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>  People don't often think about it, but given the degree of code and
> version divergence due to patches, RHEL, SLES, and OEL kernels are strictly
> speaking, forks of Linux (most distro kernels are, but usually not to the
> extreme degree that enterprise kernels are (with the exception of some
> embedded systems, which can be even worse)).

Yes. The exception is with Fedora kernels which carry very minimal
well documented patches already in or planned to go in the upstream
kernel anyway. bugzilla.kernel.org has a Tree pop-up menu with a
Fedora option in addition to Mainline and some others, but no other
distros are listed.


-- 
Chris Murphy

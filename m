Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:34761 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbcCGS5i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 13:57:38 -0500
Received: by mail-qk0-f181.google.com with SMTP id x1so50535261qkc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 10:57:38 -0800 (PST)
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
To: Chris Murphy <lists@colorremedies.com>,
        Marc Haber <mh+linux-btrfs@zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160305200909.GJ1902@torres.zugschlus.de>
 <pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
 <CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
 <20160307084235.GB6939@torres.zugschlus.de>
 <CAJCQCtTbfexN9UKRrHTs6yDkSxP3G7qsX-TMR8qZi=x1ef6vSg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56DDCEF6.4050308@gmail.com>
Date: Mon, 7 Mar 2016 13:56:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTbfexN9UKRrHTs6yDkSxP3G7qsX-TMR8qZi=x1ef6vSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-07 13:39, Chris Murphy wrote:
> On Mon, Mar 7, 2016 at 1:42 AM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
>> [1] Does RHEL 6 have btrfs in the first place?
>
> They do, but you need a decoder ring to figure out what's been
> backported to have some vague idea of what equivalent kernel.org
> kernel it is.
>
Yeah, in general, if you want to get good upstream support for BTRFS 
(such as from the mailing lists), you still want to steer clear of 
'Enterprise' branded distros (RHEL (and by extension CentOS) is 
particularly bad about kernel versioning, OEL and and SLES are 
marginally better but still not great).  People don't often think about 
it, but given the degree of code and version divergence due to patches, 
RHEL, SLES, and OEL kernels are strictly speaking, forks of Linux (most 
distro kernels are, but usually not to the extreme degree that 
enterprise kernels are (with the exception of some embedded systems, 
which can be even worse)).

In fact, this is part of the reason I switched from using Gentoo's 
official kernel sources (they're nowhere near as bad about kernel 
versioning as enterprise distros, but they do have back-ports and 
numerous local modifications I don't care about) to my own sources which 
(try to) directly track linux-stable (the other reason being that it's 
easier to maintain my own patches via git than trying to handle user 
patching for gentoo-sources).

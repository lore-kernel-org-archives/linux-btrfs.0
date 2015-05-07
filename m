Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:33885 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbbEGFOc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 May 2015 01:14:32 -0400
Received: by iedfl3 with SMTP id fl3so34828767ied.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 22:14:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1816824.Xy3LLo99sJ@merkaba>
References: <1429312124.8371.62.camel@scientia.net> <1816824.Xy3LLo99sJ@merkaba>
From: Paul Harvey <csirac2@gmail.com>
Date: Thu, 7 May 2015 15:14:11 +1000
Message-ID: <CAB3_QuKK44Vy8Suu9xFap9m8ef+pLvOwd+=1_y3XA5YZwXpY+A@mail.gmail.com>
Subject: Re: how to clone a btrfs filesystem
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, russell@coker.com.au
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry I'm late to this conversation...

On 18 April 2015 at 18:10, Martin Steigerwald <martin@lichtvoll.de> wrote:
> That said, I think it can be scripted. But I am not aware of anyone having
> done this. I may be missing something, so maybe someone on the list has a
> recommendation.

I thought I'd mention that I have developed a script [1] which is a
part of snazzer [2] which at least transports all snapshots of all
subvolumes on all mounted btrfs filesystems (or a subset thereof),
using send -p where possible between two local filesystems or a remote
host via ssh. That is, of course, assuming your snapshots are named
and located according to the idiomatic convention expected by
snazzer-receive [1] - which is unlikely, I admit. Everybody uses btrfs
slightly differently.

Regarding comments in this thread that btrfs send/receive hasn't been
well tested and optimized, I've already found one inconsistency myself
[3] so I thought I'd just contribute that I've also got a "snapshot
measurement" script [4] which will give you a reliable, reproducible
sha512sum and PGP signature report (this report contains a shell
"one-liner" (!) consisting of only standard GNU core utils which you
can run at any point to reproduce the measurement or verify the PGP
signature still matches the filesystem under the path).

snazzer-measure [4] should give consistent sha512sums and PGP
signature verification regardless of whether the snapshot path happens
to live on a btrfs filesystem or not, so you can maintain a chain of
integrity all the way up to and beyond the point you move your
snapshots onto non-btrfs filesystems if you so wish.

[1] https://github.com/csirac2/snazzer/blob/master/doc/snazzer-receive.md
[2] https://github.com/csirac2/snazzer
[3] https://bugzilla.kernel.org/show_bug.cgi?id=95201
[4] https://github.com/csirac2/snazzer/blob/master/doc/snazzer-measure.md

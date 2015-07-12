Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48422 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbGLIyk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jul 2015 04:54:40 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: "erpo41@gmail.com" <erpo41@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Defrag operations sometimes don't work.
Date: Sun, 12 Jul 2015 10:54:37 +0200
Message-ID: <11405054.0T05W1bXEO@merkaba>
In-Reply-To: <CAPQXdDTT5E3f3VqAuQYKp3FwHjU45CfGW35du3HxRCHdyuz5gA@mail.gmail.com>
References: <CAPQXdDRKpp43M+by8wMGiMZa9VPD5XKs8CGpNLT=J41Q96E1Ug@mail.gmail.com> <3753681.2HYhjf7Zfa@merkaba> <CAPQXdDTT5E3f3VqAuQYKp3FwHjU45CfGW35du3HxRCHdyuz5gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 11. Juli 2015, 10:40:29 schrieb erpo41@gmail.com:
> On Sat, Jul 11, 2015 at 4:12 AM, Martin Steigerwald <martin@lichtvoll.de> 
wrote:
> > Always do "sync" after a "btrfs fi defrag" and before measuring with
> > "filefrag". The kernel may not have written everything. I have seen this
> > repeatedly that the extent count drops further after a "sync", following
> > "btrfs fi defrag".
> 
> First of all, thank you for your help. This fixed the problem for
> defragging individual files.

Note however: Even without "sync" BTRFS will defragment the file. It may 
just take a while till the new extents are written. So there is no need to 
call "sync" after btrfs fi defrag.

Why are you trying to defragment anyway? What are you trying to achieve / 
solve?

> I'm now seeing that recursive defragging doesn't work the way I expect.
> Running
> 
> $ btrfs fi defrag -r /path/to
> 
> returns almost immediately and does not reduce the number of fragments
> in /path/to/file. However, running
> 
> $ btrfs fi defrag /path/to/file
> 
> does reduce the number of fragments.

Well, I have no idea about this one. I have the same behavior with

> >> btrfs --version: Btrfs v3.17

v4.0

Ciao,
-- 
Martin

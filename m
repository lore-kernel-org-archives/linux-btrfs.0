Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34235 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112AbcCCPjN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 10:39:13 -0500
Received: by mail-ig0-f178.google.com with SMTP id g6so22209055igt.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 07:39:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$1a785$dbfe4789$bdc8f4d5$778788dd@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<pan$1a785$dbfe4789$bdc8f4d5$778788dd@cox.net>
Date: Thu, 3 Mar 2016 17:39:12 +0200
Message-ID: <CAOE4rSw_+PQEjAiHJkk03ec=J3ti9t9VCOD-zJSi=rP4dPnsjQ@mail.gmail.com>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-03-03 6:57 GMT+02:00 Duncan <1i5t5.duncan@cox.net>:
>
> You're issue isn't the same, because all your space was allocated,
> leaving only 1 MiB unallocated, which isn't normally enough to allocate a
> new chunk to rewrite the data or metadata from the old chunks into.
>
> That's a known issue, with known workarounds as dealt with in the FAQ.
>

Ah, thanks, well it was surprising for me that balance failed with out of
space when both data and metadata had not all been used and I thought
it could just use space from those...

especially as from FAQ:
> If there is a lot of allocated but unused data or metadata chunks,
> a balance may reclaim some of that allocated space. This is the
> main reason for running a balance on a single-device filesystem.

so I think regular balance should be smart enough that it could
solve this on own and wouldn't need to specify any options.

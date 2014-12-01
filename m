Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:59511 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaLAUwA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 15:52:00 -0500
Received: by mail-qa0-f52.google.com with SMTP id dc16so7937784qab.11
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 12:52:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547CD129.2030007@gmail.com>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<1416859665.3019.6@mail.thefacebook.com>
	<20141125164717.GK26471@twin.jikos.cz>
	<5475D7F3.4040408@swiftspirit.co.za>
	<5475DC9A.3060003@gmail.com>
	<20141201183729.GM12140@twin.jikos.cz>
	<547CD129.2030007@gmail.com>
Date: Mon, 1 Dec 2014 12:51:59 -0800
Message-ID: <CAJBj3vfr+awjY1iztH-wcy9PSzsCa2cYsDhmRz2cV-O=SFifHw@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: dsterba@suse.cz, Brendan Hide <brendan@swiftspirit.co.za>,
        Chris Mason <clm@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 12:35 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> My only reasoning is that with this set of hashes (crc32c, adler32, and
> md5), the statistical likely-hood of running into a hash collision with more
> than one of them at a time is infinitesimally small compared to the
> likely-hood of any one of them having a collision (or even compared to
> something ridiculous like the probability of being killed by a meteor
> strike), and the combination is faster on most systems that I have tried
> than many 256-bit crypto hashes.

I have not seen any evidence that combining hashes like that actually
reduces the chances of collision, but if we assume it does, then
again, the non-crypto hashes would be faster. For example, 128-bit
Spooky2 combined with 128-bit CityHash would produce a 256-bit hash
and would be faster than MD5 + whatever.

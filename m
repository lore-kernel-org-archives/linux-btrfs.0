Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36517 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbbHLSfY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 14:35:24 -0400
Received: by igxp17 with SMTP id p17so5920713igx.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 11:35:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJwcFg-Y5q2xBGnoohy0zSzpjtFZAq9U+HWS+erTcskUDgdWRw@mail.gmail.com>
References: <CAJwcFg-Y5q2xBGnoohy0zSzpjtFZAq9U+HWS+erTcskUDgdWRw@mail.gmail.com>
From: Catalin <zrianc@gmail.com>
Date: Wed, 12 Aug 2015 21:35:04 +0300
Message-ID: <CAJwcFg8i7hcqRUkgw2gG2S02d1NfCR1f6UufrMc=iKtNTCmjbQ@mail.gmail.com>
Subject: Re: btrfs-progs: btrfs balance returns enospc error on a system with
 80% free space
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 12:18 PM, Catalin wrote:
> I have a recently installed an Arch Linux x86_64 system on a 50GB
> btrfs partition and every time I try btrfs balance start it gives me
> an enospc error even though I have less than 20% of the available
> space full.
>
> I have tried the recommended method (from
> https://btrfs.wiki.kernel.org/index.php/Balance_Filters) and with
> -dusage I can go up to -dusage=100 with no problems but with -musage
> it works until 34 and then at musage=35 it fails with the enospc
> error.

Today I tried to force all installed packages to reinstall but before
that I deleted once again all the caches and existing snapshots and
BEFORE trying to reinstall I run again btrfs balance and this time it
worked even though I have more space occupied now than I had when the
error first appeared!

So theoretically my problem is SOLVED but I still think there is
either something wrong with balance since it should have be able to do
it before or there is something wrong with scrub or check because they
should have reported an error if there was one.

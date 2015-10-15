Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:32773 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbbJOQd7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 12:33:59 -0400
Received: by iodv82 with SMTP id v82so95772567iod.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 09:33:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151015024749.GB4400@hungrycats.org>
References: <CAGfcS_kADCxYy2yvTsHLdTTk=OEpx8FyspRfhvjLhbCQwdspKw@mail.gmail.com>
	<20151014050916.GA4400@hungrycats.org>
	<CAGfcS_nBFR7-aBVcTgU=htQBDWjzQnB_ePpdWKESVx+x4nROpw@mail.gmail.com>
	<20151015024749.GB4400@hungrycats.org>
Date: Thu, 15 Oct 2015 12:33:56 -0400
Message-ID: <CAGfcS_kWLphBDrcg=AxTMsuqf5zOSigxpLrqU=h5VwfCp=ZUDQ@mail.gmail.com>
Subject: Re: State of Dedup / Defrag
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2015 at 10:47 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> I wouldn't describe dedup+defrag as unsafe.  More like insane.  You won't
> lose any data, but running both will waste a lot of time and power.
> Either one is OK without the other, or applied to non-overlapping sets
> of files, but they are operations with opposite results.

That is probably why I disabled it then.  I now recall past discussion
that defragging a file wasn't snapshot-aware, though I thought that
was fixed.

Obviously there is always a tradeoff since from a dedup perspective
you're best off arranging extents so that you're sharing as much as
possible, and from a defrag standpoint you want to just have each file
have a single extent even if two files differ by a single byte.

I've pretty much stopped running VMs on btrfs and I've adjusted my
journal settings to something more sane so the defrag isn't nearly as
important these days.

--
Rich

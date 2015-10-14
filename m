Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34311 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbbJNM3V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 08:29:21 -0400
Received: by igbni9 with SMTP id ni9so77807397igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 05:29:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151014050916.GA4400@hungrycats.org>
References: <CAGfcS_kADCxYy2yvTsHLdTTk=OEpx8FyspRfhvjLhbCQwdspKw@mail.gmail.com>
	<20151014050916.GA4400@hungrycats.org>
Date: Wed, 14 Oct 2015 08:29:20 -0400
Message-ID: <CAGfcS_nBFR7-aBVcTgU=htQBDWjzQnB_ePpdWKESVx+x4nROpw@mail.gmail.com>
Subject: Re: State of Dedup / Defrag
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2015 at 1:09 AM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> I wouldn't try to use dedup on a kernel older than v4.1 because of these
> fixes in 4.1 and later:

I would assume that these would be ported to the other longterm
kernels like 3.18 at some point?

> Do dedup a photo or video file collection.  Don't dedup
> a live database server on a filesystem with compression enabled...yet.

LIkewise.  Typically I just dedup the entire filesystem, so it sounds
like we're not quite there yet.  Would it make sense to put this on
the wiki in the gotchas section?

> Using dedup and defrag at the same time is still a bad idea.  The features
> work against each other

You mentioned quite a bit about autodefrag.  I was thinking more in
terms of using explicit defrag, as was done by dedup in the past.  It
looks like duperemove doesn't actually do this, perhaps because it is
also considered unsafe these days.

Thanks, I was just trying to get a sense for where this was at.  It
sounds like we're getting to the point where it could be used in
general, but for now it is probably best to run it manually on stuff
that isn't too busy.

--
Rich

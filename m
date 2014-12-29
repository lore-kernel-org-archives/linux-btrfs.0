Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:50446 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaL2UZP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 15:25:15 -0500
Received: by mail-ie0-f179.google.com with SMTP id rp18so12710499iec.38
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Dec 2014 12:25:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141229190400.GA26040@carfax.org.uk>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
	<CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>
	<20141229190400.GA26040@carfax.org.uk>
Date: Mon, 29 Dec 2014 14:25:14 -0600
Message-ID: <CAAe=sHUYJVX5=Xi-r5HOMSLnPJV55z-FOmWWkZSj7yH2_YD1CA@mail.gmail.com>
Subject: Re: I need to P. are we almost there yet?
From: "sys.syphus" <syssyphus@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, "sys.syphus" <syssyphus@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

so am I to read that as if btrfs redundancy isn't really functional?
if i yank a member of my raid 1 out in live "prod" is it going to take
a dump on my data?

On Mon, Dec 29, 2014 at 1:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Dec 29, 2014 at 01:00:05PM -0600, sys.syphus wrote:
>> oh, and sorry to bump myself. but is raid10 *ever* more redundant in
>> btrfs-speak than raid1? I currently use raid1 but i know in mdadm
>> speak raid10 means you can lose 2 drives assuming they aren't the
>> "wrong ones", is it safe to say with btrfs / raid 10 you can only lose
>> one no matter what?
>
>    I think that with an even number of identical-sized devices, you
> get the same "guarantees" (well, behaviour) as you would with
> traditional RAID-10.
>
>    I may be wrong about that -- do test before relying on it. The FS
> probably won't like losing two devices, though, even if the remaining
> data is actually enough to reconstruct the FS.
>
>    Hugo.
>
> --
> Hugo Mills             | I can resist everything except temptation
> hugo@... carfax.org.uk |
> http://carfax.org.uk/  |
> PGP: 65E74AC0          |

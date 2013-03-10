Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37129 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3CJGh3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 01:37:29 -0500
Received: by mail-lb0-f179.google.com with SMTP id j14so2295045lbo.24
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Mar 2013 22:37:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFWF=anqt8ssajAQtVR2CBCLVXJJSneLjuvRZERm7m-oPkK=Ug@mail.gmail.com>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <khgcsi$1k4$1@ger.gmane.org> <20130310014434.GB30771@carfax.org.uk>
 <khh6er$nmk$1@ger.gmane.org> <CAFWF=anqt8ssajAQtVR2CBCLVXJJSneLjuvRZERm7m-oPkK=Ug@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Sun, 10 Mar 2013 07:37:07 +0100
Message-ID: <CAFWF=amO=G+BtqJxBNj8h_5Y7d8T=38xK4qnu=LZbUQyn3Zvew@mail.gmail.com>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Very good points,
>
> I was also gonna write something by the lines of 'all that matters is
> achieving the minimum amount of redundancy, as requested by the user,
> at the maximum possible performance'.
>
> After reading your post now, Roger, I'm much more clear on what I
> actually wanted to say, which is pretty much the same thing:
>
> In paradise really all I would have to tell btrfs is how many drives
> I'm willing to give away so that they will be used exclusively for
> redundancy. Everything else btrfs should figure out by itself. Not
> just because it's simpler for the user, but also because btrfs
> actually is in a position to KNOW better.
>
> As Roger said, as long as the given minimum redundancy quota is
> filled, btrfs could make choices that favor either even more
> redundancy or more performance based on my usage of the filesystem by
> meassuring things like throughput, ioops or space used. I could
> imagine that a snail filesystem that barely fills and doesn't do whole
> lot could easily work itself up on building huge redunancy, while a
> filesystem that requires high performance would do excessive striping
> to achieve maximum performance, while only keeping the minimum
> requested redundancy intact.
>
> It sounds quite futuristic to me, but it is definitely something that
> we have to achieve hopefully rather sooner than later :)
>
> I'm looking forward to it!

I have to add something to my own message: Even the notion of thinking
in 'how many devices do I want to give away for redundancy' is
outdated... What it really comes down to is how much space am I
willing to sacrifice so that my reliablilty is increasing. Rather than
addressing that at a per-drive level with a futuristic fs like btrfs I
think setting a percent value of total space would be best. Here are
my n hard drives, I want to give up thirty percent of maximum space so
that basically I can lose that amount of space across any device
combination and be safe. Do this for me and do it at maximum possible
performance with the device count, and type, and sizes that I've given
you. And if I'm not using the filesystem much, if I have tons of space
free, feel free to build even more redundancy while idle.

This is pretty much what it would be like in a perfect world, in my opinion :)

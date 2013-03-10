Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47538 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3CJLbr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 07:31:47 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Date: Sun, 10 Mar 2013 12:31:45 +0100
Cc: Harald Glatt <mail@hachre.de>, Roger Binns <rogerb@rogerbinns.com>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> <CAFWF=anqt8ssajAQtVR2CBCLVXJJSneLjuvRZERm7m-oPkK=Ug@mail.gmail.com> <CAFWF=amO=G+BtqJxBNj8h_5Y7d8T=38xK4qnu=LZbUQyn3Zvew@mail.gmail.com> (sfid-20130310_104338_942503_9A304C35)
In-Reply-To: <CAFWF=amO=G+BtqJxBNj8h_5Y7d8T=38xK4qnu=LZbUQyn3Zvew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303101231.45597.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 10. März 2013 schrieb Harald Glatt:
> > Very good points,
> > 
> > I was also gonna write something by the lines of 'all that matters is
> > achieving the minimum amount of redundancy, as requested by the user,
> > at the maximum possible performance'.
> > 
> > After reading your post now, Roger, I'm much more clear on what I
> > actually wanted to say, which is pretty much the same thing:
> > 
> > In paradise really all I would have to tell btrfs is how many drives
> > I'm willing to give away so that they will be used exclusively for
> > redundancy. Everything else btrfs should figure out by itself. Not
> > just because it's simpler for the user, but also because btrfs
> > actually is in a position to KNOW better.
[…]
> > It sounds quite futuristic to me, but it is definitely something that
> > we have to achieve hopefully rather sooner than later :)
> > 
> > I'm looking forward to it!
> 
> I have to add something to my own message: Even the notion of thinking
> in 'how many devices do I want to give away for redundancy' is
> outdated... What it really comes down to is how much space am I
> willing to sacrifice so that my reliablilty is increasing. Rather than
> addressing that at a per-drive level with a futuristic fs like btrfs I
> think setting a percent value of total space would be best. Here are
> my n hard drives, I want to give up thirty percent of maximum space so
> that basically I can lose that amount of space across any device
> combination and be safe. Do this for me and do it at maximum possible
> performance with the device count, and type, and sizes that I've given
> you. And if I'm not using the filesystem much, if I have tons of space
> free, feel free to build even more redundancy while idle.
> 
> This is pretty much what it would be like in a perfect world, in my
> opinion :) --

Still, the way to a perfect world is done in steps. Thus I agree with Hugo 
to start somewhere and I think for a admin who wants to know and specify 
exactly what is going one the patches Hugo offered for discussions are a 
huge step forward.

I think they are a good base to build upon.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

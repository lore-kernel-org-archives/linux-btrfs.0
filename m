Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:53585 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbbDEDa4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Apr 2015 23:30:56 -0400
From: Russell Coker <russell@coker.com.au>
To: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs hangs 3.19-10
Date: Sun, 5 Apr 2015 03:30:47 +0000
Cc: linux-btrfs@vger.kernel.org
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com> <20150404130047.GC13864@carfax.org.uk> <pan$bf795$4bdcf130$e29eb18a$9b854964@cox.net>
In-Reply-To: <pan$bf795$4bdcf130$e29eb18a$9b854964@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201504050330.47299.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 5 Apr 2015 03:16:21 AM Duncan wrote:
> Hugo Mills posted on Sat, 04 Apr 2015 13:00:47 +0000 as excerpted:
> > On Sat, Apr 04, 2015 at 12:55:08PM +0000, Russell Coker wrote:
> >> As an aside are there options to mkfs.btrfs that would make a
> >> filesystem mountable by kernel 3.2.65?  If so I'll file a Debian/Jessie
> >> bug report requesting that a specific mention be added to the man page.
> > 
> > Yes, there are. It's probably -O^extref, but if you can show the
> > dmesg output from the 3.2 kernel on the failed mount (so that it shows
> > what the actual failure was), we should be able to give you a more
> > precise answer.

[698190.987065] Btrfs loaded
[698190.999992] device fsid 118e2c64-6ce1-4f21-85e2-2d6aea8f0fa5 devid 1 
transid 426 /dev/sdf1
[698191.000981] btrfs: disk space caching is enabled
[698191.000986] BTRFS: couldn't mount because of unsupported optional features 
(60).
[698191.018176] btrfs: open_ctree failed

> So I was thinking about this, and the several other earlier options where
> support wasn't added until kernel X, and had an idea...
> 
> How easy and useful might it be to add to mkfs.btrfs appropriate option-
> group aliases such that if one knew the oldest kernel one was likely to
> deal with, all one would need to do for the mkfs would be to set for
> example, -O3.2, or even simply --3.2 (or maybe even --32), and have
> mkfs.btrfs automatically set/unset the appropriate options so it would
> "just work" with that kernel and anything newer?

That would be really useful.  Also it would be good if the code structure 
allowed adding extra aliases, so for Debian we could add an option -Owheezy.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

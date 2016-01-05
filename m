Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60476 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbcAETBO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 14:01:14 -0500
Received: from merkaba.localnet (host-188-174-204-22.customer.m-online.net [188.174.204.22])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 1AC6B24C
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Jan 2016 20:01:13 +0100 (CET)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs Check - "type mismatch with chunk"
Date: Tue, 05 Jan 2016 20:01:12 +0100
Message-ID: <3477132.ObA1D5uT4E@merkaba>
In-Reply-To: <pan$2c260$62827c72$5fe5d34$36d9b844@cox.net>
References: <CACRRrm9SwfDzqHNpWjAGniuu6HDu5wo3vW_ETdzijrdYm7YGGw@mail.gmail.com> <1451711566.8761.31.camel@scientia.net> <pan$2c260$62827c72$5fe5d34$36d9b844@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 5. Januar 2016, 15:34:35 CET schrieb Duncan:
> Christoph Anton Mitterer posted on Sat, 02 Jan 2016 06:12:46 +0100 as
> 
> excerpted:
> > On Fri, 2015-12-25 at 08:06 +0000, Duncan wrote:
> >> I wasn't personally sure if 4.1 itself was affected or not, but the
> >> wiki says don't use 4.1.1 as it's broken with this bug, with the
> >> quick-fix in 4.1.2, so I /think/ 4.1 itself is fine.  A scan with a
> >> current btrfs check should tell you for sure.  But if you meant 4.1.1
> >> and only typed 4.1, then yes, better redo.
> > 
> > What exactly was that bug in 4.1.1 mkfs and how would one notice that
> > one suffers from it?
> > I created a number of personal filesystems that I use "productively" and
> > I'm not 100% sure during which version I've created them... :/
> >
> > 
> >
> > Is there some easy way to find out, like a fs creation time stamp??
> 
> I believe a current btrfs check will flag the errors, but can't fix them, 
> as the problem was in the filesystem creation and is simply too deep to 
> fix, so the bad filesystems must be wiped and recreated with a mkfs.btrfs 
> without the bug, to fix.

btrfs check from btrfs tools 4.3.1 on kernel 4.4-rc6 has not been able to fix 
these errors and I recreated the filesystem that had the errors. I think I 
mentioned it also in this thread.

Thanks,
-- 
Martin

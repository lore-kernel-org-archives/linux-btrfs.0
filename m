Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60381 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaJFEKe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 00:10:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xazd2-0002om-LD
	for linux-btrfs@vger.kernel.org; Mon, 06 Oct 2014 06:10:32 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Oct 2014 06:10:32 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Oct 2014 06:10:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs check segfaults after flipping 2 Bytes
Date: Mon, 6 Oct 2014 04:10:21 +0000 (UTC)
Message-ID: <pan$37fbc$985496aa$c0a58ffc$edacda92@cox.net>
References: <542C6443.1010809@niklasfi.de> <5431FEA1.20803@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 06 Oct 2014 10:29:53 +0800 as excerpted:

> 2 problems here.
> 
> [1] csum mismatch As already mentioned by Ducan and Brendan, the csum
> does not match.
> 
> What makes thing much worse, since small file's extent is inlined, the
> data is stored in metadata tree blocks,
> and the file system is almost empty so the inline extent lies in the
> *root* leaf of fs_tree.
> These two unfortunate facts makes the whole fs_tree corrupted(only one
> leaf, and its cusm dismatch),
> which cause btrfs-progs segfault.

So I nailed it. =:^)

> The good news is that, the bug in btrfs-progs is already fixed by Wang's
> patch:
> https://patchwork.kernel.org/patch/4254631/
> So at least, btrfs-progs will not segfault anymore.
> 
> [2] two occurences?
> So you definitely changed something you should not touch... maybe
> another tree root?

1) Single device btrfs, therefore...
2) DUP metadata by default.

3) Small file, therefore...
4) Inlined in (DUP) metadata, therefore...

5) Two occurrences, each a copy of the (metadata-inlined) file in its own 
instance of the (duped) metadata block.

I nailed it again. =:^)

But the connection between the mentioned tree root patch and this 
particular bug had escaped me, so that's useful new information to me 
too, resolving the problem that I spotted but had no clue whether it was 
even fixable.  Thanks.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


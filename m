Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55848 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbaHXBVc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 21:21:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XLMUs-000432-Rz
	for linux-btrfs@vger.kernel.org; Sun, 24 Aug 2014 03:21:30 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 03:21:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 03:21:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs unmountable, any btrfs tool segfaults
Date: Sun, 24 Aug 2014 01:21:17 +0000 (UTC)
Message-ID: <pan$cd143$1f075140$a44693a2$c17a5577@cox.net>
References: <CAGP2HaPx2pXbN=FyBH5MskrsufDXcWtddVfG4Kaie-ZVg=ivJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nikolay Shtabel posted on Sat, 23 Aug 2014 16:39:48 +0000 as excerpted:

> After all, the last step is to use btrfs restore:
> 
> btrfs restore -iv /dev/sdc2 /mnt/restore/
> Check tree block failed, want=471748608, have=0
> Check tree block failed, want=471748608, have=0

> read block failed check_tree_block
> Couldn't setup extent tree

> read block failed check_tree_block
> Couldn't setup csum tree

> read block failed check_tree_block
> Segmentation fault [ 3324.252370]

> Can you please suggest any method to restore files from filesystem?

First answer (probably not too helpful, but gets the point across):

Since btrfs is still not fully stable and you are urged to keep backups 
if you value the data, then restore from them.  If you don't have them, 
by definition you obviously don't value the data enough to bother with 
the hassle of backing it up, so no big deal if you lose it, right?

Second answer (hopefully more helpful, but I'm obviously a bit grumpy 
today; I could put off answering until I'm not so grumpy, but I know what 
it's like to be waiting for an answer, so read thru the grumpy and we can 
both hope the solution works):

It used to be common courtesy to read a couple weeks of the the backgroup/
backlist before posting questions as they might be answered already.  I 
guess it isn't so these days...

Anyway, see the second half of the following post (the first half is a 
different problem and solution) dealing with using restore with btrfs-
find-root and etc, along with the wiki link mentioned (and of course the 
manpages as well).  With some luck you can still get btrfs restore 
working.  It worked for me recently (as you can see there, I had backups 
but they weren't as current as I would have liked).

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/37980

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


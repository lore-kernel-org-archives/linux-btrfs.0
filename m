Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33016 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbbI1Uwv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 16:52:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZgfPk-0000oq-C2
	for linux-btrfs@vger.kernel.org; Mon, 28 Sep 2015 22:52:48 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 22:52:48 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 22:52:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi defrag interfering (maybe) with Ceph OSD operation
Date: Mon, 28 Sep 2015 20:52:41 +0000 (UTC)
Message-ID: <pan$a0ad5$3d2cb4dd$ab00a420$4a68e0c6@cox.net>
References: <56080C9A.6030102@bouton.name>
	<pan$be4b9$74318552$9c70286d$e18abb29@cox.net>
	<56090E83.4030708@bouton.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lionel Bouton posted on Mon, 28 Sep 2015 11:55:15 +0200 as excerpted:

> From what I understood, filefrag doesn't known the length of each extent
> on disk but should have its position. This is enough to have a rough
> estimation of how badly fragmented the file is : it doesn't change the
> result much when computing what a rotating disk must do (especially how
> many head movements) to access the whole file.

AFAIK, it's the number of extents reported that's the problem with 
filefrag and btrfs compression.  Multiple 128 KiB compression blocks can 
be right next to each other, forming one longer extent on-device, but due 
to the compression, filefrag sees and reports them as one extent per 
compression block, making the file look like it has perhaps thousands or 
tens of thousands of extents when in actuality it's only a handful, 
single or double digits.

In that regard, length or position neither one matter, filefrag will 
simply report a number of extents orders of magnitude higher than what's 
actually there, on-device.

But I'm not a coder so could be entirely wrong; that's simply how I 
understand it based on what I've seen on-list from the devs themselves.

> In the case of Ceph OSD, this isn't what causes the performance problem:
> the journal is on the main subvolume and snapshots are done on another
> subvolume.

Understood... now.  I was actually composing a reply saying I didn't get 
it, when suddenly I did.  The snapshots were being taken of different 
subvolumes entirely, thus excluding the files here in question.

Thanks. =:^)

>>> This is on a 3.8.19 kernel [...]

>> [Btrfs was still experimental] until 3.12 [so] 3.8
>> is very much still in btrfs-experimental land! [...]
> 
> Oops, that was a typo : I meant 3.18.9, sorry :-(

That makes a /world/ of difference!  LOL!  I'm very much relieved!  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


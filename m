Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49003 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2HPHp5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 03:45:57 -0400
Date: Thu, 16 Aug 2012 00:45:55 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Message-ID: <20120816074555.GD8802@merlins.org>
References: <20120722185848.GA10089@merlins.org> <201208022321.51795.Martin@lichtvoll.de> <20120802214946.GB1834@merlins.org> <201208032045.19803.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201208032045.19803.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To close this thread.

I gave up on the drive after it showed abysmal benchmarking results in
windows too.

I owed everyone an update, which I just finished typing:
http://marc.merlins.org/perso/linux/post_2012-08-15_The-tale-of-SSDs_-Crucial-C300-early-Death_-Samsung-830-extreme-random-IO-slowness_-and-settling-with-OCZ-Vertex-4.html

I'm not sure how I could have gotten 2 bad drives from Samsung in 2
different shipments, so I'm afraid the entire line may be bad. At least, it
was for me after extensive benchmarking, and even using their own windows
benchmarking tool.

In the end, I got a OCZ Vertex 4 and it's superfast as per the benchmarks I
posted in the link above.

What is interesting is that ext4 is somewhat faster than btrfs in the tests
I posted above, but not in ways that should be truly worrisome.
I'm still happy to have COW and snapshots, even if that costs me
performance.

Sorry for spamming the list with what apparently just ended up a crappy
drive (well, 2 since I got two just to make sure) from a vendor who
shouldn't have been selling crappy SSDs.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

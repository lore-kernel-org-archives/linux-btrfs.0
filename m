Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42069 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaCYB3R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 21:29:17 -0400
Date: Mon, 24 Mar 2014 18:29:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs and raid5 status with kernel 3.14, documentation, and howto
Message-ID: <20140325012916.GF11533@merlins.org>
References: <20140323225657.GA17039@merlins.org> <lgq0b9$e5r$1@ger.gmane.org> <20140324215239.GC11533@merlins.org> <lgql40$lm5$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <lgql40$lm5$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 25, 2014 at 01:11:43AM +0000, Martin wrote:
> Yes, looking good, but for my usage I need the option to run ok with a
> failed drive. So, that's one to keep a development eye on for continued
> progress...
 
So it does run with a failed drive, it'll just fill the logs with write
errors, but continue working ok.
 
> There's a big thread a short while ago about using parity across
> n-devices where the parity is spread such that you can have 1, 2, and up
> to 6 redundant devices. Well beyond just raid5 and raid6:
> 
> http://lwn.net/Articles/579034/
 
Aah, ok. I didn't understand you meant that. I know nothing about that, but
to be honest, raid6 feels like it's enough for me :)

> btrfs raid1 at present is always just the two copies of data spread
> across whatever number of disks you have. A more flexible arrangement is
> to be able to set to have say 3 copies of data and use say 4 disks.
> There's a new naming scheme proposed somewhere that enumerates all the
> permutations possible for numbers of devices, copies and parity that
> btrfs can support. For me, that is a 'killer' feature beyond what can be
> done with md-raid for example.
 
Right. That's on the roadmap from what I read here, just not ready yet.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

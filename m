Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:57364 "EHLO
	cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbcBNAom (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Feb 2016 19:44:42 -0500
Date: Sat, 13 Feb 2016 19:44:39 -0500
From: Sean Greenslade <sean@seangreenslade.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID1 disk upgrade method
Message-ID: <20160214004439.GA1990@fox.rh.rit.edu>
References: <20160122034538.GA25196@coach.student.rit.edu>
 <pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
 <20160123214127.GA601@fox.wireless.rit.edu>
 <CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
 <20160127224549.GA4891@fox.rh.rit.edu>
 <20160127235528.GA5498@fox.rh.rit.edu>
 <56AA0A0A.1060807@gmail.com>
 <20160128153756.GA19617@fox.rh.rit.edu>
 <CAJCQCtRQZOM3cYiG_KyJYWRS-OR7Q+xMm6o1vBD6BTy=Eb2MUw@mail.gmail.com>
 <20160128184736.GB1167@fox.rh.rit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160128184736.GB1167@fox.rh.rit.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 28, 2016 at 01:47:36PM -0500, Sean Greenslade wrote:
> OK, I just misunderstood how that syntax worked. All seems good now.
> I'll try to play around with some dummy configurations this weekend to
> see if I can reproduce the post-replace mount bug.

So I finally got some time to play with this, and I am entirely unable
to reproduce these errors with virtual loop disks. I'm going to chalk
these errors up to transient SATA nastiness, since that's happened on
this system before. Either way, there was no data loss during this
entire operation, so besides a few extra unplanned reboots, things went
extremely well. Excellent work on btrfs, devs, and thanks to everyone
who chimed in to help me. 

--Sean


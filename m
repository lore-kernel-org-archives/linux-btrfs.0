Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:52861 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751637AbaLYDO3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 22:14:29 -0500
Date: Wed, 24 Dec 2014 21:18:47 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
Message-ID: <20141225031847.GC5864@pyropus.ca>
References: <20141217024228.GA5544@pyropus.ca> <54955624.5040808@pobox.com>
 <20141221163207.GA18988@pyropus.ca> <54973C65.6070709@pobox.com>
 <54977E50.7000109@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54977E50.7000109@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:
> 
> In addition, to confirm whether this problem is caused only by
> Btrfs or not, the following way can be used.
> 
>  1. preparing the extra storage,
>  2. copy Btrfs's data into int by dd if=<LVM volume> of=<extra storage>
>  3. Use it and confirm whether this problem still happen or not

I've already copied the ~16TB of data from the btrfs filesystem to an XFS
filesystem.  I do not see the performance variability under xfs that I see
under btrfs.

> However, since the size of your Btrfs is quite large, I guess you
> can't do it. If you have such extra storage, you've already
> embed it to Btrfs.

Actually, I decided to move to xfs, at least for now.  Apparently not many
people are using btrfs with filesystems >15TB, so it seems I'm in more-or-less
uncharted territory, at least according to the responses I've gotten when
looking into this issue.

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------

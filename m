From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: Poor performance unlinking hard-linked files (repost)
Date: Wed, 1 Dec 2010 10:24:53 +1100
Message-ID: <20101130232453.GB15817@brong.net>
References: <1289618724.28645.1405062363@webmail.messagingengine.com>
 <20101116125445.GA3229@brong.net>
 <1289914577-sup-8535@think>
 <20101117041148.GA10048@brong.net>
 <1290094104-sup-8656@think>
 <20101118214631.GC2401@brong.net>
 <1290175586-sup-2461@think>
 <20101119215810.GF12386@brong.net>
 <20101130093510.GB3622@brong.net>
 <1291121299-sup-9081@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bron Gondwana <brong@fastmail.fm>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291121299-sup-9081@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 30, 2010 at 07:49:26AM -0500, Chris Mason wrote:
> Excerpts from Bron Gondwana's message of 2010-11-30 04:35:10 -0500:
> > Do you have any suggestsions for what I could try?  You mentioned READ_SYNC
> > above.  We now have one working partition on this machine, but it took longer
> > to set up than most, and I'm not sure how it will cope with 7 more of them 
> > (which is my next project - compare to the historical performance of this
> > box first with reiserfs and then with ext4!)
> 
> Let me work up a patch that does READ_SYNC calls for the metadata reads,
> and I'll try to model this here a little.  We should be able to improve
> things.

Is there any reason why the read is going back down to the disk?  The
machine has 8Gb of RAM, and should easily have been able to cache all
the metadata under the workload it had.

I look forward to trying the patch :)

Thanks,

Bron.

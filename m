From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: yum upgrade on btrfs very slow
Date: Thu, 1 Oct 2009 11:01:46 +0200
Message-ID: <20091001090146.GA14522@mother.pipebreaker.pl>
References: <20090928121827.GA15930@mother.pipebreaker.pl> <20090928133543.GB6405@think> <20090929061822.GB15930@mother.pipebreaker.pl> <20090929132538.GN6405@think> <20090930194350.GA29166@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090930194350.GA29166@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 30, 2009 at 09:43:51PM +0200, Tomasz Torcz wrote:
> > 
> > If you're comparing w/ext3 and wondering why btrfs is sooooooo much
> > slower it might be because btrfs has barriers on by default and ext3
> > doesn't.  You could mount -o nobarrier for btrfs or mount -o barrier=1
> > for ext3 for a proper comparison.
> > 
> > (Assuming your dmesg doesn't have messages from btrfs about disabling
> > barriers).
> 
>   I wouldn't expect barriers to work here (reminder, this is PATA drive
> on ICH7 sata controller), but I will test tomorrow with nobarrier.
> Then I probably check his "yum upgrade" under seekwatcher on friday.

  Nobarrier result are here:
http://pipebreaker.pl/dump/sysrq_w-nobarrier.txt.bz2
http://pipebreaker.pl/dump/vmstat-nobarrier.txt.bz2

  My observation: still slow. Just a note on my unscientific methodology:
I've got two very similar machines with Rawhide, one on ext4, second
on btrfs. Every day I do "yum upgrade" on both. Ext4 one finishes much
faster thatn btrfs. This is especially visible while yum is in "cleanup phase".
On ext4 most packages are cleaned'up in under one second time. On btrfs
this takes few seconds.
  Whole transaction ends in couple of minutes on ext4. On btrfs it takes 5x
longer.

-- 
Tomasz Torcz               RIP is irrevelant. Spoofing is futile.
xmpp: zdzichubg@chrome.pl     Your routes will be aggreggated. -- Alex Yuriev


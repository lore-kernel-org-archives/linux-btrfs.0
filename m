From: Chris Mason <chris.mason@oracle.com>
Subject: Re: yum upgrade on btrfs very slow
Date: Mon, 26 Oct 2009 17:55:45 +0900
Message-ID: <20091026085545.GA5564@think>
References: <20090928121827.GA15930@mother.pipebreaker.pl>
 <20090928133543.GB6405@think>
 <20090929061822.GB15930@mother.pipebreaker.pl>
 <20090929132538.GN6405@think>
 <20090930194350.GA29166@mother.pipebreaker.pl>
 <20091001090146.GA14522@mother.pipebreaker.pl>
 <20091021092733.GD23138@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091021092733.GD23138@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 21, 2009 at 11:27:33AM +0200, Tomasz Torcz wrote:
> On Thu, Oct 01, 2009 at 11:01:46AM +0200, Tomasz Torcz wrote:
> > On Wed, Sep 30, 2009 at 09:43:51PM +0200, Tomasz Torcz wrote:
> > > > 
> > > > If you're comparing w/ext3 and wondering why btrfs is sooooooo much
> > > > slower it might be because btrfs has barriers on by default and ext3
> > > > doesn't.  You could mount -o nobarrier for btrfs or mount -o barrier=1
> > > > for ext3 for a proper comparison.
> 
>    Last update: things got noticably faster with 2.6.31.4-88.fc12.x86_64,
> which contains backport of latest mainline btrfs (thank you, Josef!).
> No more comlains from me (for now ;).

Fantastic. Are you running with or without barriers now?

-chris


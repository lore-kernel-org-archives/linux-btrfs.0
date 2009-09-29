From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: yum upgrade on btrfs very slow
Date: Tue, 29 Sep 2009 08:18:22 +0200
Message-ID: <20090929061822.GB15930@mother.pipebreaker.pl>
References: <20090928121827.GA15930@mother.pipebreaker.pl> <20090928133543.GB6405@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090928133543.GB6405@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 28, 2009 at 09:35:43AM -0400, Chris Mason wrote:
> On Mon, Sep 28, 2009 at 02:18:27PM +0200, Tomasz Torcz wrote:
> > 
> >   Hi,
> > 
> >  I'm using btrfs as rootfs on my Fedora 12 (rawhide) test system.
> > Every yum activity is very slow, like 15 minutes for installation of 11
> > packages 25MB in size. Kernel is 2.6.31.1-48.fc12.x86_64, btrfs-progs-0.19-7.fc12.x86_64.
> > Hardware is pentium 4 3.0 GHz (Hyperthreading, 64 bit), with single IDE disk 
> > on Intel ICH controller.
> 
> You're doing quite a lot of reads, and some writes.  Could you please
> capture the output of sysrq-w at 5s intervals during the upgrade?

  It got quite big (over 100 KiB, over 1 MiB after unpacking), so I
put it at http://pipebreaker.pl/dump/sysrq-w_every_5_sec.txt.bz2

-- 
Tomasz Torcz                Only gods can safely risk perfection,
xmpp: zdzichubg@chrome.pl     it's a dangerous thing for a man.  -- Alia


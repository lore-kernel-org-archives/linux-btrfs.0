From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: Re: subvolumes missing from "btrfs subvolume list" output
Date: Thu, 30 Jun 2011 09:40:46 +0100
Message-ID: <chaz20110630084046.GC28702@seebyte.com>
References: <chaz20110629143747.GA28702@seebyte.com> <chaz20110629150041.GB28702@seebyte.com> <4E0BC7AA.7000709@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0BC7AA.7000709@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-06-30 08:47:38 +0800, Li Zefan:
> Stephane Chazelas wrote:
> > 2011-06-29 15:37:47 +0100, Stephane Chazelas:
> > [...]
> >> I found
> >> http://thread.gmane.org/gmane.comp.file-systems.btrfs/8123/focus=8208
> >>
> >> which looks like the same issue, with Li Zefan saying he had a
> >> fix, but I couldn't find any mention that it was actually fixed.
> >>
> >> Has anybody got any update on that?
> > [...]
> > 
> > I've found
> > http://thread.gmane.org/gmane.comp.file-systems.btrfs/8232
> > 
> 
> After that, I posted a patch to fix btrfs-progs, which Chris aggreed
> on:
> 
> http://marc.info/?l=linux-btrfs&m=129238454714319&w=2
[...]

Great. Thanks a lot

It fixes my problem indeed.

Which brings me to my next question: where to find the latest
btrfs-progs if not at
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
(that one hasn't been modified in 8 months)?

Have changes for read-only subvolumes, per-directory settings...
been applied to some publicly available repository?

Cheers,
Stephane

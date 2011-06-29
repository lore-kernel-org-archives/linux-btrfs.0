From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: Re: subvolumes missing from "btrfs subvolume list" output
Date: Wed, 29 Jun 2011 16:00:41 +0100
Message-ID: <chaz20110629150041.GB28702@seebyte.com>
References: <chaz20110629143747.GA28702@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110629143747.GA28702@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-06-29 15:37:47 +0100, Stephane Chazelas:
[...]
> I found
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/8123/focus=8208
> 
> which looks like the same issue, with Li Zefan saying he had a
> fix, but I couldn't find any mention that it was actually fixed.
> 
> Has anybody got any update on that?
[...]

I've found
http://thread.gmane.org/gmane.comp.file-systems.btrfs/8232

but no corresponding fix or ioctl.c
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=history;f=fs/btrfs/ioctl.c

I'm under the impression that the issue has been forgotten
about.

>From what I managed to gather though, it seems that what's on
disk is correct, it's just the ioctl and/or "btrfs sub list"
that's wrong. Am I right?

(btw, I forgot to mention the kernel version: 3.0rc4 amd64,
btrfs tools from git)

Cheers,
Stephane

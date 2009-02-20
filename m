From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs-progs: update btrfs-debug-tree
Date: Fri, 20 Feb 2009 09:28:28 -0500
Message-ID: <1235140108.13249.0.camel@think.oraclecorp.com>
References: <499D04FF.5020600@cn.fujitsu.com>  <499DFBAC.1020602@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Shen Feng <shen@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <499DFBAC.1020602@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-02-19 at 19:39 -0500, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Shen Feng wrote:
> > output objectid in btrfs_disk_key with human readable strings.
> > Other updates are included for more readable output.
> 
> This gets messy fast. I'd like to see some sort of generic extensible
> printk mechanism in the kernel. 

This is a btrfs-progs patch ;)

> Maybe I've been spoiled by the reiserfs
> type printing but it seems a lot nicer to do eprintk(&ops, "key: %k\n");
> than to split them out into different printks. Since the core behavior
> ends up in vsnprintf, you get it for things like panic for free too.
> Ideally, the tprintk(&ops, ...) would be hidden behind a btrfs_warning()
> or something.
> 
> I have a patch set that implements an extensible printk so that every
> single pointer type doesn't need to be added to lib/vsprintf.c's pointer().
> 

That would be interesting, I do miss the old reiserfs %k

-chris



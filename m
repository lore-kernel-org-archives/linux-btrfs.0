Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:32986 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbbLHWiv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 17:38:51 -0500
Received: by pfnn128 with SMTP id n128so18909558pfn.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2015 14:38:51 -0800 (PST)
Received: from localhost (203-166-229-17.dyn.iinet.net.au. [203.166.229.17])
        by smtp.gmail.com with ESMTPSA id f67sm6890559pfd.9.2015.12.08.14.38.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Dec 2015 14:38:50 -0800 (PST)
Date: Wed, 9 Dec 2015 09:38:47 +1100
From: Alistair Grant <akgrant0710@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Fixing recursive fault and parent transid verify failed
Message-ID: <20151208223847.GA4419@alistair-xps13>
References: <20151207015715.GA13954@alistair-xps13>
 <pan$42653$68e1a3aa$3a4c1c2c$b0e89f8@cox.net>
 <20151207100256.GA6836@alistair-xps13>
 <pan$cb93a$b4f560b9$2dfdbdbc$17d7a835@cox.net>
 <20151207195504.GA9262@alistair-xps13>
 <pan$73edd$edd83c4d$2a373055$4b6032dd@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$73edd$edd83c4d$2a373055$4b6032dd@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 08, 2015 at 03:25:14PM +0000, Duncan wrote:
> Alistair Grant posted on Tue, 08 Dec 2015 06:55:04 +1100 as excerpted:
> 
> > On Mon, Dec 07, 2015 at 01:48:47PM +0000, Duncan wrote:
> >> Alistair Grant posted on Mon, 07 Dec 2015 21:02:56 +1100 as excerpted:
> >> 
> >> > I think I'll try the btrfs restore as a learning exercise, and to
> >> > check the contents of my backup (I don't trust my memory, so
> >> > something could have changed since the last backup).
> >> 
> >> Trying btrfs restore is an excellent idea.  It'll make things far
> >> easier if you have to use it for real some day.
> >> 
> >> Note that while I see your kernel is reasonably current (4.2 series), I
> >> don't know what btrfs-progs ubuntu ships.  There have been some marked
> >> improvements to restore somewhat recently, checking the wiki
> >> btrfs-progs release-changelog list says 4.0 brought optional metadata
> >> restore, 4.0.1 added --symlinks, and 4.2.3 fixed a symlink path check
> >> off-by-one error. (And don't use 4.1.1 as its mkfs.btrfs is broken and
> >> produces invalid filesystems.)  So you'll want at least progs 4.0 to
> >> get the optional metadata restoration, and 4.2.3 to get full symlinks
> >> restoration support.
> >> 
> >> ...


Thanks again Duncan for your assistance.

I plugged the ext4 drive I planned to use for the recovery in to the
machine and immediately got a couple of errors, which makes me wonder
whether there isn't a hardware problem with the machine somewhere.  So
decided to move to another machine to do the recovery.

So I'm now recovering on Arch Linux 4.1.13-1 with btrfs-progs v4.3.1
(the latest version from archlinuxarm.org).

Attempting:

sudo btrfs restore -S -m -v /dev/sdb /mnt/btrfs-recover/ ^&1 | tee btrfs-recover.log

only recovered 53 of the more than 106,000 files that should be available.

The log is available at: 

https://www.dropbox.com/s/p8bi6b8b27s9mhv/btrfs-recover.log?dl=0

I did attempt btrfs-find-root, but couldn't make sense of the output:

https://www.dropbox.com/s/qm3h2f7c6puvd4j/btrfs-find-root.log?dl=0

Simply mounting the drive, then re-mounting it read only, and rsync'ing
the files to the backup drive recovered 97,974 files before crashing.
If anyone is interested, I've uploaded a photo of the console to:

https://www.dropbox.com/s/xbrp6hiah9y6i7s/rsync%20crash.jpg?dl=0

I'm currently running a hashdeep audit between the recovered files and
the backup to see how the recovery went.

If you'd like me to try any other tests, I'll keep the damaged file
system for at least the next day or so.

Thanks again for all your assistance,
Alistair


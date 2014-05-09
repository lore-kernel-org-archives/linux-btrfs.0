Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaEIOvU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 10:51:20 -0400
Date: Fri, 9 May 2014 16:51:18 +0200
From: David Sterba <dsterba@suse.cz>
To: =?utf-8?B?VG9tw6HFoSBQcnXFvmluYQ==?= <pruzinat@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fwd: [suggestion] Add verbose notification about inode-cache
 rebuild to kernel log
Message-ID: <20140509145118.GD5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CACHxQ2tAU15z_pUEGBuGqYFR9n_fH9BeyA8=jYryRrb3H=zCYA@mail.gmail.com>
 <CACHxQ2sQH96Z==zqEaoEoOxc65k9TYD66yLXQzOYL1kxaPcrqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACHxQ2sQH96Z==zqEaoEoOxc65k9TYD66yLXQzOYL1kxaPcrqw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 08, 2014 at 04:22:13PM +0200, Tomáš Pružina wrote:
> I ran into some troubles with inode-cache rebuilding on root fs after
> filesystem was mounted without inode_cache, which stalls boot of my
> box by several minutes.
> 
> I boot from commandline like:
> root=/dev/sda4 rootfstype=btrfs
> rootflags=inode_cache,space_cache,autodefrag rw ...
> 
> However when I manually remount root fs without inode_cache (for
> example via kexec), it triggers cache rebuild at next mount which
> takes several tens of minutes and mimick 'freeze' on boot.
> 
> Would it be possible to put some printk saying that this is happening
> so users don't get confused about it??

Adding the printk is probably a good thing, but I'd rather reconsider
using inode_cache at all. IMO it's supposed to fix problems with inode
numbers that we don't have.

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Free_inode_number_cache

"As the filesystem fills up, finding a free inode number will become
expensive. This should be cached the same way we do free blocks."

Without inode_cache the new inode number is a simple increment from the
last number, in the 64bit space, per subvolume. We're not going to
reach the limits anytime soon.

The documentation does not say anything about that, I'll update the
wiki.

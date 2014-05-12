Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758475AbaELOjs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 10:39:48 -0400
Date: Mon, 12 May 2014 16:39:46 +0200
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: =?utf-8?B?VG9tw6HFoSBQcnXFvmluYQ==?= <pruzinat@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Fwd: [suggestion] Add verbose notification about inode-cache
 rebuild to kernel log
Message-ID: <20140512143946.GD6917@suse.cz>
Reply-To: dsterba@suse.cz
References: <CACHxQ2tAU15z_pUEGBuGqYFR9n_fH9BeyA8=jYryRrb3H=zCYA@mail.gmail.com>
 <CACHxQ2sQH96Z==zqEaoEoOxc65k9TYD66yLXQzOYL1kxaPcrqw@mail.gmail.com>
 <20140509145118.GD5988@twin.jikos.cz>
 <536D1AA6.7050407@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <536D1AA6.7050407@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 09, 2014 at 08:12:54PM +0200, Goffredo Baroncelli wrote:
> > Adding the printk is probably a good thing, but I'd rather reconsider
> > using inode_cache at all. IMO it's supposed to fix problems with inode
> > numbers that we don't have.
> 
> IIRC, the problem is for the 32 bit system, were the API wants the inode number to be 32 bit..
> 
> In the past the inode_cache was introduced because the inode often reached 2^32 [1]

Right, it makes sense for the 32bit case under some circumstances.
However I don't see where's "often reached 2^32" mentioned in the link.
If it's really 'often', then there's something wrong. A 32bit machine
serving large amounts of files? Or, it could reach the limit over time,
say a few years, so I'm not saying it can't happen in practice.

Then, inode_cache is the workaround for this usecase and can be turned on
if things are going to be bad.

Another workaround, that requires more manual intervention, is to create
a new subvolume and reflink all the files there.

> Because most modern hardware is 64 bit (with the exception of ARM ?),
> could be make sense to allow btrfs to work without inode_cache only on
> 64bit, loosing the possibility to be used on 32 bit system.
> 
> Instead when the inode_cache is used, btrfs still be compatible with
> both 32bit and 64bit systems.

There are 32bit machines in use and inode_cache brings some
compatibility assurance. Just that I would not recommend it to use by
default.

> How often a filesystem is moved between a 64bit and 32bit systems ?

Not so often I'd say, but for example the block device on a 32bit
machine can be exported via iscsi to a 64bit machine temporarily, then
the changes made on the 64bit host can make it unusable.

Thanks for the pointer, I think this is a documentation issue, we can
keep inode_cache code as-is.

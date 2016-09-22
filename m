Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932375AbcIVIyG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 04:54:06 -0400
Date: Thu, 22 Sep 2016 10:52:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com, osandov@fb.com
Subject: Re: Status of free-space-tree feature
Message-ID: <20160922085205.GM16983@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160921092406.GD16983@twin.jikos.cz>
 <57E2602C.7050703@applied-asynchrony.com>
 <85fb7ee0-7f6a-e8a0-46c6-dac12c3e69d2@gmail.com>
 <20160921203152.GA7694@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160921203152.GA7694@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 01:31:52PM -0700, Omar Sandoval wrote:
> > > I'm not sure I understand - can you explain why this is was so wrong?
> > > Or Omar maybe?
> > > 
> > > If btrfsck wants to correct something (write), it can simply always
> > > and unconditionally invalidate the fst instead of trying to "repair"
> > > it..and I think that's what happens at the moment (at least I think
> > > it did for me recently). That seems like a safe and simple way.
> > I know this is what it does with the regular FSC, but I'm not sure if it
> > does so with the FST.  If it doesn't, it probably should though.
> 
> It doesn't. The free space cache is easy to invalidate because we can
> just compare the generation number of the superblock to that of the
> space cache, but as it exists now, the free space tree doesn't have
> anything equivalent. That means that any modifications that btrfs-progs
> made to a space_cache=v2 filesystem could potentially have caused
> filesystem corruption :/
> 
> However, I talked this through with Chris, and he came up with a great
> idea that will help us deal with both this issue and the endianness
> issue [1] in one fell swoop. Basically, my objection to adding a compat
> bit for the endianness bug was that it would unnecessarily affect the
> vast majority of users on x86; forcing those users to recreate their
> free space tree seemed silly. However, because of the btrfs-progs bug,
> just to be safe, we might as well force everyone to recreate their free
> space tree.
> 
> The solution is to add a FREE_SPACE_TREE_VALID compat_ro bit. If the bit
> isn't set, then we destroy and rebuild the free space tree. This covers
> the case of big-endian kernels which created broken free space trees and
> filesystems which could have possibly gone through btrfs-progs.
> 
> This time we'll make sure not to make btrfs-progs think it can mount
> FREE_SPACE_TREE_VALID filesystems read-write. We can even have
> btrfs-progs check for that bit and clear it if it's mounting read-write.
> The next time it gets mounted, the kernel will recreate the tree. It's
> not pretty, but it'll work.

Sounds like a good plan to me. The bit is a form of 'clear_cache' mount.
We need to to a coordinated fix (kernel, progs), if the patches are
ready soon, 4.9 is feasible target.

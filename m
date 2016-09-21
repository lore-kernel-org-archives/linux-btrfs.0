Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:33887 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933548AbcIUUby (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 16:31:54 -0400
Received: by mail-pf0-f181.google.com with SMTP id p64so22628478pfb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 13:31:54 -0700 (PDT)
Date: Wed, 21 Sep 2016 13:31:52 -0700
From: Omar Sandoval <osandov@osandov.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        dsterba@suse.cz, linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com,
        osandov@fb.com
Subject: Re: Status of free-space-tree feature
Message-ID: <20160921203152.GA7694@vader.DHCP.thefacebook.com>
References: <20160921092406.GD16983@twin.jikos.cz>
 <57E2602C.7050703@applied-asynchrony.com>
 <85fb7ee0-7f6a-e8a0-46c6-dac12c3e69d2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <85fb7ee0-7f6a-e8a0-46c6-dac12c3e69d2@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey, guys,

On Wed, Sep 21, 2016 at 08:12:51AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-09-21 06:25, Holger Hoffstätte wrote:
> > On 09/21/16 11:24, David Sterba wrote:
> > > Hi,
> > > 
> > > as you might have noticed, the [1] wiki Status page lists the
> > > free-space-tree as 'Unstable', referencing a problem with the bitmap
> > > endianity. This will affect only bigendian systems.
> > > 
> > > There's one more problem that I overlooked but was pointed to by Omar
> > > recently.  The initial FST support in btrfs-progs is read-only,
> > > 
> > > https://marc.info/?l=linux-btrfs&m=144113538017042
> > > 
> > > "However, we're not adding the FREE_SPACE_TREE read-only compat bit to
> > > the set of supported bits because progs doesn't know how to keep the
> > > free space tree consistent."
> > > 
> > > Historically, the initial patchset version did not recognize FST feature
> > > and thus refused to write, but then it was pointed by Qu and Holger that
> > > the compat_ro bit is missing for FST. I've added it but this was a
> > > mistake. This change is going to be reverted.
> > 
> > I'm not sure I understand - can you explain why this is was so wrong?
> > Or Omar maybe?
> > 
> > If btrfsck wants to correct something (write), it can simply always
> > and unconditionally invalidate the fst instead of trying to "repair"
> > it..and I think that's what happens at the moment (at least I think
> > it did for me recently). That seems like a safe and simple way.
> I know this is what it does with the regular FSC, but I'm not sure if it
> does so with the FST.  If it doesn't, it probably should though.

It doesn't. The free space cache is easy to invalidate because we can
just compare the generation number of the superblock to that of the
space cache, but as it exists now, the free space tree doesn't have
anything equivalent. That means that any modifications that btrfs-progs
made to a space_cache=v2 filesystem could potentially have caused
filesystem corruption :/

However, I talked this through with Chris, and he came up with a great
idea that will help us deal with both this issue and the endianness
issue [1] in one fell swoop. Basically, my objection to adding a compat
bit for the endianness bug was that it would unnecessarily affect the
vast majority of users on x86; forcing those users to recreate their
free space tree seemed silly. However, because of the btrfs-progs bug,
just to be safe, we might as well force everyone to recreate their free
space tree.

The solution is to add a FREE_SPACE_TREE_VALID compat_ro bit. If the bit
isn't set, then we destroy and rebuild the free space tree. This covers
the case of big-endian kernels which created broken free space trees and
filesystems which could have possibly gone through btrfs-progs.

This time we'll make sure not to make btrfs-progs think it can mount
FREE_SPACE_TREE_VALID filesystems read-write. We can even have
btrfs-progs check for that bit and clear it if it's mounting read-write.
The next time it gets mounted, the kernel will recreate the tree. It's
not pretty, but it'll work.

1: http://marc.info/?l=linux-btrfs&m=147159380621517&w=2

-- 
Omar

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35429 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbbL2GZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 01:25:27 -0500
Received: by mail-wm0-f51.google.com with SMTP id f206so1281766wmf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 22:25:27 -0800 (PST)
Date: Mon, 28 Dec 2015 21:23:43 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151228212343.449c8631@gmail.com>
In-Reply-To: <1451368991.7094.45.camel@scientia.net>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<1451341195.7094.0.camel@scientia.net>
	<20151228153801.6561feff@gmail.com>
	<1451352069.7094.3.camel@scientia.net>
	<20151228164333.2b8d8336@gmail.com>
	<1451360528.7094.7.camel@scientia.net>
	<20151228190336.59a3f440@gmail.com>
	<1451363188.7094.23.camel@scientia.net>
	<20151228203111.7ba8b0be@gmail.com>
	<1451368991.7094.45.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 29 Dec 2015 07:03:11 +0100
Christoph Anton Mitterer <calestyo@scientia.net> wrote:

> On Mon, 2015-12-28 at 20:31 -0500, Sanidhya Solanki wrote:
> > What is your experience like about running a production system on
> > what
> > is essentially a beta product? Crashes?
> What do you mean? btrfs? I'm not yet running it in production (there
> was a subthread recently, where I've explained a bit more why).

>From Documentation/filesystems/BTRFS.txt:
Btrfs is under heavy development, and is not suitable for
any uses other than benchmarking and review. The Btrfs disk format is
not yet finalized.

> > Would something like ZFS not be more suited to your environment?
> Well I guess that's my personal political decision... I simply think
> that btrfs should and will be the next gen Linux main filesystem.
> Plus that IIRC zfs-fuse is no unmaintained and linux-zfs not yet part
> of Debian rules it anyway out, as I'd be tool lazy to compile it
> myself (at least for work ;) ).

The kernel module "ZFS on Linux" is still actively developed according
to their repo activity (https://github.com/zfsonlinux/zfs). It is done
by a subcontractor for Lawrence Livermore National Laboratory.
Considering they are still in preparation for their Next Generation
Supercomputer (Summit), we can assume that they will keep financing the
development.

> > Especially as not all disks will be full, and, if a disk was to
> > fail, the entire disk would need to be rebuilt from parity drives
> > (as opposed
> > to ZFS only using the parity data, and not copying empty blocks
> > (another feature that is planned for BTRFS))
> Ah? I thought btrfs would already do that as well?

Not yet. Not according to the source code "todo"s atleast.
Thanks for the information about HW RAID controllers.
> I'm not sure what you mean by "cache"... wouldn't btrfs' CoW mean that
> you "just" copy the data, and once this is done, update the metadata
> and things would be either consistent or they would not (and in case
> of a crash still point to the old, not yet reshaped, data)?
> 
> A special case were of course nodatacow'ed data.... there one may need
> some kind of cache or journal... (see the other thread of mine, where
> I ask for checksumming with no-CoWed data =) ).

I just started working recently on BTRFS, I forgot about the CoW part.

Thanks

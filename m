Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:62978 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3CCXwq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 18:52:46 -0500
Received: by mail-we0-f182.google.com with SMTP id t57so4075364wey.27
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Mar 2013 15:52:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEx9m454t17kngaKv+PWL2V=DLYr6viT6J_eWEtHFfc10csioQ@mail.gmail.com>
References: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
	<20130220175410.GB2062@localhost.localdomain>
	<CAEx9m46b9rW4xDiQi8QiTmyC5Wa9hNcasL_nXF4Y2qdyPE+D6g@mail.gmail.com>
	<CAEzrpqcGeiq=tHEvcH9625vZpCZaD94PrpjYO1_r4nS2GP9ByA@mail.gmail.com>
	<CAEx9m45V6aUkNQe0PTf+qJjpkJLHyMc4UBfSex9mxGOy-X7GrQ@mail.gmail.com>
	<20130225172719.GA2434@localhost.localdomain>
	<CAEx9m44BBv-rZqF_tv5PgKkHjfzBYo9p-4h3WeGLdykA+s+71A@mail.gmail.com>
	<CAEx9m454t17kngaKv+PWL2V=DLYr6viT6J_eWEtHFfc10csioQ@mail.gmail.com>
Date: Sun, 3 Mar 2013 18:52:44 -0500
Message-ID: <CAEzrpqe86eFRTr+AL+1agmaF712nGS0fXwpDf67CnaDd86KuLQ@mail.gmail.com>
Subject: Re: basic questions regarding COW in Btrfs
From: Josef Bacik <josef@toxicpanda.com>
To: Aastha Mehta <aasthakm@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 3, 2013 at 10:41 AM, Aastha Mehta <aasthakm@gmail.com> wrote:
> Hi Josef,
>
> I have some more questions following up on my previous e-mails.
> I now do somewhat understand the place where extent entries get
> cow'ed. But I am unclear about the order of operations.
>
> Is it correct that the data extent written first, then the pointer in
> the indirect block needs to be updated, so then it is cowed and
> written to disk and so on recursively up the tree? Or is the entire
> path from leaf to node that is going to be affected by the write cowed
> first and then all the cowed extents are written to the disk and then
> the rest of the metadata pointers, (for example, in checksum tree,
> extent tree, etc., I am not sure about this)?

The second one.  We COW the entire path from root to leaf as things
need COW'ing.  We start a transaction, we insert the file extent
entries, we add the checksums, and we add the delayed ref updates to
the extent tree.  The delayed things are guaranteed to happen in that
transaction so we have consistency there.  The COW'ing from top to
bottom works like that for all trees.

>
> Also, I need to understand specifically how the data (leaf nodes) of a
> file is written to disk v/s the metadata including the indirect nodes
> of the file. In extent_writepage I only know the pages of a file that
> are to be written. I guess, I can identify metadata pages based on the
> inode of the page's owner. But is it possible to distinguish the pages
> available in extent_writepage path as belonging to the leaf node or
> internal node for a file? If it cannot be identified at this point,
> where earlier in the path can this be decided?
>

So they are different things, and they could change from the time we
write to the time that the write completes because of COW.  Also keep
in mind that the metadata (the file extent items and such) for the
inodes are not stored specifically within the inode, they're stored
inside the same tree that the inode resides in.  So you can have a
leaf node with multiple inodes and extents for those different inodes.
 And so any sort of random things can happen, other inodes can be
deleted and this inode's metadata will be shifted into a new leaf, or
another inode could be added and this inode's data could be pushed off
into an adjacent leaf.  The only way to know which leaf/page the inode
is associated with is to search for whatever you are looking for in
the tree, and then while you are holding all of the locks and
reference counting you can be sure that those pages contain the
metadata you are looking for, but once you let that go there are no
guarantees.

So as far as how it is written to disk, that is where transactions
come in.  We track all the dirty metadata pages we have per
transaction, and then at transaction commit time we make sure that all
of those pages are written to disk and then we commit our super to
point to the new root of the tree root, which in turn points at all of
our new roots because of COW.  These pages can be written before the
commit though because of memory pressure, and if they are written and
then modified again within in the same transaction we will re-cow them
to make sure we don't have any partial-page updates.  Keeping track of
where a specific inodes metadata is contained is a tricky business.
Let me know if that helped.  Thanks,

Josef

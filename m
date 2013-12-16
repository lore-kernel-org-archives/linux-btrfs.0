Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42855 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab3LPQSo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 11:18:44 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Mon, 16 Dec 2013 11:18:43 -0500
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 8F465C90026
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 11:18:38 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23032.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rBGGIe2D31719476
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 16:18:40 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rBGGIdIh006237
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 11:18:40 -0500
Subject: Re: [PATCH 2/7] btrfs: subpagesize-blocksize: Use a global
 alignment for size
From: Chandra Seetharaman <sekharan@us.ibm.com>
Reply-To: sekharan@us.ibm.com
To: dsterba@suse.cz
Cc: saeed bishara <saeed.bishara@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <20131216144830.GF6498@twin.jikos.cz>
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
	 <1386805122-23972-3-git-send-email-sekharan@us.ibm.com>
	 <CAMAG_ee_8od-mQ2GG3314aMiq8msqWFMoSGp_jBS9xZwvY9GBA@mail.gmail.com>
	 <20131216144830.GF6498@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Dec 2013 10:18:38 -0600
Message-ID: <1387210718.4241.215.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2013-12-16 at 15:48 +0100, David Sterba wrote:
> On Mon, Dec 16, 2013 at 02:33:11PM +0200, saeed bishara wrote:
> > On Thu, Dec 12, 2013 at 1:38 AM, Chandra Seetharaman
> > <sekharan@us.ibm.com> wrote:
> > > In order to handle a blocksize that is smaller than the
> > > PAGE_SIZE, we need align all IOs to PAGE_SIZE.
> > >
> > > This patch defines a new macro btrfs_align_size() that
> > > calculates the alignment size based on the sectorsize
> > > and uses it at appropriate places.
> > >
> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > ---
> > >  fs/btrfs/btrfs_inode.h  |  7 +++++++
> > >  fs/btrfs/compression.c  |  3 ++-
> > >  fs/btrfs/extent-tree.c  | 12 ++++++------
> > >  fs/btrfs/extent_io.c    | 17 ++++++-----------
> > >  fs/btrfs/file.c         | 15 +++++++--------
> > >  fs/btrfs/inode.c        | 41 ++++++++++++++++++++++-------------------
> > >  fs/btrfs/ioctl.c        |  6 +++---
> > >  fs/btrfs/ordered-data.c |  2 +-
> > >  fs/btrfs/tree-log.c     |  2 +-
> > >  9 files changed, 55 insertions(+), 50 deletions(-)
> > >
> > > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > > index ac0b39d..eee994f 100644
> > > --- a/fs/btrfs/btrfs_inode.h
> > > +++ b/fs/btrfs/btrfs_inode.h
> > > @@ -280,4 +280,11 @@ static inline void btrfs_inode_resume_unlocked_dio(struct inode *inode)
> > >                   &BTRFS_I(inode)->runtime_flags);
> > >  }
> > >
> > > +static inline u64 btrfs_align_size(struct inode *inode)
> > > +{
> > > +       if (BTRFS_I(inode)->root->sectorsize < PAGE_CACHE_SIZE)
> > > +               return (u64)PAGE_CACHE_SIZE;
> > > +       else
> > > +               return (u64)BTRFS_I(inode)->root->sectorsize;
> > > +}
> > for performance, isn't it worth to store this value instead of
> > calculating it each time?

Good suggestion Saeed. will do
> 
> I agree, would be better to add the corresponding item into fs_info,
> initialized as proposed above.

Godd idea David. will do.
> 



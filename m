Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab3LPOsb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 09:48:31 -0500
Date: Mon, 16 Dec 2013 15:48:30 +0100
From: David Sterba <dsterba@suse.cz>
To: saeed bishara <saeed.bishara@gmail.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/7] btrfs: subpagesize-blocksize: Use a global alignment
 for size
Message-ID: <20131216144830.GF6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
 <1386805122-23972-3-git-send-email-sekharan@us.ibm.com>
 <CAMAG_ee_8od-mQ2GG3314aMiq8msqWFMoSGp_jBS9xZwvY9GBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMAG_ee_8od-mQ2GG3314aMiq8msqWFMoSGp_jBS9xZwvY9GBA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 16, 2013 at 02:33:11PM +0200, saeed bishara wrote:
> On Thu, Dec 12, 2013 at 1:38 AM, Chandra Seetharaman
> <sekharan@us.ibm.com> wrote:
> > In order to handle a blocksize that is smaller than the
> > PAGE_SIZE, we need align all IOs to PAGE_SIZE.
> >
> > This patch defines a new macro btrfs_align_size() that
> > calculates the alignment size based on the sectorsize
> > and uses it at appropriate places.
> >
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---
> >  fs/btrfs/btrfs_inode.h  |  7 +++++++
> >  fs/btrfs/compression.c  |  3 ++-
> >  fs/btrfs/extent-tree.c  | 12 ++++++------
> >  fs/btrfs/extent_io.c    | 17 ++++++-----------
> >  fs/btrfs/file.c         | 15 +++++++--------
> >  fs/btrfs/inode.c        | 41 ++++++++++++++++++++++-------------------
> >  fs/btrfs/ioctl.c        |  6 +++---
> >  fs/btrfs/ordered-data.c |  2 +-
> >  fs/btrfs/tree-log.c     |  2 +-
> >  9 files changed, 55 insertions(+), 50 deletions(-)
> >
> > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > index ac0b39d..eee994f 100644
> > --- a/fs/btrfs/btrfs_inode.h
> > +++ b/fs/btrfs/btrfs_inode.h
> > @@ -280,4 +280,11 @@ static inline void btrfs_inode_resume_unlocked_dio(struct inode *inode)
> >                   &BTRFS_I(inode)->runtime_flags);
> >  }
> >
> > +static inline u64 btrfs_align_size(struct inode *inode)
> > +{
> > +       if (BTRFS_I(inode)->root->sectorsize < PAGE_CACHE_SIZE)
> > +               return (u64)PAGE_CACHE_SIZE;
> > +       else
> > +               return (u64)BTRFS_I(inode)->root->sectorsize;
> > +}
> for performance, isn't it worth to store this value instead of
> calculating it each time?

I agree, would be better to add the corresponding item into fs_info,
initialized as proposed above.

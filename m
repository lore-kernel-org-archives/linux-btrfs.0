Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbbLGNyi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 08:54:38 -0500
Date: Mon, 7 Dec 2015 14:52:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 04/12] btrfs: change how delay_iput is tracked in
 btrfs_delalloc_work
Message-ID: <20151207135239.GA4227@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1449161602.git.dsterba@suse.com>
 <a4469a31e3b0cc55ebba9c3aee26cd5632743056.1449161602.git.dsterba@suse.com>
 <20151204022537.GH19589@localhost.localdomain>
 <20151204123625.GF31035@suse.cz>
 <CAL3q7H6jxdUJEXDJ_4MrEwB6xixwzjM1=A3Ryo+f9hgoMWRhGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6jxdUJEXDJ_4MrEwB6xixwzjM1=A3Ryo+f9hgoMWRhGQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 04, 2015 at 01:08:59PM +0000, Filipe Manana wrote:
> On Fri, Dec 4, 2015 at 12:36 PM, David Sterba <dsterba@suse.cz> wrote:
> > On Thu, Dec 03, 2015 at 06:25:37PM -0800, Liu Bo wrote:
> >> >     struct inode *inode;
> >> > -   int delay_iput;
> >> >     struct completion completion;
> >> >     struct list_head list;
> >> >     struct btrfs_work work;
> >> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >> > index 15b29e879ffc..529a53b80ca0 100644
> >> > --- a/fs/btrfs/inode.c
> >> > +++ b/fs/btrfs/inode.c
> >> > @@ -9436,16 +9436,21 @@ static void btrfs_run_delalloc_work(struct btrfs_work *work)
> >> >  {
> >> >     struct btrfs_delalloc_work *delalloc_work;
> >> >     struct inode *inode;
> >> > +   int delay_iput;
> >> >
> >> >     delalloc_work = container_of(work, struct btrfs_delalloc_work,
> >> >                                  work);
> >> >     inode = delalloc_work->inode;
> >> > +   /* Lowest bit of inode pointer tracks the delayed status */
> >> > +   delay_iput = ((unsigned long)inode & 1UL);
> >> > +   inode = (struct inode *)((unsigned long)inode & ~1UL);
> >> > +
> >>
> >> To be quite frankly, I don't like this, it's a pointer anyway,
> >> error-prone in a debugging view, instead would 'u8 delayed_iput' help?
> >
> > The point was to shrink the structure. Adding the u8 will grow it by
> > another 8 bytes, besides the slab objects are aligned to 8 bytes by
> > default so the overall cost of storing the delayed information is 8
> > bytes:
> >
> > struct btrfs_delalloc_work {
> >         struct inode *             inode;                /*     0     8 */
> >         struct completion          completion;           /*     8    32 */
> >         struct list_head           list;                 /*    40    16 */
> >         struct btrfs_work          work;                 /*    56    88 */
> >         /* --- cacheline 2 boundary (128 bytes) was 16 bytes ago --- */
> >         u8                         delay;                /*   144     1 */
> >
> >         /* size: 152, cachelines: 3, members: 5 */
> >         /* padding: 7 */
> >         /* last cacheline: 24 bytes */
> > };
> >
> > As the use of the inode pointer is limited, I don't think this would
> > cause surprises. And it's commented where used which should help during
> > debugging.
> >
> > Abusing the low bits of pointers is nothing new, the page cache tags are
> > implemented that way. This kind of low-level optimizations is IMO acceptable.
> 
> Acceptable, but, is it needed? I mean, are we using so much memory
> with this structure or does the better packing causes any significant
> performance improvement to justify this sort of obscure code? IMO it's
> worth only when we know (measured) that it actually positively impacts
> workloads (either real ones or even artificial ones from benchmark
> tools).

And it turns out this structure is not critical, seldomly used so the
space savings and bit tricks are not justified. Patch dropped.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37277 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbeEKVDs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 17:03:48 -0400
Date: Fri, 11 May 2018 23:01:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: use kvzalloc for EXTENT_SAME temporary data
Message-ID: <20180511210107.GE6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180511155754.27084-1-dsterba@suse.com>
 <CAL3q7H7=hGCnbsVvst-+shPj3rNqkkNZkr1kQaSjB4miTr_4mA@mail.gmail.com>
 <20180511164916.GC6649@twin.jikos.cz>
 <CAL3q7H6eCie5HRq7P7eCic0R61RgG6v57vDaWyXM9krvi_jcpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6eCie5HRq7P7eCic0R61RgG6v57vDaWyXM9krvi_jcpw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 06:16:15PM +0100, Filipe Manana wrote:
> On Fri, May 11, 2018 at 5:49 PM, David Sterba <dsterba@suse.cz> wrote:
> > On Fri, May 11, 2018 at 05:25:50PM +0100, Filipe Manana wrote:
> >> On Fri, May 11, 2018 at 4:57 PM, David Sterba <dsterba@suse.com> wrote:
> >> > The dedupe range is 16 MiB, with 4KiB pages and 8 byte pointers, the
> >> > arrays can be 32KiB large. To avoid allocation failures due to
> >> > fragmented memory, use the allocation with fallback to vmalloc.
> >> >
> >> > Signed-off-by: David Sterba <dsterba@suse.com>
> >> > ---
> >> >
> >> > This depends on the patches that remove the 16MiB restriction in the
> >> > dedupe ioctl, but contextually can be applied to the current code too.
> >> >
> >> > https://patchwork.kernel.org/patch/10374941/
> >> >
> >> >  fs/btrfs/ioctl.c | 4 ++--
> >> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> >> > index b572e38b4b64..a7f517009cd7 100644
> >> > --- a/fs/btrfs/ioctl.c
> >> > +++ b/fs/btrfs/ioctl.c
> >> > @@ -3178,8 +3178,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> >> >          * locking. We use an array for the page pointers. Size of the array is
> >> >          * bounded by len, which is in turn bounded by BTRFS_MAX_DEDUPE_LEN.
> >> >          */
> >> > -       cmp.src_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> >> > -       cmp.dst_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> >> > +       cmp.src_pages = kvzalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> >> > +       cmp.dst_pages = kvzalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> >>
> >> Kvzalloc should take 2 parameters and not 3.
> >
> > And the right function is kvmalloc_array.
> >
> >> Also, aren't the corresponding kvfree() calls missing?
> >
> > Yes, thanks for catching it. The updated version:
> >
> > From: David Sterba <dsterba@suse.com>
> > Subject: [PATCH] btrfs: use kvzalloc for EXTENT_SAME temporary data
> >
> > The dedupe range is 16 MiB, with 4KiB pages and 8 byte pointers, the
> > arrays can be 32KiB large. To avoid allocation failures due to
> > fragmented memory, use the allocation with fallback to vmalloc.
> >
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/ioctl.c | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index b572e38b4b64..4fcfa05ed960 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -3178,12 +3178,13 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> >          * locking. We use an array for the page pointers. Size of the array is
> >          * bounded by len, which is in turn bounded by BTRFS_MAX_DEDUPE_LEN.
> >          */
> > -       cmp.src_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> > -       cmp.dst_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> > +       cmp.src_pages = kvmalloc_array(num_pages, sizeof(struct page *),
> > +                                      GFP_KERNEL);
> > +       cmp.dst_pages = kvmalloc_array(num_pages, sizeof(struct page *),
> > +                                      GFP_KERNEL);
> >         if (!cmp.src_pages || !cmp.dst_pages) {
> > -               kfree(cmp.src_pages);
> > -               kfree(cmp.dst_pages);
> > -               return -ENOMEM;
> > +               ret = -ENOMEM;
> > +               goto out_free;
> >         }
> >
> >         if (same_inode)
> > @@ -3211,8 +3212,9 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> >         else
> >                 btrfs_double_inode_unlock(src, dst);
> >
> > -       kfree(cmp.src_pages);
> > -       kfree(cmp.dst_pages);
> > +out_free:
> > +       kvfree(cmp.src_pages);
> > +       kvfree(cmp.dst_pages);
> 
> kvfree() missing at btrfs_cmp_data_free() too.

Bah, no more quick fixes from me today. I'll drop the patch from the
branch and will have a fresh look another day.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:42992 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbeEKRsb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 13:48:31 -0400
Received: by mail-oi0-f67.google.com with SMTP id t27-v6so5413050oij.9
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 10:48:30 -0700 (PDT)
MIME-Version: 1.0
References: <20180511155754.27084-1-dsterba@suse.com> <CAL3q7H7=hGCnbsVvst-+shPj3rNqkkNZkr1kQaSjB4miTr_4mA@mail.gmail.com>
 <20180511164916.GC6649@twin.jikos.cz> <20180511173150.GD29366@vader>
In-Reply-To: <20180511173150.GD29366@vader>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 11 May 2018 20:47:54 +0300
Message-ID: <CAGqmi7556gD99smW0KRsWebrY2GQn_FqOkzQdqrA7mtp0ptarw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: use kvzalloc for EXTENT_SAME temporary data
To: osandov@osandov.com
Cc: David Sterba <dsterba@suse.cz>, Filipe Manana <fdmanana@gmail.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

пт, 11 мая 2018 г. в 20:32, Omar Sandoval <osandov@osandov.com>:

> On Fri, May 11, 2018 at 06:49:16PM +0200, David Sterba wrote:
> > On Fri, May 11, 2018 at 05:25:50PM +0100, Filipe Manana wrote:
> > > On Fri, May 11, 2018 at 4:57 PM, David Sterba <dsterba@suse.com>
wrote:
> > > > The dedupe range is 16 MiB, with 4KiB pages and 8 byte pointers, the
> > > > arrays can be 32KiB large. To avoid allocation failures due to
> > > > fragmented memory, use the allocation with fallback to vmalloc.
> > > >
> > > > Signed-off-by: David Sterba <dsterba@suse.com>
> > > > ---
> > > >
> > > > This depends on the patches that remove the 16MiB restriction in the
> > > > dedupe ioctl, but contextually can be applied to the current code
too.
> > > >
> > > > https://patchwork.kernel.org/patch/10374941/
> > > >
> > > >  fs/btrfs/ioctl.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > > > index b572e38b4b64..a7f517009cd7 100644
> > > > --- a/fs/btrfs/ioctl.c
> > > > +++ b/fs/btrfs/ioctl.c
> > > > @@ -3178,8 +3178,8 @@ static int btrfs_extent_same(struct inode
*src, u64 loff, u64 olen,
> > > >          * locking. We use an array for the page pointers. Size of
the array is
> > > >          * bounded by len, which is in turn bounded by
BTRFS_MAX_DEDUPE_LEN.
> > > >          */
> > > > -       cmp.src_pages = kcalloc(num_pages, sizeof(struct page *),
GFP_KERNEL);
> > > > -       cmp.dst_pages = kcalloc(num_pages, sizeof(struct page *),
GFP_KERNEL);
> > > > +       cmp.src_pages = kvzalloc(num_pages, sizeof(struct page *),
GFP_KERNEL);
> > > > +       cmp.dst_pages = kvzalloc(num_pages, sizeof(struct page *),
GFP_KERNEL);
> > >
> > > Kvzalloc should take 2 parameters and not 3.
> >
> > And the right function is kvmalloc_array.
> >
> > > Also, aren't the corresponding kvfree() calls missing?
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
> > @@ -3178,12 +3178,13 @@ static int btrfs_extent_same(struct inode *src,
u64 loff, u64 olen,
> >        * locking. We use an array for the page pointers. Size of the
array is
> >        * bounded by len, which is in turn bounded by
BTRFS_MAX_DEDUPE_LEN.
> >        */
> > -     cmp.src_pages = kcalloc(num_pages, sizeof(struct page *),
GFP_KERNEL);
> > -     cmp.dst_pages = kcalloc(num_pages, sizeof(struct page *),
GFP_KERNEL);
> > +     cmp.src_pages = kvmalloc_array(num_pages, sizeof(struct page *),
> > +                                    GFP_KERNEL);
> > +     cmp.dst_pages = kvmalloc_array(num_pages, sizeof(struct page *),
> > +                                    GFP_KERNEL);

> kcalloc() implies __GFP_ZERO, do we need that here?

AFAIK, yes, because:
btrfs_cmp_data_free():
...
pg = cmp->src_pages[i];
if (pg) {...}
..

And we will catch that, if errors happens in gather_extent_pages().

Thanks.
> >       if (!cmp.src_pages || !cmp.dst_pages) {
> > -             kfree(cmp.src_pages);
> > -             kfree(cmp.dst_pages);
> > -             return -ENOMEM;
> > +             ret = -ENOMEM;
> > +             goto out_free;
> >       }
> >
> >       if (same_inode)
> > @@ -3211,8 +3212,9 @@ static int btrfs_extent_same(struct inode *src,
u64 loff, u64 olen,
> >       else
> >               btrfs_double_inode_unlock(src, dst);
> >
> > -     kfree(cmp.src_pages);
> > -     kfree(cmp.dst_pages);
> > +out_free:
> > +     kvfree(cmp.src_pages);
> > +     kvfree(cmp.dst_pages);
> >
> >       return ret;
> >  }
> > --
> > 2.16.2
> >


-- 
Have a nice day,
Timofey.

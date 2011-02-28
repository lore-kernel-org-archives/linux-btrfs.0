From: Chris Mason <chris.mason@oracle.com>
Subject: RE: [PATCH] btrfs file write debugging patch
Date: Mon, 28 Feb 2011 09:02:38 -0500
Message-ID: <1298901635-sup-9740@think>
References: <AANLkTik3KtjzP4zVU-foQUxEvZEtrTi7T2aj6PJzUV43@mail.gmail.com> <1298857223-sup-5612@think> <1865303E0DED764181A9D882DEF65FB68662A5E3F3@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	=?utf-8?q?Maria_Wikstr=C3=B6m?= <maria@ponstudios.se>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1865303E0DED764181A9D882DEF65FB68662A5E3F3@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Zhong, Xin's message of 2011-02-28 03:56:40 -0500:
> One possible issue I can see is in the random failure case #2 that co=
py_from_user only process half of the data.=20
>=20
> For example, if it write a 4k aligned page and copy_from_user only wr=
ite 2k. Then it will not call btrfs_delalloc_release_space since num_pa=
ges and dirty_pages are both 1.=20
> In the next round, it write another 2k and btrfs_delalloc_reserve_spa=
ce is called twice for the same page.=20
>=20
> Is it a problem? Thanks!

It should be the correct answer.  The result of the short copy_from_use=
r
should be exactly the same as two write calls where one does 2K and the
other does another 2K.

Either way, it shouldn't result in incorrect bytes in the file, which i=
s
still happening for me with the debugging hunks in place.

-chris

>=20
> -----Original Message-----
> From: Chris Mason [mailto:chris.mason@oracle.com]=20
> Sent: Monday, February 28, 2011 9:46 AM
> To: Mitch Harder
> Cc: Maria Wikstr=C3=B6m; Zhong, Xin; Johannes Hirte; linux-btrfs@vger=
=2Ekernel.org
> Subject: [PATCH] btrfs file write debugging patch
>=20
> Excerpts from Mitch Harder's message of 2011-02-25 13:43:37 -0500:
> > Some clarification on my previous message...
> >=20
> > After looking at my ftrace log more closely, I can see where Btrfs =
is
> > trying to release the allocated pages.  However, the calculation fo=
r
> > the number of dirty_pages is equal to 1 when "copied =3D=3D 0".
> >=20
> > So I'm seeing at least two problems:
> > (1)  It keeps looping when "copied =3D=3D 0".
> > (2)  One dirty page is not being released on every loop even though
> > "copied =3D=3D 0" (at least this problem keeps it from being an inf=
inite
> > loop by eventually exhausting reserveable space on the disk).
>=20
> Hi everyone,
>=20
> There are actually tow bugs here.  First the one that Mitch hit, and =
a
> second one that still results in bad file_write results with my
> debugging hunks (the first two hunks below) in place.
>=20
> My patch fixes Mitch's bug by checking for copied =3D=3D 0 after
> btrfs_copy_from_user and going the correct delalloc accounting.  This
> one looks solved, but you'll notice the patch is bigger.
>=20
> First, I add some random failures to btrfs_copy_from_user() by failin=
g
> everyone once and a while.  This was much more reliable than trying t=
o
> use memory pressure than making copy_from_user fail.
>=20
> If copy_from_user fails and we partially update a page, we end up wit=
h a
> page that may go away due to memory pressure.  But, btrfs_file_write
> assumes that only the first and last page may have good data that nee=
ds
> to be read off the disk.
>=20
> This patch ditches that code and puts it into prepare_pages instead.
> But I'm still having some errors during long stress.sh runs.  Ideas a=
re
> more than welcome, hopefully some other timezones will kick in ideas
> while I sleep.
>=20
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 7084140..89a6a26 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -54,6 +54,13 @@ static noinline int btrfs_copy_from_user(loff_t po=
s, int num_pages,
>      int offset =3D pos & (PAGE_CACHE_SIZE - 1);
>      int total_copied =3D 0;
> =20
> +    if ((jiffies % 10) =3D=3D 0)
> +        return 0;
> +
> +    if ((jiffies % 25) =3D=3D 0) {
> +        write_bytes /=3D 2;
> +    }
> +
>      while (write_bytes > 0) {
>          size_t count =3D min_t(size_t,
>                       PAGE_CACHE_SIZE - offset, write_bytes);
> @@ -763,6 +770,26 @@ out:
>  }
> =20
>  /*
> + * on error we return an unlocked page and the error value
> + * on success we return a locked page and 0
> + */
> +static int prepare_uptodate_page(struct page *page, u64 pos)
> +{
> +    int ret =3D 0;
> +    if ((pos & (PAGE_CACHE_SIZE - 1)) && !PageUptodate(page)) {
> +        ret =3D btrfs_readpage(NULL, page);
> +        if (ret)
> +            return ret;
> +        lock_page(page);
> +        if (!PageUptodate(page)) {
> +            unlock_page(page);
> +            return -EIO;
> +        }
> +    }
> +    return 0;
> +}
> +
> +/*
>   * this gets pages into the page cache and locks them down, it also =
properly
>   * waits for data=3Dordered extents to finish before allowing the pa=
ges to be
>   * modified.
> @@ -777,6 +804,7 @@ static noinline int prepare_pages(struct btrfs_ro=
ot *root, struct file *file,
>      unsigned long index =3D pos >> PAGE_CACHE_SHIFT;
>      struct inode *inode =3D fdentry(file)->d_inode;
>      int err =3D 0;
> +    int faili =3D 0;
>      u64 start_pos;
>      u64 last_pos;
> =20
> @@ -794,15 +822,24 @@ again:
>      for (i =3D 0; i < num_pages; i++) {
>          pages[i] =3D grab_cache_page(inode->i_mapping, index + i);
>          if (!pages[i]) {
> -            int c;
> -            for (c =3D i - 1; c >=3D 0; c--) {
> -                unlock_page(pages[c]);
> -                page_cache_release(pages[c]);
> -            }
> -            return -ENOMEM;
> +            faili =3D i - 1;
> +            err =3D -ENOMEM;
> +            goto fail;
> +        }
> +
> +        if (i =3D=3D 0)
> +            err =3D prepare_uptodate_page(pages[i], pos);
> +        else if (i =3D=3D num_pages - 1)
> +            err =3D prepare_uptodate_page(pages[i],
> +                            pos + write_bytes);
> +        if (err) {
> +            page_cache_release(pages[i]);
> +            faili =3D i - 1;
> +            goto fail;
>          }
>          wait_on_page_writeback(pages[i]);
>      }
> +    err =3D 0;
>      if (start_pos < inode->i_size) {
>          struct btrfs_ordered_extent *ordered;
>          lock_extent_bits(&BTRFS_I(inode)->io_tree,
> @@ -842,6 +879,14 @@ again:
>          WARN_ON(!PageLocked(pages[i]));
>      }
>      return 0;
> +fail:
> +    while (faili >=3D 0) {
> +        unlock_page(pages[faili]);
> +        page_cache_release(pages[faili]);
> +        faili--;
> +    }
> +    return err;
> +
>  }
> =20
>  static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
> @@ -851,7 +896,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb =
*iocb,
>      struct file *file =3D iocb->ki_filp;
>      struct inode *inode =3D fdentry(file)->d_inode;
>      struct btrfs_root *root =3D BTRFS_I(inode)->root;
> -    struct page *pinned[2];
>      struct page **pages =3D NULL;
>      struct iov_iter i;
>      loff_t *ppos =3D &iocb->ki_pos;
> @@ -872,9 +916,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb =
*iocb,
>      will_write =3D ((file->f_flags & O_DSYNC) || IS_SYNC(inode) ||
>                (file->f_flags & O_DIRECT));
> =20
> -    pinned[0] =3D NULL;
> -    pinned[1] =3D NULL;
> -
>      start_pos =3D pos;
> =20
>      vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> @@ -962,32 +1003,6 @@ static ssize_t btrfs_file_aio_write(struct kioc=
b *iocb,
>      first_index =3D pos >> PAGE_CACHE_SHIFT;
>      last_index =3D (pos + iov_iter_count(&i)) >> PAGE_CACHE_SHIFT;
> =20
> -    /*
> -     * there are lots of better ways to do this, but this code
> -     * makes sure the first and last page in the file range are
> -     * up to date and ready for cow
> -     */
> -    if ((pos & (PAGE_CACHE_SIZE - 1))) {
> -        pinned[0] =3D grab_cache_page(inode->i_mapping, first_index)=
;
> -        if (!PageUptodate(pinned[0])) {
> -            ret =3D btrfs_readpage(NULL, pinned[0]);
> -            BUG_ON(ret);
> -            wait_on_page_locked(pinned[0]);
> -        } else {
> -            unlock_page(pinned[0]);
> -        }
> -    }
> -    if ((pos + iov_iter_count(&i)) & (PAGE_CACHE_SIZE - 1)) {
> -        pinned[1] =3D grab_cache_page(inode->i_mapping, last_index);
> -        if (!PageUptodate(pinned[1])) {
> -            ret =3D btrfs_readpage(NULL, pinned[1]);
> -            BUG_ON(ret);
> -            wait_on_page_locked(pinned[1]);
> -        } else {
> -            unlock_page(pinned[1]);
> -        }
> -    }
> -
>      while (iov_iter_count(&i) > 0) {
>          size_t offset =3D pos & (PAGE_CACHE_SIZE - 1);
>          size_t write_bytes =3D min(iov_iter_count(&i),
> @@ -1024,8 +1039,12 @@ static ssize_t btrfs_file_aio_write(struct kio=
cb *iocb,
> =20
>          copied =3D btrfs_copy_from_user(pos, num_pages,
>                         write_bytes, pages, &i);
> -        dirty_pages =3D (copied + offset + PAGE_CACHE_SIZE - 1) >>
> -                PAGE_CACHE_SHIFT;
> +        if (copied =3D=3D 0)
> +            dirty_pages =3D 0;
> +        else
> +            dirty_pages =3D (copied + offset +
> +                       PAGE_CACHE_SIZE - 1) >>
> +                       PAGE_CACHE_SHIFT;
> =20
>          if (num_pages > dirty_pages) {
>              if (copied > 0)
> @@ -1069,10 +1088,6 @@ out:
>          err =3D ret;
> =20
>      kfree(pages);
> -    if (pinned[0])
> -        page_cache_release(pinned[0]);
> -    if (pinned[1])
> -        page_cache_release(pinned[1]);
>      *ppos =3D pos;
> =20
>      /*
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:35207 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbeBWWkj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 17:40:39 -0500
Received: by mail-pl0-f65.google.com with SMTP id bb3so5701609plb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 14:40:38 -0800 (PST)
Date: Fri, 23 Feb 2018 14:40:36 -0800
From: Omar Sandoval <osandov@osandov.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 10/27] libbtrfsutil: add
 btrfs_util_[gs]et_default_subvolume()
Message-ID: <20180223224036.GA7046@vader.DHCP.thefacebook.com>
References: <cover.1518720598.git.osandov@fb.com>
 <12357e01654532c78dccd2eb52edbdc7589d6ee6.1518720598.git.osandov@fb.com>
 <9e93751b-02fe-93a7-a866-3ec56fbdb839@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9e93751b-02fe-93a7-a866-3ec56fbdb839@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 22, 2018 at 10:55:48AM +0900, Misono, Tomohiro wrote:
> On 2018/02/16 4:04, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > set_default_subvolume() is a trivial ioctl(), but there's no ioctl() for
> > get_default_subvolume(), so we need to search the root tree.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  libbtrfsutil/btrfsutil.h                    |  41 ++++++++++
> >  libbtrfsutil/python/btrfsutilpy.h           |   2 +
> >  libbtrfsutil/python/module.c                |  14 ++++
> >  libbtrfsutil/python/subvolume.c             |  50 ++++++++++++
> >  libbtrfsutil/python/tests/test_subvolume.py |  14 ++++
> >  libbtrfsutil/subvolume.c                    | 113 ++++++++++++++++++++++++++++
> >  6 files changed, 234 insertions(+)
> > 
> > diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
> > index 8bd2b847..54777f1d 100644
> > --- a/libbtrfsutil/btrfsutil.h
> > +++ b/libbtrfsutil/btrfsutil.h
> > @@ -256,6 +256,8 @@ enum btrfs_util_error btrfs_util_get_subvolume_read_only_fd(int fd, bool *ret);
> >   * @path: Subvolume path.
> >   * @read_only: New value of read-only flag.
> >   *
> > + * This requires appropriate privilege (CAP_SYS_ADMIN).
> > + *
> >   * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
> >   */
> >  enum btrfs_util_error btrfs_util_set_subvolume_read_only(const char *path,
> > @@ -268,6 +270,45 @@ enum btrfs_util_error btrfs_util_set_subvolume_read_only(const char *path,
> >  enum btrfs_util_error btrfs_util_set_subvolume_read_only_fd(int fd,
> >  							    bool read_only);
> >  
> > +/**
> > + * btrfs_util_get_default_subvolume() - Get the default subvolume for a
> > + * filesystem.
> > + * @path: Path on a Btrfs filesystem.
> > + * @id_ret: Returned subvolume ID.
> > + *
> > + * This requires appropriate privilege (CAP_SYS_ADMIN).
> > + *
> > + * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
> > + */
> > +enum btrfs_util_error btrfs_util_get_default_subvolume(const char *path,
> > +						       uint64_t *id_ret);
> > +
> > +/**
> > + * btrfs_util_get_default_subvolume_fd() - See
> > + * btrfs_util_get_default_subvolume().
> > + */
> > +enum btrfs_util_error btrfs_util_get_default_subvolume_fd(int fd,
> > +							  uint64_t *id_ret);
> > +
> > +/**
> > + * btrfs_util_set_default_subvolume() - Set the default subvolume for a
> > + * filesystem.
> > + * @path: Path in a Btrfs filesystem. This may be any path in the filesystem; it
> > + * does not have to refer to a subvolume unless @id is zero.
> > + * @id: ID of subvolume to set as the default. If zero is given, the subvolume
> > + * ID of @path is used.
> 
> The line "This requires appropriate privilege (CAP_SYS_ADMIN)." is missing here.

Good catch, thanks, fixed.

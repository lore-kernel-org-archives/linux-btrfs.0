Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:39310 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751749AbeA2XpN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 18:45:13 -0500
Received: by mail-pf0-f193.google.com with SMTP id e11so6902706pff.6
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 15:45:13 -0800 (PST)
Date: Mon, 29 Jan 2018 15:45:06 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 02/26] Add libbtrfsutil
Message-ID: <20180129234506.GB1362@vader.DHCP.thefacebook.com>
References: <cover.1516991902.git.osandov@fb.com>
 <d9c524c091d339c69fba4320d57e11b22c22c27d.1516991902.git.osandov@fb.com>
 <24bfaf58-bde9-a6d6-6ecd-57bc3dbe6391@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <24bfaf58-bde9-a6d6-6ecd-57bc3dbe6391@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 29, 2018 at 10:16:40AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年01月27日 02:40, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Currently, users wishing to manage Btrfs filesystems programatically
> > have to shell out to btrfs-progs and parse the output. This isn't ideal.
> > The goal of libbtrfsutil is to provide a library version of as many of
> > the operations of btrfs-progs as possible and to migrate btrfs-progs to
> > use it.
> > 
> > Rather than simply refactoring the existing btrfs-progs code, the code
> > has to be written from scratch for a couple of reasons:
> > 
> > * A lot of the btrfs-progs code was not designed with a nice library API
> >   in mind in terms of reusability, naming, and error reporting.
> > * libbtrfsutil is licensed under the LGPL, whereas btrfs-progs is under
> >   the GPL, which makes it dubious to directly copy or move the code.
> > 
> > Eventually, most of the low-level btrfs-progs code should either live in
> > libbtrfsutil or the shared kernel/userspace filesystem code, and
> > btrfs-progs will just be the CLI wrapper.
> > 
> > This first commit just includes the build system changes, license,
> > README, and error reporting helper.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  .gitignore                  |   2 +
> >  Makefile                    |  47 +--
> >  libbtrfsutil/COPYING        | 674 ++++++++++++++++++++++++++++++++++++++++++++
> >  libbtrfsutil/COPYING.LESSER | 165 +++++++++++
> >  libbtrfsutil/README.md      |  32 +++
> >  libbtrfsutil/btrfsutil.h    |  72 +++++
> >  libbtrfsutil/errors.c       |  55 ++++
> >  7 files changed, 1031 insertions(+), 16 deletions(-)
> >  create mode 100644 libbtrfsutil/COPYING
> >  create mode 100644 libbtrfsutil/COPYING.LESSER
> >  create mode 100644 libbtrfsutil/README.md
> >  create mode 100644 libbtrfsutil/btrfsutil.h
> >  create mode 100644 libbtrfsutil/errors.c
> > 

[snip]

> > diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
> > new file mode 100644
> > index 00000000..fe1091ca
> > --- /dev/null
> > +++ b/libbtrfsutil/btrfsutil.h
> > @@ -0,0 +1,72 @@
> > +/*
> > + * Copyright (C) 2018 Facebook
> > + *
> > + * This file is part of libbtrfsutil.
> > + *
> > + * libbtrfsutil is free software: you can redistribute it and/or modify
> > + * it under the terms of the GNU Lesser General Public License as published by
> > + * the Free Software Foundation, either version 3 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * libbtrfsutil is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU Lesser General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU Lesser General Public License
> > + * along with libbtrfsutil.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#ifndef BTRFS_UTIL_H
> > +#define BTRFS_UTIL_H
> > +
> > +#ifdef __cplusplus
> > +extern "C" {
> > +#endif
> > +
> > +/**
> > + * enum btrfs_util_error - libbtrfsutil error codes.
> > + *
> > + * All functions in libbtrfsutil that can return an error return this type and
> > + * set errno.
> > + */
> 
> I totally understand that libbtrfsutils needs extra error numbers, but I
> didn't see similar practice, would you mind to give some existing
> example of such >0 error usage in other projects?
> (Just curious)

Sure, pthreads returns 0 on success, positive errnos on failure. libcurl
also uses positive error codes (https://curl.haxx.se/libcurl/c/libcurl-errors.html).
Those are just the first two I checked.

> Normally people would expect error values < 0 to indicate errors, just
> like glibc system call wrappers, which always return -1 to indicate errors.
> 
> > +enum btrfs_util_error {
> > +	BTRFS_UTIL_OK,
> > +	BTRFS_UTIL_ERROR_STOP_ITERATION,
> > +	BTRFS_UTIL_ERROR_NO_MEMORY,
> 
> Not sure if this is duplicated with -ENOMEM errno.
> 
> From my understanding, these extra numbers should be used to indicate
> extra error not definied in generic errno.h.
> 
> For NOT_BTRFS and NOT_SUBVOLUME they makes sense, but for NO_MEMORY, I'm
> really not sure.

So sometimes we return an errno, sometimes an enum btrfs_util_error? And
then we have to make sure to avoid collisions between the enum values
and errno values? That seems clunky.

Thanks for taking a look.

> > +	BTRFS_UTIL_ERROR_INVALID_ARGUMENT,
> > +	BTRFS_UTIL_ERROR_NOT_BTRFS,
> > +	BTRFS_UTIL_ERROR_NOT_SUBVOLUME,
> > +	BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND,
> > +	BTRFS_UTIL_ERROR_OPEN_FAILED,
> > +	BTRFS_UTIL_ERROR_RMDIR_FAILED,
> > +	BTRFS_UTIL_ERROR_UNLINK_FAILED,
> > +	BTRFS_UTIL_ERROR_STAT_FAILED,
> > +	BTRFS_UTIL_ERROR_STATFS_FAILED,
> > +	BTRFS_UTIL_ERROR_SEARCH_FAILED,
> > +	BTRFS_UTIL_ERROR_INO_LOOKUP_FAILED,
> > +	BTRFS_UTIL_ERROR_SUBVOL_GETFLAGS_FAILED,
> > +	BTRFS_UTIL_ERROR_SUBVOL_SETFLAGS_FAILED,
> > +	BTRFS_UTIL_ERROR_SUBVOL_CREATE_FAILED,
> > +	BTRFS_UTIL_ERROR_SNAP_CREATE_FAILED,
> > +	BTRFS_UTIL_ERROR_SNAP_DESTROY_FAILED,
> > +	BTRFS_UTIL_ERROR_DEFAULT_SUBVOL_FAILED,
> > +	BTRFS_UTIL_ERROR_SYNC_FAILED,
> > +	BTRFS_UTIL_ERROR_START_SYNC_FAILED,
> > +	BTRFS_UTIL_ERROR_WAIT_SYNC_FAILED,
> > +};

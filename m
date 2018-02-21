Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45141 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935904AbeBUNEX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 08:04:23 -0500
Date: Wed, 21 Feb 2018 14:02:02 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 04/27] libbtrfsutil: add btrfs_util_is_subvolume() and
 btrfs_util_subvolume_id()
Message-ID: <20180221130202.GC1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1518720598.git.osandov@fb.com>
 <72c661cf7dc5cd27373ff0d19eb77cea14ce391c.1518720598.git.osandov@fb.com>
 <20180221114307.GA1469@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180221114307.GA1469@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 21, 2018 at 12:43:07PM +0100, David Sterba wrote:
> On Thu, Feb 15, 2018 at 11:04:49AM -0800, Omar Sandoval wrote:
> > --- /dev/null
> > +++ b/libbtrfsutil/subvolume.c
> > @@ -0,0 +1,127 @@
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
> > +#include <errno.h>
> > +#include <fcntl.h>
> > +#include <unistd.h>
> > +#include <sys/ioctl.h>
> > +#include <sys/stat.h>
> > +#include <sys/types.h>
> > +#include <sys/vfs.h>
> > +#include <linux/btrfs.h>
> > +#include <linux/btrfs_tree.h>
> 
> How is this supposed to work? This pulls the system-wide includes, the
> travis-ci environment has an old kernel and btrfs_tree.h does not exist
> there. The missing defines are provided by libbtrfs' btrfs/ctree.h.
> 
> We can add a configure-time check to detect the availability of the
> headers, but I'm not sure if this is right. As libbtrfsutil/subvolume.c
> is built internally it should use the includes from the btrfs-progs git
> itself, no?

Oh yeah, the fun has begun.  This will need to be sorted first. ctree.h
unconditionally pulls kerncompat.h, so it cannot be used instead of the
linux/btrfs*.h headers, there are warnings about redefined endianity
conversion macros.

We can split the headers by type, so ctree.h does not contain
everything, or copy defines and types to libbtrfsutil header so it is
completely independent of the git or system headers. Or something else.

I can now make it compile without including btrfs_tree.h and copying
parts of ctree.h until it compiles. The type u8 also has to be __u8.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41710 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752075AbdLDOnH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 09:43:07 -0500
Date: Mon, 4 Dec 2017 15:41:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: compression: add helper for type to string
 conversion
Message-ID: <20171204144107.GZ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1512058075.git.dsterba@suse.com>
 <a82165fb386d2abba1e7366689e3aefada14ed26.1512058075.git.dsterba@suse.com>
 <4fb8aaa3-e79c-e3f1-d834-3da44bde58f9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4fb8aaa3-e79c-e3f1-d834-3da44bde58f9@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 01, 2017 at 05:55:56AM +0800, Anand Jain wrote:
> 
> 
> On 12/01/2017 12:09 AM, David Sterba wrote:
> > There are several places opencoding this conversion, add a helper now
> > that we have 3 compression algorithms.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >   fs/btrfs/compression.c | 15 +++++++++++++++
> >   fs/btrfs/compression.h |  2 ++
> >   2 files changed, 17 insertions(+)
> > 
> > diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> > index 5982c8a71f02..a1a5958ff328 100644
> > --- a/fs/btrfs/compression.c
> > +++ b/fs/btrfs/compression.c
> > @@ -45,6 +45,21 @@
> >   #include "extent_io.h"
> >   #include "extent_map.h"
> >   
> > +static const char* const btrfs_compress_types[] = { "", "lzo", "zlib", "zstd" };
> 
> This is wrong order.
> 
> compression.h:	BTRFS_COMPRESS_NONE  = 0,
> compression.h:	BTRFS_COMPRESS_ZLIB  = 1,
> compression.h:	BTRFS_COMPRESS_LZO   = 2,
> compression.h:	BTRFS_COMPRESS_ZSTD  = 3,
> compression.h:	BTRFS_COMPRESS_TYPES = 3,

This was unintentionally left as an exercise for reviewers. Will fix,
thanks.

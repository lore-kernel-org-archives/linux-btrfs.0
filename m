Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49276 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751509AbdG0Qu0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 12:50:26 -0400
Date: Thu, 27 Jul 2017 18:49:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH preview] btrfs: allow to set compression level for zlib
Message-ID: <20170727164905.GP2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170724172939.24527-1-dsterba@suse.com>
 <e6381f64-0c24-e3ac-ef9a-f9ff761ab74e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e6381f64-0c24-e3ac-ef9a-f9ff761ab74e@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 27, 2017 at 03:52:56PM +0800, Anand Jain wrote:
> > --- a/fs/btrfs/zlib.c
> > +++ b/fs/btrfs/zlib.c
> > @@ -37,6 +37,7 @@ struct workspace {
> >   	z_stream strm;
> >   	char *buf;
> >   	struct list_head list;
> > +	int level;
> >   };
> 
>   No need to set it for the workspace. We could just redefine the
>   function prototype for btrfs_compress_op->compress_pages()
>   and pass as an argument.

I think this comes from the early version of the patch where the way the
tpe and level were mangled in a bit different way, so it was up to the
compression algo to set it and decipher back without the changes to any
of the interfaces.


> > +static void zlib_set_level(struct list_head *ws, unsigned int type)
> > +{
> > +	struct workspace *workspace = list_entry(ws, struct workspace, list);
> > +	unsigned level = (type & 0xF0) >> 4;
> > +
> > +	workspace->level = level > 0 ? level : 3;
> > +}
> > +
> >   const struct btrfs_compress_op btrfs_zlib_compress = {
> >   	.alloc_workspace	= zlib_alloc_workspace,
> >   	.free_workspace		= zlib_free_workspace,
> >   	.compress_pages		= zlib_compress_pages,
> >   	.decompress_bio		= zlib_decompress_bio,
> >   	.decompress		= zlib_decompress,
> > +	.set_level              = zlib_set_level,
> >   };
> > 
> 
> 
> How about the compress-force to accept the compression levels ?
> or I wonder if your are planning to deprecate it in the long run.

Although not mentioned, compress-force also accepts the level. I'll add
it to the changelog in the next version.

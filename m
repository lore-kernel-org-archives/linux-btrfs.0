Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53329 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751026AbdB1KoH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 05:44:07 -0500
Date: Tue, 28 Feb 2017 11:41:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: do proper error handling in
 btrfs_insert_xattr_item
Message-ID: <20170228104156.GA4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1487614974.git.dsterba@suse.com>
 <e204841964263393974c193010c74648faa5a761.1487614974.git.dsterba@suse.com>
 <20170222053905.GC1497@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170222053905.GC1497@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 21, 2017 at 09:39:05PM -0800, Liu Bo wrote:
> On Mon, Feb 20, 2017 at 07:25:06PM +0100, David Sterba wrote:
> > The space check in btrfs_insert_xattr_item is duplicated in it's caller
> > (do_setxattr) so we won't hit the BUG_ON. Continuing without any check
> > could be disasterous so turn it to a proper error handling.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/dir-item.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> > index 724504a2d7ac..640801082533 100644
> > --- a/fs/btrfs/dir-item.c
> > +++ b/fs/btrfs/dir-item.c
> > @@ -80,7 +80,8 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
> >  	struct extent_buffer *leaf;
> >  	u32 data_size;
> >  
> > -	BUG_ON(name_len + data_len > BTRFS_MAX_XATTR_SIZE(root->fs_info));
> > +	if (name_len + data_len > BTRFS_MAX_XATTR_SIZE(root->fs_info))
> > +		return -ENOSPC;
> >
> 
> Besides making it silent, how about adding a ASSERT to cry out?
> (Although currently we'd never come into this case.)

I don't think we need the assert, the caller is supposed to handle the
error. In this case it's validation of input parameters, that could
possibly happen as the function is not static.

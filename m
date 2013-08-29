Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23701 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3H2DHB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 23:07:01 -0400
Date: Thu, 29 Aug 2013 11:06:49 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, pth@suse.de, sf@suse.de,
        jeff.liu@oracle.com
Subject: Re: [RFC PATCH] Btrfs: export btrfs space shared info to userspace
Message-ID: <20130829030648.GB22790@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1376641648-25015-1-git-send-email-bo.li.liu@oracle.com>
 <20130828172938.GF23113@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130828172938.GF23113@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 28, 2013 at 07:29:38PM +0200, David Sterba wrote:
> On Fri, Aug 16, 2013 at 04:27:28PM +0800, Liu Bo wrote:
> > Similar to ocfs2, btrfs also supports that extents can be shared by
> > different inodes, and there are some userspace tools requesting
> > for this kind of 'space shared infomation'.[1]
> > 
> > ocfs2 uses flag FIEMAP_EXTENT_SHARED, so does btrfs.
> 
> Looks ok to me.
> 
> > +			int ref_cnt = 0;
> 
> I think using long is cleaner here, it always fits into (void*), int
> does not.

Good point.

> 
> > +			/*
> > +			 * As btrfs supports shared space, this information
> > +			 * can be exported to userspace tools via
> > +			 * flag FIEMAP_EXTENT_SHARED.
> > +			 */
> > +			ret = iterate_inodes_from_logical(
> > +					em->block_start,
> > +					BTRFS_I(inode)->root->fs_info,
> > +					path, count_ext_ref, &ref_cnt);
> > +			if (ret < 0)
> > +				goto out_free;
> > +
> > +			if (ref_cnt > 1)
> > +				flags |= FIEMAP_EXTENT_SHARED;
> 
> AFAICS, e2fsprogs filefrag does not yet know about FIEMAP_EXTENT_SHARED.

With checking filefrag's code, it's easy to make filefrag aware of this
flag.

I'll make a patch for filefrag unless someone has already done it, thanks.

-liubo

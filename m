Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47072 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933338AbdKPB5q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 20:57:46 -0500
Date: Wed, 15 Nov 2017 17:57:38 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 2/3] btrfs: tree-checker: Add checker for dir item
Message-ID: <20171116015737.GA14603@dhcp-whq-twvpn-1-vpnpool-10-159-153-242.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20171108005426.17903-1-wqu@suse.com>
 <20171108005426.17903-3-wqu@suse.com>
 <2ec9cf70-768f-8a77-52fe-1bf06f756f6a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2ec9cf70-768f-8a77-52fe-1bf06f756f6a@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 08, 2017 at 09:59:39AM +0200, Nikolay Borisov wrote:
> 
> 
> On  8.11.2017 02:54, Qu Wenruo wrote:
> > Add checker for dir item, for key types DIR_ITEM, DIR_INDEX and
> > XATTR_ITEM.
> > 
> > This checker does comprehensive check for:
> > 1) dir_item header and its data size
> >    Against item boundary and maximum name/xattr length.
> >    This part is mostly the same as old verify_dir_item().
> > 
> > 2) dir_type
> >    Against maximum file types, and against key type.
> >    Since XATTR key should only have FT_XATTR dir item, and normal dir
> >    item type should not have XATTR key.
> > 
> >    The check between key->type and dir_type is newly introduced by this
> >    patch.
> > 
> > 3) name hash
> >    For XATTR and DIR_ITEM key, key->offset is name hash (crc32).
> >    Check the hash of name against key to ensure it's correct.
> > 
> >    The name hash check is only found in btrfs-progs before this patch.
> > 
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > ---
> >  fs/btrfs/tree-checker.c | 141 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 141 insertions(+)
> > 
> 
> 
> I'm gonna 'hijack' this patch to discuss something  - we do return the
> correct EUCLEAN status from the leaf checker, however the only place
> where it's called is in btree_readpage_end_io_hook and if the check
> fails we only return -EIO. I wonder whether want to propagate the
> EUCLEAN from there, any thoughts?

The @ret from readpage_end_io_hook won't go upper layer as it's
wrapped in end_bio_extent_readpage().

The readpage/readpages will just check page's uptodate bit and error
bit.

Thanks,

-liubo

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48919 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbdKHH7l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Nov 2017 02:59:41 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B3CB3AAC3
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Nov 2017 07:59:39 +0000 (UTC)
Subject: Re: [PATCH v2 2/3] btrfs: tree-checker: Add checker for dir item
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171108005426.17903-1-wqu@suse.com>
 <20171108005426.17903-3-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2ec9cf70-768f-8a77-52fe-1bf06f756f6a@suse.com>
Date: Wed, 8 Nov 2017 09:59:39 +0200
MIME-Version: 1.0
In-Reply-To: <20171108005426.17903-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  8.11.2017 02:54, Qu Wenruo wrote:
> Add checker for dir item, for key types DIR_ITEM, DIR_INDEX and
> XATTR_ITEM.
> 
> This checker does comprehensive check for:
> 1) dir_item header and its data size
>    Against item boundary and maximum name/xattr length.
>    This part is mostly the same as old verify_dir_item().
> 
> 2) dir_type
>    Against maximum file types, and against key type.
>    Since XATTR key should only have FT_XATTR dir item, and normal dir
>    item type should not have XATTR key.
> 
>    The check between key->type and dir_type is newly introduced by this
>    patch.
> 
> 3) name hash
>    For XATTR and DIR_ITEM key, key->offset is name hash (crc32).
>    Check the hash of name against key to ensure it's correct.
> 
>    The name hash check is only found in btrfs-progs before this patch.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 141 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 141 insertions(+)
> 


I'm gonna 'hijack' this patch to discuss something  - we do return the
correct EUCLEAN status from the leaf checker, however the only place
where it's called is in btree_readpage_end_io_hook and if the check
fails we only return -EIO. I wonder whether want to propagate the
EUCLEAN from there, any thoughts?



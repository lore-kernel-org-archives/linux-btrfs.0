Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36887 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756489AbdKOQRK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 11:17:10 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 44203ACEE
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 16:17:09 +0000 (UTC)
Date: Wed, 15 Nov 2017 17:15:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 2/3] btrfs: tree-checker: Add checker for dir item
Message-ID: <20171115161516.GR28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171108005426.17903-1-wqu@suse.com>
 <20171108005426.17903-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171108005426.17903-3-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 08, 2017 at 08:54:25AM +0800, Qu Wenruo wrote:
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

Reviewed-by: David Sterba <dsterba@suse.com>

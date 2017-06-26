Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36111 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751431AbdFZMsW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 08:48:22 -0400
Date: Mon, 26 Jun 2017 14:47:12 +0200
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, dsterba <dsterba@suse.cz>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170626124712.GH2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170603095745.GA4730@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170603095745.GA4730@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 03, 2017 at 03:27:45PM +0530, Lakshmipathi.G wrote:
> With larger file system (in this case its 22TB), ext2fs_open() returns
> EXT2_ET_CANT_USE_LEGACY_BITMAPS error message with ext2fs_read_block_bitmap().
> 
> To overcome this issue, (a) we need pass EXT2_FLAG_64BITS flag with ext2fs_open.
> (b) use 64-bit functions like ext2fs_get_block_bitmap_range2,
> ext2fs_inode_data_blocks2,ext2fs_read_ext_attr2. (c) use 64bit types with
> btrfs_convert_context fields.
> 
> bug: https://bugzilla.kernel.org/show_bug.cgi?id=194795
> Signed-off-by: Lakshmipathi.G <lakshmipathi.g@giis.co.in>

Applied, thanks.

> --- a/convert/common.h
> +++ b/convert/common.h
> @@ -30,10 +30,10 @@ struct btrfs_mkfs_config;
>  
>  struct btrfs_convert_context {
>  	u32 blocksize;
> -	u32 first_data_block;
> -	u32 block_count;
> -	u32 inodes_count;
> -	u32 free_inodes_count;
> +	u64 first_data_block;
> +	u64 block_count;
> +	u64 inodes_count;
> +	u64 free_inodes_count;

I've split this change from the patch as it does not logically belong to
the same patch, altough the change is simple.

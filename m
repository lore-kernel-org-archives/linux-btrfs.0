Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C088FC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 14:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B4C22083D
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 14:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfCSOtj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 10:49:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:58712 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726466AbfCSOtj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 10:49:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5D632AEDB;
        Tue, 19 Mar 2019 14:49:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6680DDAC36; Tue, 19 Mar 2019 15:50:51 +0100 (CET)
Date:   Tue, 19 Mar 2019 15:50:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>
Subject: Re: [PATCH 1/6] btrfs: tree-checker: Verify chunk items
Message-ID: <20190319145050.GL3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190313085511.23540-1-wqu@suse.com>
 <20190313085511.23540-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190313085511.23540-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 13, 2019 at 04:55:06PM +0800, Qu Wenruo wrote:
> We already have btrfs_check_chunk_valid() to verify each chunk before
> tree-checker.
> 
> Merge that function into tree-checker, and update its error message to
> be more readable.
> 
> Old error message would be something like:
>   BTRFS error (device dm-3): invalid chunk num_stipres: 0
> 
> New error message would be:
>   Btrfs critical (device dm-3): corrupt superblock syschunk array: chunk_start=2097152, invalid chunk num_stripes: 0
> Or
>   Btrfs critical (device dm-3): corrupt leaf: root=3 block=8388608 slot=3 chunk_start=2097152, invalid chunk num_stripes: 0
> 
> Btrfs_check_chunk_valid() is exported for super block syschunk array
> verification.
> 
> Also make tree-checker to verify chunk items, this makes chunk item
> checker covers all chunks and avoid fuzzed image.
> 
> Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202751
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 152 ++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/tree-checker.h |   3 +
>  fs/btrfs/volumes.c      |  94 +------------------------
>  3 files changed, 156 insertions(+), 93 deletions(-)

Please split the patch to part where you just move the code and where
the logic is changed. btrfs_check_chunk_valid is not the same, old has
-EIO and new -EUCLEAN. Moving a function is ok in the same patch if
there's no change.

> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index b8cdaf472031..fe3f37c23c29 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -448,6 +448,152 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
>  	return 0;
>  }
>  
> +__printf(5, 6)
> +__cold
> +static void chunk_err(const struct btrfs_fs_info *fs_info,
> +		      const struct extent_buffer *leaf,
> +		      const struct btrfs_chunk *chunk, u64 logical,
> +		      const char *fmt, ...)
> +{
> +	/* Only superblock eb is able to have such small offset */
> +	bool is_sb = (leaf->start == BTRFS_SUPER_INFO_OFFSET);

Please move the initialization and comment out of the declaration block

> +	struct va_format vaf;
> +	va_list args;
> +	int i;
> +	int slot = -1;
> +
> +	if (!is_sb) {
> +		/*
> +		 * Get the slot number by iterating through all slots, this
> +		 * would provide better readability.
> +		 */
> +		for (i = 0; i < btrfs_header_nritems(leaf); i++) {
> +			if (btrfs_item_ptr_offset(leaf, i) ==
> +					(unsigned long) chunk) {
> +				slot = i;
> +				break;
> +			}
> +		}
> +	}

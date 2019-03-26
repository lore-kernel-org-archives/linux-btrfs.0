Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C92C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 15:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EA912075E
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 15:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731913AbfCZPZw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:25:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:58290 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731546AbfCZPZw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 11:25:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 56B60ACBA
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 15:25:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3D3D3DA8D8; Tue, 26 Mar 2019 16:27:03 +0100 (CET)
Date:   Tue, 26 Mar 2019 16:27:02 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCh v2 8/9] btrfs: tree-checker: Verify inode item
Message-ID: <20190326152702.GU10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-9-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320063717.31770-9-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 02:37:16PM +0800, Qu Wenruo wrote:
> @@ -1539,6 +1539,8 @@ do {                                                                   \
>  #define BTRFS_INODE_COMPRESS		(1 << 11)
>  
>  #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
> +#define BTRFS_INODE_FLAG_MASK		(((1 << 12) - 1) |\
> +					 BTRFS_INODE_ROOT_ITEM_INIT)

That's fragile, the mask constant should enumerate all bits it's
supposed to cover, like

+#define BTRFS_INODE_FLAG_MASK                                          \
+       (BTRFS_INODE_NODATASUM |                                        \
+        BTRFS_INODE_NODATACOW |                                        \
+        BTRFS_INODE_READONLY |                                         \
+        BTRFS_INODE_NOCOMPRESS |                                       \
+        BTRFS_INODE_PREALLOC |                                         \
+        BTRFS_INODE_SYNC |                                             \
+        BTRFS_INODE_IMMUTABLE |                                        \
+        BTRFS_INODE_APPEND |                                           \
+        BTRFS_INODE_NODUMP |                                           \
+        BTRFS_INODE_NOATIME |                                          \
+        BTRFS_INODE_DIRSYNC |                                          \
+        BTRFS_INODE_COMPRESS |                                         \
+        BTRFS_INODE_ROOT_ITEM_INIT)
+

> +	u64 super_gen = btrfs_super_generation(fs_info->super_copy);
> +	u32 valid_mask = (S_IFMT | S_ISUID | S_ISGID | S_ISVTX | 0777);
> +	u32 mode;
> +
> +	if ((key->objectid < BTRFS_FIRST_FREE_OBJECTID ||
> +	     key->objectid > BTRFS_LAST_FREE_OBJECTID) &&
> +	     key->objectid != BTRFS_ROOT_TREE_DIR_OBJECTID &&
> +	     key->objectid != BTRFS_FREE_INO_OBJECTID) {
> +		generic_err(fs_info, leaf, slot,
> +	"invalid key objectid: has %llu expect %llu or [%llu, %llu] or %llu",
> +			    key->objectid, BTRFS_ROOT_TREE_DIR_OBJECTID,
> +			    BTRFS_FIRST_FREE_OBJECTID,
> +			    BTRFS_LAST_FREE_OBJECTID,
> +			    BTRFS_FREE_INO_OBJECTID);
> +		goto error;
> +	}
> +	if (key->offset != 0) {
> +		inode_item_err(fs_info, leaf, slot,
> +			"invalid key offset: has %llu expect 0",
> +			key->offset);
> +		goto error;
> +	}
> +	iitem = btrfs_item_ptr(leaf, slot, struct btrfs_inode_item);
> +
> +	/* Here we use super block generation + 1 to handle log tree */
> +	if (btrfs_inode_generation(leaf, iitem) > super_gen + 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			"invalid inode generation: has %llu expect (0, %llu]",
> +			       btrfs_inode_generation(leaf, iitem),
> +			       super_gen + 1);
> +		goto error;
> +	}
> +	/* Note for ROOT_TREE_DIR_ITEM, mkfs could make its transid as 0 */
> +	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			"invalid inode generation: has %llu expect [0, %llu]",
> +			       btrfs_inode_transid(leaf, iitem),
> +			       super_gen + 1);
> +		goto error;
> +	}
> +
> +	/*
> +	 * For size and nbytes it's better not to be too strict, as for dir
> +	 * item its size/nbytes can easily get wrong, but doesn't affect
> +	 * any thing of the fs. So here we skip the check.
> +	 */
> +
> +	mode = btrfs_inode_mode(leaf, iitem);
> +	if (mode & ~valid_mask) {
> +		inode_item_err(fs_info, leaf, slot,
> +			       "unknown mode bit detected: 0x%x",
> +			       mode & ~valid_mask);
> +		goto error;
> +	}
> +
> +	/*
> +	 * S_IFMT is not bit mapped so we can't completely rely is_power_of_2(),
> +	 * but is_power_of_2() can save us from checking FIFO/CHR/DIR/REG.
> +	 * Only needs to check BLK, LNK and SOCKS
> +	 */
> +	if (!is_power_of_2(mode & S_IFMT)) {
> +		if (!S_ISLNK(mode) && ! S_ISBLK(mode) && !S_ISSOCK(mode)) {
> +			inode_item_err(fs_info, leaf, slot,
> +			"invalid mode: has 0%o expect valid S_IF* bit(s)",
> +				       mode & S_IFMT);
> +			goto error;
> +		}
> +	}
> +	if (S_ISDIR(mode) && btrfs_inode_nlink(leaf, iitem) > 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			       "invalid nlink: has %u expect no more than 1 for dir",
> +			btrfs_inode_nlink(leaf, iitem));
> +		goto error;
> +	}
> +	if (btrfs_inode_flags(leaf, iitem) & ~BTRFS_INODE_FLAG_MASK) {
> +		inode_item_err(fs_info, leaf, slot,
> +			       "unknown flags detected: 0x%llx",
> +			       btrfs_inode_flags(leaf, iitem) &
> +			       ~BTRFS_INODE_FLAG_MASK);
> +		goto error;
> +	}
> +	return 0;
> +
> +error:
> +	return -EUCLEAN;

Switched to local returns instead of gotos.

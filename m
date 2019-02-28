Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UPPERCASE_50_75,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEC1C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 15:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96945206B8
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 15:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388985AbfB1PXB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:23:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:33564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732350AbfB1PXA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 10:23:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 62DA6AFED
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 15:22:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C973DDA944; Thu, 28 Feb 2019 16:24:19 +0100 (CET)
Date:   Thu, 28 Feb 2019 16:24:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: trace: Add trace events for extent_io_tree
Message-ID: <20190228152419.GH31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190228100255.10953-1-wqu@suse.com>
 <20190228100255.10953-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228100255.10953-3-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 28, 2019 at 06:02:55PM +0800, Qu Wenruo wrote:
>  TRACE_DEFINE_ENUM(FLUSH_DELAYED_ITEMS_NR);
> +#define show_extent_io_tree_owner(owner)				\
> +	__print_symbolic(owner,						\
> +		{ IO_TREE_FS_INFO_FREED_EXTENTS0, "FREED_EXTENTS0" },	\
> +		{ IO_TREE_FS_INFO_FREED_EXTENTS1, "FREED_EXTENTS1" },	\
> +		{ IO_TREE_INODE_IO_TREE,	 "INODE_IO_TREE" },	\
> +		{ IO_TREE_INODE_IO_FAILURE_TREE, "INODE_IO_FAILURE" },	\
> +		{ IO_TREE_RELOCATION_PROCESSED_BLOCKS, "RELOCATION" },	\
> +		{ IO_TREE_TRANSACTION_DIRTY_PAGES, "TRANS_DIRTY_PAGES" },\
> +		{ IO_TREE_ROOT_DIRTY_LOG_PAGES, "ROOT_DIRTY_LOG" },	\
> +		{ IO_TREE_TMP })

Please align the strings

> +
>  #define BTRFS_GROUP_FLAGS	\
>  	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"},	\
>  	{ BTRFS_BLOCK_GROUP_SYSTEM,	"SYSTEM"},	\
> @@ -88,6 +100,25 @@ TRACE_DEFINE_ENUM(COMMIT_TRANS);
>  	{ BTRFS_BLOCK_GROUP_RAID5,	"RAID5"},	\
>  	{ BTRFS_BLOCK_GROUP_RAID6,	"RAID6"}
>  
> +#define EXTENT_FLAGS					\
> +	{ EXTENT_DIRTY,		"DIRTY"},		\
> +	{ EXTENT_WRITEBACK,	"WRITEBACK"},		\
> +	{ EXTENT_UPTODATE,	"UPTODATE"},		\
> +	{ EXTENT_LOCKED,	"LOCKED"},		\
> +	{ EXTENT_NEW,		"NEW"},			\
> +	{ EXTENT_DELALLOC,	"DELALLOC"},		\
> +	{ EXTENT_DEFRAG,	"DEFRAG"},		\
> +	{ EXTENT_BOUNDARY,	"BOUNDARY"},		\
> +	{ EXTENT_NODATASUM,	"NODATASUM"},		\
> +	{ EXTENT_CLEAR_META_RESV,"CLEAR_META_RSV"},	\
> +	{ EXTENT_FIRST_DELALLOC,"FIRST_DELALLOC"},	\
> +	{ EXTENT_NEED_WAIT,	"NEED_WAIT"},		\
> +	{ EXTENT_DAMAGED,	"DAMAGED"},		\
> +	{ EXTENT_NORESERVE,	"NORESERVE"},		\
> +	{ EXTENT_QGROUP_RESERVED,"QGROUP_RESERVED"},	\
> +	{ EXTENT_CLEAR_DATA_RESV,"CLEAR_DATA_RESV"},	\
> +	{ EXTENT_DELALLOC_NEW,	"DELALLOC_NEW"}

and there, the maximum line width is 80 and there's enough space.

> +
>  #define BTRFS_FSID_SIZE 16
>  #define TP_STRUCT__entry_fsid __array(u8, fsid, BTRFS_FSID_SIZE)
>  
> @@ -1878,6 +1909,126 @@ DEFINE_EVENT(btrfs__block_group, btrfs_skip_unused_block_group,
>  	TP_ARGS(bg_cache)
>  );
>  
> +TRACE_EVENT(btrfs_set_extent_bit,
> +	TP_PROTO(const struct extent_io_tree *tree,
> +		 u64 start, u64 len, unsigned set_bits),
> +
> +	TP_ARGS(tree, start, len, set_bits),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned,	owner	)
> +		__field(	u64,		ino	)
> +		__field(	u64,		rootid	)
> +		__field(	u64,		start	)
> +		__field(	u64,		len	)
> +		__field(	unsigned,	set_bits)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->owner	= tree->owner;
> +		if (tree->private_data) {
> +			struct inode *inode = tree->private_data;
> +
> +			__entry->ino	= inode->i_ino;

Don't use raw i_ino but btrfs_ino

> +			__entry->rootid	=
> +				BTRFS_I(inode)->root->root_key.objectid;
> +		} else {
> +			__entry->ino	= 0;
> +			__entry->rootid	= 0;
> +		}
> +		__entry->start		= start;
> +		__entry->len		= len;
> +		__entry->set_bits	= set_bits;
> +	),

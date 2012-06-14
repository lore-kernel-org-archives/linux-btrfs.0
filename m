Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:38307 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075Ab2FNPDZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 11:03:25 -0400
Date: Thu, 14 Jun 2012 17:03:16 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: use radix tree for checksum
Message-ID: <20120614150316.GT32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1339582751-32029-2-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339582751-32029-2-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 13, 2012 at 06:19:08PM +0800, Liu Bo wrote:
> We used to issue a checksum to an extent state of 4K range for read endio,
> but now we want to use larger range for performance optimization, so instead we
> create a radix tree for checksum, where an item stands for checksum of 4K data.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 25900af..c896962 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -96,11 +96,13 @@ struct extent_io_ops {
>  struct extent_io_tree {
>  	struct rb_root state;
>  	struct radix_tree_root buffer;
> +	struct radix_tree_root csum;
>  	struct address_space *mapping;
>  	u64 dirty_bytes;
>  	int track_uptodate;
>  	spinlock_t lock;
>  	spinlock_t buffer_lock;
> +	spinlock_t csum_lock;

I'm afraid 3 spinlocks sharing the same cacheline will bite and hurt
performance.

struct extent_io_tree {
        struct rb_root             state;                /*     0     8 */
        struct radix_tree_root     buffer;               /*     8    16 */
        struct radix_tree_root     csum;                 /*    24    16 */
        struct address_space *     mapping;              /*    40     8 */
        u64                        dirty_bytes;          /*    48     8 */
        int                        track_uptodate;       /*    56     4 */

        /* XXX 4 bytes hole, try to pack */

        /* --- cacheline 1 boundary (64 bytes) --- */
        rwlock_t                   lock;                 /*    64     8 */
        spinlock_t                 buffer_lock;          /*    72     4 */
        spinlock_t                 csum_lock;            /*    76     4 */
        struct extent_io_ops *     ops;                  /*    80     8 */

        /* size: 88, cachelines: 2, members: 10 */
        /* sum members: 84, holes: 1, sum holes: 4 */
        /* last cacheline: 24 bytes */
};

so we have to live with 2 cachenlines, maybe it'll be enough to split
the structure to 2 sections depending on the access paterns. Definetely
for later, but I think it should be noted as the patchset tries to
improve performance.


>  	struct extent_io_ops *ops;
>  };


david

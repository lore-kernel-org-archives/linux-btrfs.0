Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbaAOP4T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 10:56:19 -0500
Date: Wed, 15 Jan 2014 16:56:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] Btrfs: change the members' order of btrfs_space_info
 structure to reduce the cache miss
Message-ID: <20140115155618.GC6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 15, 2014 at 08:00:54PM +0800, Miao Xie wrote:
> It is better that the position of the lock is close to the data which is
> protected by it, because they may be in the same cache line, we will load
> less cache lines when we access them. So we rearrange the members' position
> of btrfs_space_info structure to make the lock be closer to the its data.

I like that
Reviewed-by: David Sterba <dsterba@suse.cz>

New structure layout according to pahole looks reasonable. We can try to
split 'groups_sem' and 'wait' to 2 cachelines, but this would need more
shuffling and maybe some measurement if this wins any perf percents.

struct btrfs_space_info {
        spinlock_t                 lock;                 /*     0     4 */

        /* XXX 4 bytes hole, try to pack */

        u64                        total_bytes;          /*     8     8 */
        u64                        bytes_used;           /*    16     8 */
        u64                        bytes_pinned;         /*    24     8 */
        u64                        bytes_reserved;       /*    32     8 */
        u64                        bytes_may_use;        /*    40     8 */
        u64                        bytes_readonly;       /*    48     8 */
        unsigned int               full:1;               /*    56:31  4 */
        unsigned int               chunk_alloc:1;        /*    56:30  4 */
        unsigned int               flush:1;              /*    56:29  4 */

        /* XXX 29 bits hole, try to pack */

        unsigned int               force_alloc;          /*    60     4 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        u64                        disk_used;            /*    64     8 */
        u64                        disk_total;           /*    72     8 */
        u64                        flags;                /*    80     8 */
        struct percpu_counter      total_bytes_pinned;   /*    88    40 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        struct list_head           list;                 /*   128    16 */
        struct rw_semaphore        groups_sem;           /*   144    32 */
        struct list_head           block_groups[7];      /*   176   112 */
        /* --- cacheline 4 boundary (256 bytes) was 32 bytes ago --- */
        wait_queue_head_t          wait;                 /*   288    24 */

        /* size: 312, cachelines: 5, members: 19 */
        /* sum members: 308, holes: 1, sum holes: 4 */
        /* bit holes: 1, sum bit holes: 29 bits */
        /* last cacheline: 56 bytes */
};

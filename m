Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44503C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 09:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B6AE20866
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 09:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbeL1JPw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 04:15:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:43772 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729927AbeL1JPw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 04:15:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 20A29ADCE
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2018 09:15:49 +0000 (UTC)
Subject: Re: [PATCH RFC 0/2] Use new incompat feature BG_TREE to hugely reduce
 mount time
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181228083745.3134-1-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <38520a81-e5b0-35b5-bf81-966ea6ef2c45@suse.com>
Date:   Fri, 28 Dec 2018 11:15:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181228083745.3134-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.12.18 г. 10:37 ч., Qu Wenruo wrote:
> This patchset can be fetched from:
> https://github.com/adam900710/linux/tree/bg_tree
> Which is based on v4.20-rc1 tag.
> 
> This patchset will hugely reduce mount time of large fs by putting all
> block group items into its own tree.
> 
> The old behavior will try to read out all block group items at mount
> time, however due to the key of block group items are scattered across
> tons of extent items, we must call btrfs_search_slot() for each block
> group.
> 
> It works fine for small fs, but when number of block groups goes beyond
> 200, such tree search will become a random read, causing obvious slow
> down.
> 
> On the other hand, btrfs_read_chunk_tree() is still very fast, since we
> put CHUNK_ITEMS into their own tree and package them next to each other.
> 
> 
> Following this idea, we could do the same thing for block group items,
> so instead of triggering btrfs_search_slot() for each block group, we
> just call btrfs_next_item() and under most case we could finish in
> memory, and hugely speed up mount (see BENCHMARK below).
> 
> The only disadvantage is, this method introduce an incompatible feature,
> so existing fs can't use this feature directly.
> Either specify it at mkfs time, or use btrfs-progs offline convert tool
> (*).

What if we start recording block group items in the chunk tree? Would
that bring any benefit without creating yet another tree, though likely
we'd still have to use an incompat flag? That way shouldn't BLOCK_GROUP
items be chunked together?

> 
> *: Mkfs and convert tool are doing the same work, however I haven't
> decide if I should put this feature to btrfstune.
> 
> The RFC tag is for the comprehensive test and sysfs interface.
> At least during my filling test it definitely works fine.
> 
> [[Benchmark]]
> Physical device:	HDD (7200RPM)
> Nodesize:		4K  (to bump up tree height)
> Used size:		250G
> Total size:		500G
> Extent data size:	1M
> 
> All file extents on disk is in 1M size, ensured by using fallocate.
> 
> Without patchset:
> Use ftrace function graph:
> 
>   3)               |  open_ctree [btrfs]() {
>   3)               |    btrfs_read_chunk_tree [btrfs]() {
>   3) * 69033.31 us |    }
>   3)               |    btrfs_verify_dev_extents [btrfs]() {
>   3) * 90376.15 us |    }
>   3)               |    btrfs_read_block_groups [btrfs]() {
>   2) $ 2733853 us  |    } /* btrfs_read_block_groups [btrfs] */
>   2) $ 3168384 us  |  } /* open_ctree [btrfs] */
> 
>  btrfs_read_block_groups() takes 87% of the total mount time,
> 
> With patchset, and use -O bg-tree mkfs option:
>   7)               |  open_ctree [btrfs]() {
>   7)               |    btrfs_read_chunk_tree [btrfs]() {
>   7) # 2448.562 us |    }
>   7)               |    btrfs_verify_dev_extents [btrfs]() {
>   7) * 19802.02 us |    }
>   7)               |    btrfs_read_block_groups [btrfs]() {
>   7) # 8610.397 us |    }
>   7) @ 113498.6 us |  }
> 
>   open_ctree() time is only 3% of original mount time.
>   And btrfs_read_block_groups() only takes 7.6% of total open_ctree()
>   execution time.
> 
> 
> 
> Qu Wenruo (2):
>   btrfs: Refactor btrfs_read_block_groups()
>   btrfs: Introduce new incompat feature, BG_TREE
> 
>  fs/btrfs/ctree.h                |   5 +-
>  fs/btrfs/disk-io.c              |  13 ++
>  fs/btrfs/extent-tree.c          | 300 ++++++++++++++++++++------------
>  include/uapi/linux/btrfs.h      |   1 +
>  include/uapi/linux/btrfs_tree.h |   3 +
>  5 files changed, 206 insertions(+), 116 deletions(-)
> 

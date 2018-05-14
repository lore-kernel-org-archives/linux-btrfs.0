Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:49081 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932202AbeENOfd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 10:35:33 -0400
Date: Mon, 14 May 2018 22:35:10 +0800
From: Liu Bo <bo.liu@linux.alibaba.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: verify key failure
Message-ID: <20180514143510.x5hwstlzm2lpeiqx@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I got another warning of verify_level_key by running btrfs/124 in a loop, I'm testing against 4.17-rc3.

Not sure if it's false positive.

[101414.336691] WARNING: CPU: 3 PID: 30194 at fs/btrfs/disk-io.c:455 btree_read_extent_buffer_pages+0x183/0x220 [btrfs]
[101414.340372] Modules linked in: btrfs(O) xor zstd_decompress zstd_compress xxhash zlib_inflate lzo_compress lzo_decompress zlib_deflate raid6_pq dm_flakey [last unloaded: xor]
[101414.345713] CPU: 3 PID: 30194 Comm: btrfs Tainted: G        W  O      4.17.0-rc3-liubo+ #35
[101414.348501] RIP: 0010:btree_read_extent_buffer_pages+0x183/0x220 [btrfs]
...
[101414.369713] Call Trace:
[101414.370477]  read_tree_block+0x3d/0x60 [btrfs]
[101414.371946]  read_block_for_search.isra.11+0x19c/0x350 [btrfs]
[101414.373915]  btrfs_search_slot+0x4a0/0xa60 [btrfs]
[101414.375489]  ? trace_hardirqs_on_caller+0x12/0x1c0
[101414.377080]  ? btrfs_lookup_ordered_extent+0x8b/0xd0 [btrfs]
[101414.379007]  btrfs_lookup_csum+0x42/0x130 [btrfs]
[101414.380456]  __btrfs_lookup_bio_sums+0x2fb/0x6a0 [btrfs]
[101414.381554]  btrfs_submit_bio_hook+0xbb/0x180 [btrfs]
[101414.382598]  submit_one_bio+0x57/0x80 [btrfs]
[101414.383509]  submit_extent_page+0xd5/0x1f0 [btrfs]
[101414.384507]  __do_readpage+0x2a6/0x770 [btrfs]
[101414.385449]  ? btrfs_create_repair_bio+0x100/0x100 [btrfs]
[101414.386576]  ? btrfs_direct_IO+0x3a0/0x3a0 [btrfs]
[101414.387569]  ? btrfs_direct_IO+0x3a0/0x3a0 [btrfs]
[101414.388562]  __extent_readpages+0x2e2/0x330 [btrfs]
[101414.389584]  extent_readpages+0x10e/0x1a0 [btrfs]
[101414.390565]  __do_page_cache_readahead+0x283/0x340
[101414.391550]  ? ondemand_readahead+0x207/0x460
[101414.392451]  ondemand_readahead+0x207/0x460
[101414.393353]  relocate_file_extent_cluster+0x364/0x4c0 [btrfs]
[101414.394546]  relocate_block_group+0x5d4/0x6e0 [btrfs]
...
[101414.432616] BTRFS error (device sdb): tree first key mismatch detected, bytenr=30523392 key expected=(18446744073709551606, 128, 1120665600) has=(1, 204, 22020096)

thanks,
-liubo

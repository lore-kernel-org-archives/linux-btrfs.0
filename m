Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:45136 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752916AbcJOUtv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Oct 2016 16:49:51 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: speed up cp --reflink=always
Message-ID: <6e902770-05f3-2562-eeb3-dd9ef53b9406@profihost.ag>
Date: Sat, 15 Oct 2016 22:49:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

cp --reflink=always takes sometimes very long. (i.e. 25-35 minutes)

An example:

source file:
# ls -la vm-279-disk-1.img
-rw-r--r-- 1 root root 204010946560 Oct 14 12:15 vm-279-disk-1.img

target file after around 10 minutes:
# ls -la vm-279-disk-1.img.tmp
-rw-r--r-- 1 root root 65022328832 Oct 15 22:13 vm-279-disk-1.img.tmp

I/O Waits are at around 6% but disk usage is at around 100%.

The process using most of the disk I/O is a kworker process. A function
trace of this kworker for 30s is already 44MB - no idea where to upload.
This volume uses space_cache=v2.

While digging through it i see a lot of this calls:

   kworker/u65:4-20679 [007] .... 46021.641882: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641882: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641882: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641882: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641882: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641882: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641882: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641882: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641883: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641883: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641883: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641883: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641883: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641883: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641883: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641883: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641883: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641883: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641883: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641884: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641884: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641884: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641884: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641884: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641884: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641884: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641884: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641884: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641884: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641884: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641885: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641885: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641885: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641885: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641885: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641885: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641886: btrfs_set_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641886: btrfs_get_token_32
<-btrfs_del_items
   kworker/u65:4-20679 [007] .... 46021.641886: btrfs_set_token_32
<-btrfs_del_items

Sorting the calls shows:
   4892 _raw_spin_lock <-free_extent_buffer
   4894 release_extent_buffer <-free_extent_buffer
   6803 map_private_extent_buffer <-generic_bin_search.constprop.36
   6839 __set_page_dirty_nobuffers <-btree_set_page_dirty
   6840 btree_set_page_dirty <-set_page_dirty
   6840 mem_cgroup_begin_page_stat <-__set_page_dirty_nobuffers
   6840 page_mapping <-set_page_dirty
   6840 set_page_dirty <-set_extent_buffer_dirty
   6841 mem_cgroup_end_page_stat <-__set_page_dirty_nobuffers
   7521 btrfs_clear_lock_blocking_rw <-btrfs_clear_path_blocking
   7967 btrfs_get_token_64 <-read_block_for_search.isra.33
   8018 btrfs_set_token_32 <-btrfs_del_items
   8235 btrfs_get_token_32 <-btrfs_del_items
   8813 btrfs_set_lock_blocking_rw <-btrfs_set_path_blocking
   9235 map_private_extent_buffer <-btrfs_get_token_32
  11824 btrfs_set_token_32 <-btrfs_extend_item
  12090 map_private_extent_buffer <-btrfs_get_token_64
  12367 mark_page_accessed <-mark_extent_buffer_accessed
  12621 btrfs_get_token_32 <-btrfs_extend_item
  16267 btrfs_set_token_32 <-setup_items_for_insert
  16423 btrfs_get_token_32 <-setup_items_for_insert
  28542 btrfs_comp_cpu_keys <-generic_bin_search.constprop.36

CPU usage is at around 10%.

perf top looks like this:
   7,55%  [kernel]               [k] __find_stripe
   2,47%  [kernel]               [k] read_extent_buffer
   2,46%  [kernel]               [k] analyse_stripe
   1,96%  [kernel]               [k] _raw_spin_lock
   1,79%  [kernel]               [k] btrfs_get_token_32
   1,65%  [kernel]               [k] __radix_tree_lookup
   1,61%  [kernel]               [k] btrfs_set_lock_blocking_rw
   1,53%  [kernel]               [k] map_private_extent_buffer
   1,36%  [kernel]               [k] generic_bin_search.constprop.36
   1,33%  [kernel]               [k] ops_run_io
   1,26%  [kernel]               [k] move_freepages
   1,22%  [kernel]               [k] memcpy_erms
   1,20%  [kernel]               [k] rb_next
   1,12%  [kernel]               [k] bio_init
   1,07%  [kernel]               [k] btrfs_clear_lock_blocking_rw
   1,05%  [kernel]               [k] __memmove
   1,00%  [kernel]               [k] _raw_spin_lock_irqsave
   0,94%  [kernel]               [k] btrfs_set_token_32
   0,89%  [kernel]               [k] menu_select
   0,83%  [kernel]               [k] btrfs_get_token_64
   0,82%  [kernel]               [k] __lookup_extent_mapping
   0,77%  [kernel]               [k] handle_stripe
   0,77%  [kernel]               [k] native_queued_spin_lock_slowpath
   0,75%  [kernel]               [k] raid5_compute_blocknr
   0,64%  [kernel]               [k] btrfs_search_slot
   0,63%  [kernel]               [k] btrfs_comp_cpu_keys

Greets,
Stefan

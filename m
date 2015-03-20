Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20239 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbCTOix (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 10:38:53 -0400
Date: Fri, 20 Mar 2015 17:38:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: fdmanana@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: Btrfs: make fsync work after cloning into a file
Message-ID: <20150320143840.GC5108@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Filipe Manana,

The patch 7ffbb598a059: "Btrfs: make fsync work after cloning into a
file" from Jun 9, 2014, leads to the following static checker warning:

	fs/btrfs/inode.c:6602 btrfs_get_extent()
	warn: we tested 'create' before and it was 'false'

fs/btrfs/inode.c
  6589  
  6590                  if (new_inline)
                            ^^^^^^^^^^
This implies that "create == 0".

  6591                          goto out;
  6592  
  6593                  size = btrfs_file_extent_inline_len(leaf, path->slots[0], item);
  6594                  extent_offset = page_offset(page) + pg_offset - extent_start;
  6595                  copy_size = min_t(u64, PAGE_CACHE_SIZE - pg_offset,
  6596                                  size - extent_offset);
  6597                  em->start = extent_start + extent_offset;
  6598                  em->len = ALIGN(copy_size, root->sectorsize);
  6599                  em->orig_block_len = em->len;
  6600                  em->orig_start = em->start;
  6601                  ptr = btrfs_file_extent_inline_start(item) + extent_offset;
  6602                  if (create == 0 && !PageUptodate(page)) {
                            ^^^^^^^^^^^
No need to check here.

  6603                          if (btrfs_file_extent_compression(leaf, item) !=
  6604                              BTRFS_COMPRESS_NONE) {
  6605                                  ret = uncompress_inline(path, inode, page,
  6606                                                          pg_offset,
  6607                                                          extent_offset, item);
  6608                                  if (ret) {
  6609                                          err = ret;
  6610                                          goto out;
  6611                                  }
  6612                          } else {
  6613                                  map = kmap(page);
  6614                                  read_extent_buffer(leaf, map + pg_offset, ptr,
  6615                                                     copy_size);
  6616                                  if (pg_offset + copy_size < PAGE_CACHE_SIZE) {
  6617                                          memset(map + pg_offset + copy_size, 0,
  6618                                                 PAGE_CACHE_SIZE - pg_offset -
  6619                                                 copy_size);
  6620                                  }
  6621                                  kunmap(page);
  6622                          }
  6623                          flush_dcache_page(page);
  6624                  } else if (create && PageUptodate(page)) {
                                   ^^^^^^
Or here.

  6625                          BUG();
  6626                          if (!trans) {

regards,
dan carpenter

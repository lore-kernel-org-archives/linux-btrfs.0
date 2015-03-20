Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33715 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbCTPKD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 11:10:03 -0400
Received: by iecvj10 with SMTP id vj10so95164738iec.0
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 08:10:02 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150320143840.GC5108@mwanda>
References: <20150320143840.GC5108@mwanda>
Date: Fri, 20 Mar 2015 15:10:02 +0000
Message-ID: <CAL3q7H65R=oNy3AHZFsZZEmyAXvO4eDMVhiScT_a375sn0x=QA@mail.gmail.com>
Subject: Re: Btrfs: make fsync work after cloning into a file
From: Filipe David Manana <fdmanana@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 20, 2015 at 2:38 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Hello Filipe Manana,
>
> The patch 7ffbb598a059: "Btrfs: make fsync work after cloning into a
> file" from Jun 9, 2014, leads to the following static checker warning:
>
>         fs/btrfs/inode.c:6602 btrfs_get_extent()
>         warn: we tested 'create' before and it was 'false'
>
> fs/btrfs/inode.c
>   6589
>   6590                  if (new_inline)
>                             ^^^^^^^^^^
> This implies that "create == 0".
>
>   6591                          goto out;
>   6592
>   6593                  size = btrfs_file_extent_inline_len(leaf, path->slots[0], item);
>   6594                  extent_offset = page_offset(page) + pg_offset - extent_start;
>   6595                  copy_size = min_t(u64, PAGE_CACHE_SIZE - pg_offset,
>   6596                                  size - extent_offset);
>   6597                  em->start = extent_start + extent_offset;
>   6598                  em->len = ALIGN(copy_size, root->sectorsize);
>   6599                  em->orig_block_len = em->len;
>   6600                  em->orig_start = em->start;
>   6601                  ptr = btrfs_file_extent_inline_start(item) + extent_offset;
>   6602                  if (create == 0 && !PageUptodate(page)) {
>                             ^^^^^^^^^^^
> No need to check here.
>
>   6603                          if (btrfs_file_extent_compression(leaf, item) !=
>   6604                              BTRFS_COMPRESS_NONE) {
>   6605                                  ret = uncompress_inline(path, inode, page,
>   6606                                                          pg_offset,
>   6607                                                          extent_offset, item);
>   6608                                  if (ret) {
>   6609                                          err = ret;
>   6610                                          goto out;
>   6611                                  }
>   6612                          } else {
>   6613                                  map = kmap(page);
>   6614                                  read_extent_buffer(leaf, map + pg_offset, ptr,
>   6615                                                     copy_size);
>   6616                                  if (pg_offset + copy_size < PAGE_CACHE_SIZE) {
>   6617                                          memset(map + pg_offset + copy_size, 0,
>   6618                                                 PAGE_CACHE_SIZE - pg_offset -
>   6619                                                 copy_size);
>   6620                                  }
>   6621                                  kunmap(page);
>   6622                          }
>   6623                          flush_dcache_page(page);
>   6624                  } else if (create && PageUptodate(page)) {
>                                    ^^^^^^
> Or here.
>
>   6625                          BUG();
>   6626                          if (!trans) {

Hi,

Valid warning, but the change mentioned above didn't add or update
that logic (only stored the result of "!page || create" into a local
variable named "new_inline").
The logic with the unnecessary checks for "create" was added in 2007,
commit 179e29e488cc (Btrfs: Fix a number of inline extent problems
that Yan Zheng reported.).

thanks

>
> regards,
> dan carpenter



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

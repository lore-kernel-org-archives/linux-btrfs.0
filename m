From: liubo <liubo2009@cn.fujitsu.com>
Subject: [fnst-kernel 10816] Found several problems while reading btrfs code
Date: Wed, 27 Oct 2010 15:40:13 +0800
Message-ID: <4CC7D75D.3050806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris,

We've found several tiny problems while reading btrfs code.

These problems are mainly about uncheck return value or BUG_ON check. 
They really have an impact on codes' quality, though they will not be 
hit in normal cases.

Here comes some examples:

1. memory allocation check
May cause -ENOMEM, btrfs BUG_ON().

static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
...
        path = btrfs_alloc_path();
        BUG_ON(!path);

2. return value's BUG_ON() check

static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
...
        if (btrfs_block_can_be_shared(root, buf)) {
                ret = btrfs_lookup_extent_info(trans, root, buf->start,
                                               buf->len, &refs, &flags);
                BUG_ON(ret);
                BUG_ON(refs == 0);



Is there a plan to improve the above? 
We are helpful on this:)


thanks, 
liubo













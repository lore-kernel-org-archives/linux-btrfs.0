From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Redundant check in verify_parent_transid
Date: Tue, 30 Jun 2009 14:24:21 +0900
Message-ID: <4A49A185.5080109@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

In verify_parent_transid() of disk-io.c (btrfs-progs), I found
redundant check.
---
static int verify_parent_transid(struct extent_io_tree *io_tree,
                                 struct extent_buffer *eb, u64 parent_transid)
{
        int ret;

        if (!parent_transid || btrfs_header_generation(eb) == parent_transid)
                               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---
If second check is true in this sentense, then the function return.
So the next if sentence is not estimated.
---
                return 0;

        if (extent_buffer_uptodate(eb) &&
            btrfs_header_generation(eb) == parent_transid) {
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                ret = 0;
                goto out;
        }
---
However, here has same check which looks redundant.
I guess here includes a bug, but I'm not sure.
Could someone tell me why?
---
        printk("parent transid verify failed on %llu wanted %llu found %llu\n",
               (unsigned long long)eb->start,
               (unsigned long long)parent_transid,
               (unsigned long long)btrfs_header_generation(eb));
        ret = 1;
---(snip)---

-- 
taruisi


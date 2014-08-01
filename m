Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:38525 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaHADZy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 23:25:54 -0400
MIME-Version: 1.0
Date: Thu, 31 Jul 2014 23:25:53 -0400
Message-ID: <CAPDOMVhHq9kmRh11tX7BF_V4XjDncpzUROoJJntif-vwKZbbNw@mail.gmail.com>
Subject: Help with btrfs_zero_range function
From: Nick Krause <xerofoify@gmail.com>
To: "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Guys,
I need to ask a question again, I am writing the above function and
basing it off the one of punch hole.
I have only started writing the function and have a few questions
about how to write this. Below this message
are my questions so fair and I also posting my written code in case
you guys want to give any feed back.
Regards and Thanks Again,
Nick
Questions
1. bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
   How I change this to check for a zero range or do I just remove
this variable;
2. ret = find_first_non_hole(inode, &offset, &len);
    How do I modify the called function for ret to be for a zero range?
The other parts of this function  are pretty similar to the one for
punch holes and seems pretty easy
to move other the other parts.
Code

static long btrfs_zero_range(struct inode *inode, loff_t loffset,
loff_t len,){
    struct btrfs_root *root = BTRF_I(inode)->root;
    struct btrfs_path *path;
    struct btrfs_block_rsv *rsv;
    struct btrfs_trans_handle *trans;
     u64 lockstart;
     u64 lockend;
     u64 tail_start;
     u64 tail_len;
     u64 orig_start = offset;
    u64 cur_offset;
    u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
    u64 drop_end;
    int ret = 0;
     int err = 0;
     int rsv_count;
     bool same_page;
     bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
     u64 ino_size;
    ret=btrfs_wait_ordered_range(inode, offset, len);
    if(ret)
        return ret;

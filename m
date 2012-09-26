Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:52252 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab2IZLsu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 07:48:50 -0400
Received: by dady13 with SMTP id y13so116474dad.19
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2012 04:48:50 -0700 (PDT)
Message-ID: <5062EB9F.4080507@gmail.com>
Date: Wed, 26 Sep 2012 19:48:47 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: typo in inode.c
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a typo (?) in inode.c (git)

i guess the "int limit = 10 * 1024 * 1042;" should be "int limit = 10 * 1024 * 1024;" instead

Could developer fix this typo?


static int cow_file_range_async(struct inode *inode, struct page *locked_page,
				u64 start, u64 end, int *page_started,
				unsigned long *nr_written)
{
	struct async_cow *async_cow;
	struct btrfs_root *root = BTRFS_I(inode)->root;
	unsigned long nr_pages;
	u64 cur_end;
	int limit = 10 * 1024 * 1042;

	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
			 1, 0, NULL, GFP_NOFS);
	while (start < end) {
		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
		BUG_ON(!async_cow);
		async_cow->inode = inode;
		async_cow->root = root;
		async_cow->locked_page = locked_page;
		async_cow->start = start;



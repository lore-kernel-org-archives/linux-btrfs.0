Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:48835 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaAIXoS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 18:44:18 -0500
Received: by mail-ve0-f175.google.com with SMTP id jx11so2919658veb.6
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 15:44:17 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 10 Jan 2014 00:44:17 +0100
Message-ID: <CACeaM885anPZOwbAw_2w43vOU8e0zkj-w_drar1sJhpppCsJeA@mail.gmail.com>
Subject: BTRFS_SEARCH_ARGS_BUFSIZE too small
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm playing around with the BTRFS_IOC_SEARCH_TREE to extract the csums
of the physical blocks. During the tests some item_header had len = 0,
which indicates the buffer was to small to hold the item. I added a
printk into the kernel to get the original size of the item and it was
around 6600 bytes. Is there another way to get the item? Otherwise I
would suggest to create an ioctl, which is a little bit more flexible,
something like

struct btrfs_ioctl_search_args2 {
        struct btrfs_ioctl_search_key key;
        __u64 buf_len
        char buf[0];
};

Gerhard

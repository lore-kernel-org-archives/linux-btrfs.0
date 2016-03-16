Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20182 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751837AbcCPCtB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 22:49:01 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id C670742B4B10
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 10:48:49 +0800 (CST)
To: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Why we always balance system chunk alone with metadata?
Message-ID: <56E8C990.1010508@cn.fujitsu.com>
Date: Wed, 16 Mar 2016 10:48:48 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

During debugging a bug related to balancing metadata chunk, we found 
that if we specify -m option for "btrfs balance", it will always balance 
system chunk too.

cmds-balance.c:
---
         /*
          * allow -s only under --force, otherwise do with system chunks
          * the same thing we were ordered to do with meta chunks
          */
         if (args.flags & BTRFS_BALANCE_SYSTEM) {
                 if (!force) {
                         error(
                             "Refusing to explicitly operate on system 
chunks.\n"
                             "Pass --force if you really want to do that.");
                         return 1;
                 }
         } else if (args.flags & BTRFS_BALANCE_METADATA) {
                 args.flags |= BTRFS_BALANCE_SYSTEM; <<< Here
                 memcpy(&args.sys, &args.meta,
                         sizeof(struct btrfs_balance_args));
         }
---

I'm curious why we always bind system chunk to metadata balance?

Is there any special reason?
The patch introducing such behavior is dated back to 2012, and this 
makes us unable to do metadata *only* balance.

Any idea?

Thanks,
Qu



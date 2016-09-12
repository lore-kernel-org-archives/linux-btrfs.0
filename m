Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:45645 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757224AbcILJOl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 05:14:41 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 03458600A5
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 11:14:36 +0200 (CEST)
Subject: Re: btrfstune -x -> extent-tree.c:2688: btrfs_reserve_extent:
 Assertion `ret` failed.
To: linux-btrfs@vger.kernel.org
References: <478c1cee-80f0-c8f3-0bb9-c8c8932a9fb5@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <65410ac0-fae5-62a8-7c47-7f9afbaffabd@mendix.com>
Date: Mon, 12 Sep 2016 11:14:36 +0200
MIME-Version: 1.0
In-Reply-To: <478c1cee-80f0-c8f3-0bb9-c8c8932a9fb5@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/09/2016 11:37 PM, Hans van Kranenburg wrote:
> 
> While trying to enable skinny metadata on a filesystem, I got this error
> (after minutes of reading from disk by the program):
> 
> -# btrfstune -x /dev/xvdb
> extent-tree.c:2688: btrfs_reserve_extent: Assertion `ret` failed.
> btrfstune[0x410ef6]
> btrfstune[0x410f1d]
> btrfstune(btrfs_reserve_extent+0x781)[0x41522e]
> btrfstune(btrfs_alloc_free_block+0x63)[0x415413]
> btrfstune(__btrfs_cow_block+0xfc)[0x409176]
> btrfstune(btrfs_cow_block+0x8b)[0x409718]
> btrfstune[0x40d8ad]
> btrfstune(btrfs_commit_transaction+0xb8)[0x40f10d]
> btrfstune(main+0x3b3)[0x407e31]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7f945fa06700]
> btrfstune(_start+0x29)[0x408509]

I took a fresh clone of the thing, and tried again, same crash, after 50
minutes of reading from disk.

Should I put this in the bugzilla?

Bumping a bit, since the previous mail already got buried in dozens of
mails over the weekend. ;]

-- 
Hans van Kranenburg

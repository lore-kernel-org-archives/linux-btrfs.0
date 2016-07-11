Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47332 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbcGKP7o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 11:59:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bMdcU-00063e-6u
	for linux-btrfs@vger.kernel.org; Mon, 11 Jul 2016 17:59:42 +0200
Received: from ip-64-134-228-164.public.wayport.net ([64.134.228.164])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 17:59:42 +0200
Received: from 1i5t5.duncan by ip-64-134-228-164.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 17:59:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2] btrfs: fix free space calculation in
 dump_space_info()
Date: Mon, 11 Jul 2016 15:59:35 +0000 (UTC)
Message-ID: <pan$9c0bf$33ee4c33$fff8aed3$9ef69860@cox.net>
References: <20160711113004.4896-1-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang Xiaoguang posted on Mon, 11 Jul 2016 19:30:04 +0800 as excerpted:

> In btrfs, btrfs_space_info's bytes_may_use is treated as fs used space,
> as what we do in reserve_metadata_bytes() or
> btrfs_alloc_data_chunk_ondemand(), so in dump_space_info(), when
> calculating free space, we should also minus btrfs_space_info's
> bytes_may_use.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 4 ++--

I'm not a dev so won't evaluate the patch itself.  However, on kernel 
related mailing lists it's standard practice to include a short, often 
one-line per revision, revision changelog.  It helps reviewers keep track 
of what changed since the last time they looked at the patch.  See pretty 
much any on-list v2+ patch as an example.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


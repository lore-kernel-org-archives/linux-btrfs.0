Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:38128 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751058AbaFJJEt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jun 2014 05:04:49 -0400
Message-ID: <5396BEB6.6060203@elastichosts.com>
Date: Tue, 10 Jun 2014 09:15:50 +0100
From: Alin Dobre <alin.dobre@elastichosts.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, Miao Xie <miaox@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] Btrfs: fix broken free space cache after the
 system crashed
References: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com> <1389787258-10865-5-git-send-email-miaox@cn.fujitsu.com> <53795F83.20109@fb.com>
In-Reply-To: <53795F83.20109@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/05/14 02:33, Chris Mason wrote:
> I had this one in the integration branch, but lockdep reported troubles.  It
> looks like lockdep is correct.  find_free_extent is nesting the cache rwsem
> inside the groups rwsem, but btrfs_write_out_cache is holding the new cache
> rwsem when it calls find_free_extent.

Is there a new patch for this problem? We have another issue that makes
us reboot the system quite often - I'm going to report that in a
separate thread - and after each machine restart, btrfs reports broken
free space cache. I know that's probably not that harmful, but it's
disturbing and it's not that easy to remount the filesystem to fix the
free space cache.

Cheers,
Alin.

Return-Path: <SRS0=k4qV=O4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA6AC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 10:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D26B21873
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 10:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="OMnTIsi+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbeLSKdT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Dec 2018 05:33:19 -0500
Received: from mail.synology.com ([211.23.38.101]:50140 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726812AbeLSKdS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Dec 2018 05:33:18 -0500
Received: from _ (localhost [127.0.0.1])
        by synology.com (Postfix) with ESMTPA id C608919A3CC5;
        Wed, 19 Dec 2018 18:33:11 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1545215591; bh=REnxYF7uyuB5kDTCw0I2fstKbeF6y6l6JfTQp1LZCAk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=OMnTIsi+54kUtDvVoA8AVaXEH8AI0Zx/9vQL8V8FCwLAfcXCSsVMGBznmz75Zr3eo
         4nkcqXV6W7H9MTwseg8cdognqJQOh2lGD+e2yydPUb/XF629+aazuew8TXxy/mEYSo
         HdLOFsmzE5dc28wMi9DfH9reuDhFkfB30eutHHGo=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 19 Dec 2018 18:33:11 +0800
From:   ethanlien <ethanlien@synology.com>
To:     Martin Raiber <martin@urbackup.org>
Cc:     Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>,
        linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
In-Reply-To: <01020167bc7811f0-cb1970f5-3d51-49f9-a5bb-63ba1ea35eea-000000@eu-west-1.amazonses.com>
References: <20180528054821.9092-1-ethanlien@synology.com>
 <D7645E04-6424-4BFA-90C6-D63245EB9435@fb.com>
 <01020167a30347da-385e2eff-ed13-422a-b27f-c3d5933aaef2-000000@eu-west-1.amazonses.com>
 <d324045eb532b2fa525203c20c57bed1@synology.com>
 <01020167bc7811f0-cb1970f5-3d51-49f9-a5bb-63ba1ea35eea-000000@eu-west-1.amazonses.com>
Message-ID: <362642e5e618dbf17effc17e0cb7457f@synology.com>
X-Sender: ethanlien@synology.com
User-Agent: Roundcube Webmail/1.1.2
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Martin Raiber 於 2018-12-17 22:00 寫到:

>>>> 
>>> I had lockups with this patch as well. If you put e.g. a loop device 
>>> on
>>> top of a btrfs file, loop sets PF_LESS_THROTTLE to avoid a feed back
>>> loop causing delays. The task balancing dirty pages in
>>> btrfs_finish_ordered_io doesn't have the flag and causes slow-downs. 
>>> In
>>> my case it managed to cause a feedback loop where it queues other
>>> btrfs_finish_ordered_io and gets stuck completely.
>>> 
>> 
>> The data writepage endio will queue a work for
>> btrfs_finish_ordered_io() in a separate workqueue and clear page's
>> writeback, so throttling in btrfs_finish_ordered_io() should not slow
>> down flusher thread. One suspicious point is while the caller is
>> waiting a range of ordered_extents to complete, they will be
>> blocked until balance_dirty_pages_ratelimited() make some
>> progress, since we finish ordered_extents in
>> btrfs_finish_ordered_io().
>> Do you have call stack information for stuck processes or using
>> fsync/sync frequently? If this is the case, maybe we should pull
>> this thing out and try balance dirty metadata pages somewhere.
> 
> Yeah like,
> 
> [875317.071433] Call Trace:
> [875317.071438]  ? __schedule+0x306/0x7f0
> [875317.071442]  schedule+0x32/0x80
> [875317.071447]  btrfs_start_ordered_extent+0xed/0x120
> [875317.071450]  ? remove_wait_queue+0x60/0x60
> [875317.071454]  btrfs_wait_ordered_range+0xa0/0x100
> [875317.071457]  btrfs_sync_file+0x1d6/0x400
> [875317.071461]  ? do_fsync+0x38/0x60
> [875317.071463]  ? btrfs_fdatawrite_range+0x50/0x50
> [875317.071465]  do_fsync+0x38/0x60
> [875317.071468]  __x64_sys_fsync+0x10/0x20
> [875317.071470]  do_syscall_64+0x55/0x100
> [875317.071473]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> so I guess the problem is that the calling balance_dirty_pages causes
> fsyncs to the same btrfs (via my unusual setup of loop+fuse)? Those
> fsyncs are deadlocked because they are called indirectly from
> btrfs_finish_ordered_io... It is a unusal setup, which is why I did not
> post it to the mailing list initially.

To me this is not like a real deadlock. The fsync call invokes two 
steps:
(1) flushing dirty data pages, (2) update corresponding metadata to
point to those flushed data. Since step1 consume dirty pages and
step2 produce more dirty pages, in this patch we leave step1
unchanged and block step2 in btrfs_finish_ordered_io(), which
seems reasonable to a OOM fix. The problem is, if there are
other processes continually writing new data, the fsync call will
need to wait the metadata update for a long time, even its dirty
data has been flushed long time ago.

Back to the deadlock problem, what Chris found is really a deadlock,
and it can be fixed by adding a check of free space inode.
For the fsync delay problem, it depends on whether we want to
control dirty metadata page size to match dirty_bytes limit here.
If we don't want, we revert this patch and try flushing dirty metadata
pages somewhere. It should be enough to fix the OOM. But if we
want to control dirty metadata page size to match dirty_bytes limit, we
still need some throttling here. Setting __GFP_WRITE in extent_buffer
page is bad since in most of the time we use them as read cache to
speedup b-tree traversal. Adding PF_LESS_THROTTLE in
btrfs_finish_ordered_io() might help since it create a window where
new writes are blocked but all the flushing and metadata update
keep unblocked, and still remain some kind of throttling. But it
needs more test to know the delay of fsync in the worst case.


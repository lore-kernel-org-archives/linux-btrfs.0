Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3EDC67839
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 08:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CB4B2080F
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 08:07:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="gIptEuAS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CB4B2080F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=synology.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbeLNIHQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Dec 2018 03:07:16 -0500
Received: from mail.synology.com ([211.23.38.101]:50799 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbeLNIHQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Dec 2018 03:07:16 -0500
Received: from _ (localhost [127.0.0.1])
        by synology.com (Postfix) with ESMTPA id A81F73D74CFE;
        Fri, 14 Dec 2018 16:07:09 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1544774829; bh=4IDkdhj7ejqtMQNVLsJEwZ5dZwO/Y58DekKpOa36k5E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=gIptEuASJVhVHoBgP//lb9TmzKzNfc7SXYvjcdNlu+U398KNp9AGXLUL/+DW3dAQV
         lgJH7gWSUMXINjZWW0e2+ycWLI2gdgcB0Rz5N4o/RCy/08gIjv9VYCqQrn5BCKrE0H
         d3bRTxpz6vcBv0CBWEGSE9Xvuaa3CzEljAYUDyr0=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 14 Dec 2018 16:07:09 +0800
From:   ethanlien <ethanlien@synology.com>
To:     Martin Raiber <martin@urbackup.org>
Cc:     Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>,
        linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
In-Reply-To: <01020167a30347da-385e2eff-ed13-422a-b27f-c3d5933aaef2-000000@eu-west-1.amazonses.com>
References: <20180528054821.9092-1-ethanlien@synology.com>
 <D7645E04-6424-4BFA-90C6-D63245EB9435@fb.com>
 <01020167a30347da-385e2eff-ed13-422a-b27f-c3d5933aaef2-000000@eu-west-1.amazonses.com>
Message-ID: <d324045eb532b2fa525203c20c57bed1@synology.com>
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

Martin Raiber 於 2018-12-12 23:22 寫到:
> On 12.12.2018 15:47 Chris Mason wrote:
>> On 28 May 2018, at 1:48, Ethan Lien wrote:
>> 
>> It took me a while to trigger, but this actually deadlocks ;)  More
>> below.
>> 
>>> [Problem description and how we fix it]
>>> We should balance dirty metadata pages at the end of
>>> btrfs_finish_ordered_io, since a small, unmergeable random write can
>>> potentially produce dirty metadata which is multiple times larger 
>>> than
>>> the data itself. For example, a small, unmergeable 4KiB write may
>>> produce:
>>> 
>>>     16KiB dirty leaf (and possibly 16KiB dirty node) in subvolume 
>>> tree
>>>     16KiB dirty leaf (and possibly 16KiB dirty node) in checksum tree
>>>     16KiB dirty leaf (and possibly 16KiB dirty node) in extent tree
>>> 
>>> Although we do call balance dirty pages in write side, but in the
>>> buffered write path, most metadata are dirtied only after we reach 
>>> the
>>> dirty background limit (which by far only counts dirty data pages) 
>>> and
>>> wakeup the flusher thread. If there are many small, unmergeable 
>>> random
>>> writes spread in a large btree, we'll find a burst of dirty pages
>>> exceeds the dirty_bytes limit after we wakeup the flusher thread -
>>> which
>>> is not what we expect. In our machine, it caused out-of-memory 
>>> problem
>>> since a page cannot be dropped if it is marked dirty.
>>> 
>>> Someone may worry about we may sleep in
>>> btrfs_btree_balance_dirty_nodelay,
>>> but since we do btrfs_finish_ordered_io in a separate worker, it will
>>> not
>>> stop the flusher consuming dirty pages. Also, we use different worker
>>> for
>>> metadata writeback endio, sleep in btrfs_finish_ordered_io help us
>>> throttle
>>> the size of dirty metadata pages.
>> In general, slowing down btrfs_finish_ordered_io isn't ideal because 
>> it
>> adds latency to places we need to finish quickly.  Also,
>> btrfs_finish_ordered_io is used by the free space cache.  Even though
>> this happens from its own workqueue, it means completing free space
>> cache writeback may end up waiting on balance_dirty_pages, something
>> like this stack trace:
>> 
>> [..]
>> 
>> Eventually, we have every process in the system waiting on
>> balance_dirty_pages(), and nobody is able to make progress on paclear 
>> page's writebackge
>> writeback.
>> 
> I had lockups with this patch as well. If you put e.g. a loop device on
> top of a btrfs file, loop sets PF_LESS_THROTTLE to avoid a feed back
> loop causing delays. The task balancing dirty pages in
> btrfs_finish_ordered_io doesn't have the flag and causes slow-downs. In
> my case it managed to cause a feedback loop where it queues other
> btrfs_finish_ordered_io and gets stuck completely.
> 

The data writepage endio will queue a work for
btrfs_finish_ordered_io() in a separate workqueue and clear page's
writeback, so throttling in btrfs_finish_ordered_io() should not slow
down flusher thread. One suspicious point is while the caller is
waiting a range of ordered_extents to complete, they will be
blocked until balance_dirty_pages_ratelimited() make some
progress, since we finish ordered_extents in
btrfs_finish_ordered_io().
Do you have call stack information for stuck processes or using
fsync/sync frequently? If this is the case, maybe we should pull
this thing out and try balance dirty metadata pages somewhere.

> Regards,
> Martin Raiber


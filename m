Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A9EC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 14:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 839DB2133F
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 14:00:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=urbackup.org header.i=@urbackup.org header.b="bKOi71rq";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="ZhhwasoW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732217AbeLQOAs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 09:00:48 -0500
Received: from a4-6.smtp-out.eu-west-1.amazonses.com ([54.240.4.6]:42380 "EHLO
        a4-6.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727319AbeLQOAs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 09:00:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=vbsgq4olmwpaxkmtpgfbbmccllr2wq3g; d=urbackup.org; t=1545055244;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=t+0EgRvC4/3I2d1Eo371nSSdzhTagNgzf+iw8HRH7Ds=;
        b=bKOi71rqqXgIlEnUAnV7BnAGXxbNwPP5OCWafli71j01iYaxD7yNwg7sb0c5tHFD
        Vf7T5HeVf3txLemhLOwYgMp9SJ2TotodHXnjs7uhPxt0oT4IRJMoNJmdKkteh5nPwoy
        hWZ60PVIlf/3kshd7IVIa5iGXSUPv4fJ7j6INrVk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=uku4taia5b5tsbglxyj6zym32efj7xqv; d=amazonses.com; t=1545055244;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=t+0EgRvC4/3I2d1Eo371nSSdzhTagNgzf+iw8HRH7Ds=;
        b=ZhhwasoWKIsqXARvR8ulqoUDoClGM2mro0IUKhhEF//xoey4bUbnMuk/mH3FCwI9
        jnNunfOoqVsPpxK1mY9zwnQ4mr8V7s5kul7Yo8qBXbVaUK9XJmV8KF+Q2SQDxhbZhB4
        QDRUtjV2BBBmPykC9K3RZyYF7IN/RCil7E7ny7hI=
Subject: Re: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
To:     ethanlien <ethanlien@synology.com>
Cc:     Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>,
        linux-btrfs-owner@vger.kernel.org
References: <20180528054821.9092-1-ethanlien@synology.com>
 <D7645E04-6424-4BFA-90C6-D63245EB9435@fb.com>
 <01020167a30347da-385e2eff-ed13-422a-b27f-c3d5933aaef2-000000@eu-west-1.amazonses.com>
 <d324045eb532b2fa525203c20c57bed1@synology.com>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <01020167bc7811f0-cb1970f5-3d51-49f9-a5bb-63ba1ea35eea-000000@eu-west-1.amazonses.com>
Date:   Mon, 17 Dec 2018 14:00:44 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <d324045eb532b2fa525203c20c57bed1@synology.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SES-Outgoing: 2018.12.17-54.240.4.6
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 14.12.2018 09:07 ethanlien wrote:
> Martin Raiber 於 2018-12-12 23:22 寫到:
>> On 12.12.2018 15:47 Chris Mason wrote:
>>> On 28 May 2018, at 1:48, Ethan Lien wrote:
>>>
>>> It took me a while to trigger, but this actually deadlocks ;)  More
>>> below.
>>>
>>>> [Problem description and how we fix it]
>>>> We should balance dirty metadata pages at the end of
>>>> btrfs_finish_ordered_io, since a small, unmergeable random write can
>>>> potentially produce dirty metadata which is multiple times larger than
>>>> the data itself. For example, a small, unmergeable 4KiB write may
>>>> produce:
>>>>
>>>>     16KiB dirty leaf (and possibly 16KiB dirty node) in subvolume tree
>>>>     16KiB dirty leaf (and possibly 16KiB dirty node) in checksum tree
>>>>     16KiB dirty leaf (and possibly 16KiB dirty node) in extent tree
>>>>
>>>> Although we do call balance dirty pages in write side, but in the
>>>> buffered write path, most metadata are dirtied only after we reach the
>>>> dirty background limit (which by far only counts dirty data pages) and
>>>> wakeup the flusher thread. If there are many small, unmergeable random
>>>> writes spread in a large btree, we'll find a burst of dirty pages
>>>> exceeds the dirty_bytes limit after we wakeup the flusher thread -
>>>> which
>>>> is not what we expect. In our machine, it caused out-of-memory problem
>>>> since a page cannot be dropped if it is marked dirty.
>>>>
>>>> Someone may worry about we may sleep in
>>>> btrfs_btree_balance_dirty_nodelay,
>>>> but since we do btrfs_finish_ordered_io in a separate worker, it will
>>>> not
>>>> stop the flusher consuming dirty pages. Also, we use different worker
>>>> for
>>>> metadata writeback endio, sleep in btrfs_finish_ordered_io help us
>>>> throttle
>>>> the size of dirty metadata pages.
>>> In general, slowing down btrfs_finish_ordered_io isn't ideal because it
>>> adds latency to places we need to finish quickly.  Also,
>>> btrfs_finish_ordered_io is used by the free space cache.  Even though
>>> this happens from its own workqueue, it means completing free space
>>> cache writeback may end up waiting on balance_dirty_pages, something
>>> like this stack trace:
>>>
>>> [..]
>>>
>>> Eventually, we have every process in the system waiting on
>>> balance_dirty_pages(), and nobody is able to make progress on
>>> paclear page's writebackge
>>> writeback.
>>>
>> I had lockups with this patch as well. If you put e.g. a loop device on
>> top of a btrfs file, loop sets PF_LESS_THROTTLE to avoid a feed back
>> loop causing delays. The task balancing dirty pages in
>> btrfs_finish_ordered_io doesn't have the flag and causes slow-downs. In
>> my case it managed to cause a feedback loop where it queues other
>> btrfs_finish_ordered_io and gets stuck completely.
>>
>
> The data writepage endio will queue a work for
> btrfs_finish_ordered_io() in a separate workqueue and clear page's
> writeback, so throttling in btrfs_finish_ordered_io() should not slow
> down flusher thread. One suspicious point is while the caller is
> waiting a range of ordered_extents to complete, they will be
> blocked until balance_dirty_pages_ratelimited() make some
> progress, since we finish ordered_extents in
> btrfs_finish_ordered_io().
> Do you have call stack information for stuck processes or using
> fsync/sync frequently? If this is the case, maybe we should pull
> this thing out and try balance dirty metadata pages somewhere.

Yeah like,

[875317.071433] Call Trace:
[875317.071438]  ? __schedule+0x306/0x7f0
[875317.071442]  schedule+0x32/0x80
[875317.071447]  btrfs_start_ordered_extent+0xed/0x120
[875317.071450]  ? remove_wait_queue+0x60/0x60
[875317.071454]  btrfs_wait_ordered_range+0xa0/0x100
[875317.071457]  btrfs_sync_file+0x1d6/0x400
[875317.071461]  ? do_fsync+0x38/0x60
[875317.071463]  ? btrfs_fdatawrite_range+0x50/0x50
[875317.071465]  do_fsync+0x38/0x60
[875317.071468]  __x64_sys_fsync+0x10/0x20
[875317.071470]  do_syscall_64+0x55/0x100
[875317.071473]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

so I guess the problem is that the calling balance_dirty_pages causes
fsyncs to the same btrfs (via my unusual setup of loop+fuse)? Those
fsyncs are deadlocked because they are called indirectly from
btrfs_finish_ordered_io... It is a unusal setup, which is why I did not
post it to the mailing list initially.



Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9CEC67839
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 15:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E9BC2080F
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 15:22:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=urbackup.org header.i=@urbackup.org header.b="ZoWT7ZEX";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="ROpOdcvG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E9BC2080F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=urbackup.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbeLLPWn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 10:22:43 -0500
Received: from a4-3.smtp-out.eu-west-1.amazonses.com ([54.240.4.3]:43142 "EHLO
        a4-3.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726300AbeLLPWm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 10:22:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=vbsgq4olmwpaxkmtpgfbbmccllr2wq3g; d=urbackup.org; t=1544628160;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=h534ilDY3fMhUpZLFFhvCEnUWSB+WiL9jwMWE39WN9I=;
        b=ZoWT7ZEX/g3plmWoDPYNg7B3eMsxO8zdQyAoWQmp/RQ/18AeIZ/kntnNPU40JDVE
        oI1ufyHBp7mIyD/EuP0S7k4OyjYR8u90WmJfpmYUTW6bNo9LbEyZP37rwockq28I4rZ
        UQBKmr1P/zoaGjJvh5zXRYRIYSyn5xhTr15/pOzw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=uku4taia5b5tsbglxyj6zym32efj7xqv; d=amazonses.com; t=1544628160;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=h534ilDY3fMhUpZLFFhvCEnUWSB+WiL9jwMWE39WN9I=;
        b=ROpOdcvGgSzlQgh8qqimNJnh69qGtOVoaKPIcjqwnNdzb2VWvWPF/a1Qg8tayZ8+
        UONlKCFogxFe64cdhfLl5Vl/aTckxcOhBltSrzcOX8vynSpEQFCa48tKS5mXcqWvpzU
        w8wyAlAiGPe/4mu0kipwuspiurJnfdS5Er48jEVg=
Subject: Re: [PATCH v2] btrfs: balance dirty metadata pages in
 btrfs_finish_ordered_io
To:     Chris Mason <clm@fb.com>, Ethan Lien <ethanlien@synology.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <20180528054821.9092-1-ethanlien@synology.com>
 <D7645E04-6424-4BFA-90C6-D63245EB9435@fb.com>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <01020167a30347da-385e2eff-ed13-422a-b27f-c3d5933aaef2-000000@eu-west-1.amazonses.com>
Date:   Wed, 12 Dec 2018 15:22:40 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <D7645E04-6424-4BFA-90C6-D63245EB9435@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2018.12.12-54.240.4.3
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12.12.2018 15:47 Chris Mason wrote:
> On 28 May 2018, at 1:48, Ethan Lien wrote:
>
> It took me a while to trigger, but this actually deadlocks ;)  More 
> below.
>
>> [Problem description and how we fix it]
>> We should balance dirty metadata pages at the end of
>> btrfs_finish_ordered_io, since a small, unmergeable random write can
>> potentially produce dirty metadata which is multiple times larger than
>> the data itself. For example, a small, unmergeable 4KiB write may
>> produce:
>>
>>     16KiB dirty leaf (and possibly 16KiB dirty node) in subvolume tree
>>     16KiB dirty leaf (and possibly 16KiB dirty node) in checksum tree
>>     16KiB dirty leaf (and possibly 16KiB dirty node) in extent tree
>>
>> Although we do call balance dirty pages in write side, but in the
>> buffered write path, most metadata are dirtied only after we reach the
>> dirty background limit (which by far only counts dirty data pages) and
>> wakeup the flusher thread. If there are many small, unmergeable random
>> writes spread in a large btree, we'll find a burst of dirty pages
>> exceeds the dirty_bytes limit after we wakeup the flusher thread - 
>> which
>> is not what we expect. In our machine, it caused out-of-memory problem
>> since a page cannot be dropped if it is marked dirty.
>>
>> Someone may worry about we may sleep in 
>> btrfs_btree_balance_dirty_nodelay,
>> but since we do btrfs_finish_ordered_io in a separate worker, it will 
>> not
>> stop the flusher consuming dirty pages. Also, we use different worker 
>> for
>> metadata writeback endio, sleep in btrfs_finish_ordered_io help us 
>> throttle
>> the size of dirty metadata pages.
> In general, slowing down btrfs_finish_ordered_io isn't ideal because it 
> adds latency to places we need to finish quickly.  Also, 
> btrfs_finish_ordered_io is used by the free space cache.  Even though 
> this happens from its own workqueue, it means completing free space 
> cache writeback may end up waiting on balance_dirty_pages, something 
> like this stack trace:
>
> [..]
>
> Eventually, we have every process in the system waiting on 
> balance_dirty_pages(), and nobody is able to make progress on page 
> writeback.
>
I had lockups with this patch as well. If you put e.g. a loop device on
top of a btrfs file, loop sets PF_LESS_THROTTLE to avoid a feed back
loop causing delays. The task balancing dirty pages in
btrfs_finish_ordered_io doesn't have the flag and causes slow-downs. In
my case it managed to cause a feedback loop where it queues other
btrfs_finish_ordered_io and gets stuck completely.

Regards,
Martin Raiber


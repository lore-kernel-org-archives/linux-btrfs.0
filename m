Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFE5C32789
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 08:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90EFC2081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 08:43:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90EFC2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbeKBRtq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 13:49:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:37472 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726026AbeKBRtq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 13:49:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D0DFABE4;
        Fri,  2 Nov 2018 08:43:21 +0000 (UTC)
Subject: Re: [PATCH] btrfs: use tagged writepage to mitigate livelock of
 snapshot
To:     ethanlien <ethanlien@synology.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Cc:     linux-btrfs-owner@vger.kernel.org
References: <20181101064903.11638-1-ethanlien@synology.com>
 <20181101180206.GU9136@twin.jikos.cz>
 <d56ae2d1ac65a6e5f3cd1fd00b5f4784@synology.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <c0bc1228-fb20-089f-276f-83690bfa6928@suse.com>
Date:   Fri, 2 Nov 2018 10:43:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <d56ae2d1ac65a6e5f3cd1fd00b5f4784@synology.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2.11.18 г. 9:13 ч., ethanlien wrote:
> David Sterba 於 2018-11-02 02:02 寫到:
>> On Thu, Nov 01, 2018 at 02:49:03PM +0800, Ethan Lien wrote:
>>> Snapshot is expected to be fast. But if there are writers steadily
>>> create dirty pages in our subvolume, the snapshot may take a very long
>>> time to complete. To fix the problem, we use tagged writepage for
>>> snapshot
>>> flusher as we do in the generic write_cache_pages(), so we can ommit
>>> pages
>>> dirtied after the snapshot command.
>>>
>>> We do a simple snapshot speed test on a Intel D-1531 box:
>>>
>>> fio --ioengine=libaio --iodepth=32 --bs=4k --rw=write --size=64G
>>> --direct=0 --thread=1 --numjobs=1 --time_based --runtime=120
>>> --filename=/mnt/sub/testfile --name=job1 --group_reporting & sleep 5;
>>> time btrfs sub snap -r /mnt/sub /mnt/snap; killall fio
>>>
>>> original: 1m58sec
>>> patched:  6.54sec
>>>
>>> This is the best case for this patch since for a sequential write case,
>>> we omit nearly all pages dirtied after the snapshot command.
>>>
>>> For a multi writers, random write test:
>>>
>>> fio --ioengine=libaio --iodepth=32 --bs=4k --rw=randwrite --size=64G
>>> --direct=0 --thread=1 --numjobs=4 --time_based --runtime=120
>>> --filename=/mnt/sub/testfile --name=job1 --group_reporting & sleep 5;
>>> time btrfs sub snap -r /mnt/sub /mnt/snap; killall fio
>>>
>>> original: 15.83sec
>>> patched:  10.35sec
>>>
>>> The improvement is less compared with the sequential write case, since
>>> we omit only half of the pages dirtied after snapshot command.
>>>
>>> Signed-off-by: Ethan Lien <ethanlien@synology.com>
>>
>> This looks nice, thanks. I agree with the The suggestions from Nikolay,
>> please update and resend.
>>
>> I was bit curious about the 'livelock', what you describe does not seem
>> to be one. System under heavy IO can make the snapshot dead slow but can
>> recover from that once the IO stops.>
> I'm not sure if this is indeed the case of 'livelock'. I learn the term
> from commit:
> f446daaea9d4a420d, "mm: implement writeback livelock avoidance using
> page tagging".
> If this is not the case, I can use another term.

It's really bad to use terms you don't fully comprehend because that way
you can, inadvertently, mislead people who don't necessarily have the
same context as you do. A brief description of what livelock can be
found here:

https://stackoverflow.com/questions/6155951/whats-the-difference-between-deadlock-and-livelock

In the context of wb livelock could occur since you have 2 processes - 1
producer (dirtying pages) and the other one consumer (writeback). So a
livelock will be when both are doing useful work yet the system doesn't
make forward progress ( in this case there is a risk of the snapshot
never being created since we will never finish doing the writeback for
constantly dirtied pages).

David, indeed what Ethan fixes and what Jan fixed in f446daaea9d4a420d
are the same class of issues. And livelock in this context really
depends on one's definition of how long a
no-forward-progress-but-useful-work-being-done situation persisting.

> 
>> Regarding the sync semantics, there's AFAIK no change to the current
>> state where the sync is done before snapshot but without further other
>> guarantees. From that point I think it's safe to select only subset of
>> pages and make things faster.
>>
>> As the requested changes are not functional I'll add the patch to
>> for-next for testing.
> 
> 

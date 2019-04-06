Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6C4C282DA
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 09:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D6D9218D4
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 09:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfDFJbY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 05:31:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:40820 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbfDFJbY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 05:31:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BF523AF95;
        Sat,  6 Apr 2019 09:31:21 +0000 (UTC)
Subject: Re: [PATCH 1/2] block: Add new BLK_STS_SELFTEST status
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20190406031426.22436-1-wqu@suse.com>
 <8b35c2d5-6707-0898-b978-ab09b748f2cb@suse.com>
 <d959f6d7-ee8b-1441-1484-7d6ba276c122@gmx.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <184fe5a1-7007-e8d9-7605-7394e7865f31@suse.com>
Date:   Sat, 6 Apr 2019 12:31:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d959f6d7-ee8b-1441-1484-7d6ba276c122@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 6.04.19 г. 12:18 ч., Qu Wenruo wrote:
> 
> 
> On 2019/4/6 下午4:41, Nikolay Borisov wrote:
>>
>>
>> On 6.04.19 г. 6:14 ч., Qu Wenruo wrote:
>>> There are a lot of end_io hooks which can do some self test at
>>> read/write time.
>>>
>>> Normally such selftest should return -EUCLEAN to indicate something
>>> unexpected.
>>>
>>> However there is no BLK_STS_* bit for that, this makes every selftest
>>> error to be interpreted to EIO, which lowers the severity.
>>>
>>> This patch will add a new BLK_STS_SELFTEST, to allow the error from
>>> endio to be passed to filesystem.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  block/blk-core.c          | 1 +
>>>  include/linux/blk_types.h | 3 +++
>>>  2 files changed, 4 insertions(+)
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 4673ebe42255..66967642a5ef 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -135,6 +135,7 @@ static const struct {
>>>  	[BLK_STS_RESOURCE]	= { -ENOMEM,	"kernel resource" },
>>>  	[BLK_STS_DEV_RESOURCE]	= { -EBUSY,	"device resource" },
>>>  	[BLK_STS_AGAIN]		= { -EAGAIN,	"nonblocking retry" },
>>> +	[BLK_STS_SELFTEST]	= { -EUCLEAN,	"filesystem selftest" },
>>
>> SELFTEST is ambiguous, I personally relate it to the selftests that some
>> subsystems have. This should be changed to STS_CLEANUP or STS_CORRUPT or
>> some such.
> 
> Considering my poor naming schemes, what about sticking to EUCLEAN
> across all of these?
> BLK_STS_UCLEAN	-ECULEAN "Structure needs clean up"

Sounds good!
> 
> Thanks,
> Qu
> 
>>
>>>
>>>  	/* device mapper special case, should not leak out: */
>>>  	[BLK_STS_DM_REQUEUE]	= { -EREMCHG, "dm internal retry" },
>>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>>> index 791fee35df88..5bba24c3753c 100644
>>> --- a/include/linux/blk_types.h
>>> +++ b/include/linux/blk_types.h
>>> @@ -63,6 +63,9 @@ typedef u8 __bitwise blk_status_t;
>>>   */
>>>  #define BLK_STS_DEV_RESOURCE	((__force blk_status_t)13)
>>>
>>> +/* Filesystem selftest error */
>>> +#define BLK_STS_SELFTEST	((__force blk_status_t)14)
>>> +
>>>  /**
>>>   * blk_path_error - returns true if error may be path related
>>>   * @error: status the request was completed with
>>>
> 

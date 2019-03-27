Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A34C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 08:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92CC32075E
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 08:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbfC0ICF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 04:02:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:39330 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725772AbfC0ICF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 04:02:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 11FC8ACE8
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 08:02:03 +0000 (UTC)
Subject: Re: [PATCH URGENT 1/2] btrfs-progs: disk-io: Make super block write
 error more easy to read
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190327072500.11156-1-wqu@suse.com>
 <20190327072500.11156-2-wqu@suse.com>
 <48887087-8018-07e4-6c49-63757676f2a0@suse.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <35f7eb3a-3ca6-9c10-b00d-c380b1d39318@suse.de>
Date:   Wed, 27 Mar 2019 16:01:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <48887087-8018-07e4-6c49-63757676f2a0@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/27 下午4:00, Nikolay Borisov wrote:
> 
> 
> On 27.03.19 г. 9:24 ч., Qu Wenruo wrote:
>> When we failed to write super blocks, we just output something like:
>>   WARNING: failed to write sb: I/O error
>> Or
>>   WARNING: failed to write all sb data
>>
>> There is no info about which device failed and there are two different
>> error message for the same write error.
>>
>> This patch will change it to something more detailed:
>> ERROR: failed to write super block: I/O error
>> ERROR: failed to write super block for devid 1
> 
> But now we print 2 messages for 1 error. I'd rather have the information
> conveyed on a single line. I.e call fprintf directly from both callsites
> that do goto write_err with respective format and rename write_err label
> to out.

Makes sense.

I'll go that way.

Thanks,
Qu

> 
>>
>> This provides the basis for later super block flush error handling.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  disk-io.c | 17 +++++++++++------
>>  1 file changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/disk-io.c b/disk-io.c
>> index 797b9b79ea3c..238b1821be14 100644
>> --- a/disk-io.c
>> +++ b/disk-io.c
>> @@ -1599,8 +1599,12 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
>>  		ret = pwrite64(device->fd, fs_info->super_copy,
>>  				BTRFS_SUPER_INFO_SIZE,
>>  				fs_info->super_bytenr);
>> -		if (ret != BTRFS_SUPER_INFO_SIZE)
>> +		if (ret != BTRFS_SUPER_INFO_SIZE) {
>> +			errno = EIO;
>> +			ret = -errno;
>> +			error("failed to write super block: %m");
>>  			goto write_err;
>> +		}
>>  		return 0;
>>  	}
>>  
>> @@ -1622,17 +1626,18 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
>>  		 */
>>  		ret = pwrite64(device->fd, fs_info->super_copy,
>>  				BTRFS_SUPER_INFO_SIZE, bytenr);
>> -		if (ret != BTRFS_SUPER_INFO_SIZE)
>> +		if (ret != BTRFS_SUPER_INFO_SIZE) {
>> +			errno = EIO;
>> +			ret = -errno;
>> +			error("failed to write super block %i: %m", i);
>>  			goto write_err;
>> +		}
>>  	}
>>  
>>  	return 0;
>>  
>>  write_err:
>> -	if (ret > 0)
>> -		fprintf(stderr, "WARNING: failed to write all sb data\n");
>> -	else
>> -		fprintf(stderr, "WARNING: failed to write sb: %m\n");
>> +	error("failed to write super block for devid %llu", device->devid);
>>  	return ret;
>>  }
>>  
>>

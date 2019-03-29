Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67C9C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 12:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84B48217F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 12:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbfC2MIo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 08:08:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:44630 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729384AbfC2MIo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 08:08:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3032AACE8
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 12:08:41 +0000 (UTC)
Subject: Re: [PATCH 7/7] btrfs: tests/fsck: Add test image for free space
 cache mode repair
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190325082253.19583-1-wqu@suse.com>
 <20190325082253.19583-8-wqu@suse.com>
 <1e65e3ab-dc48-db4b-3035-85ba2786d909@suse.com>
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
Message-ID: <d85f7db7-de29-6c77-e748-fef3dc31cbe5@suse.de>
Date:   Fri, 29 Mar 2019 20:08:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <1e65e3ab-dc48-db4b-3035-85ba2786d909@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/29 下午8:05, Nikolay Borisov wrote:
> 
> 
> On 25.03.19 г. 10:22 ч., Qu Wenruo wrote:
>> The image has one free space cache inode with invalid mode (0).
>>         item 9 key (256 INODE_ITEM 0) itemoff 13702 itemsize 160
>>                 generation 30 transid 30 size 65536 nbytes 1507328
>>                 block group 0 mode 0 links 1 uid 0 gid 0 rdev 0
>>                 sequence 23 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
>>                 atime 0.0 (1970-01-01 08:00:00)
>>                 ctime 1553491158.189771625 (2019-03-25 13:19:18)
>>                 mtime 0.0 (1970-01-01 08:00:00)
>>                 otime 0.0 (1970-01-01 08:00:00)
>>
>> Both lowmem and original mode should be able to detect and fix it.
>>
>> The extracted test image is pretty big (1G extracted), as kernel won't
>> cache small chunks.
>> Even with SSD, such test may still take some seconds just extracting the
>> image.
> 
> 
> Should this image contain also a non-freespace but root inode (for the
> root dir case) so it has full coverage of the code you introduced?

OK, another image will be added for ROOT_TREE_DIR.

Thanks,
Qu

> 
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  .../test.raw.xz                                | Bin 0 -> 159128 bytes
>>  1 file changed, 0 insertions(+), 0 deletions(-)
>>  create mode 100644 tests/fsck-tests/038-bad-free-space-cache-inode-mode/test.raw.xz
>>
>> diff --git a/tests/fsck-tests/038-bad-free-space-cache-inode-mode/test.raw.xz b/tests/fsck-tests/038-bad-free-space-cache-inode-mode/test.raw.xz
>> new file mode 100644
>> index 0000000000000000000000000000000000000000..c2603c024098992bece235d27187eefa696b3fe0
>> GIT binary patch
>> literal 159128
>> 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
>>
>> literal 0
>> HcmV?d00001
>>

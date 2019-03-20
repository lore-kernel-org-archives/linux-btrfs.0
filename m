Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A7FC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 11:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D6572184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 11:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfCTLx0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 07:53:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:32930 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726448AbfCTLx0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 07:53:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0CD39AC6C;
        Wed, 20 Mar 2019 11:53:24 +0000 (UTC)
Subject: Re: [PATCh v2 5/9] btrfs: tree-checker: Verify dev item
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-6-wqu@suse.com>
 <1472c094-bc6a-dc6f-2cf8-220ad5d34e40@suse.de>
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
Message-ID: <b6c74880-ddca-8772-41f2-a3b1587e8374@suse.de>
Date:   Wed, 20 Mar 2019 19:53:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <1472c094-bc6a-dc6f-2cf8-220ad5d34e40@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/20 下午7:51, Johannes Thumshirn wrote:
> On 20/03/2019 07:37, Qu Wenruo wrote:
> [...]
> 
>> +static int check_dev_item(struct btrfs_fs_info *fs_info,
>> +			  struct extent_buffer *leaf,
>> +			  struct btrfs_key *key, int slot)
>> +{
>> +	struct btrfs_dev_item *ditem;
>> +	u64 max_devid = max(BTRFS_MAX_DEVS(fs_info), BTRFS_MAX_DEVS_SYS_CHUNK);
>> +
>> +	if (key->objectid != BTRFS_DEV_ITEMS_OBJECTID) {
>> +		dev_item_err(fs_info, leaf, slot,
>> +			     "invalid objectid: has=%llu expect=%llu",
>> +			     key->objectid, BTRFS_DEV_ITEMS_OBJECTID);
>> +		goto error;
>> +	}
>> +	if (key->offset > max_devid) {
>> +		dev_item_err(fs_info, leaf, slot,
>> +			     "invalid devid: has=%llu expect=[0, %llu]",
>> +			     key->offset, max_devid);
>> +		goto error;
>> +	}
>> +	ditem = btrfs_item_ptr(leaf, slot, struct btrfs_dev_item);
>> +	if (btrfs_device_id(leaf, ditem) != key->offset) {
>> +		dev_item_err(fs_info, leaf, slot,
>> +			     "devid mismatch: key has=%llu item has=%llu",
>> +			     key->offset, btrfs_device_id(leaf, ditem));
>> +		goto error;
>> +	}
>> +
>> +	/*
>> +	 * Since btrfs device add doesn't check device size at all, we could
>> +	 * have device item whose size is smaller than 1M which is useless, but
>> +	 * still valid.
>> +	 * So here we can only check the obviously wrong case.
>> +	 */
>> +	if (btrfs_device_total_bytes(leaf, ditem) == 0) {
>> +		dev_item_err(fs_info, leaf, slot,
>> +			     "invalid total bytes: have 0");
>> +		goto error;
>> +	}
>> +	if (btrfs_device_bytes_used(leaf, ditem) >
>> +	    btrfs_device_total_bytes(leaf, ditem)) {
>> +		dev_item_err(fs_info, leaf, slot,
>> +			     "invalid bytes used: have %llu expect [0, %llu]",
>> +			     btrfs_device_bytes_used(leaf, ditem),
>> +			     btrfs_device_total_bytes(leaf, ditem));
>> +		goto error;
>> +	}
>> +	/*
>> +	 * Remaining members like io_align/type/gen/dev_group aren't really
>> +	 * utilized.
>> +	 * Skip them to make later usage of them easier.
>> +	 */
>> +	return 0;
>> +error:
>> +	return -EUCLEAN;
>> +}
>> +
> 
> Why aren't you directly returning -EUCLEAN instead of the gotos? There's
> no cleanup pending so the additional jump label is unnecessary.

Just a coding preference.

Will it impact the performance or compiler is clever enough to change
the goto line to return -EUCLEAN?

Thanks,
Qu

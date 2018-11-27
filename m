Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D6EC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21FA9208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21FA9208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbeK0T4E (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 14:56:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:41790 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729563AbeK0T4E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 14:56:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A3F7ACD3;
        Tue, 27 Nov 2018 08:58:50 +0000 (UTC)
Subject: Re: [PATCH v2 1/5] btrfs-progs: image: Refactor fixup_devices() to
 fixup_chunks_and_devices()
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181127083828.23861-1-wqu@suse.com>
 <20181127083828.23861-2-wqu@suse.com>
 <e40b8c45-2c16-35c0-c583-ca33c1500b97@suse.com>
 <c9f75bee-67f8-79a8-d66c-cffc9c828264@gmx.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 xsFNBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABzSJOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuZGU+wsF4BBMBAgAiBQJYijkSAhsDBgsJCAcDAgYVCAIJ
 CgsEFgIDAQIeAQIXgAAKCRBxvoJG5T8oV/B6D/9a8EcRPdHg8uLEPywuJR8URwXzkofT5bZE
 IfGF0Z+Lt2ADe+nLOXrwKsamhweUFAvwEUxxnndovRLPOpWerTOAl47lxad08080jXnGfYFS
 Dc+ew7C3SFI4tFFHln8Y22Q9075saZ2yQS1ywJy+TFPADIprAZXnPbbbNbGtJLoq0LTiESnD
 w/SUC6sfikYwGRS94Dc9qO4nWyEvBK3Ql8NkoY0Sjky3B0vL572Gq0ytILDDGYuZVo4alUs8
 LeXS5ukoZIw1QYXVstDJQnYjFxYgoQ5uGVi4t7FsFM/6ykYDzbIPNOx49Rbh9W4uKsLVhTzG
 BDTzdvX4ARl9La2kCQIjjWRg+XGuBM5rxT/NaTS78PXjhqWNYlGc5OhO0l8e5DIS2tXwYMDY
 LuHYNkkpMFksBslldvNttSNei7xr5VwjVqW4vASk2Aak5AleXZS+xIq2FADPS/XSgIaepyTV
 tkfnyreep1pk09cjfXY4A7qpEFwazCRZg9LLvYVc2M2eFQHDMtXsH59nOMstXx2OtNMcx5p8
 0a5FHXE/HoXz3p9bD0uIUq6p04VYOHsMasHqHPbsMAq9V2OCytJQPWwe46bBjYZCOwG0+x58
 fBFreP/NiJNeTQPOa6FoxLOLXMuVtpbcXIqKQDoEte9aMpoj9L24f60G4q+pL/54ql2VRscK
 d87BTQRYigc+ARAAyJSq9EFk28++SLfg791xOh28tLI6Yr8wwEOvM3wKeTfTZd+caVb9gBBy
 wxYhIopKlK1zq2YP7ZjTP1aPJGoWvcQZ8fVFdK/1nW+Z8/NTjaOx1mfrrtTGtFxVBdSCgqBB
 jHTnlDYV1R5plJqK+ggEP1a0mr/rpQ9dFGvgf/5jkVpRnH6BY0aYFPprRL8ZCcdv2DeeicOO
 YMobD5g7g/poQzHLLeT0+y1qiLIFefNABLN06Lf0GBZC5l8hCM3Rpb4ObyQ4B9PmL/KTn2FV
 Xq/c0scGMdXD2QeWLePC+yLMhf1fZby1vVJ59pXGq+o7XXfYA7xX0JsTUNxVPx/MgK8aLjYW
 hX+TRA4bCr4uYt/S3ThDRywSX6Hr1lyp4FJBwgyb8iv42it8KvoeOsHqVbuCIGRCXqGGiaeX
 Wa0M/oxN1vJjMSIEVzBAPi16tztL/wQtFHJtZAdCnuzFAz8ue6GzvsyBj97pzkBVacwp3/Mw
 qbiu7sDz7yB0d7J2tFBJYNpVt/Lce6nQhrvon0VqiWeMHxgtQ4k92Eja9u80JDaKnHDdjdwq
 FUikZirB28UiLPQV6PvCckgIiukmz/5ctAfKpyYRGfez+JbAGl6iCvHYt/wAZ7Oqe/3Cirs5
 KhaXBcMmJR1qo8QH8eYZ+qhFE3bSPH446+5oEw8A9v5oonKV7zMAEQEAAcLBXwQYAQIACQUC
 WIoHPgIbDAAKCRBxvoJG5T8oV1pyD/4zdXdOL0lhkSIjJWGqz7Idvo0wjVHSSQCbOwZDWNTN
 JBTP0BUxHpPu/Z8gRNNP9/k6i63T4eL1xjy4umTwJaej1X15H8Hsh+zakADyWHadbjcUXCkg
 OJK4NsfqhMuaIYIHbToi9K5pAKnV953xTrK6oYVyd/Rmkmb+wgsbYQJ0Ur1Ficwhp6qU1CaJ
 mJwFjaWaVgUERoxcejL4ruds66LM9Z1Qqgoer62ZneID6ovmzpCWbi2sfbz98+kW46aA/w8r
 7sulgs1KXWhBSv5aWqKU8C4twKjlV2XsztUUsyrjHFj91j31pnHRklBgXHTD/pSRsN0UvM26
 lPs0g3ryVlG5wiZ9+JbI3sKMfbdfdOeLxtL25ujs443rw1s/PVghphoeadVAKMPINeRCgoJH
 zZV/2Z/myWPRWWl/79amy/9MfxffZqO9rfugRBORY0ywPHLDdo9Kmzoxoxp9w3uTrTLZaT9M
 KIuxEcV8wcVjr+Wr9zRl06waOCkgrQbTPp631hToxo+4rA1jiQF2M80HAet65ytBVR2pFGZF
 zGYYLqiG+mpUZ+FPjxk9kpkRYz61mTLSY7tuFljExfJWMGfgSg1OxfLV631jV1TcdUnx+h3l
 Sqs2vMhAVt14zT8mpIuu2VNxcontxgVr1kzYA/tQg32fVRbGr449j1gw57BV9i0vww==
Message-ID: <5f60cc52-ce0b-a7ed-5294-ab3ba05970ae@suse.com>
Date:   Tue, 27 Nov 2018 10:58:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <c9f75bee-67f8-79a8-d66c-cffc9c828264@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 27.11.18 г. 10:50 ч., Qu Wenruo wrote:
> 
> 
> On 2018/11/27 下午4:46, Nikolay Borisov wrote:
>>
>>
>> On 27.11.18 г. 10:38 ч., Qu Wenruo wrote:
>>> Current fixup_devices() will only remove DEV_ITEMs and reset DEV_ITEM
>>> size.
>>> Later we need to do more fixup works, so change the name to
>>> fixup_chunks_and_devices() and refactor the original device size fixup
>>> to fixup_device_size().
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>>
>> However, one minor nit below.
>>
>>> ---
>>>  image/main.c | 52 ++++++++++++++++++++++++++++++++++++----------------
>>>  1 file changed, 36 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/image/main.c b/image/main.c
>>> index c680ab19de6c..bbfcf8f19298 100644
>>> --- a/image/main.c
>>> +++ b/image/main.c
>>> @@ -2084,28 +2084,19 @@ static void remap_overlapping_chunks(struct mdrestore_struct *mdres)
>>>  	}
>>>  }
>>>  
>>> -static int fixup_devices(struct btrfs_fs_info *fs_info,
>>> -			 struct mdrestore_struct *mdres, off_t dev_size)
>>> +static int fixup_device_size(struct btrfs_trans_handle *trans,
>>> +			     struct mdrestore_struct *mdres,
>>> +			     off_t dev_size)
>>>  {
>>> -	struct btrfs_trans_handle *trans;
>>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>>>  	struct btrfs_dev_item *dev_item;
>>>  	struct btrfs_path path;
>>> -	struct extent_buffer *leaf;
>>>  	struct btrfs_root *root = fs_info->chunk_root;
>>>  	struct btrfs_key key;
>>> +	struct extent_buffer *leaf;
>>
>> nit: Unnecessary change
> 
> Doesn't it look better when all btrfs_ prefix get batched together? :)

Didn't even realize this was the intended effect. IMO doesn't make much
difference, what does, though, is probably reverse christmas tree, ie

longer variable names
come before shorter
ones

But I guess this is a matter of taste, no need to resend.

> 
> Thanks,
> Qu
> 
>>
>>>  	u64 devid, cur_devid;
>>>  	int ret;
>>>  
>>> -	if (btrfs_super_log_root(fs_info->super_copy)) {
>>> -		warning(
>>> -		"log tree detected, its generation will not match superblock");
>>> -	}
>>> -	trans = btrfs_start_transaction(fs_info->tree_root, 1);
>>> -	if (IS_ERR(trans)) {
>>> -		error("cannot starting transaction %ld", PTR_ERR(trans));
>>> -		return PTR_ERR(trans);
>>> -	}
>>> -
>>>  	dev_item = &fs_info->super_copy->dev_item;
>>>  
>>>  	devid = btrfs_stack_device_id(dev_item);
>>> @@ -2123,7 +2114,7 @@ again:
>>>  	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
>>>  	if (ret < 0) {
>>>  		error("search failed: %d", ret);
>>> -		exit(1);
>>> +		return ret;
>>>  	}
>>>  
>>>  	while (1) {
>>> @@ -2170,12 +2161,41 @@ again:
>>>  	}
>>>  
>>>  	btrfs_release_path(&path);
>>> +	return 0;
>>> +}
>>> +
>>> +static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
>>> +			 struct mdrestore_struct *mdres, off_t dev_size)
>>> +{
>>> +	struct btrfs_trans_handle *trans;
>>> +	int ret;
>>> +
>>> +	if (btrfs_super_log_root(fs_info->super_copy)) {
>>> +		warning(
>>> +		"log tree detected, its generation will not match superblock");
>>> +	}
>>> +	trans = btrfs_start_transaction(fs_info->tree_root, 1);
>>> +	if (IS_ERR(trans)) {
>>> +		error("cannot starting transaction %ld", PTR_ERR(trans));
>>> +		return PTR_ERR(trans);
>>> +	}
>>> +
>>> +	ret = fixup_device_size(trans, mdres, dev_size);
>>> +	if (ret < 0)
>>> +		goto error;
>>> +
>>>  	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
>>>  	if (ret) {
>>>  		error("unable to commit transaction: %d", ret);
>>>  		return ret;
>>>  	}
>>>  	return 0;
>>> +error:
>>> +	error(
>>> +"failed to fix chunks and devices mapping, the fs may not be mountable: %s",
>>> +		strerror(-ret));
>>> +	btrfs_abort_transaction(trans, ret);
>>> +	return ret;
>>>  }
>>>  
>>>  static int restore_metadump(const char *input, FILE *out, int old_restore,
>>> @@ -2282,7 +2302,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
>>>  			return 1;
>>>  		}
>>>  
>>> -		ret = fixup_devices(info, &mdrestore, st.st_size);
>>> +		ret = fixup_chunks_and_devices(info, &mdrestore, st.st_size);
>>>  		close_ctree(info->chunk_root);
>>>  		if (ret)
>>>  			goto out;
>>>
> 

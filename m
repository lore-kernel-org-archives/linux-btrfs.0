Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC92ECDE44
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 09:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED90A20685
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 09:43:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED90A20685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbeJaSku (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 14:40:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:42834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727436AbeJaSku (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 14:40:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C5BDDAF3C;
        Wed, 31 Oct 2018 09:43:26 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs-progs: check: lowmem: Factor out inline extent
 checking code in its own function
To:     "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <20180913120507.18197-1-nborisov@suse.com>
 <20180913120507.18197-2-nborisov@suse.com>
 <09347419-aba9-7fdb-e756-109ed8d3eaee@fujitsu.com>
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
Message-ID: <7bc87724-9d43-e487-140b-fc184cd83873@suse.com>
Date:   Wed, 31 Oct 2018 11:43:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <09347419-aba9-7fdb-e756-109ed8d3eaee@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 31.10.18 г. 11:35 ч., misono.tomohiro@fujitsu.com wrote:
> Hello,
> 
> fsck-test 006 fails for low-mem mode in current devel branch and bisect points this.
> 
>> Since the inline extent code can be largely self-sufficient, factor
>> it out from check_file_extent. No functional changes.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  check/mode-lowmem.c | 142 ++++++++++++++++++++++++++------------------
>>  1 file changed, 83 insertions(+), 59 deletions(-)
>>
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index 1bce44f5658a..48c1537e7440 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -1800,6 +1800,87 @@ static int repair_inline_ram_bytes(struct btrfs_root *root,
>>  	return ret;
>>  }
>>  
>> +
>> +static int check_file_extent_inline(struct btrfs_root *root,
>> +				    struct btrfs_path *path, u64 *size,
>> +				    u64 *end)
>> +{
>> +	u32 max_inline_extent_size = min_t(u32, root->fs_info->sectorsize - 1,
>> +				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
>> +	struct extent_buffer *node = path->nodes[0];
>> +	struct btrfs_item *e = btrfs_item_nr(0);
>                                btrfs_item_nr(path->slots[0])
> 
> I think this fixes the problem.

Indeed, the original code uses path->slots[0] as the slot whereas I've
fixed that at slow 0, which of course is not always going to be the case.

David will you fold this in the original patch ?

> Thanks.
> 
> Misono
> 
>> +	struct btrfs_file_extent_item *fi;
>> +	struct btrfs_key fkey;
>> +	u64 extent_num_bytes;
>> +	u32 item_inline_len;
>> +	int ret;
>> +	int compressed = 0;
>> +	int err = 0;
>> +
>> +	fi = btrfs_item_ptr(node, path->slots[0],
>> +			    struct btrfs_file_extent_item);
>> +	item_inline_len = btrfs_file_extent_inline_item_len(node, e);
>> +	extent_num_bytes = btrfs_file_extent_ram_bytes(node, fi);
>> +	compressed = btrfs_file_extent_compression(node, fi);
>> +	btrfs_item_key_to_cpu(node, &fkey, path->slots[0]);
>> +
>> +	if (extent_num_bytes == 0) {
>> +		error(
>> +"root %llu EXTENT_DATA[%llu %llu] has empty inline extent",
>> +				root->objectid, fkey.objectid, fkey.offset);
>> +		err |= FILE_EXTENT_ERROR;
>> +	}
>> +
>> +	if (compressed) {
>> +		if (extent_num_bytes > root->fs_info->sectorsize) {
>> +			error(
>> +"root %llu EXTENT_DATA[%llu %llu] too large inline extent ram size, have %llu, max: %u",
>> +				root->objectid, fkey.objectid,
>> +				fkey.offset, extent_num_bytes,
>> +				root->fs_info->sectorsize - 1);
>> +				err |= FILE_EXTENT_ERROR;
>> +		}
>> +
>> +		if (item_inline_len > max_inline_extent_size) {
>> +			error(
>> +"root %llu EXTENT_DATA[%llu %llu] too large inline extent on-disk size, have %u, max: %u",
>> +				root->objectid, fkey.objectid,
>> +				fkey.offset, item_inline_len,
>> +				max_inline_extent_size);
>> +				err |= FILE_EXTENT_ERROR;
>> +		}
>> +
>> +	} else {
>> +
>> +		if (extent_num_bytes > max_inline_extent_size) {
>> +			error(
>> +"root %llu EXTENT_DATA[%llu %llu] too large inline extent size, have %llu, max: %u",
>> +				root->objectid, fkey.objectid, fkey.offset,
>> +				extent_num_bytes, max_inline_extent_size);
>> +				err |= FILE_EXTENT_ERROR;
>> +		}
>> +
>> +	}
>> +	if (!compressed && extent_num_bytes != item_inline_len) {
>> +		error(
>> +"root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expected: %u",
>> +				root->objectid, fkey.objectid, fkey.offset,
>> +				extent_num_bytes, item_inline_len);
>> +		if (repair) {
>> +			ret = repair_inline_ram_bytes(root, path,
>> +						      &extent_num_bytes);
>> +			if (ret)
>> +				err |= FILE_EXTENT_ERROR;
>> +		} else {
>> +			err |= FILE_EXTENT_ERROR;
>> +		}
>> +	}
>> +	*end += extent_num_bytes;
>> +	*size += extent_num_bytes;
>> +
>> +	return err;
>> +}
>> +
>>  /*
>>   * Check file extent datasum/hole, update the size of the file extents,
>>   * check and update the last offset of the file extent.
>> @@ -1824,8 +1905,6 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
>>  	u64 csum_found;		/* In byte size, sectorsize aligned */
>>  	u64 search_start;	/* Logical range start we search for csum */
>>  	u64 search_len;		/* Logical range len we search for csum */
>> -	u32 max_inline_extent_size = min_t(u32, root->fs_info->sectorsize - 1,
>> -				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
>>  	unsigned int extent_type;
>>  	unsigned int is_hole;
>>  	int slot = path->slots[0];
>> @@ -1838,63 +1917,8 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
>>  
>>  	/* Check inline extent */
>>  	extent_type = btrfs_file_extent_type(node, fi);
>> -	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
>> -		struct btrfs_item *e = btrfs_item_nr(slot);
>> -		u32 item_inline_len;
>> -
>> -		item_inline_len = btrfs_file_extent_inline_item_len(node, e);
>> -		extent_num_bytes = btrfs_file_extent_ram_bytes(node, fi);
>> -		compressed = btrfs_file_extent_compression(node, fi);
>> -		if (extent_num_bytes == 0) {
>> -			error(
>> -		"root %llu EXTENT_DATA[%llu %llu] has empty inline extent",
>> -				root->objectid, fkey.objectid, fkey.offset);
>> -			err |= FILE_EXTENT_ERROR;
>> -		}
>> -		if (compressed) {
>> -			if (extent_num_bytes > root->fs_info->sectorsize) {
>> -				error(
>> -"root %llu EXTENT_DATA[%llu %llu] too large inline extent ram size, have %llu, max: %u",
>> -					root->objectid, fkey.objectid,
>> -					fkey.offset, extent_num_bytes,
>> -					root->fs_info->sectorsize - 1);
>> -				err |= FILE_EXTENT_ERROR;
>> -			}
>> -			if (item_inline_len > max_inline_extent_size) {
>> -				error(
>> -"root %llu EXTENT_DATA[%llu %llu] too large inline extent on-disk size, have %u, max: %u",
>> -					root->objectid, fkey.objectid,
>> -					fkey.offset, item_inline_len,
>> -					max_inline_extent_size);
>> -				err |= FILE_EXTENT_ERROR;
>> -			}
>> -		} else {
>> -			if (extent_num_bytes > max_inline_extent_size) {
>> - 			error(
>> - "root %llu EXTENT_DATA[%llu %llu] too large inline extent size, have %llu, max: %u",
>> - 				root->objectid, fkey.objectid, fkey.offset,
>> - 				extent_num_bytes, max_inline_extent_size);
>> -				err |= FILE_EXTENT_ERROR;
>> -			}
>> -		}
>> -		if (!compressed && extent_num_bytes != item_inline_len) {
>> -			error(
>> -		"root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expected: %u",
>> -				root->objectid, fkey.objectid, fkey.offset,
>> -				extent_num_bytes, item_inline_len);
>> -			if (repair) {
>> -				ret = repair_inline_ram_bytes(root, path,
>> -							      &extent_num_bytes);
>> -				if (ret)
>> -					err |= FILE_EXTENT_ERROR;
>> -			} else {
>> -				err |= FILE_EXTENT_ERROR;
>> -			}
>> -		}
>> -		*end += extent_num_bytes;
>> -		*size += extent_num_bytes;
>> -		return err;
>> -	}
>> +	if (extent_type == BTRFS_FILE_EXTENT_INLINE)
>> +		return check_file_extent_inline(root, path, size, end);
>>  
>>  	/* Check extent type */
>>  	if (extent_type != BTRFS_FILE_EXTENT_REG &&

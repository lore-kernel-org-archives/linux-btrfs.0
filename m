Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2F8C32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 15:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8843F20862
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 15:14:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8843F20862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbeKGAkE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 19:40:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:51892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729574AbeKGAkE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 19:40:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42C84B0DE;
        Tue,  6 Nov 2018 15:14:21 +0000 (UTC)
Subject: Re: [PATCH] btrfs: Always try all copies when reading extent buffers
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc:     wqu@suse.com, josef@toxicpanda.com
References: <20181106144020.3446-1-nborisov@suse.com>
 <a9c486f8-f8ae-7463-205a-8ba60e011842@gmx.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <bb0c0091-5f00-55be-53b9-6e0376f0e67d@suse.com>
Date:   Tue, 6 Nov 2018 17:14:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <a9c486f8-f8ae-7463-205a-8ba60e011842@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 6.11.18 г. 16:53 ч., Qu Wenruo wrote:
> 
> 
> On 2018/11/6 下午10:40, Nikolay Borisov wrote:
>> When a metadata read is served the endio routine btree_readpage_end_io_hook
>> is called which eventually runs the tree-checker. If tree-checker fails
>> to validate the read eb then it sets EXTENT_BUFFER_CORRUPT flag. This
>> leads to btree_read_extent_buffer_pages wrongly assuming that all
>> available copies of this extent buffer are wrong and failing prematurely.
>> Fix this modify btree_read_extent_buffer_pages to read all copies of
>> the data.
>>
>> This failure was exhibitted in xfstests btrfs/124 which would
>> spuriously fail its balance operations. The reason was that when balance
>> was run following re-introduction of the missing raid1 disk
>> __btrfs_map_block would map the read request to stripe 0, which
>> corresponded to devid 2 (the disk which is being removed in the test):
>>
>>     item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 3553624064) itemoff 15975 itemsize 112
>> 	length 1073741824 owner 2 stripe_len 65536 type DATA|RAID1
>> 	io_align 65536 io_width 65536 sector_size 4096
>> 	num_stripes 2 sub_stripes 1
>> 		stripe 0 devid 2 offset 2156920832
>> 		dev_uuid 8466c350-ed0c-4c3b-b17d-6379b445d5c8
>> 		stripe 1 devid 1 offset 3553624064
>> 		dev_uuid 1265d8db-5596-477e-af03-df08eb38d2ca
>>
>> This caused read requests for a checksum item that to be routed to the
>> stale disk which triggered the aforementioned logic involving
>> EXTENT_BUFFER_CORRUPT flag. This then triggered cascading failures of
>> the balance operation.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> Suggested-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> However there is still a tiny piece missing.
> 
> Tree checker is done after some basic checks, including:
> 1) bytenr
> 2) level
> 3) fsid
> 4) csum
> 
> 1~2) can be easily skipped just by pure luck.
> 
> But 3) and especially 4) are not that easy to hit.
> Not to mention meeting both 3) and 4), since csum range covers fsid.
> 
> So I must say you're a really super lucky guy!

s/lucky/unlucky/ :)

I wonder if reads just land in some random memory on the stale disk
hence it's really a matter of what's "there" so that reads fail with
random reasons?

> 
> Thanks,
> Qu
> 
> 
>> Fixes: a826d6dcb32d ("Btrfs: check items for correctness as we search")
>> ---
>>  fs/btrfs/disk-io.c | 11 +----------
>>  1 file changed, 1 insertion(+), 10 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 00ee5e37e989..279c6dbcc736 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -477,9 +477,9 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
>>  	int mirror_num = 0;
>>  	int failed_mirror = 0;
>>  
>> -	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
>>  	io_tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
>>  	while (1) {
>> +		clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
>>  		ret = read_extent_buffer_pages(io_tree, eb, WAIT_COMPLETE,
>>  					       mirror_num);
>>  		if (!ret) {
>> @@ -493,15 +493,6 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
>>  				break;
>>  		}
>>  
>> -		/*
>> -		 * This buffer's crc is fine, but its contents are corrupted, so
>> -		 * there is no reason to read the other copies, they won't be
>> -		 * any less wrong.
>> -		 */
>> -		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags) ||
>> -		    ret == -EUCLEAN)
>> -			break;
>> -
>>  		num_copies = btrfs_num_copies(fs_info,
>>  					      eb->start, eb->len);
>>  		if (num_copies == 1)
>>
> 

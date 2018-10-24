Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ABC8C67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26819206B5
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26819206B5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbeJXMAt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 08:00:49 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:1940 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726301AbeJXMAs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 08:00:48 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46629411"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 24 Oct 2018 09:10:48 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id F39604B3305F;
        Wed, 24 Oct 2018 09:10:47 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 24 Oct 2018 09:10:54 +0800
Subject: Re: [PATCH 01/13] btrfs-progs: lowmem: add argument path to
 punch_extent_hole()
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-2-suy.fnst@cn.fujitsu.com>
 <79d1c476-4df2-e422-8aa4-74815a5a53e2@gmx.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <0f175df3-6a41-ca15-8ca8-3fb911e5fab4@cn.fujitsu.com>
Date:   Wed, 24 Oct 2018 09:18:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <79d1c476-4df2-e422-8aa4-74815a5a53e2@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: F39604B3305F.AAF76
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/23/18 6:04 PM, Qu Wenruo wrote:
> 
> 
> On 2018/10/23 下午5:41, Su Yue wrote:
>> Since repair will do CoW, the outer path may be invalid,
>> add an argument path to punch_extent_hole().
>> When punch_extent_hole() returns, path will still point to the item
>> before calling punch_extent_hole();
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> Overall it looks OK, however still some nitpicks with a new bug exposed
> inlined below.
> 
>> ---
>>   check/mode-lowmem.c | 21 ++++++++++++++++-----
>>   1 file changed, 16 insertions(+), 5 deletions(-)
>>
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index 1bce44f5658a..c8e4f13d816f 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -1710,15 +1710,20 @@ out:
>>   /*
>>    * Wrapper function of btrfs_punch_hole.
>>    *
>> + * @path:	will point to the item while calling the function.
>> + *
>>    * Returns 0 means success.
>>    * Returns not 0 means error.
>>    */
>> -static int punch_extent_hole(struct btrfs_root *root, u64 ino, u64 start,
>> -			     u64 len)
>> +static int punch_extent_hole(struct btrfs_root *root, struct btrfs_path *path,
>> +			     u64 ino, u64 start, u64 len)
>>   {
>>   	struct btrfs_trans_handle *trans;
>> -	int ret = 0;
>> +	struct btrfs_key key;
>> +	int ret;
>> +	int ret2;
> 
> I didn't see the need to introduce another ret.
> 
> @ret is used to record the error from btrfs_punch_hole(), which should
> only return <0 or 0.
> 
> We should only continue for ret == 0, so we can overwrite @ret.
> 
>>   
>> +	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>>   	trans = btrfs_start_transaction(root, 1);
>>   	if (IS_ERR(trans))
>>   		return PTR_ERR(trans);
>> @@ -1732,6 +1737,12 @@ static int punch_extent_hole(struct btrfs_root *root, u64 ino, u64 start,
>>   		       ino);
>>   
>>   	btrfs_commit_transaction(trans, root);
> 
> Here since the wrapper is a little old and at that time we don't have
> btrfs_abort_transaction() (well, not really have one even now).
> 
> The correct behavior is to abort trans and return error if we get error
> from btrfs_punch_hole().
> 
> And if we get no error from btrfs_punch_hole(), we can reuse @ret for
> btrfs_search_slot(), no need to introduce @ret2.
> 

Thanks to your clean explanation.

>> +
>> +	btrfs_release_path(path);
>> +	ret2 = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +	if (ret2 > 0)
>> +		ret2 = -ENOENT;
>> +	ret |= ret2;
>>   	return ret;
>>   }
>>   
>> @@ -1963,7 +1974,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
>>   	/* Check EXTENT_DATA hole */
>>   	if (!no_holes && *end != fkey.offset) {
>>   		if (repair)
>> -			ret = punch_extent_hole(root, fkey.objectid,
>> +			ret = punch_extent_hole(root, path, fkey.objectid,
>>   						*end, fkey.offset - *end);
>>   		if (!repair || ret) {
>>   			err |= FILE_EXTENT_ERROR;
>> @@ -2534,7 +2545,7 @@ out:
>>   
>>   		if (!nbytes && !no_holes && extent_end < isize) {
>>   			if (repair)
>> -				ret = punch_extent_hole(root, inode_id,
>> +				ret = punch_extent_hole(root, path, inode_id,
>>   						extent_end, isize - extent_end);
> 
> In this case, it's check_inode_item() and it's repair case for missing
> tailing hole.
> 
> However isize can be unaligned, but hole extent should always be aligned.
> So there is another bug that repair could create invalid hole extents.
> 

Oh.. Will fix those two.

Thanks,
Su

> Thanks,
> Qu
> 
>>   			if (!repair || ret) {
>>   				err |= NBYTES_ERROR;
>>
> 
> 



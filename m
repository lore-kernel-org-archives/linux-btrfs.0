Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92803C32789
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 01:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3223E2081B
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 01:13:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3223E2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbeKEKa7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 05:30:59 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:57719 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726133AbeKEKa7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 05:30:59 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47313107"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 05 Nov 2018 09:13:54 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D993E4B714DB;
        Mon,  5 Nov 2018 09:13:54 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 5 Nov 2018 09:13:57 +0800
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
To:     Nikolay Borisov <nborisov@suse.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
 <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
 <7146cafcc48d46ad123388d492807cbba08e101c.camel@scientia.net>
 <94750beb-c339-756a-11ec-f2bcc72b98e3@cn.fujitsu.com>
 <e2ac3e05ddd1297d4017cbeecfa4b392b04613ad.camel@scientia.net>
 <04ccd53107bb11e08baaa8c1ec55b11b00133d3b.camel@scientia.net>
 <412fc97cf7979251b96c101c87e4ff171049a6dc.camel@scientia.net>
 <a88d9b34-6a99-ce64-4794-8e25f590f50e@gmx.com>
 <df428289-aac7-5bf8-b0d8-d6cf1d399a38@suse.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <37735421-81ac-3b84-db10-790a6a0f3ea8@cn.fujitsu.com>
Date:   Mon, 5 Nov 2018 09:21:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <df428289-aac7-5bf8-b0d8-d6cf1d399a38@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: D993E4B714DB.AC5CA
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/3/18 5:20 PM, Nikolay Borisov wrote:
> 
> 
> On 3.11.18 г. 3:34 ч., Su Yue wrote:
>>
>>
>> On 2018/11/2 10:10 PM, Christoph Anton Mitterer wrote:
>>> Hey Su.
>>>
>>
>> Sorry for the late reply cause I'm busy at other things.
>>
>>> Anything further I need to do in this matter or can I consider it
>>> "solved" and you won't need further testing by my side, but just PR the
>>> patches of that branch? :-)
>>>
>>
>> I just looked through related codes and found the bug.
>> The patches can fix it. So no need to do more tests.
>> Thanks to your tests and patience. :)
>>
>>
>> In previous output of debug version, we can see @ret code
>> is 524296 which is (DIR_ITEM_MISMATCH(1 << 3) | DIR_INDEX_MISMATCH
>> (1<<19)).
>>
>> In btrfs-progs v4.17,
>> function check_inode_extref() passes u64 @mode as the last parameter
>> of find_dir_item();
>> However, find_dir_item() is defined as:
>> static int find_dir_item(struct btrfs_root *root, struct btrfs_key *key,
>>                           struct btrfs_key *location_key, char *name,
>>                           u32 namelen, u8 file_type);
>>
>> The type of the last argument is u8 not u64.
> 
> So this would have been caught by gcc's -Wconversion, except it likely
> wouldn't have been because right now this option produces loads of false
> positives... Too bad...
> Yes, type cast is too common in C, enabling such compile warnings
is annoying...


>>
>> So the case is that while checking files with inode_extrefs,
>> if (imode != file_type), then find_dir_item() thinks it found
>> DIR_ITEM_MISMATCH or DIR_INDEX_MISMATCH.
>>
>> Thanks,
>> Su
>>
>>> Thanks,
>>> Chris.
>>>
>>> On Sat, 2018-10-27 at 14:15 +0200, Christoph Anton Mitterer wrote:
>>>> Hey.
>>>>
>>>>
>>>> Without the last patches on 4.17:
>>>>
>>>> checking extents
>>>> checking free space cache
>>>> checking fs roots
>>>> ERROR: errors found in fs roots
>>>> Checking filesystem on /dev/mapper/system
>>>> UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
>>>> found 619543498752 bytes used, error(s) found
>>>> total csum bytes: 602382204
>>>> total tree bytes: 2534309888
>>>> total fs tree bytes: 1652097024
>>>> total extent tree bytes: 160432128
>>>> btree space waste bytes: 459291608
>>>> file data blocks allocated: 7334036647936
>>>>    referenced 730839187456
>>>>
>>>>
>>>> With the last patches, on 4.17:
>>>>
>>>> checking extents
>>>> checking free space cache
>>>> checking fs roots
>>>> checking only csum items (without verifying data)
>>>> checking root refs
>>>> Checking filesystem on /dev/mapper/system
>>>> UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
>>>> found 619543498752 bytes used, no error found
>>>> total csum bytes: 602382204
>>>> total tree bytes: 2534309888
>>>> total fs tree bytes: 1652097024
>>>> total extent tree bytes: 160432128
>>>> btree space waste bytes: 459291608
>>>> file data blocks allocated: 7334036647936
>>>>    referenced 730839187456
>>>>
>>>>
>>>> Cheers,
>>>> Chris.
>>>>
>>>
> 
> 



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59150 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751496AbdFWQki (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 12:40:38 -0400
Subject: Re: [PATCH] btrfs: fix integer overflow in calc_reclaim_items_nr
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        <linux-btrfs@vger.kernel.org>
References: <20170623143240.1245989-1-clm@fb.com>
 <b033955e-c0ff-20da-0e98-f68a5eb767c8@applied-asynchrony.com>
CC: <davej@codemonkey.org.uk>
From: Chris Mason <clm@fb.com>
Message-ID: <049bbc67-6028-10d8-04e3-cfcba69b24be@fb.com>
Date: Fri, 23 Jun 2017 12:40:12 -0400
MIME-Version: 1.0
In-Reply-To: <b033955e-c0ff-20da-0e98-f68a5eb767c8@applied-asynchrony.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/23/2017 11:29 AM, Holger Hoffstätte wrote:
> On 06/23/17 16:32, Chris Mason wrote:
> [..]
>> -static inline int calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
>> +static inline u64 calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
>>  					u64 to_reclaim)
>>  {
>>  	u64 bytes;
>> -	int nr;
>> +	u64 nr;
>>
>>  	bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
>>  	nr = (int)div64_u64(to_reclaim, bytes);
>         ^^^^^^^^^^
>
> Isn't this a bit odd? I can't even tell whether it matters, just randomly
> noticed it because I genuinely dislike type casts..
>

Crud, yes that's broken.  Thanks!

-chris


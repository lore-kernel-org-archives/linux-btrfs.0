Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29024 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756909AbaGYIQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 04:16:40 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6P8G47D024852
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 16:16:05 +0800
Message-ID: <53D21248.1040102@cn.fujitsu.com>
Date: Fri, 25 Jul 2014 16:16:08 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: Return right extent when fiemap gives unaligned
 offset and len.
References: <1406252943-5834-1-git-send-email-quwenruo@cn.fujitsu.com> <53D20CB4.3000409@jp.fujitsu.com>
In-Reply-To: <53D20CB4.3000409@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v2] btrfs: Return right extent when fiemap gives 
unaligned offset and len.
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Date: 2014年07月25日 15:52
> Hi Qu,
>
> (2014/07/25 10:49), Qu Wenruo wrote:
>> When page aligned start and len passed to extent_fiemap(), the result is
>> good, but when start and len is not aligned, e.g. start = 1 and len =
>> 4095 is passed to extent_fiemap(), it returns no extent.
>>
>> The problem is that start and len is all rounded up which causes the
>> problem. This patch will round down start and round up (start + len) to
>> return right extent.
>>
>> Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> changelog:
>> v2: reword the description(ALIGN rounds up, not rounds down).
>> ---
>>    fs/btrfs/extent_io.c | 4 ++--
>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index a389820..1c70cff 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -4213,8 +4213,8 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>    		return -ENOMEM;
>>    	path->leave_spinning = 1;
>>    
>> -	start = ALIGN(start, BTRFS_I(inode)->root->sectorsize);
>> -	len = ALIGN(len, BTRFS_I(inode)->root->sectorsize);
>> +	start = round_down(start, BTRFS_I(inode)->root->sectorsize);
>> +	len = round_up(max, BTRFS_I(inode)->root->sectorsize) - start;
> I have one question.
>
> Why isn't it "len = round_up(len, BTRFS_I(inode)->root->sectorsize);" ?
> Old behavior make len sectorsize aligned. However, if start is not
> aligned to sectorsize, new bahavior make len not sectorsize aligned.
> Does it an expected behavior?
In fact, in my code, len is also aligned.
The calculation is somewhat easy, round_down original 'start' and 
round_up original end(in the code, max is original
unaligned end position),
then calculate 'len' by minus aligned end with aligned 'start'.
Since the *new* 'start' is already aligned and the new end is aligned, 
the len will also be aligned.

Thanks,
Qu
>
> CMIIW. I'm not good at extent code.
>
> Thanks,
> Satoru
>
>>    
>>    	/*
>>    	 * lookup the last file extent.  We're not using i_size here
>>


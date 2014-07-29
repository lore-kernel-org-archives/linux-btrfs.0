Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43002 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaG2DPH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 23:15:07 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id AFE873EE0B6
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 12:15:04 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B3BF6AC0406
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 12:15:03 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 17B471DB803E
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 12:15:03 +0900 (JST)
Received: from G01JPEXCHYT15.g01.fujitsu.local (G01JPEXCHYT15.g01.fujitsu.local [10.128.194.54])
	by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id DC8C258421B
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 12:15:01 +0900 (JST)
Message-ID: <53D711A2.4090908@jp.fujitsu.com>
Date: Tue, 29 Jul 2014 12:14:42 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: Return right extent when fiemap gives unaligned
 offset and len.
References: <1406252943-5834-1-git-send-email-quwenruo@cn.fujitsu.com> <53D20CB4.3000409@jp.fujitsu.com> <53D21248.1040102@cn.fujitsu.com>
In-Reply-To: <53D21248.1040102@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

(2014/07/25 17:16), Qu Wenruo wrote:
>
> -------- Original Message --------
> Subject: Re: [PATCH v2] btrfs: Return right extent when fiemap gives unaligned offset and len.
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
> Date: 2014年07月25日 15:52
>> Hi Qu,
>>
>> (2014/07/25 10:49), Qu Wenruo wrote:
>>> When page aligned start and len passed to extent_fiemap(), the result is
>>> good, but when start and len is not aligned, e.g. start = 1 and len =
>>> 4095 is passed to extent_fiemap(), it returns no extent.
>>>
>>> The problem is that start and len is all rounded up which causes the
>>> problem. This patch will round down start and round up (start + len) to
>>> return right extent.
>>>
>>> Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>> changelog:
>>> v2: reword the description(ALIGN rounds up, not rounds down).
>>> ---
>>>    fs/btrfs/extent_io.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>> index a389820..1c70cff 100644
>>> --- a/fs/btrfs/extent_io.c
>>> +++ b/fs/btrfs/extent_io.c
>>> @@ -4213,8 +4213,8 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>>            return -ENOMEM;
>>>        path->leave_spinning = 1;
>>> -    start = ALIGN(start, BTRFS_I(inode)->root->sectorsize);
>>> -    len = ALIGN(len, BTRFS_I(inode)->root->sectorsize);
>>> +    start = round_down(start, BTRFS_I(inode)->root->sectorsize);
>>> +    len = round_up(max, BTRFS_I(inode)->root->sectorsize) - start;
>> I have one question.
>>
>> Why isn't it "len = round_up(len, BTRFS_I(inode)->root->sectorsize);" ?
>> Old behavior make len sectorsize aligned. However, if start is not
>> aligned to sectorsize, new bahavior make len not sectorsize aligned.
>> Does it an expected behavior?
> In fact, in my code, len is also aligned.
> The calculation is somewhat easy, round_down original 'start' and round_up original end(in the code, max is original
> unaligned end position),
> then calculate 'len' by minus aligned end with aligned 'start'.
> Since the *new* 'start' is already aligned and the new end is aligned, the len will also be aligned.

Thank you for your explanation. I understood.
I forgot to that "start" is aligned here.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

>
> Thanks,
> Qu
>>
>> CMIIW. I'm not good at extent code.
>>
>> Thanks,
>> Satoru
>>
>>>        /*
>>>         * lookup the last file extent.  We're not using i_size here
>>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


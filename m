Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:55787 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759856AbaGYLhI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 07:37:08 -0400
Message-ID: <53D24166.7030208@skagestad.org>
Date: Fri, 25 Jul 2014 13:37:10 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
References: <1502954.OtX3SzjMKZ@merkaba> <53C52AE4.6010803@fb.com> <1984661.CMGGdWA6Ux@merkaba> <1809953.ithLVmijbn@merkaba> <53D11F2B.1070008@fb.com> <53D1E260.6080708@skagestad.org> <20140725092800.GC25859@localhost.localdomain> <53D22FD4.2070806@skagestad.org> <53D23AF1.9010704@skagestad.org>
In-Reply-To: <53D23AF1.9010704@skagestad.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25. juli 2014 13:09, Torbjørn wrote:
> On 25. juli 2014 12:22, Torbjørn wrote:
>> On 25. juli 2014 11:28, Liu Bo wrote:
>>> Hi Torbjørn,
>>>
>>> On Fri, Jul 25, 2014 at 06:51:44AM +0200, Torbjørn wrote:
>>>> On 07/24/2014 04:58 PM, Chris Mason wrote:
>>>>> <snip>
>>>>> Liu Bo has a promising patch:
>>>>>
>>>>> https://patchwork.kernel.org/patch/4618421/
>>>>>
>>>>> Please give it a shot.  There's a second deadlock reading the free 
>>>>> space
>>>>> cache, I'm still working on that one too.
>>>>>
>>>>> -chris
>>>> I (as expected, my hang was with free space cache) still get hangs
>>>> with this applied on top of 3.16-rc6.
>>>> Looking forward to the free space cache patch.
>>>>
>>>> I have not been able to trigger the same hang as I had with 3.15 on
>>>> any of the 3.16-rc6 kernels so far.
>>> Seems that you can run into the hang quite stably, I have a stupid 
>>> debugging
>>> patch here with adding a WARN_ON() to __load_free_space_inode(), 
>>> would you
>>> please give it a shot and show us the output of dmesg?
>>>
>>> (This may make 'dmesg' a mess, but it will show who the hell holds 
>>> the free
>>> space inode's page just at the time before hang)
>>>
>>> thanks,
>>> -liubo
>>>
>>>
>>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>>> index 2b0a627..e364888 100644
>>> --- a/fs/btrfs/free-space-cache.c
>>> +++ b/fs/btrfs/free-space-cache.c
>>> @@ -350,6 +350,8 @@ static int io_ctl_prepare_pages(struct io_ctl 
>>> *io_ctl,
>>> struct inode *inode,
>>>       gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
>>>       int i;
>>>   +    WARN_ON(1);
>>> +
>>>       for (i = 0; i < io_ctl->num_pages; i++) {
>>>           page = find_or_create_page(inode->i_mapping, i, mask);
>>>           if (!page) {
>>
>> That patch did not apply cleanly on top of current linus master.
>> Not sure what branch you are at, so I added that WARN_ON(1); manually 
>> in free-space-cache.c.
>> I reverted all the other patches before manually applying this one.
>> If you need me to test from some other branch or with some other 
>> patch included, please let me know.
>>
>> I'm doing a build now. Will run my rsync job and report back.
>>
>> Thanks.
>> -- 
>> Torbjørn
> Back with results.
> That's output from dmesg. If you need more, I can send netconsole log 
> as well.
>
Seems like the list did not accept the huge email.
dmesg is available from: 
https://gist.github.com/anonymous/dba1f53211a1d482c3e0

--
Torbjørn

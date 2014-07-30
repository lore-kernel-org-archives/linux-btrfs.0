Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32982 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaG3GJV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 02:09:21 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id E70403EE0FE
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:09:20 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id CFC12AC0660
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:09:19 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 855B81DB803B
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:09:19 +0900 (JST)
Received: from G01JPEXCHKW14.g01.fujitsu.local (G01JPEXCHKW14.g01.fujitsu.local [10.0.194.53])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id C69BEBD6632
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:09:17 +0900 (JST)
Message-ID: <53D88C08.6050704@jp.fujitsu.com>
Date: Wed, 30 Jul 2014 15:09:12 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/4] btrfs-progs: correct manpage option description for
 scrub
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>	 <1405564839-28702-4-git-send-email-guihc.fnst@cn.fujitsu.com>	 <53D8808E.4020609@jp.fujitsu.com> <1406698778.30821.8.camel@localhost.localdomain>
In-Reply-To: <1406698778.30821.8.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gui,

(2014/07/30 14:39), Gui Hecheng wrote:
> On Wed, 2014-07-30 at 14:20 +0900, Satoru Takeuchi wrote:
>> Hi Gui,
>>
>> (2014/07/17 11:40), Gui Hecheng wrote:
>>> The -f option of scrub means to skip checking running scrub,
>>> not to force checking.
>>>
>>> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>>> ---
>>>    Documentation/btrfs-scrub.txt | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
>>> index 7b27d63..1af9b9f 100644
>>> --- a/Documentation/btrfs-scrub.txt
>>> +++ b/Documentation/btrfs-scrub.txt
>>> @@ -47,7 +47,7 @@ manpage).
>>>    -n <ioprio_classdata>::::
>>>    Set IO priority classdata (see `ionice`(1) manpage).
>>>    -f::::
>>> -force to check whether scrub has started or resumed in userspace.
>>> +force to skip checking whether scrub has started or resumed in userspace.
>
> Hi Satoru,
> Thanks for your comments first. My opinions are as follows:
>
>> I consider "scrub has started and resumed" is not user-friendly
>> expression. First, it can be replaced with more easy one,
>> "scrub is running". Second, there in no explanation about
>> this checking behavior before "-f" option's description.
>
> Yes, "Scrub is running" is more precise.
>
>> So, how about the following idea?
>>
>>   Fix 1. Add "If scrub is already running running, it fails."
>>          to the description before `Options` section
>    This is really a valuable idea.
>
>>   Fix 2. Replace "force to check ..." with
>>          "force starting new scrub even if scrub is already running."
>    This is more precise.
>
>>   Fix 3. Fix cmd_scrub_start_usage too.
>    Of course, thanks for reminding me.
>
> So please let me rework this patch,

Thank you for reworking.

>could I add your sign-off-by then?

Yes, please.

Thanks,
Satoru

>
> Thanks,
> Gui
>>
>> Thanks,
>> Satoru
>>
>>>    this is useful when scrub stat record file is damaged.
>>>
>>>    *cancel* <path>|<device>::
>>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


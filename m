Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38878 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbAEBCv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Jan 2015 20:02:51 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 4B2553EE16B
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 10:02:50 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 5168DAC0305
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 10:02:49 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 02D96E08004
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 10:02:49 +0900 (JST)
Message-ID: <54A9E2A5.50909@jp.fujitsu.com>
Date: Mon, 5 Jan 2015 10:02:29 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Petr Janecek <janecek@ucw.cz>
CC: <russell@coker.com.au>, <linux-btrfs@vger.kernel.org>,
        Timofey Titovets <nefelim4ag@gmail.com>
Subject: Re: Debian/Jessie 3.16.7-ckt2-1 kernel error
References: <201412241202.59568.russell@coker.com.au> <549A8B9B.5000005@jp.fujitsu.com> <549B5D4C.1070804@jp.fujitsu.com> <20141227153621.GB19957@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20141227153621.GB19957@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Petr,

On 2014/12/28 0:36, Petr Janecek wrote:
> Hello Satoru and all,
>
>    that Oct. report was the only time I've experienced the error, so I
> don't have much to add. I can try to answer your questions:
>
>>> Here are my questions.
>>>
>>> 1. Is your system "btrfs scrub" clean?
>
>    yes,
>
>>> 2. Is this message shown every boot time?
>
>    no, I have seen them only during one boot
>
>>> 3. Is this message shown only in boot?
>
>    As in my Oct. email
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/39721
> I've seen a similar one after creating a subvolume on a new fs.
> But it was during the same boot.
>
>>> 4. When this message is started to be shown?
>>> 5. Do you have any trouble, change your operation or configuration
>>>     just before the answer of Q4 ?
>
>    a disk was added to the fs and balance has been run. The balance
> crashed, as in https://bugzilla.kernel.org/show_bug.cgi?id=64961
> (probably unrelated).  After reboot, I've seen the messages.
>
>> Additional questions.
>> Q5. Could you give me your kernel configuration?
>>      At least, could you tell me whether your kernel
>>      enabled CONFIG_PREEMPT or not?
>
>    CONFIG_PREEMPT_VOLUNTARY=y
>
>> Q6. If the answer of Q1 is correct, please give me the
>>      file system image which can be captured by the following command.
>
>    Sorry, the fs's are long gone. I continued to run similar workloads on
> that test box, but these errors never appeared again.

Thank you for giving me information.

So, further investigation of this problem seems to be hard.
Please give us the above-mentioned information if this problem
happens again.

Thanks,
Satoru

>
>
> Regards,
>
> Petr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


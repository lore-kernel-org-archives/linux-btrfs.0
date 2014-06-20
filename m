Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob05.myregisteredsite.com ([209.17.115.43]:50349 "EHLO
	atl4mhob05.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965771AbaFTADo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 20:03:44 -0400
Received: from mailpod1.hostingplatform.com (atl4obmail01pod1.mgt.hosting.qts.netsol.com [10.30.71.113])
	by atl4mhob05.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s5K03gWw030520
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 20:03:42 -0400
Message-ID: <53A37A9B.7020301@chinilu.com>
Date: Thu, 19 Jun 2014 17:04:43 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.comHe
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: open_ctree failed
References: <539EF06A.4080803@martos.bme.hu> <539EF907.6010102@martos.bme.hu> <53A35B2D.4000606@martos.bme.hu>
In-Reply-To: <53A35B2D.4000606@martos.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/19/2014 02:50 PM, Tamas Papp wrote:
>
> On 06/16/2014 04:02 PM, Tamas Papp wrote:
>>
>> On 06/16/2014 03:26 PM, Tamas Papp wrote:
>>> hi All,
>>>
>>> There is a Dell XPS 13 laptop with and SSD.
>>>
>>> System:
>>>
>>> Ubuntu 14.04 amd64
>>> Kernel is from the daily ppa, like 3.15rcX.
>>>
>>> Now, it's running live system:
>>>
>>> Linux ubuntu 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 
>>> UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>>
>>> Linux ubuntu 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 
>>> UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>>> Label: none  uuid: 7cf95491-8ec6-48a2-b4c4-4b80650d169a
>>>     Total devices 1 FS bytes used 121.91GiB
>>>     devid    1 size 236.53GiB used 146.02GiB path /dev/sda4
>>>
>>> Btrfs v3.14.1
>>>
>>>
>>>
>>> I've attached all debug output, that I was able to get.
>>> btrfs check exited with segfault.
>>>
>>>
>>> Can you help me with this?
>>>
>>
>> I just fixed the subject.
>
> Someone? Any idea?
>
>
> 10x
> tamas
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
Hello Tamas,

I think it would help to provide more information than what you have 
posted.  "open_ctree" can cover a lot of territory.

1)  I may be missing something, but I see no attachment.  I am not sure 
the mailing list can handle attachments?
2)  I think it would help to include some sort of brief narrative as to 
what you are trying to do when you encounter the open_ctree failure.

- George

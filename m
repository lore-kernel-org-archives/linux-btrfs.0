Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28311 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbDWSjR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 14:39:17 -0400
Message-ID: <55393C41.60501@oracle.com>
Date: Thu, 23 Apr 2015 14:38:57 -0400
From: Sasha Levin <sasha.levin@oracle.com>
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>,
        Rich Freeman <r-btrfs@thefreemanclan.net>
CC: Greg KH <gregkh@linuxfoundation.org>, Roman Mamedov <rm@romanrm.net>,
        Chris Mason <clm@fb.com>, stable <stable@vger.kernel.org>,
        Btrfs <linux-btrfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: Please add 9c4f61f01d269815bb7c37be3ede59c5587747c6 to stable
References: <1427984267.10670.0@mail.thefacebook.com>	<20150413192838.3d5a0a69@natsu>	<20150413165818.GC32634@kroah.com>	<CAGfcS_nSSzikmkD_6wTTUAa0Zx6znoxf0qHwAfVeNuOZ9Ej5Kw@mail.gmail.com> <CA+5PVA6g7Ebez64aJv_d=eB9cj5_vHHyd632bRsr0wY=53KeXg@mail.gmail.com> <55393B4E.30702@oracle.com>
In-Reply-To: <55393B4E.30702@oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/23/2015 02:34 PM, Sasha Levin wrote:
> On 04/23/2015 02:24 PM, Josh Boyer wrote:
>> On Thu, Apr 23, 2015 at 2:16 PM, Rich Freeman
>> <r-btrfs@thefreemanclan.net> wrote:
>>>> On Mon, Apr 13, 2015 at 12:58 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>>> On Mon, Apr 13, 2015 at 07:28:38PM +0500, Roman Mamedov wrote:
>>>>>>>> On Thu, 2 Apr 2015 10:17:47 -0400
>>>>>>>> Chris Mason <clm@fb.com> wrote:
>>>>>>>>
>>>>>>>>>> Hi stable friends,
>>>>>>>>>>
>>>>>>>>>> Can you please backport this one to 3.19.y.  It fixes a bug introduced
>>>>>>>>>> by:
>>>>>>>>>>
>>>>>>>>>> 381cf6587f8a8a8e981bc0c1aaaa8859b51dc756, which was tagged for stable
>>>>>>>>>> 3.14+
>>>>>>>>>>
>>>>>>>>>> The symptoms of the bug are deadlocks during log reply after a crash.
>>>>>>>>>> The patch wasn't intentionally fixing the deadlock, which is why we
>>>>>>>>>> missed it when tagging fixes.
>>>>>>>>
>>>>>>>> Unfortunately still not fixed (no btrfs-related changes) in 3.14.38 and
>>>>>>>> 3.18.11 released today.
>>>>>>
>>>>>> I have a few hundred stable backports left to sort through, don't worry,
>>>>>> this is still in the queue, it's not lost.
>>>>
>>>> It looks like this still isn't in 3.18.12, though it looks like it is in 3.19.5.
>> Sasha is maintaining the 3.18.y stable tree, not Greg.  Added to CC.
> 
> Um, that commit was shipped back in 3.18.9.

Oh, bleh, I've looked the wrong commit. I've queued 9c4f61f01d269815bb7c37be3ede59c5587747c6
up for 3.18.13.

Thanks!


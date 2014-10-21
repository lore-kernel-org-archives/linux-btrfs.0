Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:64300 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbaJUMhE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 08:37:04 -0400
Received: by mail-la0-f50.google.com with SMTP id s18so935747lam.23
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 05:37:02 -0700 (PDT)
Message-ID: <54465320.70601@gmail.com>
Date: Tue, 21 Oct 2014 15:35:44 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
CC: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Poll: time to switch skinny-metadata on by default?
References: <20141016113337.GC22943@twin.jikos.cz> <20141020163403.GW22943@twin.jikos.cz> <pan$32992$bbc3a80d$ad912ad2$31fcc5ce@cox.net> <54463D45.1040309@gmail.com>
In-Reply-To: <54463D45.1040309@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/10/2014 2:02 μμ, Austin S Hemmelgarn wrote:
> On 2014-10-21 05:29, Duncan wrote:
>> David Sterba posted on Mon, 20 Oct 2014 18:34:03 +0200 as excerpted:
>>
>>> On Thu, Oct 16, 2014 at 01:33:37PM +0200, David Sterba wrote:
>>>> I'd like to make it default with the 3.17 release of btrfs-progs.
>>>> Please let me know if you have objections.
>>>
>>> For the record, 3.17 will not change the defaults. The timing of the
>>> poll was very bad to get enough feedback before the release. Let's keep
>>> it open for now.
>>
>> FWIW my own results agree with yours, I've had no problem with skinny-
>> metadata here, and it has been my default now for a couple 
>> backup-and-new-
>> mkfs.btrfs generations, now.
>>
>> As you know there were some problems with it in the first kernel 
>> cycle or
>> two after it was introduced as an option, and I waited awhile until they
>> died down before trying it here, but as I said, no problems since I
>> switched it on, and I've been running it awhile now.
>>
>> So defaulting to skinny-metadata looks good from here. =:^)
>>
> Same here, I've been using it on all my systems since I switched from 
> 3.15 to 3.16, and have had no issues whatsoever.
>
I am using skinny-metadata for years, and only once had an issue with 
it. It was with scrub and was fixed by Liu Bo[1], so i think 
skinny-metadata is mature enough be a default.

[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg34493.html

-- 
Konstantinos Skarlatos


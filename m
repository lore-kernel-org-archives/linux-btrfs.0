Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:40525 "EHLO
	techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932155AbcHJSq5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 14:46:57 -0400
To: g6094199@freenet.de, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <a70af895-6d3e-3b8a-eeb3-71d6609f8154@techsquare.com>
 <CAJCQCtReDSm46LVVZaiMO3oSRgi9EBQnY9+JkH6Fia1SFH4AWg@mail.gmail.com>
 <1c409a92-978d-a37a-75ae-8ff2e84f5674@techsquare.com>
 <cf494b45-6d2e-18a8-b579-17f14b586598@chefmail.de>
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <5c6c7531-0dac-8f93-c466-609b4a809b93@techsquare.com>
Date: Wed, 10 Aug 2016 07:16:43 -0400
MIME-Version: 1.0
In-Reply-To: <cf494b45-6d2e-18a8-b579-17f14b586598@chefmail.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963:
 errno=-17 Object already exists
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I performed a quick balance which gave me:

[39020.030638] BTRFS info (device sda1): relocating block group 
25428383236096 flags 1
[39020.206097] BTRFS warning (device sda1): block group 23113395863552 
has wrong amount of free space
[39020.206101] BTRFS warning (device sda1): failed to load free space 
cache for block group 23113395863552, rebuilding it now

then a crash dump.

Remounted with -o clear_cache,nospace_cache and the balance completed. 
Running a larger balance now.

Will umount, and remount with default options to see if that works.

-Matt

On 08/10/2016 03:09 AM, g6094199@freenet.de wrote:
> Hi,
>
> from what i see you have a non finished balance ongoing, since you have
> system and metadata DUP and single information on disk.
>
> so you should (re)run a balance for this data.
>
>
> sash
>
>
> Am 10.08.2016 um 02:17 schrieb Matt McKinnon:
>> -o usebackuproot worked well.
>>
>> after the file system settled, performing a sync and a clean umount, a
>> normal mount works now as well.
>>
>> Anything I should be doing going forward?
>>
>> Thanks,
>> Matt
>>
>> On 08/09/2016 08:01 PM, Chris Murphy wrote:
>>> On Tue, Aug 9, 2016 at 5:15 PM, Matt McKinnon <matt@techsquare.com>
>>> wrote:
>>>> Hello,
>>>>
>>>> Our server recently crashed and was rebooted.  When it returned our
>>>> BTRFS
>>>> volume is mounting read-only:
>>>
>>> What happens when you try mounting with -o usebackuproot ?
>>>
>>> If that fails, what output do you get for 'btrfs check' (without
>>> --repair)? If you only get some "errors 400, nbytes wrong" then
>>> --repair should fix the problem.
>>>
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

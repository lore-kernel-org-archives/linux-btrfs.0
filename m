Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-wd.italiaonline.it ([212.48.13.167]:37647 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751335AbdIORaM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 13:30:12 -0400
Reply-To: kreijack@inwind.it
Subject: Re: BUG: BTRFS and O_DIRECT could lead to wrong checksum and wrong
 data
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
 <3fc175a8-a61b-6060-5c78-abbbe2e61037@gmail.com>
 <22378b5d-c679-f85f-af1b-0a4b3c8d5f14@inwind.it>
 <4eda8832-c588-5775-4816-629bb39b0251@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <0e88304d-5c63-b27a-cebf-6e99befc4858@inwind.it>
Date: Fri, 15 Sep 2017 19:30:09 +0200
MIME-Version: 1.0
In-Reply-To: <4eda8832-c588-5775-4816-629bb39b0251@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2017 07:01 PM, Andrei Borzenkov wrote:
> 15.09.2017 08:50, Goffredo Baroncelli пишет:
>> On 09/15/2017 05:55 AM, Andrei Borzenkov wrote:
>>> 15.09.2017 01:00, Goffredo Baroncelli пишет:
>>>>
>>>> 2) The second bug, is a more severe bug. If during a writing of a buffer with O_DIRECT, the buffer is updated at the same time by a second process, the checksum may be incorrect.
>>>>
>>>
>>> Is it btrfs specific ? If buffer is updated before it was actually
>>> consumed by kernel, this likely means data corruption on any filesystem.
>>
>> I don't see any corruption in other FS. The fact that application push to filesystem garbage, doesn't allow the filesystem to be corrupted. 
> 
> I did not say "filesystem corruption", 
I did it.. because there is a filesystem corruption only in BTRFS .
I agree with you that a concurrent access between different processes to the same page which is in writing is bad. However only in BTRFS this lead to a filesystem corruption. This is the first problem. The second one is that BTRFS doesn't warn the user about that (read more below), however it returns wrong data (a page filled by 0x01)

> I said "data corruption".
And, are you sure that there is data corruption ?  don't have evidence of that in other filesystem. Proof is that there are a lot of problem in BTRFS when O_DIRECT is used, but not in other filesystem. 
If this is due to a better serialization or is due to the application touch the page which is going to written but doesn't care about the data I don't know. 

Anyway from open(2) man page:

[...]
O_DIRECT  I/Os should never be run concurrently with the fork(2)[...] if the memory buffer is a private mapping (i.e., any mapping created  with the mmap(2) MAP_PRIVATE flag.
[...]This restriction does not apply when the  memory buffer for the O_DIRECT I/Os was created using shmat(2) or mmap(2) with the MAP_SHARED flag.
[...]

So it is a valid and accepted use case O_DIRECT+mmap(MAP_SHARED)+fork()


> 
>> In this case the filesystem became corrupted, because another application which try to read the data (without O_DIRECT) may got -EIO.
>>
> 
> No. *Data* on this filesystem was corrupted and luckily btrfs makes you
> aware of it. 

Please re-read my messages. BTRFS doesn't make the user aware of it: if the data is read with O_DIRECT, it doesn't return an error in case of checksum mismatch (this is the second problem)

> On different filesystem you still may have the same data
> corruption, but silent.
> 
>> I repeat, the problem is a data race when the data is in the FS camp, and the kernel does wrong checksum.
>>
> 
> Of course it is race. But again - I expect that when pwrite() returns it
> means data buffer can be reused. Otherwise I cannot see how O_DIRECT can
> be sensibly used at all. In this case you need to demonstrate that data
> corruption happens after pwrite() returns - this makes it btrfs issue
> indeed. If data corruption happens while thread is waiting for pwrite()
> to return, I say this is expected behavior and application fault - it
> need to protect against concurrent write and modification.
> 
>>
>> IMHO, BTRFS should disallow O_DIRECT (which is the same thing that does ZFS on linux); I think that it could be allowed only for  nodatasum files.
>>
>>> I.e. there should be clear indication from kernel that buffer can be
>>> reused by application, in your example - when pwrite returns. So when
>>> data corruption happens - during pwrite or after? 
>>> If data is corrupted
>>> during pwrite, it is arguably application fault - it should disallow
>>> concurrent access.
>>
>>
>>
>>
>>
>>>
>>
>>
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

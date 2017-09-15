Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:50601 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdIORBQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 13:01:16 -0400
Received: by mail-lf0-f52.google.com with SMTP id d4so3044206lfj.7
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 10:01:15 -0700 (PDT)
Subject: Re: BUG: BTRFS and O_DIRECT could lead to wrong checksum and wrong
 data
To: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
 <3fc175a8-a61b-6060-5c78-abbbe2e61037@gmail.com>
 <22378b5d-c679-f85f-af1b-0a4b3c8d5f14@inwind.it>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <4eda8832-c588-5775-4816-629bb39b0251@gmail.com>
Date: Fri, 15 Sep 2017 20:01:13 +0300
MIME-Version: 1.0
In-Reply-To: <22378b5d-c679-f85f-af1b-0a4b3c8d5f14@inwind.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

15.09.2017 08:50, Goffredo Baroncelli пишет:
> On 09/15/2017 05:55 AM, Andrei Borzenkov wrote:
>> 15.09.2017 01:00, Goffredo Baroncelli пишет:
>>>
>>> 2) The second bug, is a more severe bug. If during a writing of a buffer with O_DIRECT, the buffer is updated at the same time by a second process, the checksum may be incorrect.
>>>
>>
>> Is it btrfs specific ? If buffer is updated before it was actually
>> consumed by kernel, this likely means data corruption on any filesystem.
> 
> I don't see any corruption in other FS. The fact that application push to filesystem garbage, doesn't allow the filesystem to be corrupted. 

I did not say "filesystem corruption", I said "data corruption".

> In this case the filesystem became corrupted, because another application which try to read the data (without O_DIRECT) may got -EIO.
> 

No. *Data* on this filesystem was corrupted and luckily btrfs makes you
aware of it. On different filesystem you still may have the same data
corruption, but silent.

> I repeat, the problem is a data race when the data is in the FS camp, and the kernel does wrong checksum.
> 

Of course it is race. But again - I expect that when pwrite() returns it
means data buffer can be reused. Otherwise I cannot see how O_DIRECT can
be sensibly used at all. In this case you need to demonstrate that data
corruption happens after pwrite() returns - this makes it btrfs issue
indeed. If data corruption happens while thread is waiting for pwrite()
to return, I say this is expected behavior and application fault - it
need to protect against concurrent write and modification.

> 
> IMHO, BTRFS should disallow O_DIRECT (which is the same thing that does ZFS on linux); I think that it could be allowed only for  nodatasum files.
> 
>> I.e. there should be clear indication from kernel that buffer can be
>> reused by application, in your example - when pwrite returns. So when
>> data corruption happens - during pwrite or after? 
>> If data is corrupted
>> during pwrite, it is arguably application fault - it should disallow
>> concurrent access.
> 
> 
> 
> 
> 
>>
> 
> 


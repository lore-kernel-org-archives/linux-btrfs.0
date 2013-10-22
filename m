Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:54022 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3JVIhv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 04:37:51 -0400
Message-ID: <52663960.4060905@giantdisaster.de>
Date: Tue, 22 Oct 2013 10:37:52 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race condition between writting and scrubing
 supers
References: <1382156250-2336-1-git-send-email-wangshilong1991@gmail.com>	<526247E3.9000804@giantdisaster.de> <CAP9B-Qncw5aCJzbQapy6i4iRrJ-mYh_yhkorY7+p9wZtzJodTQ@mail.gmail.com> <5262914D.7030306@giantdisaster.de> <B9B7D38F-3E92-4347-A41F-FA4D80D31745@gmail.com>
In-Reply-To: <B9B7D38F-3E92-4347-A41F-FA4D80D31745@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 20 Oct 2013 12:03:01 +0800, Wang Shilong wrote:
>> On 10/19/2013 12:32, Shilong Wang wrote:
>>> 2013/10/19, Stefan Behrens <sbehrens@giantdisaster.de>:
>>>> On 10/19/2013 06:17, Wang Shilong wrote:
>>>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>>>
>>>>> Scrubing supers is not in a transaction context, when trying to
>>>>> write supers to disk, we should check if we are trying to
>>>>> scrub supers.Fix it.
>>>>>
>>>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
[...]
>>>> What kind of race do you see between writing the 4K superblock and scrub
>>>> checking its checksum? Or in other words, what could happen?
>>
>>> Yeah, it did not hurt. but it may  output checksum mismatch.  For example:
>>> Writing 4k superblock is not totally finished, but we are trying to scrub it.
>>
>> Have you ever seen this issue?

You replied with "No, just noticing it by accident" in the mail before.

I don't believe that this issue can ever happen. I don't believe that
somewhere on the path to the flash memory, to the magnetic disc or to
the drive's cache memory, someone interrupts a 4KB write in the middle
of operation to read from this 4KB area. This is not an issue IMHO.


>> If yes, let's find a different solution. You scrub, let's say, once a week. Scrubbing the superblock takes, let's say, 100ms, then it's finished. This short race doesn't justify to add such code to btrfs_commit_transaction and btrfs_commit_super IMHO. And commiting a transaction is synchronized to scrub already when the commit root is updated.
>>
>> If this is really an issue and these 4K disk writes and reads interfere, let's find a better solution please.
> 
> How about this approach?
> 
> We let scrub_supers in a transaction context.
> 
> btrfs_join_transaction()
> 
> scrub_supers
> 
> btrfs_commit_transaction().
> 
> This is not elegant, but we can remove scrub_lock with supers(Notice, there is another place that have used
> this lock).



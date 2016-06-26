Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:55863 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751731AbcFZJUx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 05:20:53 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
 <CAJCQCtSF3WTxOkrgdWL78DqxYf-kLzXr4vnKPLoe2mhURhqkOA@mail.gmail.com>
 <268f4f78-c277-43e9-a621-fc32d5fad172@inwind.it>
 <CAJCQCtRWfWXruAJTbCsh7dKc=2iRk6CHMOMTUBbh7JGH6SaXtA@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <a291b1c0-fadf-da85-fc46-657884ec38bc@inwind.it>
Date: Sun, 26 Jun 2016 11:20:50 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRWfWXruAJTbCsh7dKc=2iRk6CHMOMTUBbh7JGH6SaXtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-26 00:33, Chris Murphy wrote:
> On Sat, Jun 25, 2016 at 12:42 PM, Goffredo Baroncelli
> <kreijack@inwind.it> wrote:
>> On 2016-06-25 19:58, Chris Murphy wrote:
>> [...]
>>>> Wow. So it sees the data strip corruption, uses good parity on disk to
>>>> fix it, writes the fix to disk, recomputes parity for some reason but
>>>> does it wrongly, and then overwrites good parity with bad parity?
>>>
>>> The wrong parity, is it valid for the data strips that includes the
>>> (intentionally) corrupt data?
>>>
>>> Can parity computation happen before the csum check? Where sometimes you get:
>>>
>>> read data strips > computer parity > check csum fails > read good
>>> parity from disk > fix up the bad data chunk > write wrong parity
>>> (based on wrong data)?
>>>
>>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/fs/btrfs/raid56.c?id=refs/tags/v4.6.3
>>>
>>> 2371-2383 suggest that there's a parity check, it's not always being
>>> rewritten to disk if it's already correct. But it doesn't know it's
>>> not correct, it thinks it's wrong so writes out the wrongly computed
>>> parity?
>>
>> The parity is not valid for both the corrected data and the corrupted data. It seems that the scrub process copy the contents of the disk2 to disk3. It could happens only if the contents of disk1 is zero.
> 
> I'm not sure what it takes to hit this exactly. I just tested 3x
> raid5, where two files 128KiB "a" and 128KiB "b", so that's a full
> stripe write for each. I corrupted devid 1 64KiB of "a" and devid2
> 64KiB of "b" did a scrub, error is detected, and corrected, and parity
> is still correct.

How many time tried this corruption test ? I was unable to raise the bug systematically; in average every three tests I got 1 bug.... 


[....]

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

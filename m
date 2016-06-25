Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35218 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbcFYR7A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 13:59:00 -0400
Received: by mail-oi0-f50.google.com with SMTP id r2so154493323oih.2
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 10:58:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it> <CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 25 Jun 2016 11:58:58 -0600
Message-ID: <CAJCQCtSF3WTxOkrgdWL78DqxYf-kLzXr4vnKPLoe2mhURhqkOA@mail.gmail.com>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: Chris Murphy <lists@colorremedies.com>
Cc: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 25, 2016 at 11:25 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, Jun 25, 2016 at 6:21 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
>
>> 5) I check the disks at the offsets above, to verify that the data/parity is correct
>>
>> However I found that:
>> 1) if I corrupt the parity disk (/dev/loop2), scrub don't find any corruption, but recomputed the parity (always correctly);
>
> This is mostly good news, that it is fixing bad parity during scrub.
> What's not clear due to the lack of any message is if the scrub is
> always writing out new parity, or only writes it if there's a
> mismatch.
>
>
>> 2) when I corrupted the other disks (/dev/loop[01]) btrfs was able to find the corruption. But I found two main behaviors:
>>
>> 2.a) the kernel repaired the damage, but compute the wrong parity. Where it was the parity, the kernel copied the data of the second disk on the parity disk
>
> Wow. So it sees the data strip corruption, uses good parity on disk to
> fix it, writes the fix to disk, recomputes parity for some reason but
> does it wrongly, and then overwrites good parity with bad parity?

The wrong parity, is it valid for the data strips that includes the
(intentionally) corrupt data?

Can parity computation happen before the csum check? Where sometimes you get:

read data strips > computer parity > check csum fails > read good
parity from disk > fix up the bad data chunk > write wrong parity
(based on wrong data)?

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/fs/btrfs/raid56.c?id=refs/tags/v4.6.3

2371-2383 suggest that there's a parity check, it's not always being
rewritten to disk if it's already correct. But it doesn't know it's
not correct, it thinks it's wrong so writes out the wrongly computed
parity?



-- 
Chris Murphy

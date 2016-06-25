Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:56111 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751349AbcFYSm7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 14:42:59 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
 <CAJCQCtSF3WTxOkrgdWL78DqxYf-kLzXr4vnKPLoe2mhURhqkOA@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <268f4f78-c277-43e9-a621-fc32d5fad172@inwind.it>
Date: Sat, 25 Jun 2016 20:42:55 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSF3WTxOkrgdWL78DqxYf-kLzXr4vnKPLoe2mhURhqkOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-25 19:58, Chris Murphy wrote:
[...]
>> Wow. So it sees the data strip corruption, uses good parity on disk to
>> fix it, writes the fix to disk, recomputes parity for some reason but
>> does it wrongly, and then overwrites good parity with bad parity?
> 
> The wrong parity, is it valid for the data strips that includes the
> (intentionally) corrupt data?
> 
> Can parity computation happen before the csum check? Where sometimes you get:
> 
> read data strips > computer parity > check csum fails > read good
> parity from disk > fix up the bad data chunk > write wrong parity
> (based on wrong data)?
> 
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/fs/btrfs/raid56.c?id=refs/tags/v4.6.3
> 
> 2371-2383 suggest that there's a parity check, it's not always being
> rewritten to disk if it's already correct. But it doesn't know it's
> not correct, it thinks it's wrong so writes out the wrongly computed
> parity?

The parity is not valid for both the corrected data and the corrupted data. It seems that the scrub process copy the contents of the disk2 to disk3. It could happens only if the contents of disk1 is zero.

BR
GB


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

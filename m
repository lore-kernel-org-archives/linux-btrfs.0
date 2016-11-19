Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32.italiaonline.it ([212.48.25.160]:60060 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750958AbcKSJNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Nov 2016 04:13:42 -0500
Reply-To: kreijack@inwind.it
Subject: Re: RFC: raid with a variable stripe size
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
 <20161119082252.GU21290@hungrycats.org>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <80bfba90-2aab-16f7-83e6-00cc3f2b96b4@inwind.it>
Date: Sat, 19 Nov 2016 10:13:39 +0100
MIME-Version: 1.0
In-Reply-To: <20161119082252.GU21290@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-19 09:22, Zygo Blaxell wrote:
[...]
>> If the data to be written has a size of 4k, it will be allocated to
>> the BG #1.  If the data to be written has a size of 8k, it will be
>> allocated to the BG #2 If the data to be written has a size of 12k,
>> it will be allocated to the BG #3 If the data to be written has a size
>> greater than 12k, it will be allocated to the BG3, until the data fills
>> a full stripes; then the remainder will be stored in BG #1 or BG #2.
> 
> OK I think I'm beginning to understand this idea better.  Short writes
> degenerate to RAID1, and large writes behave more like RAID5.  No disk
> format change is required because newer kernels would just allocate
> block groups and distribute data differently.
> 
> That might be OK on SSD, but on spinning rust (where you're most likely
> to find a RAID5 array) it'd be really seeky.  It'd also make 'df' output
> even less predictive of actual data capacity.
> 
> Going back to the earlier example (but on 5 disks) we now have:
> 
> 	block groups with 5 disks:
> 	D1 D2 D3 D4 P1
> 	F1 F2 F3 P2 F4
> 	F5 F6 P3 F7 F8
> 
> 	block groups with 4 disks:
> 	E1 E2 E3 P4
> 	D5 D6 P5 D7
> 
> 	block groups with 3 disks:
> 	(none)
> 
> 	block groups with 2 disks:
> 	F9 P6
> 
> Now every parity block contains data from only one transaction, but 
> extents D and F are separated by up to 4GB of disk space.
> 
[....]

> 
> When the disk does get close to full, this would lead to some nasty
> early-ENOSPC issues.  It's bad enough now with just two competing
> allocators (metadata and data)...imagine those problems multiplied by
> 10 on a big RAID5 array.

I am incline to think that some problem would be reduced developing a daemon which starts a balance automatically when need (on the basis of the fragmentation). Anyway this is an issue which we should solve anyway.

[...]
> 
> I now realize there's no need for any "plug extent" to physically
> exist--the allocator can simply infer their existence on the fly by
> noticing where the RAID stripe boundaries are, and remembering which
> blocks it had allocated in the current uncommitted transaction.


Even this could be a "simple" solution: when a write starts, the system has to use only empty stripes...
> 
> 
> The tradeoff is that more balances would be required to avoid free space
> fragmentation; on the other hand, typical RAID5 use cases involve storing
> a lot of huge files, so the fragmentation won't be a very large percentage
> of total space.  A few percent of disk capacity is a fair price to pay for
> data integrity.

Both the methods would require a more aggressive balance. In this they are equal.

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

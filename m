Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6136 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756468AbcCQBgU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 21:36:20 -0400
Subject: Re: qgroup code slowing down rebalance
To: Dave Hansen <dave@sr71.net>, <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
References: <56E9C7BB.7060509@sr71.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56EA0A0F.8070008@cn.fujitsu.com>
Date: Thu, 17 Mar 2016 09:36:15 +0800
MIME-Version: 1.0
In-Reply-To: <56E9C7BB.7060509@sr71.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Dave Hansen wrote on 2016/03/16 13:53 -0700:
> I have a medium-sized multi-device btrfs filesystem (4 disks, 16TB
> total) running under 4.5.0-rc5.  I recently added a disk and needed to
> rebalance.  I started a rebalance operation three days ago.  It was on
> the order of 20% done after those three days. :)
>
> During this rebalance, the disks were pretty lightly used.  I would see
> a small burst of tens of MB/s, then it would go back to no activity for
> a few minutes, small burst, no activity, etc...  During the quiet times
> (for the disk) one processor would be pegged inside the kernel and would
> have virtually no I/O wait time.  Also during this time, the filesystem
> was pretty unbearably slow.  An ls of a small directory would hang for
> minutes.
>
> A perf profile shows 92% of the cpu time is being spend in
> btrfs_find_all_roots(), called under this call path:
>
> 	btrfs_commit_transaction
> 	 -> btrfs_qgroup_prepare_account_extents
> 	   -> btrfs_find_all_roots
>
> So I tried disabling quotas by doing:
>
> 	btrfs quota disable /mnt/foo
>
> which took a few minutes to complete, but once it did, the disks went
> back up to doing ~200MB/s, the kernel time went down to ~20%, and the
> system now has lots of I/O wait time.  It looks to be behaving nicely.
>
> Is this expected?  From my perspective, it makes quotas pretty much
> unusable at least during a rebalance.  I have a full 'perf record'
> profile with call graphs if it would be helpful.
>
>
Thanks for the report.

Again balance, the devil is again(always) in the balance.
To be honest, balance itself is already complicated enough, and not a 
friendly neighborhood for a lot of function.
(Yeah, a lot of dedupe bugs are and can only be triggered by balance, 
and I can't hate it any more)


Perf record profile will help a lot.
Please upload it if it's OK for you.

Also, the following data would help a lot:
1) btrfs fi df output
    To determine the metadata/data ratio
    Balancing metadata should be quite slow.

2) btrfs subvolume list output
    To determine how many tree blocks are shared against each other
    More shared tree blocks, slower quota routing is.

    Feel free to mask the output to avoid information leaking.

3) perf record for balancing metadata and data respectively
    Although this is optional. Just to prove some assumption.

btrfs_find_all_roots() is quite a slow operation, and in its worst case
(tree blocks are shared by a lot of trees) it may be near O(2^n).

For normal operation, it's pretty hard to trigger so many extents 
creation/deletion/reference.
Even such case happens, it will cause much much much more IO, making the 
most time waiting IO other than doing quota accounting.

But for balance, especially for metadata balancing, IO is small but 
amount of extents is very high, making most the time consumed by 
find_all_roots().


I can try to make balance to bypass quota routine, but I'm not sure if 
such operation will open another hole to make quota crazy again, and 
only much much much more tests can prove it. :(

Thanks,
Qu



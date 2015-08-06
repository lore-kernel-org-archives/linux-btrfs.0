Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60816 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754873AbbHFImp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 04:42:45 -0400
Subject: Re: [PATCH] btrfs: qgroup: Fix a regression in qgroup reserved space.
To: <linux-btrfs@vger.kernel.org>, <clm@fb.com>
References: <1438584269-32634-1-git-send-email-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55C31E01.7010204@cn.fujitsu.com>
Date: Thu, 6 Aug 2015 16:42:41 +0800
MIME-Version: 1.0
In-Reply-To: <1438584269-32634-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Would you please consider including this patch into v4.2 if it is still 
possible?

Although the fix is still not perfect and just a hotfix, as qgroup 
reserve parts still have a lot of problems from design and a lot of 
operations can still cause reserve space leak.

But considering how easy it is to trigger, I still hope it to be merged 
asap before 4.2.


For the remaining qgroup reserve bugs(*), we hope to fix it in 4.3 with 
a new per-inode reserve space map mechanism, and just like the new 
qgroup codes, free reserved space at run delayed ref time.

It's never a small change, so definitely not suitable for current 4.2.

*: Known bugs
1) fallocate with already allocated space.
    Fallocate will reserve space for given range, even it is already
    allocate.
    So no way to release it and another source of leak.

2) Compress/inband-dedup
    Reserved space is before compression, but freed space is after
    compression.
    Inband-dedup is much the same.

3) Overlap buffered write.
    Buffered write will reserve space before write, but if two buffered
    write overlaps, the overlapped part will cause leak.

4) NODATACOW still cause EDQUOT even it's not beyond existing extent.
    NODATACOW shouldn't cause EDQUOT if it's rewritten existing extent.
    Although it doesn't increase rfer/excl counts, but it still reserve
    space and causing leak.

Thanks,
Qu

Qu Wenruo wrote on 2015/08/03 14:44 +0800:
> During the change to new btrfs extent-oriented qgroup implement, due to
> it doesn't use the old __qgroup_excl_accounting() for exclusive extent,
> it didn't free the reserved bytes.
>
> The bug will cause limit function go crazy as the reserved space is
> never freed, increasing limit will have no effect and still cause
> EQOUT.
>
> The fix is easy, just free reserved bytes for newly created exclusive
> extent as what it does before.
>
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Yang Dongsheng <yangds.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> To Chris:
>
> Would you please consider merging this patch in the late v4.2 merge
> window?
> As it's a huge regression and the fix is small enough and just does
> what it did before in __qgroup_excl_accounting() function.
>
> The corresponding test case will follow soon.
>
> And sorry for the regression I introduced.
>
> Thanks,
> Qu
> ---
>   fs/btrfs/qgroup.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index d5f1f03..1667567 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1618,6 +1618,11 @@ static int qgroup_update_counters(struct btrfs_fs_info *fs_info,
>   				/* Exclusive -> exclusive, nothing changed */
>   			}
>   		}
> +
> +		/* For exclusive extent, free its reserved bytes too */
> +		if (nr_old_roots == 0 && nr_new_roots == 1 &&
> +		    cur_new_count == nr_new_roots)
> +			qg->reserved -= num_bytes;
>   		if (dirty)
>   			qgroup_dirty(fs_info, qg);
>   	}
>

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27976 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751883AbbHaBoy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Aug 2015 21:44:54 -0400
Subject: Re: [PATCH] btrfs: Remove unneeded cast to s64 for qgroup rfer state
To: Alexandru Moise <00moses.alexander00@gmail.com>, <clm@fb.com>
References: <20150829114553.GA7522@gmail.com>
CC: <jbacik@fb.com>, <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wangsl-fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55E3B191.7030800@cn.fujitsu.com>
Date: Mon, 31 Aug 2015 09:44:49 +0800
MIME-Version: 1.0
In-Reply-To: <20150829114553.GA7522@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Alexandru Moise wrote on 2015/08/29 11:45 +0000:
> This patch reverts commit: b4fcd6be6bbd702ae1a6545c9b413681850a9814
> Wang Shilong added those casts as a workaround for a bug reproduced
> using the following steps:
>
> Steps to reproduce:
>>     	mkfs.btrfs <disk>
>>     	mount <disk> <mnt>
>>     	dd if=/dev/zero of=/<mnt>/data bs=1M count=10
>>     	sync
>>     	btrfs quota enable <mnt>
>>     	btrfs qgroup create 0/5 <mnt>
>>     	btrfs qgroup limit 5M 0/5 <mnt>
>>     	rm -f /<mnt>/data
>>     	sync
>>     	btrfs qgroup show <mnt>
>>     	dd if=/dev/zero of=data bs=1M count=1
>>
>>     >From the perspective of users, qgroup's referenced or exclusive
>>     is negative,but user can not continue to write data! a workaround
>>     way is to cast u64 to s64 when doing qgroup reservation
>
> I am unable to reproduce this problem without his modification.
> I could be wrong in reverting this, so I'm gonna CC Wang as well so
> he is aware of this patch.

The cast is a workaround for a quite old qgroup bug, which will cause 
excl/rfer overflow to minus.

The remove of cast rfer/exel now is OK, as qgroup keeps maturing, 
especially after 4.2-rc1 rfer/exel will keep sane under most case
(exception will be qgroup reassign and subvolume deletion, but will not 
case minus value even under than case).

But I'm not a fan to remove it now.
As qgroup still has a known huge bug for the qg->reserved part, we are 
aware of it and working on it actively.

So for such cleanup, I'd prefer to do it when we rework the accounting 
part of qgroup.

Thanks,
Qu

>
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
> ---
>   fs/btrfs/qgroup.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 8a82029..9c75e86 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2077,14 +2077,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
>   		qg = u64_to_ptr(unode->aux);
>
>   		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
> -		    qg->reserved + (s64)qg->rfer + num_bytes >
> +		    qg->reserved + qg->rfer + num_bytes >
>   		    qg->max_rfer) {
>   			ret = -EDQUOT;
>   			goto out;
>   		}
>
>   		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
> -		    qg->reserved + (s64)qg->excl + num_bytes >
> +		    qg->reserved + qg->excl + num_bytes >
>   		    qg->max_excl) {
>   			ret = -EDQUOT;
>   			goto out;
>

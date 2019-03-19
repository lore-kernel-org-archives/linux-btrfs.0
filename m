Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB681C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 03:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAAB720872
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 03:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfCSDbq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 23:31:46 -0400
Received: from mout.gmx.net ([212.227.17.20]:37233 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbfCSDbq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 23:31:46 -0400
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lb90f-1giHBY1BlZ-00kiTx; Tue, 19
 Mar 2019 04:31:38 +0100
Subject: Re: [PATCH 2/3] btrfs: Fix bound checking in
 qgroup_trace_new_subtree_blocks
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190318154520.4086-1-nborisov@suse.com>
 <20190318154520.4086-3-nborisov@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <760ce5a7-4ada-8642-89b9-3d8c79c7ad6e@gmx.com>
Date:   Tue, 19 Mar 2019 11:31:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190318154520.4086-3-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:XQENPR4Cx7TtK9500Uh9FrkiENttWCLxqDgstDC8DK5SRmMH+6n
 yPXFLeGmeI9/k3Rl5sT2m9YkbWlBAHau+oWIFJu55ichZbauXkKRJTxI+IMNscsvLvNfbzL
 mJqHM0YNwrW4kt9ChavU9ZAOalqSQf8pbI/vqE2HyJPCRxnYDSKtARu3BaH28qpii+R1xSC
 o93uiOk42cZS3SvVHRW5g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:p/6Fzvsut20=:HEGh19uUrhRU8+cYzDCogS
 +61rXRRVsfGR2NKhFMFZGAAcMi85hk0ovn+cNQZklX/Vp8qe1H7wsD7EoStphjWeT/gaj3rus
 SBBgPAqDbeokNtNhBVhU4ojY7NJmzJY3LBOTo61WaVyDLqjR+SyNU5jVoB50xqDbS8FbDdJ72
 8Yxuz9t6nWMHgUP65Jv3/N5J/mNPJ13ALNodASeb0hgAWIZUEP4HcB8TyVGuQ6PzAEP8KljdY
 i0PlQ2pttWY1rcoc1tuk/6q7C2BMbDl1BEz5A0T+TgMqc23+cy8c+GX+4j3VjU2QOsSWUCvQm
 j4swNq3XOBXPL4zMKAE0Ecit0l9LttLT4o9UqhC1hyg7P7gnUHzql1plcSJHmqKXpfBBWO4UZ
 OEbMszQxnB7LjvzIBSHXgPMm3XAFpJJVEBHHEZS7dDuqRR6kYBGXbv4AC8eu6HKAawjxew+D5
 pNbzkB7PhYARACwdKryuGSkgMr5D4K0cvQARJtgr/p+dUX09yxFJTb7DoUgcyqztZ9UEHyETw
 6zwaEriOj/Eq31w2trsKuu+OJ++hScgP9QtQzkfbgjKjLPDQlylZ87GoPsP2/LGhbVJlQLawG
 edscAeTolHc+qicZG96+KSc65F7aKNsOC0Uke9Dbb7WU7gEzpSHrhs0QAwlXwSzW3RMr7AuYq
 NeYpZw0Qk8cS12NPp5qoBM62d5JCllbQIOFgsXoNDjGoSJicwVFbchIGYHOzAE2OskhYldfAb
 kR8a8DyeQR40dN4KwQm/l4VdWfTveaKoZpGjEZc0Fxwd6VGU+dnRVKFAO8scZInpGEOUuswss
 lXe+2Vz+rbZAZmXHlT1JZm5J9xMF5H9tEBZKWKenr5m6Sj3x69hN3KnPFv90KbMJc673BjUxX
 H7L0PZFHFKA+qIjoI3unss5RxLJ7laCBwVClrRUsbSyLfKAqtiSRENttRjiLmcRWAF3qh4svd
 Lq4DRjD5YWw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/18 下午11:45, Nikolay Borisov wrote:
> If 'cur_level' is 7  then the bound checking at the top of the function
> will actually pass. Later on, it's possible to dereference
> ds_path->nodes[cur_level+1] which will be an out of bounds.
> 
> The correct check will be cur_level >= BTRFS_MAX_LEVEL - 1 .
> 
> Fixes-coverty-id: 1440918
> Fixes-coverty-id: 1440911
> Fixes: ea49f3e73c4b ("btrfs: qgroup: Introduce function to find all new tree blocks of reloc tree")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/qgroup.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index eb680b715dd6..7019edf5625c 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1922,8 +1922,8 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
>  	int i;
>  
>  	/* Level sanity check */
> -	if (cur_level < 0 || cur_level >= BTRFS_MAX_LEVEL ||
> -	    root_level < 0 || root_level >= BTRFS_MAX_LEVEL ||
> +	if (cur_level < 0 || cur_level >= BTRFS_MAX_LEVEL - 1 ||
> +	    root_level < 0 || root_level >= BTRFS_MAX_LEVEL - 1 ||
>  	    root_level < cur_level) {
>  		btrfs_err_rl(fs_info,
>  			"%s: bad levels, cur_level=%d root_level=%d",
> @@ -3482,7 +3482,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
>  	if (free && reserved)
>  		return qgroup_free_reserved_data(inode, reserved, start, len);
>  	extent_changeset_init(&changeset);
> -	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
> +	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
>  			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
>  	if (ret < 0)
>  		goto out;
> 

Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817653C583E
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813570; cv=none; b=DK3KHKsi+jbvkyfNWok4Pv4bYFoga7rYU0aqHnn4wA5htkuRxQHqLOXGFzQbelS+SP2BSskVizec0v94Xqa6LAu5WQhkeKrhjz8BdlC1F7xXWgv5fHqFZMmIqiowqx4vsxNemgcGGaaITKXpklrz6AZHDK/ZSxQ07HVWAcQCk8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813570; c=relaxed/simple;
	bh=YgH7tH94mWBCpGf34D6W7TeuerQxYVtHPu9eHEoa6gM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ogbPnpeu06om1otg3Npk5UGWj5w+8UaFKVbqzob8ACtrjDkltSgcgpiPSaKQf8s2l5E8hKfIf5exPzfYX2OVVxksmmy4r/LVjF5DYd9x7NNj/FuYO/B2AtC4pZHmQn+MrwSPblt0Zs8gVtZcxLLU3iEhurVNz1yUUGV+Cas/gWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=dZsOxXTZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=YzmdXZJZ; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="dZsOxXTZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YzmdXZJZ"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 108BE14000B8;
	Tue, 26 May 2026 12:39:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 26 May 2026 12:39:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779813565; x=1779899965; bh=0ONKbIw8kh
	qqK/TtmB691qX5S6WbtpTKKQIY29XkmXM=; b=dZsOxXTZe+1MkiEw09CiaoTemT
	Tq7g6YnWWfyA/NRSllGj4AHDFXFz/Ded972faEmyTufWolpFLfbpFLWnJRhf4MzR
	xOSojCG5XAgnaiw+kggYbR2ZKGuJz7+T5GAW8o0ORoCn6jA9qFkB0TTzXGVxf2kV
	wESfZGraU5+EO5FJggbhFlCjcwbzmJL5eldqIKHndP3JVlLp9OHDTVEYN33hPJLt
	BP7qs0PJKuKT/Zo5n1dXWyZsK2vl29sgyqxk6+EUmosaZkd10E1GsLSGGdhYT8N5
	bvmoHrvGsdcDJ2j8UigMkKyDnZT0kRda9/B1YKgyCeHiVuK1pIA7SYrOIJEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779813565; x=1779899965; bh=0ONKbIw8khqqK/TtmB691qX5S6WbtpTKKQI
	Y29XkmXM=; b=YzmdXZJZjd2HtpbwT06pLkRoNSywOFu4WnWFH1x+OSAtmJ5d5R/
	U42t6Pk6nVopP4Mf9KX/CGZcrcrkRDCbNs6MaGH6wlGVlVvOozYm5i1i4G1lpzCj
	VcyqH3cWqX7b1kUFGBjM90iH12uqJBKvfUrbi/849ZXlRawlkZomW0opK3YYIHup
	IQdgDKacCyoUuqr4rjugR+bJL5W8nNwbsEk/pSCsDiDFa0jmINBB5o2EeD/z5+1i
	uPYjMaAkvB43kXO7uwc0ktvk4IeAC0DZrXcEtDytUSFaoR1oWQ4Y21uXHJSxtp8q
	QVyoyN7SXaYnszo5m6KrWIRbfB/kFMd4SlA==
X-ME-Sender: <xms:vMwVahuvUQtkeRwWSADddYQKfSkg18hSHmUXX7xBqnfGHzafvw8SWw>
    <xme:vMwVagdwkeRMbJWGKtumAorFzP543pyvnd0Cf2rLriXBkVpUiNHwtGVo8LvN1MGUW
    hP72q6POojoWvD60BzeEb2USUc9XLhQUie_KFmD_bREdslwuqzziho>
X-ME-Received: <xmr:vMwVaibzT4nXM6NLMABWdCH7ccZsGwTav1Pb1_8jSlBtQB4T-ArXt4SlIxr5cdO2ib37uNvSVm_a_YgG7lLOMQIgADk>
X-ME-Proxy-Cause: dmFkZTFb7rETqYAUMiIBLKOYsffPZ61jyaKAdvU9jjUWddnFiYySQ2crOtkhLQx41ie4XH
    b1NbxmMv8xILtL1eBgKJCZxbxbvGEaHWN0mv2Njh0MAxQj5vXPV2PWbsxrlUTuZHQhdlUI
    U9GUPojc9geIm1TSaGU6J4JF/MoNDwdZ5w70VLehrw/bbP0MrosTmWUWkutk0smFodHVqF
    fvkpbg7kU8RJ85GSzoHOa4uQJP9vMKKTNwdnU7BKt778VT9XumyyjeZy5zeNa6nEdgZn6s
    4Ey1Y7p7qPBMYxCWH96rIHM717E0xUpPw3nuMT3c10yz8bOGlLD2PSc1TZXOVY30XIIqG/
    bc3qta3UHdc/83+UtCOduC+ERKXlDEIH+D8CxVxj5nABbPsqsJvgqOHhMq8nob4Qxyt4g2
    rGIlgGAJ1bC1q+aIfntNgi+WG1NbcvlhEhFef4yPWH6+omdE0B+DxpOVnAsweI7vXga6fM
    Dkt+mIQhjRPXJZ3Xs8UAn7OJ7aGenLXw7pQL/NlD03nv1UT14a403fQ3gkM6r05VlC/5sI
    bejLxI4xUHyeLufpiOkWW/M0c59fLRjI9TvenoNN4iJBLzMG6/R7hZr0d9yT69mTYJDY7E
    iEth/9y+fp6BZxj/cWIbEtxxlHJvu9+romHO2YuMD4EBG0aVsE0TzMJ6ehnw
X-ME-Proxy: <xmx:vMwVajX0YI4qZwSLA-C17Th44D-CgWUpj9fYSJcad7EQ6DxZSS4i-g>
    <xmx:vMwVakgWUrsBYZ-YNPKqBCNjaZHcSJ1bLC9lwjVNbP6vnuXouUDrbA>
    <xmx:vMwVahUY8Bmhe4MB84APynyNuLfxzRzmZgVW-rdYvCi1_lVHntMeWA>
    <xmx:vMwVarPRzQUupL2igmxBEL8GFmIZYNKAXe2D9cB6sIBALZcCcJo4ug>
    <xmx:vcwVatZh4zMIurm_6HrDITq_IAXc7Scq5E5uRjYUUxVBdTU2buGqaxx1>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 12:39:24 -0400 (EDT)
Date: Tue, 26 May 2026 09:39:12 -0700
From: Boris Burkov <boris@bur.io>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add message format for qgroupid
Message-ID: <20260526163850.GA1339601@zen.localdomain>
References: <20260523163341.243653-1-dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523163341.243653-1-dsterba@suse.com>

On Sat, May 23, 2026 at 06:33:41PM +0200, David Sterba wrote:
> The qgroupid has a specific format, add common format specifier, similar
> to what we have for checksums and keys.
> 

This is sweet, I hate typing that stuff out :)

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/fs.h     |  4 ++++
>  fs/btrfs/qgroup.c | 25 ++++++++++---------------
>  2 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index d3b439fd611f78..a0d4eb3d5ad22e 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -79,6 +79,10 @@ static_assert(sizeof(struct btrfs_super_block) == BTRFS_SUPER_INFO_SIZE);
>  #define BTRFS_KEY_FMT			"(%llu %u %llu)"
>  #define BTRFS_KEY_FMT_VALUE(key)	(key)->objectid, (key)->type, (key)->offset
>  
> +#define BTRFS_QGROUP_FMT		"%hu/%llu"
> +#define BTRFS_QGROUP_FMT_VALUE(qgroup)	btrfs_qgroup_level((qgroup)->qgroupid), \
> +					btrfs_qgroup_subvolid((qgroup)->qgroupid)
> +
>  /*
>   * Number of metadata items necessary for an unlink operation:
>   *
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 384622bd786997..502fb4a55cb227 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -373,10 +373,9 @@ static bool squota_check_parent_usage(struct btrfs_fs_info *fs_info, struct btrf
>  		    parent->excl_cmpr != excl_cmpr_sum || parent->rfer_cmpr != rfer_cmpr_sum);
>  
>  	WARN(mismatch,
> -	     "parent squota qgroup %hu/%llu has mismatched usage from its %d members. "
> +	     "parent squota qgroup " BTRFS_QGROUP_FMT " has mismatched usage from its %d members. "
>  	     "%llu %llu %llu %llu vs %llu %llu %llu %llu\n",
> -	     btrfs_qgroup_level(parent->qgroupid),
> -	     btrfs_qgroup_subvolid(parent->qgroupid), nr_members, parent->excl,
> +	     BTRFS_QGROUP_FMT_VALUE(parent), nr_members, parent->excl,
>  	     parent->rfer, parent->excl_cmpr, parent->rfer_cmpr, excl_sum,
>  	     rfer_sum, excl_cmpr_sum, rfer_cmpr_sum);
>  	return mismatch;
> @@ -652,9 +651,8 @@ bool btrfs_check_quota_leak(const struct btrfs_fs_info *fs_info)
>  			if (qgroup->rsv.values[i]) {
>  				ret = true;
>  				btrfs_warn(fs_info,
> -		"qgroup %hu/%llu has unreleased space, type %d rsv %llu",
> -				   btrfs_qgroup_level(qgroup->qgroupid),
> -				   btrfs_qgroup_subvolid(qgroup->qgroupid),
> +		"qgroup " BTRFS_QGROUP_FMT " has unreleased space, type %d rsv %llu",
> +				   BTRFS_QGROUP_FMT_VALUE(qgroup),
>  				   i, qgroup->rsv.values[i]);
>  			}
>  		}
> @@ -1863,9 +1861,8 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
>  		     qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS])) {
>  		DEBUG_WARN();
>  		btrfs_warn_rl(fs_info,
> -"to be deleted qgroup %u/%llu has non-zero numbers, data %llu meta prealloc %llu meta pertrans %llu",
> -			      btrfs_qgroup_level(qgroup->qgroupid),
> -			      btrfs_qgroup_subvolid(qgroup->qgroupid),
> +"to be deleted qgroup " BTRFS_QGROUP_FMT " has non-zero numbers, data %llu meta prealloc %llu meta pertrans %llu",
> +			      BTRFS_QGROUP_FMT_VALUE(qgroup),
>  			      qgroup->rsv.values[BTRFS_QGROUP_RSV_DATA],
>  			      qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC],
>  			      qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS]);
> @@ -1883,9 +1880,8 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
>  			     qgroup->rfer_cmpr || qgroup->excl_cmpr)) {
>  			DEBUG_WARN();
>  			qgroup_mark_inconsistent(fs_info,
> -				"to be deleted qgroup %u/%llu has non-zero numbers, rfer %llu rfer_cmpr %llu excl %llu excl_cmpr %llu",
> -				btrfs_qgroup_level(qgroup->qgroupid),
> -				btrfs_qgroup_subvolid(qgroup->qgroupid),
> +"to be deleted qgroup " BTRFS_QGROUP_FMT " has non-zero numbers, rfer %llu rfer_cmpr %llu excl %llu excl_cmpr %llu",
> +				BTRFS_QGROUP_FMT_VALUE(qgroup),
>  				qgroup->rfer, qgroup->rfer_cmpr,
>  				qgroup->excl, qgroup->excl_cmpr);
>  		}
> @@ -4971,9 +4967,8 @@ int btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
>  		ASSERT(qg->excl == qg->rfer);
>  		if (WARN_ON_ONCE(sign < 0 && qg->excl < num_bytes)) {
>  			btrfs_warn(fs_info,
> -				   "squota underflow qg %hu/%llu excl %llu num_bytes %llu",
> -				   btrfs_qgroup_level(qg->qgroupid),
> -				   btrfs_qgroup_subvolid(qg->qgroupid),
> +				   "squota underflow qg " BTRFS_QGROUP_FMT " excl %llu num_bytes %llu",
> +				   BTRFS_QGROUP_FMT_VALUE(qg),
>  				   qg->excl, num_bytes);
>  			qg->excl = 0;
>  			qg->rfer = 0;
> -- 
> 2.54.0
> 

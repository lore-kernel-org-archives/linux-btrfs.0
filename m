Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40210 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751413AbdJXLHP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 07:07:15 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 96B7AADC9
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 11:07:13 +0000 (UTC)
Subject: Re: [PATCH 2/6] btrfs: qgroup: Introduce helpers to update and access
 new qgroup rsv
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-3-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e2eda958-e17f-757b-f704-1b0371cd4ed7@suse.com>
Date: Tue, 24 Oct 2017 14:07:12 +0300
MIME-Version: 1.0
In-Reply-To: <20171024083941.21428-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.10.2017 11:39, Qu Wenruo wrote:
> Introduce helpers to:
> 
> 1) Get total reserved space
>    For limit calculation
> 
> 2) Increase reserved space for given type
> 2) Decrease reserved space for given type
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index fe3adb996883..04fd145516ad 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -47,6 +47,72 @@
>   *  - check all ioctl parameters
>   */
>  
> +/*
> + * Helpers to access qgroup reservation
> + *
> + * Callers should ensure the lock context and type are valid
> + */
> +
> +static u64 qgroup_rsv_total(const struct btrfs_qgroup *qgroup)
> +{
> +	u64 ret = 0;
> +	int i;
> +
> +	for (i = 0; i <= BTRFS_QGROUP_RSV_TYPES; i++)

So if you actually take up on my idea of having an explicit value which
denotes the end, the loop here would be just < *_END rather than the <=
which instantly looks suspicious of an off-by-one error.

> +		ret += qgroup->rsv.values[i];
> +
> +	return ret;
> +}
> +
> +static const char *qgroup_rsv_type_str(enum btrfs_qgroup_rsv_type type)
> +{
> +	if (type == BTRFS_QGROUP_RSV_DATA)
> +		return "data";
> +	if (type == BTRFS_QGROUP_RSV_META)
> +		return "meta";
> +	return NULL;
> +}
> +
> +static void qgroup_rsv_increase(struct btrfs_qgroup *qgroup, u64 num_bytes,
> +				enum btrfs_qgroup_rsv_type type)
> +{
> +	qgroup->rsv.values[type] += num_bytes;
> +}
> +
> +static void qgroup_rsv_decrease(struct btrfs_qgroup *qgroup, u64 num_bytes,
> +				enum btrfs_qgroup_rsv_type type)
> +{
> +	if (qgroup->rsv.values[type] >= num_bytes) {
> +		qgroup->rsv.values[type] -= num_bytes;
> +		return;
> +	}
> +#ifdef CONFIG_BTRFS_DEBUG
> +	WARN_RATELIMIT(1,
> +		"qgroup %llu %s reserved space underflow, have %llu to free %llu",
> +		qgroup->qgroupid, qgroup_rsv_type_str(type),
> +		qgroup->rsv.values[type], num_bytes);
> +#endif
> +	qgroup->rsv.values[type] = 0;
> +}


Perhaps these could be modelled after
block_rsv_use_bytes/block_rsv_add_bytes ? I'm not entirely sure of what
increasing the value actually does - reserving bytes or using already
reserved bytes, I guess it should be reserving. In this case what about
qgroup_bytes_reserve/qgroup_bytes_(free|unreserve) ?


> +
> +static void qgroup_rsv_increase_by_qgroup(struct btrfs_qgroup *dest,
> +					  struct btrfs_qgroup *src)
> +{
> +	int i;
> +
> +	for (i = 0; i <= BTRFS_QGROUP_RSV_TYPES; i++)
> +		qgroup_rsv_increase(dest, src->rsv.values[i], i);
> +}
> +
> +static void qgroup_rsv_decrease_by_qgroup(struct btrfs_qgroup *dest,
> +					  struct btrfs_qgroup *src)
> +{
> +	int i;
> +
> +	for (i = 0; i <= BTRFS_QGROUP_RSV_TYPES; i++)
> +		qgroup_rsv_decrease(dest, src->rsv.values[i], i);
> +}

Why don't you model these similar to what we already have for the block
rsv. In this case I believe those would correspond to the
btrfs_block_rsv_migrate. Admittedly we don't have a counterpart to
rsv_decrease_by_qgroup.


> +
>  static void btrfs_qgroup_update_old_refcnt(struct btrfs_qgroup *qg, u64 seq,
>  					   int mod)
>  {
> 

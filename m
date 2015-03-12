Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30244 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbbCLNqN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 09:46:13 -0400
Date: Thu, 12 Mar 2015 21:45:39 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Cleanup open-coded old/new_refcnt update
 and read.
Message-ID: <20150312134539.GA15352@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1426149207-7534-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426149207-7534-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 12, 2015 at 04:33:27PM +0800, Qu Wenruo wrote:
> Use inline functions to do such things, to improve readability.

This has actually hiden informations behind the helper function and
old_refcnt and new_refcnt can explain themselves, I don't see any benefit.

Thanks,

-liubo
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/qgroup.c | 102 ++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 65 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 97159a8..3f2a1e7 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -84,11 +84,58 @@ struct btrfs_qgroup {
>  
>  	/*
>  	 * temp variables for accounting operations
> +	 * Refer to qgroup_shared_accouting() for details.
>  	 */
>  	u64 old_refcnt;
>  	u64 new_refcnt;
>  };
>  
> +static void update_qg_refcnt(struct btrfs_qgroup *qg, u64 seq, int mod,
> +			     int update_old)
> +{
> +	if (update_old) {
> +		if (qg->old_refcnt < seq)
> +			qg->old_refcnt = seq;
> +		qg->old_refcnt += mod;
> +	} else {
> +		if (qg->new_refcnt < seq)
> +			qg->new_refcnt = seq;
> +		qg->new_refcnt += mod;
> +	}
> +}
> +
> +static void update_qg_old_refcnt(struct btrfs_qgroup *qg, u64 seq, int mod)
> +{
> +	update_qg_refcnt(qg, seq, mod, 1);
> +}
> +
> +static void update_qg_new_refcnt(struct btrfs_qgroup *qg, u64 seq, int mod)
> +{
> +	update_qg_refcnt(qg, seq, mod, 0);
> +}
> +
> +static inline u64 get_qg_refcnt(struct btrfs_qgroup *qg, u64 seq, int get_old)
> +{
> +	if (get_old) {
> +		if (qg->old_refcnt < seq)
> +			return 0;
> +		return qg->old_refcnt - seq;
> +	}
> +	if (qg->new_refcnt < seq)
> +		return 0;
> +	return qg->new_refcnt - seq;
> +}
> +
> +static inline u64 get_qg_old_refcnt(struct btrfs_qgroup *qg, u64 seq)
> +{
> +	return get_qg_refcnt(qg, seq, 1);
> +}
> +
> +static inline u64 get_qg_new_refcnt(struct btrfs_qgroup *qg, u64 seq)
> +{
> +	return get_qg_refcnt(qg, seq, 0);
> +}
> +
>  /*
>   * glue structure to represent the relations between qgroups.
>   */
> @@ -1497,6 +1544,7 @@ static int qgroup_calc_old_refcnt(struct btrfs_fs_info *fs_info,
>  		ULIST_ITER_INIT(&tmp_uiter);
>  		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
>  			struct btrfs_qgroup_list *glist;
> +			int mod;
>  
>  			qg = u64_to_ptr(tmp_unode->aux);
>  			/*
> @@ -1508,20 +1556,15 @@ static int qgroup_calc_old_refcnt(struct btrfs_fs_info *fs_info,
>  			 * upper level qgroups in order to determine exclusive
>  			 * counts.
>  			 *
> -			 * For rescan we want to set old_refcnt to seq so our
> -			 * exclusive calculations end up correct.
> +			 * For rescan none of the extent is recorded before so
> +			 * we just don't add old_refcnt.
>  			 */
>  			if (rescan)
> -				qg->old_refcnt = seq;
> -			else if (qg->old_refcnt < seq)
> -				qg->old_refcnt = seq + 1;
> +				mod = 0;
>  			else
> -				qg->old_refcnt++;
> -
> -			if (qg->new_refcnt < seq)
> -				qg->new_refcnt = seq + 1;
> -			else
> -				qg->new_refcnt++;
> +				mod = 1;
> +			update_qg_old_refcnt(qg, seq, mod);
> +			update_qg_new_refcnt(qg, seq, 1);
>  			list_for_each_entry(glist, &qg->groups, next_group) {
>  				ret = ulist_add(qgroups, glist->group->qgroupid,
>  						ptr_to_u64(glist->group),
> @@ -1619,10 +1662,8 @@ next:
>  			qg->old_refcnt = seq + 1;
>  		else
>  			qg->old_refcnt++;
> -		if (qg->new_refcnt < seq)
> -			qg->new_refcnt = seq + 1;
> -		else
> -			qg->new_refcnt++;
> +		update_qg_old_refcnt(qg, seq, 1);
> +		update_qg_new_refcnt(qg, seq, 1);
>  		list_for_each_entry(glist, &qg->groups, next_group) {
>  			ret = ulist_add(qgroups, glist->group->qgroupid,
>  					ptr_to_u64(glist->group), GFP_ATOMIC);
> @@ -1663,17 +1704,10 @@ static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
>  		struct btrfs_qgroup_list *glist;
>  
>  		qg = u64_to_ptr(unode->aux);
> -		if (oper->type == BTRFS_QGROUP_OPER_ADD_SHARED) {
> -			if (qg->new_refcnt < seq)
> -				qg->new_refcnt = seq + 1;
> -			else
> -				qg->new_refcnt++;
> -		} else {
> -			if (qg->old_refcnt < seq)
> -				qg->old_refcnt = seq + 1;
> -			else
> -				qg->old_refcnt++;
> -		}
> +		if (oper->type == BTRFS_QGROUP_OPER_ADD_SHARED)
> +			update_qg_new_refcnt(qg, seq, 1);
> +		else
> +			update_qg_old_refcnt(qg, seq, 1);
>  		list_for_each_entry(glist, &qg->groups, next_group) {
>  			ret = ulist_add(tmp, glist->group->qgroupid,
>  					ptr_to_u64(glist->group), GFP_ATOMIC);
> @@ -1706,11 +1740,14 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
>  		bool dirty = false;
>  
>  		qg = u64_to_ptr(unode->aux);
> +		cur_old_count = get_qg_old_refcnt(qg, seq);
> +		cur_new_count = get_qg_new_refcnt(qg, seq);
> +
>  		/*
>  		 * Wasn't referenced before but is now, add to the reference
>  		 * counters.
>  		 */
> -		if (qg->old_refcnt <= seq && qg->new_refcnt > seq) {
> +		if (cur_old_count == 0 && cur_new_count > 0) {
>  			qg->rfer += num_bytes;
>  			qg->rfer_cmpr += num_bytes;
>  			dirty = true;
> @@ -1720,21 +1757,12 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
>  		 * Was referenced before but isn't now, subtract from the
>  		 * reference counters.
>  		 */
> -		if (qg->old_refcnt > seq && qg->new_refcnt <= seq) {
> +		if (cur_old_count > 0 && cur_new_count == 0) {
>  			qg->rfer -= num_bytes;
>  			qg->rfer_cmpr -= num_bytes;
>  			dirty = true;
>  		}
>  
> -		if (qg->old_refcnt < seq)
> -			cur_old_count = 0;
> -		else
> -			cur_old_count = qg->old_refcnt - seq;
> -		if (qg->new_refcnt < seq)
> -			cur_new_count = 0;
> -		else
> -			cur_new_count = qg->new_refcnt - seq;
> -
>  		/*
>  		 * If our refcount was the same as the roots previously but our
>  		 * new count isn't the same as the number of roots now then we
> -- 
> 2.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

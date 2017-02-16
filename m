Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34754 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbdBPIpN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 03:45:13 -0500
Received: by mail-wm0-f66.google.com with SMTP id c85so1963244wmi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Feb 2017 00:45:12 -0800 (PST)
Subject: Re: [PATCH v2] btrfs: qgroup: Move half of the qgroup accounting time
 out of commit trans
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170215024303.26907-1-quwenruo@cn.fujitsu.com>
Cc: Filipe Manana <fdmanana@suse.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <cc13d0b2-9355-e61b-04c4-49f354aada58@gmail.com>
Date: Thu, 16 Feb 2017 10:45:08 +0200
MIME-Version: 1.0
In-Reply-To: <20170215024303.26907-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just a minor nit.

On 15.02.2017 04:43, Qu Wenruo wrote:
> Just as Filipe pointed out, the most time consuming parts of qgroup are
> btrfs_qgroup_account_extents() and
> btrfs_qgroup_prepare_account_extents().
> Which both call btrfs_find_all_roots() to get old_roots and new_roots
> ulist.
> 
> What makes things worse is, we're calling that expensive
> btrfs_find_all_roots() at transaction committing time with
> TRANS_STATE_COMMIT_DOING, which will blocks all incoming transaction.
> 
> Such behavior is necessary for @new_roots search as current
> btrfs_find_all_roots() can't do it correctly so we do call it just
> before switch commit roots.
> 
> However for @old_roots search, it's not necessary as such search is
> based on commit_root, so it will always be correct and we can move it
> out of transaction committing.
> 
> This patch moves the @old_roots search part out of
> commit_transaction(), so in theory we can half the time qgroup time
> consumption at commit_transaction().
> 
> But please note that, this won't speedup qgroup overall, the total time
> consumption is still the same, just reduce the performance stall.
> 
> Cc: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2:
>   Update commit message to make it more clear.
>   Don't call btrfs_find_all_roots() before insert qgroup extent record,
>   so we can avoid wasting CPU for already inserted qgroup extent record.
> 
> PS:
> If and only if we have fixed and proved btrfs_find_all_roots() can
> get correct result with current root, then we can move all
> expensive btrfs_find_all_roots() out of transaction committing.
> 
> However I strongly doubt if it's possible with current delayed ref,
> and without such prove, move btrfs_find_all_roots() for @new_roots
> out of transaction committing will just screw up qgroup accounting.
> 
> ---
>  fs/btrfs/delayed-ref.c | 20 ++++++++++++++++----
>  fs/btrfs/qgroup.c      | 33 +++++++++++++++++++++++++++++----
>  fs/btrfs/qgroup.h      | 33 ++++++++++++++++++++++++++++++---
>  3 files changed, 75 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index ef724a5fc30e..0ee927ef5a71 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -550,13 +550,14 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>  		     struct btrfs_delayed_ref_node *ref,
>  		     struct btrfs_qgroup_extent_record *qrecord,
>  		     u64 bytenr, u64 num_bytes, u64 ref_root, u64 reserved,
> -		     int action, int is_data)
> +		     int action, int is_data, int *qrecord_inserted_ret)
>  {
>  	struct btrfs_delayed_ref_head *existing;
>  	struct btrfs_delayed_ref_head *head_ref = NULL;
>  	struct btrfs_delayed_ref_root *delayed_refs;
>  	int count_mod = 1;
>  	int must_insert_reserved = 0;
> +	int qrecord_inserted = 0;

Why use an integer when you only require a boolean value? I doubt it
will make much difference at asm level if you switch to bool but at
least it will make it more apparent it's being used as a true|false
variable. The same comment applies to other functions where you've used
similar variable.


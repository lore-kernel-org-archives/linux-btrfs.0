Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab3DWPg0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 11:36:26 -0400
Date: Tue, 23 Apr 2013 17:36:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        wangshilong1991@gmail.com, dsterba@suse.cz
Subject: Re: [PATCH v3 3/3] Btrfs: automatic rescan after "quota enable"
 command
Message-ID: <20130423153623.GT16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366716411-9750-1-git-send-email-list.btrfs@jan-o-sch.net>
 <1366716411-9750-4-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366716411-9750-4-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 23, 2013 at 01:26:51PM +0200, Jan Schmidt wrote:
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1494,10 +1494,14 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
>  {
>  	struct btrfs_root *quota_root = fs_info->quota_root;
>  	int ret = 0;
> +	int start_rescan_worker = 0;
>  
>  	if (!quota_root)
>  		goto out;
>  
> +	if (!fs_info->quota_enabled && fs_info->pending_quota_state)
> +		start_rescan_worker = 1;
> +
>  	fs_info->quota_enabled = fs_info->pending_quota_state;
>  
>  	spin_lock(&fs_info->qgroup_lock);
> @@ -1523,6 +1527,12 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
>  	if (ret)
>  		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>  
> +	if (start_rescan_worker) {
> +		ret = btrfs_qgroup_rescan(fs_info);

btrfs_run_qgroups() is called from transaction commit and does BUG_ON
the return value.

btrfs_qgroup_rescan can return -EINPROGRESS if the rescan is in progress
and this is propagated back to trans commit. So the rescan triggered by
ioctl may cause a crash, unless I'm missing something.

The original question I've had is what sort of work does rescan do
because it's on the commit path and we don't want to add more work and
delay commit.

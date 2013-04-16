Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51198 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab3DPMzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 08:55:09 -0400
Received: by mail-pb0-f54.google.com with SMTP id xa7so282576pbc.13
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 05:55:09 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v2 3/3] Btrfs: automatic rescan after "quota enable" command
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1366101920-13083-4-git-send-email-list.btrfs@jan-o-sch.net>
Date: Tue, 16 Apr 2013 20:55:02 +0800
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
        "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>
Message-Id: <98173DCE-85FC-44AD-84E1-FA6D2E606714@gmail.com>
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net> <1366101920-13083-4-git-send-email-list.btrfs@jan-o-sch.net>
To: "chris.mason@fusionio.com" <chris.mason@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

	I' ve put my efforts in btrfs quota for a period of time. and i send a bunch of patches
about btrfs quota.
	If you pull Jan's qgroup rescan patches, i'd like that you pull my this patch firstly:
	https://patchwork.kernel.org/patch/2402871/
	Jan's group rescan patch relies on this patch.

Besides, i make a patch-set  to fix a btrfs quota's race condition:
	https://patchwork.kernel.org/patch/2402901/
	https://patchwork.kernel.org/patch/2402911/
	https://patchwork.kernel.org/patch/2402881/
	https://patchwork.kernel.org/patch/2402891/
	https://patchwork.kernel.org/patch/2402921/

Some bug fixes about btrfs quota:
	https://patchwork.kernel.org/patch/2356111/	
	https://patchwork.kernel.org/patch/2402941/
	https://patchwork.kernel.org/patch/2407571/
	https://patchwork.kernel.org/patch/2420731/	
	https://patchwork.kernel.org/patch/2426721/
	https://patchwork.kernel.org/patch/2445051/
	https://patchwork.kernel.org/patch/2368341/
	https://patchwork.kernel.org/patch/2368291/
	

This patch improve performances of  ulist that btrfs quota ,send
relies on this:
	https://patchwork.kernel.org/patch/2435001/

some minor cleanups:
	https://patchwork.kernel.org/patch/2441951/ 
	https://patchwork.kernel.org/patch/2444521/
	https://patchwork.kernel.org/patch/2448741/


These patches are mainly related to btrfs quota. and i have sent them
to btrfs list  reviewed by the people for a period of time. Thanks to Miao Xie's help
to my efforts in btrfs. And Arne Jasen, Jan schdmit , David really help review
my patch, many thanks.

Every efforts i have made is to make btrfs quota works well. After you pull
my patches and Jan's qgroup rescan patch, i will have a deep look at codes, and
test Jan's patch.

I am really newbie, and usually  makes a lot of mistakes.. forgive me if i do
something wrong¡­.


Thanks,
Wang

> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
> fs/btrfs/qgroup.c |   10 ++++++++++
> 1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index bb081b5..0ea2c3e 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1356,10 +1356,14 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
> {
> 	struct btrfs_root *quota_root = fs_info->quota_root;
> 	int ret = 0;
> +	int start_rescan_worker = 0;
> 
> 	if (!quota_root)
> 		goto out;
> 
> +	if (!fs_info->quota_enabled && fs_info->pending_quota_state)
> +		start_rescan_worker = 1;
> +
> 	fs_info->quota_enabled = fs_info->pending_quota_state;
> 
> 	spin_lock(&fs_info->qgroup_lock);
> @@ -1385,6 +1389,12 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
> 	if (ret)
> 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> 
> +	if (start_rescan_worker) {
> +		ret = btrfs_qgroup_rescan(fs_info);
> +		if (ret)
> +			pr_err("btrfs: start rescan quota failed: %d\n", ret);
> +	}
> +
> out:
> 
> 	return ret;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


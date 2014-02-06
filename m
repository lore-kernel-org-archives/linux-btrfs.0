Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61539 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751426AbaBFV2s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 16:28:48 -0500
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s16LO7Vh017727
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Feb 2014 13:28:48 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1hvfp68m54-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 13:28:48 -0800
Message-ID: <52F3FE8D.8040706@fb.com>
Date: Thu, 6 Feb 2014 16:28:45 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: balance delayed inode updates
References: <1391720873-4961-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1391720873-4961-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/06/2014 04:07 PM, Josef Bacik wrote:
> While trying to reproduce a delayed ref problem I noticed the box kept falling
> over using all 80gb of my ram with btrfs_inode's and btrfs_delayed_node's.
> Turns out this is because we only throttle delayed inode updates in
> btrfs_dirty_inode, which doesn't actually get called that often, especially when
> all you are doing is creating a bunch of files.  So balance delayed inode
> updates everytime we create a new inode.  With this patch we no longer use up
> all of our ram with delayed inode updates.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>   fs/btrfs/extent-tree.c | 1 +
>   fs/btrfs/inode.c       | 4 ++++
>   2 files changed, 5 insertions(+)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9c9ecc9..1d9d9ce 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2660,6 +2660,7 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
>   		atomic_read(&trans->transaction->delayed_refs.num_entries);
>   	u64 avg_runtime;
>
> +	return 1;
>   	smp_mb();

Do git add for the file I want, do git commit -a anyway.

Josef

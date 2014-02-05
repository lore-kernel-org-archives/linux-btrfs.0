Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29061 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaBENC0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Feb 2014 08:02:26 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s15D2PbR028420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Feb 2014 13:02:26 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s15D2OOA023210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Feb 2014 13:02:24 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s15D2OY1005579
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Feb 2014 13:02:24 GMT
Message-ID: <52F2365D.7090609@oracle.com>
Date: Wed, 05 Feb 2014 21:02:21 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: looping across fs_devices isn't necessary
References: <1391605052-15198-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1391605052-15198-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  This patch was incomplete. Kindly ignore.

Thanks, Anand


On 02/05/14 08:57 PM, Anand Jain wrote:
> btrfs_show_devname() is trying to know dev name with
> lowest devid for a given FSID, so looping across the
> FSID isn't necessary
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   fs/btrfs/super.c |   18 +++++++-----------
>   1 files changed, 7 insertions(+), 11 deletions(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 378157c..6ed76d8 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1885,22 +1885,18 @@ static int btrfs_unfreeze(struct super_block *sb)
>   static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
>   {
>   	struct btrfs_fs_info *fs_info = btrfs_sb(root->d_sb);
> -	struct btrfs_fs_devices *cur_devices;
>   	struct btrfs_device *dev, *first_dev = NULL;
>   	struct list_head *head;
>   	struct rcu_string *name;
>
>   	mutex_lock(&fs_info->fs_devices->device_list_mutex);
> -	cur_devices = fs_info->fs_devices;
> -	while (cur_devices) {
> -		head = &cur_devices->devices;
> -		list_for_each_entry(dev, head, dev_list) {
> -			if (dev->missing)
> -				continue;
> -			if (!first_dev || dev->devid < first_dev->devid)
> -				first_dev = dev;
> -		}
> -		cur_devices = cur_devices->seed;
> +
> +	head = &fs_info->fs_devices->devices;
> +	list_for_each_entry(dev, head, dev_list) {
> +		if (dev->missing)
> +			continue;
> +		if (!first_dev || dev->devid < first_dev->devid)
> +			first_dev = dev;
>   	}
>
>   	if (first_dev) {
>

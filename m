Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39188 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab2K0S0a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Nov 2012 13:26:30 -0500
Message-ID: <50B505C1.8050205@oracle.com>
Date: Wed, 28 Nov 2012 02:26:09 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: add label to snapshot and subvol
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com> <1353041547-10088-1-git-send-email-Anand.Jain@oracle.com> <1353041547-10088-3-git-send-email-Anand.Jain@oracle.com> <50A5DE20.7080600@cn.fujitsu.com>
In-Reply-To: <50A5DE20.7080600@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Maio,

  Thanks for the review.
  Was away for sometime sorry for delay, have sent out the
  patch with review comments accepted.

-Anand

On 11/16/2012 02:33 PM, Miao Xie wrote:
> Hi, Anand
>
> On fri, 16 Nov 2012 12:52:25 +0800, Anand jain wrote:
>> +static int btrfs_ioctl_subvol_getlabel(struct btrfs_root *root,
>> +						void __user *arg)
>> +{
>> +	char *label;
>> +
>> +	label = btrfs_root_label(&root->root_item);
>> +	if (copy_to_user(arg, label, BTRFS_SUBVOL_LABEL_SIZE))
>> +		return -EFAULT;
>> +	return 0;
>> +}
>> +
>> +static int btrfs_ioctl_subvol_setlabel(struct btrfs_root *root,
>> +						void __user *arg)
>> +{
>> +	char label[BTRFS_SUBVOL_LABEL_SIZE+1];
>> +	struct btrfs_trans_handle *trans;
>> +
>> +	if (copy_from_user(label, arg, BTRFS_SUBVOL_LABEL_SIZE))
>> +		return -EFAULT;
>> +	trans = btrfs_join_transaction(root);
>> +	if (IS_ERR(trans))
>> +		return PTR_ERR(trans);
>> +	btrfs_root_set_label(&root->root_item, label);
>> +	btrfs_end_transaction(trans, root);
>
> We need a lock to protect the label, and besides that, we need to get the write
> access before we set the label for the subvolume.
>
> Thanks
> Miao
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

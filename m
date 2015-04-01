Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48512 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbbDAGni (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 02:43:38 -0400
Message-ID: <551B9333.8070805@oracle.com>
Date: Wed, 01 Apr 2015 14:41:55 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org
CC: jeffm@suse.com
Subject: Re: [PATCH v2] Btrfs: add debugfs file to test transaction aborts
References: <1427829524-23946-1-git-send-email-fdmanana@suse.com> <1427843497-7733-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1427843497-7733-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> +bool debugfs_abort_transaction(struct btrfs_fs_info *fs_info)
> +{
> +	if (!btrfs_debugfs_label_trans_abort[0])
> +		return false;
> +	return strcmp(fs_info->super_copy->label,
> +		      btrfs_debugfs_label_trans_abort) == 0;
> +}
> +

  label is not mandatory to be present.

  did I missing something ?

Thanks, Anand

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:51755 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726204AbeHERiT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Aug 2018 13:38:19 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id 6CB1C1801A8A2
        for <linux-btrfs@vger.kernel.org>; Sun,  5 Aug 2018 15:27:54 +0000 (UTC)
Message-ID: <5b2806ada98cfca4346e48f1943aca6da0cda4a6.camel@perches.com>
Subject: Re: [PATCH 1/3] fs/btrfs/disk-io: Remove unneeded variable "err"
From: Joe Perches <joe@perches.com>
To: zhong jiang <zhongjiang@huawei.com>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 05 Aug 2018 08:27:49 -0700
In-Reply-To: <1533481371-21349-2-git-send-email-zhongjiang@huawei.com>
References: <1533481371-21349-1-git-send-email-zhongjiang@huawei.com>
         <1533481371-21349-2-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2018-08-05 at 23:02 +0800, zhong jiang wrote:
> The err is not used after initalization, So remove it and make
> the function to be void function.
[]
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
[]
> @@ -4193,7 +4192,6 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  	if (atomic_read(&delayed_refs->num_entries) == 0) {
>  		spin_unlock(&delayed_refs->lock);
>  		btrfs_info(fs_info, "delayed_refs has NO entry");
> -		return ret;

Think a little more about this please.
This is not a sensible removal.

>  	}
>  
>  	while ((node = rb_first(&delayed_refs->href_root)) != NULL) {


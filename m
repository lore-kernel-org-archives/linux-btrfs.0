Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbaEVLlL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 07:41:11 -0400
Date: Thu, 22 May 2014 13:41:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, sandeen@redhat.com,
        rm@romanrm.net
Subject: Re: [PATCH 1/2 v3] btrfs: label should not contain return char
Message-ID: <20140522114108.GA5346@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
 <1400755272-22590-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400755272-22590-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 22, 2014 at 06:41:11PM +0800, Anand Jain wrote:
> @@ -385,7 +392,8 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
>  		return PTR_ERR(trans);
>  
>  	spin_lock(&root->fs_info->super_lock);
> -	strcpy(fs_info->super_copy->label, buf);
> +	strncpy(fs_info->super_copy->label, buf, p_len);
> +	memset(fs_info->super_copy->label + p_len, '\0', 1);

This looks strange, memset of length 1?

Anyway, I think the label buffer should be zeroed at the empty space, so
the idea is

	memset(fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE):
	memcpy(fs_info->super_copy->label, buf, p_len);

Not super efficient, but works.

>  	spin_unlock(&root->fs_info->super_lock);
>  	ret = btrfs_commit_transaction(trans, root);

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758945Ab3DCOgC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Apr 2013 10:36:02 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r33Ea12T013063
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Apr 2013 10:36:02 -0400
Message-ID: <515C3E50.60807@redhat.com>
Date: Wed, 03 Apr 2013 09:36:00 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: abort unlink trans in missed error case
References: <1364936536-13130-1-git-send-email-zab@redhat.com>
In-Reply-To: <1364936536-13130-1-git-send-email-zab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/2/13 4:02 PM, Zach Brown wrote:
> __btrfs_unlink_inode() aborts its transaction when it sees errors after
> it removes the directory item.  But it missed the case where
> btrfs_del_dir_entries_in_log() returns an error.  If this happens then
> the unlink appears to fail but the items have been removed without
> updating the directory size.  The directory then has leaked bytes in
> i_size and can never be removed.
> 
> Adding the missing transaction abort at least makes this failure
> consistent with the other failure cases.
> 
> I noticed this while reading the code after someone on irc reported
> having a directory with i_size but no entries.  I tested it by forcing
> btrfs_del_dir_entries_in_log() to return -ENOMEM.

I was wondering if the transaction support should just be in the
err: goto case, and went looking.

I'm not familiar enough with this stuff yet, but what if i.e.
btrfs_delete_one_dir_name fails, should that also abort the transaction?

> Signed-off-by: Zach Brown <zab@redhat.com>
> ---
>  fs/btrfs/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d96ee30..80676ee 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3619,6 +3619,8 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  					   dir, index);
>  	if (ret == -ENOENT)
>  		ret = 0;
> +	else if (ret)
> +		btrfs_abort_transaction(trans, root, ret);
>  err:
>  	btrfs_free_path(path);
>  	if (ret)
> 


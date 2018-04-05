Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46146 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeDEJkR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Apr 2018 05:40:17 -0400
Subject: Re: [PATCH 06/16] btrfs: move clearing of EXCL_OP out of
 __cancel_balance
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <ee98f1c7110273148101478e302de3783e7b8a3b.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0ba1d0f6-0fd8-dd26-9efa-23a22a55226f@oracle.com>
Date: Thu, 5 Apr 2018 17:42:14 +0800
MIME-Version: 1.0
In-Reply-To: <ee98f1c7110273148101478e302de3783e7b8a3b.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> @@ -3926,11 +3925,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>   	return ret;
>   out:
>   	if (bctl->flags & BTRFS_BALANCE_RESUME)
> -		__cancel_balance(fs_info);
> -	else {
> +		reset_balance_state(fs_info);

  reset_balance_state() is something unrelated. More over compile fails 
at this patch.

----
fs/btrfs/volumes.c: In function ‘btrfs_balance’:
fs/btrfs/volumes.c:3928:3: error: implicit declaration of function 
‘reset_balance_state’; did you mean ‘insert_balance_item’? 
[-Werror=implicit-function-declaration]
    reset_balance_state(fs_info);
----

Thanks, Anand

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30569 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbcJJKwJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 06:52:09 -0400
Subject: Re: [PATCH] btrfs-progs: btrfstune: Register new UUIDs after uuid
 change
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20161010092101.469-1-quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d74cdd9e-ad05-3d33-111e-92308c7b9775@oracle.com>
Date: Mon, 10 Oct 2016 18:54:08 +0800
MIME-Version: 1.0
In-Reply-To: <20161010092101.469-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/10/16 17:21, Qu Wenruo wrote:
> For multi-device btrfs, after UUID change we should info kernel, or new
> fs can't be mounted due to false alert on missing devices.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  btrfstune.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/btrfstune.c b/btrfstune.c
> index 15dde90..23d06ce 100644
> --- a/btrfstune.c
> +++ b/btrfstune.c
> @@ -369,6 +369,15 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
>  	fs_info->new_fsid = NULL;
>  	fs_info->new_chunk_tree_uuid = NULL;
>  	printf("Fsid change finished\n");
> +
> +	/*
> +	 * Register new devices, or multi-volume btrfs can't be mounted until
> +	 * device scan happens.
> +	 * Ignore any error, as such register is optional.
> +	 */
> +	printf("Register new UUIDs(error can be ignored)\n");

  Whats the error in particular in this context. ?

> +	btrfs_register_all_devices();

  That means after a reboot -> change uuid it will register the devices 
though the devices weren't registered to the kernel before.

  Its fair enough just remind user to run dev scan so that kernel can 
see them.

Thanks, Anand


> +
>  out:
>  	return ret;
>  }
>

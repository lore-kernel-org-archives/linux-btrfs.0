Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40823 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3KGEVW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 23:21:22 -0500
Message-ID: <527B1744.5080705@oracle.com>
Date: Thu, 07 Nov 2013 12:29:56 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/16] btrfs-progs: btrfs_scan_kernel(): fd==0 is not
 an error
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com> <1383779755-18228-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-10-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Reviewed-by: Anand Jain <anand.jain@oracle.com>


On 11/07/2013 07:15 AM, Eric Sandeen wrote:
> The error return from open is -1, so test that, not 0,
> for success/failure.
>
> Resolves-Coverity-CID: 1125931
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>   cmds-filesystem.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index e6642ef..df9d1ff 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -362,13 +362,13 @@ static int btrfs_scan_kernel(void *search)
>   		}
>
>   		fd = open(mnt->mnt_dir, O_RDONLY);
> -		if (fd > 0 && !get_df(fd, &space_info_arg)) {
> +		if ((fd != -1) && !get_df(fd, &space_info_arg)) {
>   			get_label_mounted(mnt->mnt_dir, label);
>   			print_one_fs(&fs_info_arg, dev_info_arg,
>   					space_info_arg, label, mnt->mnt_dir);
>   			free(space_info_arg);
>   		}
> -		if (fd > 0)
> +		if (fd != -1)
>   			close(fd);
>   		free(dev_info_arg);
>   	}
>

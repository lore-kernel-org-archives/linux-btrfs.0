Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54063 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaGJMfL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 08:35:11 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 1/4] btrfs-progs: Check fstype in find_mount_root()
Date: Thu, 10 Jul 2014 14:35:09 +0200
Message-ID: <3195117.mHaDz375Rn@merkaba>
In-Reply-To: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 10. Juli 2014, 11:05:10 schrieb Qu Wenruo:
> When calling find_mount_root(), caller in fact wants to find the mount
> point of *BTRFS*.
> 
> So also check ent->fstype in find_mount_root() and output proper error
> messages if needed.
> This will suppress a lot of "Inapproiate ioctl for device" error
> message.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  utils.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/utils.c b/utils.c
> index 993d085..507ec6c 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2412,6 +2412,7 @@ int find_mount_root(const char *path, char
> **mount_root) struct mntent *ent;
>  	int len;
>  	int ret;
> +	int not_btrfs;
>  	int longest_matchlen = 0;
>  	char *longest_match = NULL;
> 
> @@ -2432,6 +2433,10 @@ int find_mount_root(const char *path, char
> **mount_root) free(longest_match);
>  				longest_matchlen = len;
>  				longest_match = strdup(ent->mnt_dir);
> +				if (strcmp(ent->mnt_type, "btrfs"))
> +					not_btrfs = 1;
> +				else
> +					not_btrfs = 0;
>  			}
>  		}
>  	}
> @@ -2443,6 +2448,12 @@ int find_mount_root(const char *path, char
> **mount_root) path);
>  		return -ENOENT;
>  	}
> +	if (not_btrfs) {
> +		fprintf(stderr,
> +			"ERROR: %s does not belong to a btrfs mount points.\n",

Just a typo: mount point

> +			path);
> +		return -EINVAL;
> +	}
> 
>  	ret = 0;
>  	*mount_root = realpath(longest_match, NULL);

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42635 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaGJHde (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 03:33:34 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 8769E3EE1DF
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 16:33:32 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 91B33AC08B0
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 16:33:31 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 40BD81DB8037
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 16:33:31 +0900 (JST)
Received: from G01JPEXCHKW13.g01.fujitsu.local (G01JPEXCHKW13.g01.fujitsu.local [10.0.194.52])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 657D3BD68BB
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 16:33:30 +0900 (JST)
Message-ID: <53BE41C3.1050804@jp.fujitsu.com>
Date: Thu, 10 Jul 2014 16:33:23 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] btrfs-progs: Integrate error message output into
 find_mount_root().
References: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com> <1404961513-14614-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1404961513-14614-2-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

(2014/07/10 12:05), Qu Wenruo wrote:
> Before this patch, find_mount_root() and the caller both output error
> message, which sometimes make the output duplicated and hard to judge
> what the problem is.
> 
> This pathh will integrate all the error messages output into
> find_mount_root() to give more meaning error prompt and remove the
> unneeded caller error messages.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   cmds-receive.c   |  2 --
>   cmds-send.c      |  8 +-------
>   cmds-subvolume.c |  5 +----
>   utils.c          | 15 ++++++++++++---
>   4 files changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/cmds-receive.c b/cmds-receive.c
> index 48380a5..084d97d 100644
> --- a/cmds-receive.c
> +++ b/cmds-receive.c
> @@ -981,8 +981,6 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
>   	ret = find_mount_root(dest_dir_full_path, &r->root_path);
>   	if (ret < 0) {
>   		ret = -EINVAL;
> -		fprintf(stderr, "ERROR: failed to determine mount point "
> -			"for %s\n", dest_dir_full_path);
>   		goto out;
>   	}
>   	r->mnt_fd = open(r->root_path, O_RDONLY | O_NOATIME);
> diff --git a/cmds-send.c b/cmds-send.c
> index 9a73b32..091f32b 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -357,8 +357,6 @@ static int init_root_path(struct btrfs_send *s, const char *subvol)
>   	ret = find_mount_root(subvol, &s->root_path);
>   	if (ret < 0) {
>   		ret = -EINVAL;
> -		fprintf(stderr, "ERROR: failed to determine mount point "
> -				"for %s\n", subvol);
>   		goto out;
>   	}
>   
> @@ -622,12 +620,8 @@ int cmd_send(int argc, char **argv)
>   		}
>   
>   		ret = find_mount_root(subvol, &mount_root);
> -		if (ret < 0) {
> -			fprintf(stderr, "ERROR: find_mount_root failed on %s: "
> -					"%s\n", subvol,
> -				strerror(-ret));
> +		if (ret < 0)
>   			goto out;
> -		}
>   		if (strcmp(send.root_path, mount_root) != 0) {
>   			ret = -EINVAL;
>   			fprintf(stderr, "ERROR: all subvols must be from the "
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 639fb10..b252eab 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -981,11 +981,8 @@ static int cmd_subvol_show(int argc, char **argv)
>   	}
>   
>   	ret = find_mount_root(fullpath, &mnt);
> -	if (ret < 0) {
> -		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
> -				"%s\n", fullpath, strerror(-ret));
> +	if (ret < 0)
>   		goto out;
> -	}
>   	ret = 1;
>   	svpath = get_subvol_name(mnt, fullpath);
>   
> diff --git a/utils.c b/utils.c
> index 507ec6c..07173ee 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2417,13 +2417,19 @@ int find_mount_root(const char *path, char **mount_root)
>   	char *longest_match = NULL;
>   
>   	fd = open(path, O_RDONLY | O_NOATIME);
> -	if (fd < 0)
> +	if (fd < 0) {
> +		fprintf(stderr, "ERROR: Failed to open %s: %s\n",
> +			path, strerror(errno));

It drops part of original messages. It doesn't show this error
is from find_mount_root(). I consider the original meaning keep as is.
How do you think?

Thanks,
Satoru

>   		return -errno;
> +	}
>   	close(fd);
>   
>   	mnttab = setmntent("/proc/self/mounts", "r");
> -	if (!mnttab)
> +	if (!mnttab) {
> +		fprintf(stderr, "ERROR: Failed to setmntent: %s\n",
> +			strerror(errno));
>   		return -errno;
> +	}
>   
>   	while ((ent = getmntent(mnttab))) {
>   		len = strlen(ent->mnt_dir);
> @@ -2457,8 +2463,11 @@ int find_mount_root(const char *path, char **mount_root)
>   
>   	ret = 0;
>   	*mount_root = realpath(longest_match, NULL);
> -	if (!*mount_root)
> +	if (!*mount_root) {
> +		fprintf(stderr, "Failed to resolve path %s: %s\n",
> +			longest_match, strerror(errno));
>   		ret = -errno;
> +	}
>   
>   	free(longest_match);
>   	return ret;
> 


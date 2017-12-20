Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:26162 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753439AbdLTAgW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 19:36:22 -0500
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 5D9B9AC0181
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 09:36:12 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: qgroup: Remove support for specifying
 inherit type
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
References: <20171219105331.9636-1-wqu@suse.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <0441718e-9a39-fbf5-b026-d54bec6fe36b@jp.fujitsu.com>
Date: Wed, 20 Dec 2017 09:34:50 +0900
MIME-Version: 1.0
In-Reply-To: <20171219105331.9636-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/12/19 19:53, Qu Wenruo wrote:
> Since kernel is deprecating the support for specifying inherit type,
> remove the support in btrfs-progs too.
> 
> Thankfully, the options for qgroup inheritance is hidden and not
> documented, so user shouldn't be affected at all.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  cmds-subvolume.c | 21 ---------------------
>  qgroup.c         | 42 ------------------------------------------
>  qgroup.h         |  3 ---
>  3 files changed, 66 deletions(-)
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index dc626a6495e5..e0839da7d8f8 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -134,13 +134,6 @@ static int cmd_subvol_create(int argc, char **argv)
>  			break;
>  
>  		switch (c) {
> -		case 'c':
> -			res = qgroup_inherit_add_copy(&inherit, optarg, 0);
> -			if (res) {
> -				retval = res;
> -				goto out;
> -			}
> -			break;
>  		case 'i':
>  			res = qgroup_inherit_add_group(&inherit, optarg);
>  			if (res) {

No harm, but we should remove "c:" from getopt() too.
Tomohiro

> @@ -670,13 +663,6 @@ static int cmd_subvol_snapshot(int argc, char **argv)
>  			break;
>  
>  		switch (c) {
> -		case 'c':
> -			res = qgroup_inherit_add_copy(&inherit, optarg, 0);
> -			if (res) {
> -				retval = res;
> -				goto out;
> -			}
> -			break;
>  		case 'i':
>  			res = qgroup_inherit_add_group(&inherit, optarg);
>  			if (res) {
> @@ -687,13 +673,6 @@ static int cmd_subvol_snapshot(int argc, char **argv)
>  		case 'r':
>  			readonly = 1;
>  			break;
> -		case 'x':
> -			res = qgroup_inherit_add_copy(&inherit, optarg, 1);
> -			if (res) {
> -				retval = res;
> -				goto out;
> -			}
> -			break;
>  		default:
>  			usage(cmd_subvol_snapshot_usage);
>  		}
> diff --git a/qgroup.c b/qgroup.c
> index 156825fd431d..e9158a260251 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -1310,45 +1310,3 @@ int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg)
>  
>  	return 0;
>  }
> -
> -int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
> -			    int type)
> -{
> -	int ret;
> -	u64 qgroup_src;
> -	u64 qgroup_dst;
> -	char *p;
> -	int pos = 0;
> -
> -	p = strchr(arg, ':');
> -	if (!p) {
> -bad:
> -		error("invalid copy specification, missing separator :");
> -		return -EINVAL;
> -	}
> -	*p = 0;
> -	qgroup_src = parse_qgroupid(arg);
> -	qgroup_dst = parse_qgroupid(p + 1);
> -	*p = ':';
> -
> -	if (!qgroup_src || !qgroup_dst)
> -		goto bad;
> -
> -	if (*inherit)
> -		pos = (*inherit)->num_qgroups +
> -		      (*inherit)->num_ref_copies * 2 * type;
> -
> -	ret = qgroup_inherit_realloc(inherit, 2, pos);
> -	if (ret)
> -		return ret;
> -
> -	(*inherit)->qgroups[pos++] = qgroup_src;
> -	(*inherit)->qgroups[pos++] = qgroup_dst;
> -
> -	if (!type)
> -		++(*inherit)->num_ref_copies;
> -	else
> -		++(*inherit)->num_excl_copies;
> -
> -	return 0;
> -}
> diff --git a/qgroup.h b/qgroup.h
> index 875fbdf37f5f..3fc57123dc2d 100644
> --- a/qgroup.h
> +++ b/qgroup.h
> @@ -92,7 +92,4 @@ int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_comparer_set **comp_set,
>  				int is_descending);
>  int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
>  int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg);
> -int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
> -			    int type);
> -
>  #endif
> 


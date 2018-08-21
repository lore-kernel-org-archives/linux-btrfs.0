Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:33963 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbeHUKeL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 06:34:11 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id A71CBAC013A
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 16:15:08 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH] btrfs-progs: rescue: Add ability to disable quota offline
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180812013358.16431-1-wqu@suse.com>
Message-ID: <c546e216-0108-fb2b-4193-b2ce1884c336@jp.fujitsu.com>
Date: Tue, 21 Aug 2018 16:14:50 +0900
MIME-Version: 1.0
In-Reply-To: <20180812013358.16431-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/12 10:33, Qu Wenruo wrote:
> Provide an offline tool to disable quota.
> 
> For kernel which skip_balance doesn't work, there is no way to disable
> quota on huge fs with balance, as quota will cause balance to hang for a
> long long time for each tree block switch.
> 
> So add an offline rescue tool to disable quota.
> 
> Reported-by: Dan Merillat <dan.merillat@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> This can patch can be fetched from github repo:
> https://github.com/adam900710/btrfs-progs/tree/quota_disable
> ---
>  Documentation/btrfs-rescue.asciidoc |  6 +++
>  cmds-rescue.c                       | 80 +++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+)
> 
> diff --git a/Documentation/btrfs-rescue.asciidoc b/Documentation/btrfs-rescue.asciidoc
> index f94a0ff2b45e..fb088c1a768a 100644
> --- a/Documentation/btrfs-rescue.asciidoc
> +++ b/Documentation/btrfs-rescue.asciidoc
> @@ -31,6 +31,12 @@ help.
>  NOTE: Since *chunk-recover* will scan the whole device, it will be *VERY* slow
>  especially executed on a large device.
>  
> +*disable-quota* <device>::
> +disable quota offline
> ++
> +Acts as a fallback method to disable quota for case where mount hangs due to
> +balance and quota.
> +
>  *fix-device-size* <device>::
>  fix device size and super block total bytes values that are do not match
>  +
> diff --git a/cmds-rescue.c b/cmds-rescue.c
> index 38c4ab9b2ef6..c7cd92427e9d 100644
> --- a/cmds-rescue.c
> +++ b/cmds-rescue.c
> @@ -250,6 +250,84 @@ out:
>  	return !!ret;
>  }
>  
> +static const char * const cmd_rescue_disable_quota_usage[] = {
> +	"btrfs rescue disable-quota <device>",
> +	"Disable quota, especially useful for balance mount hang when quota enabled",
> +	"",
> +	NULL
> +};
> +
> +static int cmd_rescue_disable_quota(int argc, char **argv)
> +{
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_fs_info *fs_info;
> +	struct btrfs_path path;
> +	struct btrfs_root *root;
> +	struct btrfs_qgroup_status_item *qi;
> +	struct btrfs_key key;
> +	char *devname;
> +	int ret;
> +
> +	clean_args_no_options(argc, argv, cmd_rescue_disable_quota_usage);
> +	if (check_argc_exact(argc, 2))
> +		usage(cmd_rescue_disable_quota_usage);
> +
> +	devname = argv[optind];
> +	ret = check_mounted(devname);
> +	if (ret < 0) {
> +		error("could not check mount status: %s", strerror(-ret));
> +		return !!ret;
> +	} else if (ret) {
> +		error("%s is currently mounted", devname);
> +		return !!ret;
> +	}
> +	fs_info = open_ctree_fs_info(devname, 0, 0, 0, OPEN_CTREE_WRITES);
> +	if (!fs_info) {
> +		error("could not open btrfs");
> +		ret = -EIO;
> +		return !!ret;
> +	}
> +	root = fs_info->quota_root;
> +	if (!root) {
> +		printf("Quota is not enabled, no need to modify the fs\n");
> +		goto close;
> +	}
> +	btrfs_init_path(&path);
> +	trans = btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		error("failed to start transaction: %s", strerror(-ret));
> +		goto close;
> +	}
> +	key.objectid = 0;
> +	key.type = BTRFS_QGROUP_STATUS_KEY;
> +	key.offset = 0;
> +	ret = btrfs_search_slot(trans, root, &key, &path, 0, 1);
> +	if (ret < 0) {
> +		error("failed to search tree: %s", strerror(-ret));
> +		goto close;
> +	}
> +	if (ret > 0) {
> +		printf(
> +		"qgroup status item not found, not need to modify the fs");
> +		ret = 0;
> +		goto release;
> +	}
> +	qi = btrfs_item_ptr(path.nodes[0], path.slots[0],
> +			    struct btrfs_qgroup_status_item);
> +	btrfs_set_qgroup_status_flags(path.nodes[0], qi,
> +			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT);

This is not what "btrfs quota disable" does (completely removes quota tree),
so I think it is better to have different name other than "disable-quota"
(I'm not sure about good name, maybe suspend?).

btw, maybe we should add this ability to online fs too so that we can
temporally disable quota during balance while keeping limit/inheritance settings?

Thanks,
Misono

> +	btrfs_mark_buffer_dirty(path.nodes[0]);
> +	ret = btrfs_commit_transaction(trans, root);
> +	if (ret < 0)
> +		error("failed to commit transaction: %s", strerror(-ret));
> +release:
> +	btrfs_release_path(&path);
> +close:
> +	close_ctree(fs_info->tree_root);
> +	return !!ret;
> +}
> +
>  static const char rescue_cmd_group_info[] =
>  "toolbox for specific rescue operations";
>  
> @@ -262,6 +340,8 @@ const struct cmd_group rescue_cmd_group = {
>  		{ "zero-log", cmd_rescue_zero_log, cmd_rescue_zero_log_usage, NULL, 0},
>  		{ "fix-device-size", cmd_rescue_fix_device_size,
>  			cmd_rescue_fix_device_size_usage, NULL, 0},
> +		{ "disable-quota", cmd_rescue_disable_quota,
> +			cmd_rescue_disable_quota_usage, NULL, 0},
>  		NULL_CMD_STRUCT
>  	}
>  };
> 

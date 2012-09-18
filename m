Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:49408 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495Ab2IRMa0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 08:30:26 -0400
Date: Tue, 18 Sep 2012 14:30:18 +0200
From: David Sterba <dave@jikos.cz>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: add mount-option command
Message-ID: <20120918123018.GA17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5057CDA7.3090201@jp.fujitsu.com>
 <5057CEA9.3070707@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5057CEA9.3070707@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2012 at 10:30:17AM +0900, Hidetoshi Seto wrote:
> Now, the command can set/get 24 options.
> These options are equal to mount options which store
> in fs_info/mount-opt.

Some of the options do not IMO fit for being default, like DEGRADED,
maybe RECOVERY, maybe SKIP_BALANCE.

> +	mount_cmd_group_usage, NULL, {
> +		{ "set", cmd_set_mntopt, cmd_set_mntopt_usage, NULL, 0 },
> +		{ "get", cmd_get_mntopt, cmd_get_mntopt_usage, NULL, 0 },
> +		{ "clear", cmd_clear_mntopt, cmd_clear_mntopt_usage, NULL, 0},
> +		{0, 0, 0, 0, 0 }

I find this very long to type,

  btrfs mount-option clear something

and I'm missing a command to list all the possible options to set.

> +	}
> +};
> +
> +int cmd_mount(int argc, char **argv)
> +{
> +	return handle_command_group(&mount_cmd_group, argc, argv);
> +}
> diff --git a/commands.h b/commands.h
> index 1ece87a..6cf91fc 100644
> --- a/commands.h
> +++ b/commands.h
> @@ -88,6 +88,7 @@ extern const struct cmd_group balance_cmd_group;
>  extern const struct cmd_group device_cmd_group;
>  extern const struct cmd_group scrub_cmd_group;
>  extern const struct cmd_group inspect_cmd_group;
> +extern const struct cmd_group mount_cmd_group;
>  extern const struct cmd_group send_cmd_group;
>  extern const struct cmd_group receive_cmd_group;
>  
> @@ -97,5 +98,6 @@ int cmd_balance(int argc, char **argv);
>  int cmd_device(int argc, char **argv);
>  int cmd_scrub(int argc, char **argv);
>  int cmd_inspect(int argc, char **argv);
> +int cmd_mount(int argc, char **argv);
>  int cmd_send(int argc, char **argv);
>  int cmd_receive(int argc, char **argv);
> diff --git a/ctree.h b/ctree.h
> index d218b88..4a1bb5b 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -401,8 +401,11 @@ struct btrfs_super_block {
>  
>  	__le64 cache_generation;
>  
> +	/* default mount options */
> +	unsigned long default_mount_opt;

__le64 here as well

> +
>  	/* future expansion */
> -	__le64 reserved[31];
> +	__le64 reserved[30];
>  	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
>  	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
>  } __attribute__ ((__packed__));
> @@ -1774,6 +1777,8 @@ BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
>  			 csum_type, 16);
>  BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
>  			 cache_generation, 64);
> +BTRFS_SETGET_STACK_FUNCS(super_default_mount_opt, struct btrfs_super_block,
> +			 default_mount_opt, 64);
>  
>  static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
>  {
> @@ -2128,3 +2133,37 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
>  			struct btrfs_root *root, struct btrfs_path *path,
>  			u64 isize);
>  #endif
> +
> +/*
> + * Flags for mount options.
> + *
> + * Note: don't forget to add new options to btrfs_show_options()

(the note does not apply here, makes sense only for kernel)


So, you're basically implementing subset of the whole-filesystem
options. As has been mentioned, alternate way is to use the 'properties'
interface as a global entry point from the management tool. It would be
great if you base your patches on top of it.

(The props haven't been acked, but we've reached a wider consensus on
irc, patches are in the mailinglist, so we can bring it up again and
discuss outstanding issues or objections. I'm mainly concerned about
priority of setting the defaults and not-bloating the 'btrfs' interface
too much.)


thanks,
david

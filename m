Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41267 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751369AbdGLWWl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:22:41 -0400
Date: Thu, 13 Jul 2017 00:21:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: add support to search subvolume by rootid
 and uuid
Message-ID: <20170712222127.GP2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712072050.2531-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712072050.2531-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 03:20:50PM +0800, Anand Jain wrote:
> Unless the top level is mounted there is no way to know the
> details of all the subvolume.  For example:
> 
> mount -o subvol=sv1/newsv1 /dev/sdb /btrfs
> 
> btrfs su list /btrfs
> ID 257 gen 12 top level 5 path sv1
> ID 258 gen 9 top level 257 path sv1/snap
> ID 259 gen 11 top level 257 path sv1/newsv1
> 
> You can't subvol show for sv1 and sv1/snap as its paths aren't
> accessible to the user unless the its top level is mounted.
> 
> This patch adds two new options to the existing btrfs subvol show
> cli. They are --rootid/-r or --uuid/-u, with this now the user will
> be able to look for a subvolume using the rootid OR the uuid.

Sounds good.

> ./btrfs su show -r 257 /btrfs
> sv1
> 	Name: 			sv1
> 	UUID: 			30129358-c69d-3e4a-a662-29509cc69c95
> 	Parent UUID: 		-
> 	Received UUID: 		-
> 	Creation time: 		2017-07-11 20:32:57 +0800
> 	Subvolume ID: 		257
> 	Generation: 		12
> 	Gen at creation: 	7
> 	Parent ID: 		5
> 	Top level ID: 		5
> 	Flags: 			-
> 	Snapshot(s):
> 				sv1/snap
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  btrfs-list.c     |  4 +++-
>  cmds-subvolume.c | 44 +++++++++++++++++++++++++++++++++++++++++---
>  utils.c          | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  utils.h          |  5 ++++-
>  4 files changed, 100 insertions(+), 5 deletions(-)
> 
> diff --git a/btrfs-list.c b/btrfs-list.c
> index 8eec05ea797f..92a537f425f3 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -1582,7 +1582,9 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri)
>  			rbn = rb_next(rbn);
>  			continue;
>  		}
> -		if (!comp_entry_with_rootid(the_ri, ri, 0)) {
> +
> +		if (!comp_entry_with_rootid(the_ri, ri, 0) ||
> +			!uuid_compare(the_ri->uuid, ri->uuid)) {
>  			memcpy(the_ri, ri, offsetof(struct root_info, path));
>  			the_ri->path = strdup_or_null(ri->path);
>  			the_ri->name = strdup_or_null(ri->name);
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index de6204eabeaf..1fa54d1b24cf 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -891,8 +891,11 @@ static int cmd_subvol_find_new(int argc, char **argv)
>  }
>  
>  static const char * const cmd_subvol_show_usage[] = {
> -	"btrfs subvolume show <subvol-path>",
> +	"btrfs subvolume show [options] <subvol-path>|<mnt>",
>  	"Show more information of the subvolume",
> +	"-r|--rootid   rootid of the subvol to show",
> +	"-u|--uuid     uuid of the subvol to show",
> +	"If no option is specified <subvol-path> will be shown.",
>  	NULL
>  };
>  
> @@ -907,8 +910,36 @@ static int cmd_subvol_show(int argc, char **argv)
>  	int fd = -1;
>  	int ret = 1;
>  	DIR *dirstream1 = NULL;
> +	int by_rootid = 0;
> +	int by_uuid = 0;
> +	u64 rootid_arg;
> +	u8 uuid_arg[BTRFS_UUID_SIZE];
>  
> -	clean_args_no_options(argc, argv, cmd_subvol_show_usage);
> +	while (1) {
> +		int c;
> +		static const struct option long_options[] = {
> +			{ "rootid", required_argument, NULL, 'r'},
> +			{ "uuid", required_argument, NULL, 'u'},
> +			{ NULL, 0, NULL, 0 }
> +		};
> +
> +		c = getopt_long(argc, argv, "r:u:", long_options, NULL);
> +		if (c < 0)
> +			break;
> +
> +		switch (c) {
> +		case 'r':
> +			rootid_arg = arg_strtou64(optarg);
> +			by_rootid = 1;
> +			break;
> +		case 'u':
> +			uuid_parse(optarg, uuid_arg);
> +			by_uuid = 1;
> +			break;
> +		default:
> +			usage(cmd_subvol_show_usage);
> +		}
> +	}
>  
>  	if (check_argc_exact(argc - optind, 1))
>  		usage(cmd_subvol_show_usage);
> @@ -921,7 +952,14 @@ static int cmd_subvol_show(int argc, char **argv)
>  		goto out;
>  	}
>  
> -	ret = get_subvol_info(fullpath, &get_ri);
> +	if (by_rootid) {
> +		ret = get_subvol_info_by_rootid(fullpath, &get_ri, rootid_arg);
> +	} else if (by_uuid) {
> +		ret = get_subvol_info_by_uuid(fullpath, &get_ri, uuid_arg);
> +	} else {
> +		ret = get_subvol_info(fullpath, &get_ri);
> +	}

Here rootid takes precedence if there are both options specified. I
think this should be handled as invalid syntax. If the rootid and uuid
do not match, it's not well defined and can cause silent breakage.

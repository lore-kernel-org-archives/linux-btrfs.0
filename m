Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36374 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab2GDPlr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 11:41:47 -0400
Date: Wed, 4 Jul 2012 17:41:35 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs-progs: add 's' option for 'btrfs subvolume
 list'
Message-ID: <20120704154135.GN5326@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1340964038-32584-3-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340964038-32584-3-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2012 at 06:00:38PM +0800, Liu Bo wrote:
> We want 'btrfs subvolume list' to act as 'ls', which means that
> we can not only list out all the subvolumes we have, but also list
> each single one.
> 
> So this patch add 's' option to show a single one:
> 
> $ ./btrfs sub list /mnt/btrfs/
> ID 256 top level 5 path subvol (Readonly,)
> ID 257 top level 5 path snapshot
> ID 258 top level 5 path subvol2
> ID 259 top level 5 path subvol2/subvol3
> 
> $ ./btrfs sub list -s /mnt/btrfs/subvol
> ID 256 top level 5 path subvol (Readonly,)

suggestions and comments:

1) show the subvolume flags only if an option is given, similar to -p
   (to show parent subvol),

2) move the flags before the subvolume path -- it is of a
   variable length and it's a bit easier (but not reliable) to parse it
   from scripts

sidenote: 'find /mnt -inum 256 -print0' will list all subvolumes in a
way that's resitent to funny characters in the path, but is slow as it
has to traverse the filesystem (and 'find' does not support a true
breadth-first-search, needs to be iterated with -mindepth/maxdepth).

the 'subvol list' command could mimic the -print0 and print the
subvolume paths terminated by '\0'.

3) drop the , if there's only one subvol property

4) the '-s' option on the mountpoint does not show anything, though I
   would expect that, eg when the mountpoint is a subvolume

--

one comment to code below

david

> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  btrfs-list.c     |   41 ++++++++++++++++++++++++++++++++++++++++-
>  cmds-subvolume.c |   15 ++++++++++-----
>  2 files changed, 50 insertions(+), 6 deletions(-)
> 
> diff --git a/btrfs-list.c b/btrfs-list.c
> index f1baa52..3e79239 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -312,6 +312,30 @@ static int lookup_ino_path(int fd, struct root_info *ri)
>  	return 0;
>  }
>  
> +/*
> + * helper function for getting the root which the file is belonged to.
> + */
> +static int lookup_ino_rootid(int fd, u64 *rootid)
> +{
> +	struct btrfs_ioctl_ino_lookup_args args;
> +	int ret, e;
> +
> +	memset(&args, 0, sizeof(args));
> +	args.treeid = 0;
> +	args.objectid = BTRFS_FIRST_FREE_OBJECTID;
> +
> +	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
> +	e = errno;
> +	if (ret) {
> +		fprintf(stderr, "ERROR: Failed to lookup root id - %s\n",
> +			strerror(e));
> +		return ret;
> +	}
> +
> +	*rootid = args.treeid;
> +	return 0;
> +}
> +
>  /* finding the generation for a given path is a two step process.
>   * First we use the inode loookup routine to find out the root id
>   *
> @@ -704,11 +728,12 @@ int subvol_get_set_flags(int fd, int set, u64 flags, u64 root_id)
>  	return 0;
>  }
>  
> -int list_subvols(int fd, int print_parent, int get_default)
> +int list_subvols(int fd, int print_parent, int print_self, int get_default)
>  {
>  	struct root_lookup root_lookup;
>  	struct rb_node *n;
>  	int ret;
> +	u64 subvolid = 0;
>  
>  	ret = __list_subvol_search(fd, &root_lookup);
>  	if (ret) {
> @@ -725,6 +750,9 @@ int list_subvols(int fd, int print_parent, int get_default)
>  	if (ret < 0)
>  		return ret;
>  
> +	if (print_self)
> +		lookup_ino_rootid(fd, &subvolid);

you should probably check the return value

> +
>  	/* now that we have all the subvol-relative paths filled in,
>  	 * we have to string the subvols together so that we can get
>  	 * a path all the way back to the FS root
> @@ -739,6 +767,14 @@ int list_subvols(int fd, int print_parent, int get_default)
>  		entry = rb_entry(n, struct root_info, rb_node);
>  		resolve_root(&root_lookup, entry, &root_id, &parent_id,
>  				&level, &path);
> +
> +		/* print this subvolume only */
> +		if (print_self && subvolid != root_id) {
> +			free(path);
> +			n = rb_prev(n);
> +			continue;
> +		}
> +
>  		if (print_parent) {
>  			printf("ID %llu parent %llu top level %llu path %s",
>  				(unsigned long long)root_id,
> @@ -753,6 +789,9 @@ int list_subvols(int fd, int print_parent, int get_default)
>  			printf("\n");
>  		free(path);
>  		n = rb_prev(n);
> +
> +		if (print_self)
> +			break;
>  	}
>  
>  	return ret;
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 8783e67..f779b78 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -30,7 +30,7 @@
>  #include "commands.h"
>  
>  /* btrfs-list.c */
> -int list_subvols(int fd, int print_parent, int get_default);
> +int list_subvols(int fd, int print_parent, int print_self, int get_default);
>  int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
>  int subvol_get_set_flags(int fd, int set, u64 flags, u64 root_id);
>  
> @@ -218,10 +218,11 @@ static int cmd_subvol_delete(int argc, char **argv)
>  }
>  
>  static const char * const cmd_subvol_list_usage[] = {
> -	"btrfs subvolume list [-p] <path>",
> +	"btrfs subvolume list [-ps] <path>",
>  	"List subvolumes (and snapshots)",
>  	"",
>  	"-p     print parent ID",
> +	"-s     print this subvolume only",
>  	NULL
>  };
>  
> @@ -230,11 +231,12 @@ static int cmd_subvol_list(int argc, char **argv)
>  	int fd;
>  	int ret;
>  	int print_parent = 0;
> +	int print_self = 0;
>  	char *subvol;
>  
>  	optind = 1;
>  	while(1) {
> -		int c = getopt(argc, argv, "p");
> +		int c = getopt(argc, argv, "ps");
>  		if (c < 0)
>  			break;
>  
> @@ -242,6 +244,9 @@ static int cmd_subvol_list(int argc, char **argv)
>  		case 'p':
>  			print_parent = 1;
>  			break;
> +		case 's':
> +			print_self = 1;
> +			break;
>  		default:
>  			usage(cmd_subvol_list_usage);
>  		}
> @@ -267,7 +272,7 @@ static int cmd_subvol_list(int argc, char **argv)
>  		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
>  		return 12;
>  	}
> -	ret = list_subvols(fd, print_parent, 0);
> +	ret = list_subvols(fd, print_parent, print_self, 0);
>  	if (ret)
>  		return 19;
>  	return 0;
> @@ -426,7 +431,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
>  		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
>  		return 12;
>  	}
> -	ret = list_subvols(fd, 0, 1);
> +	ret = list_subvols(fd, 0, 0, 1);
>  	if (ret)
>  		return 19;
>  	return 0;
> -- 
> 1.6.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

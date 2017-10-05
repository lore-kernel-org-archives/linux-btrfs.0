Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751454AbdJEPY3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Oct 2017 11:24:29 -0400
Date: Thu, 5 Oct 2017 17:22:45 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: subvol: change subvol set-default to also
 accept subvol path
Message-ID: <20171005152245.GJ3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7faa2e3c-d157-f8f6-b818-5b95917cd7e7@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7faa2e3c-d157-f8f6-b818-5b95917cd7e7@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 02, 2017 at 03:25:40PM +0900, Misono, Tomohiro wrote:
> This patch changes "subvol set-default" to also accept the subvolume path
> for convenience.
> 
> This is the one of the issue on github:
> https://github.com/kdave/btrfs-progs/issues/35
> 
> If there are two args, they are assumed as subvol id and path to the fs
> (the same as current behavior), and if there is only one arg, it is assumed
> as the path to the subvolume. Therefore there is no ambiguity between subvol
> id and subvol name, which is mentioned in the above issue page.
> 
> subvol id is resolved by get_subvol_info() which is used by "subvol show".
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  Documentation/btrfs-subvolume.asciidoc | 10 +++----
>  cmds-subvolume.c                       | 48 ++++++++++++++++++++++++++--------
>  2 files changed, 42 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
> index 5cfe885..df27460 100644
> --- a/Documentation/btrfs-subvolume.asciidoc
> +++ b/Documentation/btrfs-subvolume.asciidoc
> @@ -142,12 +142,12 @@ you can add \'\+' or \'-' in front of each items, \'+' means ascending,
>  for --sort you can combine some items together by \',', just like
>  --sort=+ogen,-gen,path,rootid.
>  
> -*set-default* <id> <path>::
> -Set the subvolume of the filesystem <path> which is mounted as
> -default.
> +*set-default* [<subvolume>|<id> <path>]::
> +Set the subvolume of the filesystem which is mounted as default.
>  +
> -The subvolume is identified by <id>, which is returned by the *subvolume list*
> -command.
> +If <id> and <path> is given, the subvolume is identified by <id>,
> +which is returned by the *subvolume list* command. The filesystem
> +is specified by <path>.
>  
>  *show* <path>::
>  Show information of a given subvolume in the <path>.
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 666f6e0..5bf8295 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -803,28 +803,54 @@ out:
>  }
>  
>  static const char * const cmd_subvol_set_default_usage[] = {
> -	"btrfs subvolume set-default <subvolid> <path>",
> -	"Set the default subvolume of a filesystem",
> +	"btrfs subvolume set-default [<subvolume>|<subvolid> <path>]",
> +	"Set the default subvolume of the filesystem mounted as default.",
> +	"The subvolume can be specified by its path,",
> +	"or the pair of subvolume id and path to the filesystem.",
>  	NULL
>  };
>  
>  static int cmd_subvol_set_default(int argc, char **argv)
>  {
> -	int	ret=0, fd, e;
> -	u64	objectid;
> -	char	*path;
> -	char	*subvolid;
> -	DIR	*dirstream = NULL;
> +	int ret = 0;
> +	int fd, e;
> +	u64 objectid;
> +	char *path;
> +	char *subvolid;
> +	DIR *dirstream = NULL;

Please don't change unrelated code, I'll drop it from the patch.

>  
>  	clean_args_no_options(argc, argv, cmd_subvol_set_default_usage);
>  
> -	if (check_argc_exact(argc - optind, 2))
> +	if (check_argc_min(argc - optind, 1) ||
> +			check_argc_max(argc - optind, 2))
>  		usage(cmd_subvol_set_default_usage);
>  
> -	subvolid = argv[optind];
> -	path = argv[optind + 1];
> +	if (argc - optind == 1) {
> +		/* path to the subvolume is specified */
> +		struct root_info ri;
> +		char *fullpath;
>  
> -	objectid = arg_strtou64(subvolid);
> +		path = argv[optind];
> +		fullpath = realpath(path, NULL);
> +		if (!fullpath) {
> +			error("cannot find real path for '%s': %s",
> +				path, strerror(errno));
> +			return 1;
> +		}
> +
> +		ret = get_subvol_info(fullpath, &ri);

That's an overkill, we just need to read the subvolume id of the given
path, but get_subvol_info reads the entire subvolume list and more.

Instead, please use lookup_path_rootid + test_issubvolume and we need to
avoid the empty subvol (inode number 2).

> +		free(fullpath);
> +
> +		if (ret)
> +			return 1;
> +
> +		objectid = ri.root_id;
> +	} else {
> +		/* subvol id and path to the filesystem are specified */
> +		subvolid = argv[optind];
> +		path = argv[optind + 1];
> +		objectid = arg_strtou64(subvolid);
> +	}
>  
>  	fd = btrfs_open_dir(path, &dirstream, 1);
>  	if (fd < 0)

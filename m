From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH v2] print parent ID in btrfs suvolume list
Date: Sat, 02 Jul 2011 09:55:47 +0200
Message-ID: <4E0ECF03.30400@libero.it>
References: <20110627144523.GA13379@carfax.org.uk> <4E0D9F90.4060703@gmail.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, hugo@carfax.org.uk
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0D9F90.4060703@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/2011 12:21 PM, Andreas Philipp wrote:
> There was some discussion on "where" subvolumes live in. Why do we not
> simply print the parent ID for each subvolume in btrfs subvolume list?
> This patch adds this functionality when called with parameter "-p".
> 

Can I ask you to update the man page too ?

> Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
> ---
> V1->V2: do not change the default behavior but rather add the switch -p.
> 
>  btrfs-list.c |   24 ++++++++++++++++++------
>  btrfs.c      |    6 ++++--
>  btrfs_cmds.c |   17 +++++++++++++++--
>  btrfs_cmds.h |    2 +-
>  4 files changed, 38 insertions(+), 11 deletions(-)
> 
> diff --git a/btrfs-list.c b/btrfs-list.c
> index f804dfc..be20c91 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -200,9 +200,10 @@ static int add_root(struct root_lookup *root_lookup,
>   * This can't be called until all the root_info->path fields are filled
>   * in by lookup_ino_path
>   */
> -static int resolve_root(struct root_lookup *rl, struct root_info *ri)
> +static int resolve_root(struct root_lookup *rl, struct root_info *ri, int print_parent)
>  {
>  	u64 top_id;
> +	u64 parent_id = 0;
>  	char *full_path = NULL;
>  	int len = 0;
>  	struct root_info *found;
> @@ -233,6 +234,11 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri)
>  		}
>  
>  		next = found->ref_tree;
> +		/* record the first parent */
> +		if ( parent_id == 0 ) {
> +			parent_id = next;
> +		}
> +
>  		/* if the ref_tree refers to ourselves, we're at the top */
>  		if (next == found->root_id) {
>  			top_id = next;
> @@ -249,9 +255,15 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri)
>  			break;
>  		}
>  	}
> -	printf("ID %llu top level %llu path %s\n",
> -	       (unsigned long long)ri->root_id, (unsigned long long)top_id,
> -	       full_path);
> +	if (print_parent) {
> +		printf("ID %llu parent %llu top level %llu path %s\n",
> +		       (unsigned long long)ri->root_id, (unsigned long long)parent_id, (unsigned long long)top_id,
> +	       		full_path);
> +	} else {
> +		printf("ID %llu top level %llu path %s\n",
> +		       (unsigned long long)ri->root_id, (unsigned long long)top_id,
> +	       		full_path);
> +	}
>  	free(full_path);
>  	return 0;
>  }
> @@ -549,7 +561,7 @@ build:
>  	return full;
>  }
>  
> -int list_subvols(int fd)
> +int list_subvols(int fd, int print_parent)
>  {
>  	struct root_lookup root_lookup;
>  	struct rb_node *n;
> @@ -666,7 +678,7 @@ int list_subvols(int fd)
>  	while (n) {
>  		struct root_info *entry;
>  		entry = rb_entry(n, struct root_info, rb_node);
> -		resolve_root(&root_lookup, entry);
> +		resolve_root(&root_lookup, entry, print_parent);
>  		n = rb_prev(n);
>  	}
>  
> diff --git a/btrfs.c b/btrfs.c
> index 87cc680..d09823a 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -66,9 +66,11 @@ static struct Command commands[] = {
>  		"not passed).",
>  	  NULL
>  	},
> -	{ do_subvol_list, 1, "subvolume list", "<path>\n"
> +	{ do_subvol_list, -1, "subvolume list", "[-p] <path>\n"
>  		"List the snapshot/subvolume of a filesystem.",
> -	  NULL
> +		"[-p] <path>\n"
> +		"List the snapshot/subvolume of a filesystem.\n"
> +		"-p	   print parent ID"
>  	},
>  	{ do_set_default_subvol, 2,
>  	  "subvolume set-default", "<id> <path>\n"
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index 062e7d7..9e0c9bc 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -303,9 +303,22 @@ int do_subvol_list(int argc, char **argv)
>  {
>  	int fd;
>  	int ret;
> +	int print_parent = 0;
>  	char *subvol;
> +        int optind = 1;
>  
> -	subvol = argv[1];
> +	while(1) {
> +		int c = getopt(argc, argv, "p");
> +		if (c < 0) break;
> +		switch(c) {
> +		case 'p':
> +			print_parent = 1;
> +			optind++;
> +			break;
> +		}
> +	}
> +
> +	subvol = argv[optind];
>  
>  	ret = test_issubvolume(subvol);
>  	if (ret < 0) {
> @@ -322,7 +335,7 @@ int do_subvol_list(int argc, char **argv)
>  		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
>  		return 12;
>  	}
> -	ret = list_subvols(fd);
> +	ret = list_subvols(fd, print_parent);
>  	if (ret)
>  		return 19;
>  	return 0;
> diff --git a/btrfs_cmds.h b/btrfs_cmds.h
> index 61456fa..83faa5b 100644
> --- a/btrfs_cmds.h
> +++ b/btrfs_cmds.h
> @@ -34,7 +34,7 @@ int do_scan(int nargs, char **argv);
>  int do_resize(int nargs, char **argv);
>  int do_subvol_list(int nargs, char **argv);
>  int do_set_default_subvol(int nargs, char **argv);
> -int list_subvols(int fd);
> +int list_subvols(int fd, int print_parent);
>  int do_df_filesystem(int nargs, char **argv);
>  int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
>  int do_find_newer(int argc, char **argv);
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
.


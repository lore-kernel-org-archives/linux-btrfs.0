Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:28099 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab3AYKHn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 05:07:43 -0500
Message-ID: <51025947.60208@giantdisaster.de>
Date: Fri, 25 Jan 2013 11:07:03 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 10/10] Btrfs-progs: add show subcommand to subvol cli
In-Reply-To: <1359106239-20870-11-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1359106239-20870-1-git-send-email-anand.jain@oracle.com>
 <1359106239-20870-11-git-send-email-anand.jain@oracle.com>

On Fri, 25 Jan 2013 17:30:39 +0800, Anand Jain wrote:
> This adds show sub-command to the btrfs subvol cli
> to display detailed inforamtion of the given subvol
> or snapshot.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  btrfs-list.c     |  25 +++++++-
>  btrfs-list.h     |   3 +-
>  cmds-subvolume.c | 172 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  man/btrfs.8.in   |   6 ++
>  4 files changed, 199 insertions(+), 7 deletions(-)
> 
> diff --git a/btrfs-list.c b/btrfs-list.c
> index 656de10..1915ece 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -1335,6 +1335,22 @@ static void print_subvolume_column(struct root_info *subv,
>  	}
>  }
>  
> +static void print_single_volume_info_raw(struct root_info *subv, char *raw_prefix)
> +{
> +	int i;
> +
> +	for (i = 0; i < BTRFS_LIST_ALL; i++) {
> +		if (!btrfs_list_columns[i].need_print)
> +			continue;
> +
> +		if (raw_prefix)
> +			printf("%s",raw_prefix);
> +
> +		print_subvolume_column(subv, i);
> +	}
> +	printf("\n");
> +}
> +
>  static void print_single_volume_info_table(struct root_info *subv)
>  {
>  	int i;
> @@ -1401,7 +1417,7 @@ static void print_all_volume_info_tab_head()
>  }
>  
>  static void print_all_volume_info(struct root_lookup *sorted_tree,
> -				  int layout)
> +				  int layout, char *raw_prefix)
>  {
>  	struct rb_node *n;
>  	struct root_info *entry;
> @@ -1419,6 +1435,9 @@ static void print_all_volume_info(struct root_lookup *sorted_tree,
>  		case BTRFS_LIST_LAYOUT_TABLE:
>  			print_single_volume_info_table(entry);
>  			break;
> +		case BTRFS_LIST_LAYOUT_RAW:
> +			print_single_volume_info_raw(entry, raw_prefix);
> +			break;
>  		}
>  		n = rb_next(n);
>  	}
> @@ -1445,7 +1464,7 @@ int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
>  
>  int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
>  		       struct btrfs_list_comparer_set *comp_set,
> -		       int layout)
> +		       int layout, char *raw_prefix)
>  {
>  	struct root_lookup root_lookup;
>  	struct root_lookup root_sort;
> @@ -1457,7 +1476,7 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
>  	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
>  				 comp_set, fd);
>  
> -	print_all_volume_info(&root_sort, layout);
> +	print_all_volume_info(&root_sort, layout, raw_prefix);
>  	__free_all_subvolumn(&root_lookup);
>  
>  	return 0;
> diff --git a/btrfs-list.h b/btrfs-list.h
> index 5b60068..09d35f7 100644
> --- a/btrfs-list.h
> +++ b/btrfs-list.h
> @@ -20,6 +20,7 @@
>  
>  #define BTRFS_LIST_LAYOUT_DEFAULT	0
>  #define BTRFS_LIST_LAYOUT_TABLE	1
> +#define BTRFS_LIST_LAYOUT_RAW		2
>  
>  /*
>   * one of these for each root we find.
> @@ -150,7 +151,7 @@ int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
>  
>  int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
>  		       struct btrfs_list_comparer_set *comp_set,
> -			int is_tab_result);
> +			int layout, char *raw_prefix);
>  int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
>  int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
>  char *btrfs_list_path_for_root(int fd, u64 root);
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index bb9629f..ad6afbc 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -24,6 +24,7 @@
>  #include <libgen.h>
>  #include <limits.h>
>  #include <getopt.h>
> +#include <uuid/uuid.h>
>  
>  #include "kerncompat.h"
>  #include "ioctl.h"
> @@ -418,10 +419,10 @@ static int cmd_subvol_list(int argc, char **argv)
>  
>  	if (is_tab_result)
>  		ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
> -				BTRFS_LIST_LAYOUT_TABLE);
> +				BTRFS_LIST_LAYOUT_TABLE, NULL);
>  	else
>  		ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
> -				BTRFS_LIST_LAYOUT_DEFAULT);
> +				BTRFS_LIST_LAYOUT_DEFAULT, NULL);
>  	if (ret)
>  		return 19;
>  	return 0;
> @@ -634,7 +635,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
>  	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
>  
>  	ret = btrfs_list_subvols_print(fd, filter_set, NULL,
> -		BTRFS_LIST_LAYOUT_DEFAULT);
> +		BTRFS_LIST_LAYOUT_DEFAULT, NULL);
>  	if (ret)
>  		return 19;
>  	return 0;
> @@ -721,6 +722,170 @@ static int cmd_find_new(int argc, char **argv)
>  	return 0;
>  }
>  
> +static const char * const cmd_subvol_show_usage[] = {
> +	"btrfs subvolume show <subvol-path>",
> +	"Show more information of the subvolume",
> +	NULL
> +};
> +
> +static int cmd_subvol_show(int argc, char **argv)
> +{
> +	struct root_info get_ri;
> +	struct btrfs_list_filter_set *filter_set;
> +	char tstr[256];
> +	char uuidparse[37];
> +	char *fullpath, *svpath, *mnt = NULL;
> +	char raw_prefix[] = "\t\t\t\t";
> +	u64 sv_id, mntid;
> +	int fd, mntfd;
> +	int ret;
> +	int clean = 0;
> +
> +	if (check_argc_exact(argc, 2))
> +		usage(cmd_subvol_show_usage);
> +
> +	fullpath = realpath(argv[1],0);
> +	if (!fullpath) {
> +		fprintf(stderr, "ERROR: finding real path for '%s', %s\n",
> +			argv[1], strerror(errno));
> +		return 1;
> +	}
> +	clean++;
> +
> +	ret = test_issubvolume(fullpath);
> +	if (ret < 0) {
> +		fprintf(stderr, "ERROR: error accessing '%s'\n", fullpath);
> +		ret = 1;
> +		goto out;
> +	}
> +	if (!ret) {
> +		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", fullpath);
> +		ret = 1;
> +		goto out;
> +	}
> +
> +	ret = find_mount_root(fullpath, &mnt);
> +	if (ret < 0) {
> +		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
> +				"%s\n", fullpath, strerror(-ret));
> +		ret = 1;
> +		goto out;
> +	}
> +	clean++;
> +
> +	svpath = get_subvol_name(mnt, fullpath);
> +
> +	fd = open_file_or_dir(fullpath);
> +	if (fd < 0) {
> +		fprintf(stderr, "ERROR: can't access '%s'\n", fullpath);
> +		ret = 1;
> +		goto out;
> +	}
> +	clean++;
> +
> +	sv_id = btrfs_list_get_path_rootid(fd);
> +	if (sv_id < 0) {
> +		fprintf(stderr, "ERROR: can't get rootid for '%s'\n",
> +			fullpath);
> +		ret = 1;
> +		goto out;
> +	}
> +
> +	mntfd = open_file_or_dir(mnt);
> +	if (mntfd < 0) {
> +		fprintf(stderr, "ERROR: can't access '%s'\n", mnt);
> +		ret = 1;
> +		goto out;
> +	}
> +	clean++;
> +
> +	mntid = btrfs_list_get_path_rootid(mntfd);
> +	if (mntid < 0) {
> +		fprintf(stderr, "ERROR: can't get rootid for '%s'\n", mnt);
> +		ret = 1;
> +		goto out;
> +	}
> +
> +	if (sv_id == 5) {

if (sv_id == BTRFS_FS_TREE_OBJECTID) {

> +		printf("%s is btrfs root\n", fullpath);
> +		ret = 1;
> +		goto out;
> +	}
> +
> +	memset(&get_ri, 0, sizeof(get_ri));
> +	get_ri.root_id = sv_id;
> +
> +	if (btrfs_get_subvol(mntfd, &get_ri)) {
> +		fprintf(stderr, "ERROR: can't find '%s'\n",
> +			svpath);
> +		ret = 1;
> +		goto out;
> +	}
> +
> +	ret = 0;
> +	/* print the info */
> +	printf("%s\n", fullpath);
> +	printf("\tName: \t\t\t%s\n", get_ri.name);
> +
> +	if (uuid_is_null(get_ri.uuid))
> +		strcpy(uuidparse, "-");
> +	else
> +		uuid_unparse(get_ri.uuid, uuidparse);
> +	printf("\tuuid: \t\t\t%s\n", uuidparse);
> +
> +	if (uuid_is_null(get_ri.puuid))
> +		strcpy(uuidparse, "-");
> +	else
> +		uuid_unparse(get_ri.puuid, uuidparse);
> +	printf("\tParent uuid: \t\t%s\n", uuidparse);
> +
> +	if (get_ri.otime)
> +		strftime(tstr, 256, "%Y-%m-%d %X",
> +			 localtime(&get_ri.otime));
> +	else
> +		strcpy(tstr, "-");
> +	printf("\tCreation time: \t\t%s\n", tstr);
> +
> +	printf("\tObject ID: \t\t%llu\n", get_ri.root_id);
> +	printf("\tGeneration (Gen): \t%llu\n", get_ri.gen);
> +	printf("\tGen at creation: \t%llu\n", get_ri.ogen);
> +	printf("\tParent: \t\t%llu\n", get_ri.ref_tree);
> +	printf("\tTop Level: \t\t%llu\n", get_ri.top_id);
> +
> +	/* print the snapshots of the given subvol if any*/
> +	printf("\tSnapshot(s):\n");
> +	filter_set = btrfs_list_alloc_filter_set();
> +	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_BY_PARENT,
> +				get_ri.uuid);
> +	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
> +	btrfs_list_subvols_print(fd, filter_set, NULL, BTRFS_LIST_LAYOUT_RAW,
> +			raw_prefix);
> +
> +	/* clean up */
> +	if (get_ri.path)
> +		free(get_ri.path);
> +	if (get_ri.name)
> +		free(get_ri.name);
> +	if (get_ri.full_path)
> +		free(get_ri.full_path);
> +
> +out:
> +	switch (clean) {
> +	case 4:
> +		close(mntfd);
> +	case 3:
> +		close(fd);
> +	case 2:
> +		free(mnt);
> +	case 1:
> +		free(fullpath);
> +		break;
> +	default:
> +		BUG();
> +	}

The common way to handle it is:
static int cmd_subvol_show(int argc, char **argv)
{
	int mntfd = -1;
	int fd = -1;
	char *mnt = NULL;
	char *fullpath = NULL;

	... everywhere, in case of errors, just goto out;

	mntfd = open...();
	if (mntfd < 0) {
		fprintf...
		goto out;
	}

out:
	if (mntfd >= 0)
		close(mntfd);
	if (fd >= 0)
		close(fd);
	free(mnt);
	free(fullpath);
	return ret;
}

Wherever an error happens inside the function, just goto out. When the
char pointers are not yet allocated, they are still NULL and thus
ignored by free(). If open() failed or the files are not yet opened, the
descriptors are still -1 and close() is not called.

It's basically impossible to add errors if you do it like this :)

> +	return ret;
> +}
> +
>  const struct cmd_group subvolume_cmd_group = {
>  	subvolume_cmd_group_usage, NULL, {
>  		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
> @@ -732,6 +897,7 @@ const struct cmd_group subvolume_cmd_group = {
>  		{ "set-default", cmd_subvol_set_default,
>  			cmd_subvol_set_default_usage, NULL, 0 },
>  		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
> +		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
>  		{ 0, 0, 0, 0, 0 }
>  	}
>  };
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index d20e332..0008a06 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -17,6 +17,8 @@ btrfs \- control a btrfs filesystem
>  .PP
>  \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
>  .PP
> +\fBbtrfs\fP \fBsubvolume show\fP\fI <path>\fP
> +.PP
>  \fBbtrfs\fP \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] \
>  [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> \
>  [<\fIfile\fR>|<\fIdir\fR>...]
> @@ -158,6 +160,10 @@ Get the default subvolume of the filesystem \fI<path>\fR. The output format
>  is similar to \fBsubvolume list\fR command.
>  .TP
>  
> +\fBsubvolume show\fR\fI <path>\fR
> +Show information of a given subvolume in the \fI<path>\fR.
> +.TP
> +
>  \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] \
>  [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
>  
> 


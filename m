Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62759 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2JCUeF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 16:34:05 -0400
Received: by wgbdr13 with SMTP id dr13so6459692wgb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 13:34:03 -0700 (PDT)
Date: Wed, 3 Oct 2012 23:34:00 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Roman Mamedov <rm@romanrm.ru>,
        =?utf-8?Q?S=C3=A9bastien?= Maury <sebastien.maury@inserm.fr>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/2] Update btrfs filesystem df command
Message-ID: <20121003203400.GD2890@zambezi.lan>
References: <1349284952-6865-1-git-send-email-kreijack@inwind.com>
 <1349284952-6865-2-git-send-email-kreijack@inwind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349284952-6865-2-git-send-email-kreijack@inwind.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 07:22:31PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
> 
> The  command  btrfs  filesystem  df is used to query the
> status of the chunks, how many space on the disk(s) are used  by
> the  chunks,  how many space are available in the chunks, and an
> estimation of the free space of the filesystem.
> ---
>  cmds-filesystem.c |  284 ++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 235 insertions(+), 49 deletions(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index b1457de..2701904 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -22,6 +22,7 @@
>  #include <errno.h>
>  #include <uuid/uuid.h>
>  #include <ctype.h>
> +#include <sys/vfs.h>
>  
>  #include "kerncompat.h"
>  #include "ctree.h"
> @@ -39,25 +40,55 @@ static const char * const filesystem_cmd_group_usage[] = {
>  	NULL
>  };
>  
> -static const char * const cmd_df_usage[] = {
> -	"btrfs filesystem df <path>",
> -	"Show space usage information for a mount point",
> -	NULL
> -};
> +static u64 disk_size( char *path){
> +	struct statfs	sfs;
> +
> +	if( statfs(path, &sfs) < 0 )
> +		return 0;
> +	else
> +		return sfs.f_bsize * sfs.f_blocks;
> +
> +}
> +
> +static void print_string(char *s, int w)
> +{
> +	int	i;
> +
> +	printf("%s", s);
> +	for( i = strlen(s) ; i < w ; i++ ) 
> +		putchar(' ');
> +}
> +
> +#define DF_SHOW_SUMMARY 	(1<<1)
> +#define DF_SHOW_DETAIL		(1<<2)
> +#define DF_HUMAN_UNIT		(1<<3)
> +
> +static void pretty_sizes_r(u64 size, int w, int mode)
> +{
> +	if( mode & DF_HUMAN_UNIT ){
> +		char *s = pretty_sizes(size);
> +		printf("%*s", w, s);
> +		free(s);
> +	} else {
> +		printf("%*llu", w, size/1024);
> +
> +	}
> +}
>  
> -static int cmd_df(int argc, char **argv)
> +static int _cmd_disk_free(char *path, int mode)
>  {
>  	struct btrfs_ioctl_space_args *sargs;
>  	u64 count = 0, i;
>  	int ret;
>  	int fd;
> -	int e;
> -	char *path;
> -
> -	if (check_argc_exact(argc, 2))
> -		usage(cmd_df_usage);
> -
> -	path = argv[1];
> +	int e, width;
> +	u64  total_disk;		/* filesystem size == sum of
> +					   disks sizes */
> +	u64  total_chunks;		/* sum of chunks sizes on disk(s) */
> +	u64  total_used;		/* logical space used */
> +	u64  total_free;		/* logical space un-used */
> +	double K;
> +	
>  
>  	fd = open_file_or_dir(path);
>  	if (fd < 0) {
> @@ -103,56 +134,211 @@ static int cmd_df(int argc, char **argv)
>  		return ret;
>  	}
>  
> -	for (i = 0; i < sargs->total_spaces; i++) {
> -		char description[80];
> -		char *total_bytes;
> -		char *used_bytes;
> -		int written = 0;
> -		u64 flags = sargs->spaces[i].flags;
> +	total_disk = disk_size(path);
> +	e = errno;
> +	if( total_disk == 0 ){
> +		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
> +			path, strerror(e));
> +		close(fd);
> +		free(sargs);
> +		return 19;
> +	}
> +		
> +	total_chunks = total_used = total_free = 0;
>  
> -		memset(description, 0, 80);
> +	for (i = 0; i < sargs->total_spaces; i++) {
> +		int  ratio=1;
> +		u64  allocated;
>  
> -		if (flags & BTRFS_BLOCK_GROUP_DATA) {
> -			if (flags & BTRFS_BLOCK_GROUP_METADATA) {
> -				snprintf(description, 14, "%s",
> -					 "Data+Metadata");
> -				written += 13;
> -			} else {
> -				snprintf(description, 5, "%s", "Data");
> -				written += 4;
> -			}
> -		} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
> -			snprintf(description, 7, "%s", "System");
> -			written += 6;
> -		} else if (flags & BTRFS_BLOCK_GROUP_METADATA) {
> -			snprintf(description, 9, "%s", "Metadata");
> -			written += 8;
> -		}
> +		u64 flags = sargs->spaces[i].flags;
>  
>  		if (flags & BTRFS_BLOCK_GROUP_RAID0) {
> -			snprintf(description+written, 8, "%s", ", RAID0");
> -			written += 7;
> +			ratio=1;
>  		} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
> -			snprintf(description+written, 8, "%s", ", RAID1");
> -			written += 7;
> +			ratio=2;
>  		} else if (flags & BTRFS_BLOCK_GROUP_DUP) {
> -			snprintf(description+written, 6, "%s", ", DUP");
> -			written += 5;
> +			ratio=2;
>  		} else if (flags & BTRFS_BLOCK_GROUP_RAID10) {
> -			snprintf(description+written, 9, "%s", ", RAID10");
> -			written += 8;
> +			ratio=2;
> +		} else {
> +			ratio=1;
>  		}
>  
> -		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
> -		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
> -		printf("%s: total=%s, used=%s\n", description, total_bytes,
> -		       used_bytes);
> +		allocated = sargs->spaces[i].total_bytes * ratio;
> +
> +		total_chunks += allocated;
> +		total_used += sargs->spaces[i].used_bytes;
> +		total_free += (sargs->spaces[i].total_bytes - 
> +					sargs->spaces[i].used_bytes);
> +
> +	}
> +	K = ((double)total_used + (double)total_free) /
> +	                (double)total_chunks;
> +
> +	if( mode & DF_HUMAN_UNIT )
> +		width = 12;
> +	else
> +		width = 18;
> +
> +	printf("Path: %s\n", path);
> +	if( mode & DF_SHOW_SUMMARY ){
> +		printf("Summary:\n");
> +		printf("  Disk_size:\t\t");
> +		pretty_sizes_r(total_disk, width, mode);
> +		printf("\n  Disk_allocated:\t");
> +		pretty_sizes_r(total_chunks, width, mode);
> +		printf("\n  Disk_unallocated:\t"); 
> +		pretty_sizes_r(total_disk-total_chunks, width, mode);
> +		printf("\n  Logical_size:\t\t"); 
> +		pretty_sizes_r(total_used+total_free, width, mode);
> +		printf("\n  Used:\t\t\t"); 
> +		pretty_sizes_r(total_used, width, mode);
> +		printf("\n  Free_(Estimated):\t");
> +		pretty_sizes_r((u64)(K*total_disk-total_used), width, mode);
> +		printf("\t(Max: ");
> +		pretty_sizes_r(total_disk-total_chunks+total_free, 
> +				0, mode );
> +		printf(", Min: ");
> +		pretty_sizes_r((total_disk-total_chunks)/2+total_free, 
> +				0, mode );
> +		printf(")\n  Data_to_disk_ratio:\t%*.0f %%\n",
> +			width-2, K*100);
> +	}
> +
> +	if( ( mode & DF_SHOW_DETAIL ) && ( mode & DF_SHOW_SUMMARY ) )
> +		printf("\n");
> +
> +	if( mode & DF_SHOW_DETAIL ){
> +		/* Remember: the terminals have maximum 80 columns
> +		   do not believe to who says otherwise */
> +		printf("Details:\n");
> +		printf("  %-12s%-8s%*s%*s%*s\n",
> +			"Chunk_type", 
> +			"Mode",
> +			width, "Chunk_size", 
> +			width+1, "Logical_size", 
> +			width, "Used"
> +		);
> +
> +		for (i = 0; i < sargs->total_spaces; i++) {
> +			char *description="";
> +			int  ratio=1;
> +			char *r_mode;
> +			u64 allocated;
> +
> +			u64 flags = sargs->spaces[i].flags;
> +
> +			if (flags & BTRFS_BLOCK_GROUP_DATA) {
> +				if (flags & BTRFS_BLOCK_GROUP_METADATA){
> +					description = "Data+M.data";
> +				} else {
> +					description = "Data";
> +				}
> +			} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
> +				description = "System";
> +			} else if (flags & BTRFS_BLOCK_GROUP_METADATA) {
> +				description = "Metadata";
> +			}
> +
> +			if (flags & BTRFS_BLOCK_GROUP_RAID0) {
> +				r_mode = "RAID0";
> +				ratio=1;
> +			} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
> +				r_mode = "RAID1";
> +				ratio=2;
> +			} else if (flags & BTRFS_BLOCK_GROUP_DUP) {
> +				r_mode = "DUP";
> +				ratio=2;
> +			} else if (flags & BTRFS_BLOCK_GROUP_RAID10) {
> +				r_mode = "RAID10";
> +				ratio=2;
> +			} else {
> +				r_mode = "Single";
> +				ratio=1;
> +			}
> +
> +			allocated = sargs->spaces[i].total_bytes * ratio;
> +
> +			printf("  ");
> +			print_string(description,12);
> +			print_string(r_mode, 8);
> +			pretty_sizes_r(allocated, width, mode);
> +			pretty_sizes_r(sargs->spaces[i].total_bytes ,
> +				    width+1, mode);
> +	
> +			pretty_sizes_r(sargs->spaces[i].used_bytes, 
> +						width, mode);
> +			printf("\n");
> +
> +		}
>  	}
>  	free(sargs);
>  
>  	return 0;
>  }
>  
> +static const char * const cmd_disk_free_usage[] = {
> +	"btrfs filesystem df [-d|-s][-k] <path> [<path>..]",
> +	"Show space usage information for a mount point(s).",
> +	"",
> +	"-k\tSet KB (1024 bytes) as unit",
> +	"-s\tShow the summary section only",
> +	"-d\tShow the detail section only",
> +	NULL
> +};
> +
> +static int cmd_disk_free(int argc, char **argv)
> +{
> +
> +	int 	flags=DF_SHOW_SUMMARY|DF_SHOW_DETAIL|DF_HUMAN_UNIT;
> +	int	i, more_than_one=0;
> +
> +	optind = 1;
> +	while(1){
> +		char	c = getopt(argc, argv, "dsk");
> +		if(c<0)
> +			break;
> +		switch(c){
> +			case 'd':
> +				flags &= ~DF_SHOW_SUMMARY;
> +				break;
> +			case 's':
> +				flags &= ~DF_SHOW_DETAIL;
> +				break;
> +			case 'k':
> +				flags &= ~DF_HUMAN_UNIT;
> +				break;
> +			default:
> +				usage(cmd_disk_free_usage);
> +		}
> +	}
> +
> +	if( !(flags & (DF_SHOW_SUMMARY|DF_SHOW_DETAIL)) ){
> +		fprintf(stderr, "btrfs filesystem df: it is not possible to specify -s AND -d\n");

This doesn't look right at all.  You are adding two switches and
specifying both of them is an error?  A little too much for a command
whose job is to do some basic math and pretty-print the result.

How about displaying just the summary by default and then adding a
*single* switch (-v or whatever) for summary+details?

Thanks,

		Ilya

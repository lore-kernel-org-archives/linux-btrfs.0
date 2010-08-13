From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH 1/2] Btrfs-progs: Add support for hot data ioctls
Date: Fri, 13 Aug 2010 18:44:25 +0200
Message-ID: <201008131844.25648.kreijack@libero.it>
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com> <1281652177-23562-2-git-send-email-bchociej@gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: bchociej@gmail.com, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1281652177-23562-2-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Mr Chociej,

some months ago I wrote a new command (called "btrfs"), with the aim to 
replace "btrfsctl" at all, for a lot of reasons: bugs, largely unmaintained, 
difficult to maintain. After a lot of review in the btrfs mailing list now 
btrfs is in the official source.
I suggest to update your patches to using the btrfs command. If you need help 
in this change, please contact me.

The experimental commands may be prefixed with the "test" verb, like

$ btrfs test <whatYouWant ...>

Chris,
does btrfsctl should be marked as deprecated ?

Regards
G.Baroncelli



On Friday, 13 August, 2010, bchociej@gmail.com wrote:
> From: Ben Chociej <bchociej@gmail.com>
> 
> Add support for the new hot data functionality in-kernel. Three ioctls
> were added to export hot data statistics and turn hot data tracking on
> and off per inode. This patch enables btrfsctl to interact with those
> ioctls.
> 
> Signed-off-by: Ben Chociej <bchociej@gmail.com>
> Signed-off-by: Matt Lupfer <mlupfer@gmail.com>
> Tested-by: Conor Scott <conscott@vt.edu>
> ---
>  btrfsctl.c   |  107 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  ioctl-test.c |    3 ++
>  ioctl.h      |   24 +++++++++++++
>  3 files changed, 134 insertions(+), 0 deletions(-)
> 
> diff --git a/btrfsctl.c b/btrfsctl.c
> index be6bf25..8617d06 100644
> --- a/btrfsctl.c
> +++ b/btrfsctl.c
> @@ -48,6 +48,7 @@ static void print_usage(void)
>  {
>  	printf("usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree 
]\n");
>  	printf("                [-r size] [-A device] [-a] [-c] [-D dir 
.]\n");
> +	printf("                [-t file] [-T file] [-h filename [0-2]]\n");
>  	printf("\t-d filename: defragments one file\n");
>  	printf("\t-d directory: defragments the entire Btree\n");
>  	printf("\t-s snap_name dir: creates a new snapshot of dir\n");
> @@ -57,6 +58,14 @@ static void print_usage(void)
>  	printf("\t-a: scans all devices for Btrfs filesystems\n");
>  	printf("\t-c: forces a single FS sync\n");
>  	printf("\t-D: delete snapshot\n");
> +	printf("\t-t filename: dump indexed heat information for a file\n");
> +	printf("\t-T filename: dump live heat informaton for a file\n");
> +	printf("\t-h filename: query heat tracking/migration status\n");
> +	printf("\t-h filename level: set heat tracking level:\n");
> +	printf("\t\tlevel =\n");
> +	printf("\t\t0: no tracking or relocation\n");
> +	printf("\t\t1: access tracking only\n");
> +	printf("\t\t2: tracking and automatic migration to SSD\n");
>  	printf("\t-m [tree id] directory: set the default mounted subvolume"
>  	       " to the [tree id] or the directory\n");
>  	printf("%s\n", BTRFS_BUILD_VERSION);
> @@ -99,12 +108,14 @@ int main(int ac, char **av)
>  	int fd;
>  	int ret;
>  	struct btrfs_ioctl_vol_args args;
> +	struct btrfs_ioctl_heat_info hotinfo;
>  	char *name = NULL;
>  	int i;
>  	unsigned long command = 0;
>  	int len;
>  	char *fullpath;
>  	u64 objectid = 0;
> +	int heatarg;
>  
>  	if (ac == 2 && strcmp(av[1], "-a") == 0) {
>  		fprintf(stderr, "Scanning for Btrfs filesystems\n");
> @@ -205,6 +216,38 @@ int main(int ac, char **av)
>  					exit(1);
>  				}
>  			}
> +		} else if (strcmp(av[i], "-t") == 0) {
> +			if (i >= ac - 1) {
> +				fprintf(stderr,
> +					"-t requires a file argument\n");
> +				print_usage();
> +			}
> +			hotinfo.live = 0;
> +			command = BTRFS_IOC_GET_HEAT_INFO;
> +		} else if (strcmp(av[i], "-T") == 0) {
> +			if (i >= ac - 1) {
> +				fprintf(stderr,
> +					"-T requires a file argument\n");
> +				print_usage();
> +			}
> +			hotinfo.live = 1;
> +			command = BTRFS_IOC_GET_HEAT_INFO;
> +		} else if (strcmp(av[i], "-h") == 0) {
> +			if (i == ac - 2) {
> +				command = BTRFS_IOC_GET_HEAT_OPTS;
> +			} else if (i == ac - 3) {
> +				command = BTRFS_IOC_SET_HEAT_OPTS;
> +				heatarg = atoi(av[i + 2]);
> +			} else {
> +				fprintf(stderr, "-h invalid number of "
> +					"arguments\n");
> +				print_usage();
> +				exit(1);
> +			}
> +
> +			fprintf(stderr, "Btrfs hot data tracking: `%s'\n\n",
> +				av[i + 1]);
> +			av[i + 2] = av[i + 1];
>  		}
>  	}
>  	if (command == 0) {
> @@ -236,6 +279,70 @@ int main(int ac, char **av)
>  	} else if (command == BTRFS_IOC_DEFAULT_SUBVOL) {
>  		printf("objectid is %llu\n", objectid);
>  		ret = ioctl(fd, command, &objectid);
> +	} else if (command == BTRFS_IOC_GET_HEAT_INFO) {
> +		strcpy(hotinfo.filename, fname);
> +		ret = ioctl(fd, command, &hotinfo);
> +		if (ret == 0) {
> +			printf("Btrfs file hotness information\n");
> +			printf("%s\n\n", hotinfo.filename);
> +			printf("Last write: %llu\n",
> +				(u64) hotinfo.last_write_time);
> +			printf("Last read: %llu\n",
> +				(u64) hotinfo.last_read_time);
> +			printf("Average write delta: %llu\n",
> +				(u64) hotinfo.avg_delta_writes);
> +			printf("Average read delta: %llu\n",
> +				(u64) hotinfo.avg_delta_reads);
> +			printf("Number of writes: %u\n",
> +				(u32) hotinfo.num_writes);
> +			printf("Number of reads: %u\n\n",
> +				(u32) hotinfo.num_reads);
> +			if (hotinfo.live > 0)
> +				printf("Temperature (live): %u\n\n",
> +					hotinfo.temperature);
> +			else
> +				printf("Temperature (indexed): %u\n\n",
> +					hotinfo.temperature);
> +		}
> +	} else if (command == BTRFS_IOC_SET_HEAT_OPTS) {
> +		ret = ioctl(fd, command, &heatarg);
> +		switch (heatarg) {
> +		case 0:
> +			printf("Turning OFF heat tracking and migration inode 
"
> +				"flags.\n");
> +			break;
> +		case 1:
> +			printf("Turning ON the heat tracking inode flag.\n");
> +			printf("Turning OFF the migration inode flag.\n");
> +			break;
> +		case 2:
> +			printf("Turning ON heat tracking and migration inode "
> +				"flags.\n");
> +			break;
> +		default:
> +			printf("Invalid heat tracking argument.\n");
> +		}
> +		printf("(Inode flags can be overridden by mount 
options)\n\n");
> +	} else if (command == BTRFS_IOC_GET_HEAT_OPTS) {
> +		ret = ioctl(fd, command, &heatarg);
> +		switch (heatarg) {
> +		case 0:
> +			printf("Heat tracking and migration inode flags are "
> +				"OFF.\n");
> +			break;
> +		case 1:
> +			printf("Heat tracking inode flag is ON, migration "
> +				"inode flag is OFF.\n");
> +			break;
> +		case 2:
> +			printf("Heat tracking and migration inode flags are "
> +				"both ON.\n");
> +			break;
> +		default:
> +			printf("Wrong filesystem type, or invalid status "
> +				"returned.\n");
> +		}
> +		printf("(Inode flags can be overridden by mount 
options)\n\n");
>  	} else
>  		ret = ioctl(fd, command, &args);
>  	if (ret < 0) {
> diff --git a/ioctl-test.c b/ioctl-test.c
> index 7cf3bc2..8d54301 100644
> --- a/ioctl-test.c
> +++ b/ioctl-test.c
> @@ -22,6 +22,9 @@ unsigned long ioctls[] = {
>  	BTRFS_IOC_INO_LOOKUP,
>  	BTRFS_IOC_DEFAULT_SUBVOL,
>  	BTRFS_IOC_SPACE_INFO,
> +	BTRFS_IOC_GET_HEAT_INFO,
> +	BTRFS_IOC_SET_HEAT_OPTS,
> +	BTRFS_IOC_GET_HEAT_OPTS,
>  	0 };
>  
>  int main(int ac, char **av)
> diff --git a/ioctl.h b/ioctl.h
> index 776d7a9..5827338 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -132,6 +132,18 @@ struct btrfs_ioctl_space_args {
>  	struct btrfs_ioctl_space_info spaces[0];
>  };
>  
> +struct btrfs_ioctl_heat_info {
> +	__u64 avg_delta_reads;
> +	__u64 avg_delta_writes;
> +	__u64 last_read_time;
> +	__u64 last_write_time;
> +	__u32 num_reads;
> +	__u32 num_writes;
> +	char filename[BTRFS_PATH_NAME_MAX + 1];
> +	int temperature;
> +	__u8 live;
> +};
> +
>  #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
> @@ -169,4 +181,16 @@ struct btrfs_ioctl_space_args {
>  #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
>  #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
>  				    struct btrfs_ioctl_space_args)
> +
> +/*
> + * Hot data tracking ioctls:
> + *
> + * GET_HEAT_INFO - retrieve frequency of access info on a file
> + * SET_HEAT_OPTS - set whether a file is tracked/migratable
> + * GET_HEAT_OPTS - check whether a file is tracked/migratable
> + */
> +#define BTRFS_IOC_GET_HEAT_INFO _IOWR(BTRFS_IOCTL_MAGIC, 21, \
> +				struct btrfs_ioctl_heat_info)
> +#define BTRFS_IOC_SET_HEAT_OPTS _IOW(BTRFS_IOCTL_MAGIC, 22, int)
> +#define BTRFS_IOC_GET_HEAT_OPTS _IOR(BTRFS_IOCTL_MAGIC, 23, int)
>  #endif
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

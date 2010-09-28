From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH] Btrfs-progs: add btrfs filesystem disk-info command
Date: Wed, 29 Sep 2010 00:48:15 +0200
Message-ID: <201009290048.15214.kreijack@libero.it>
References: <1285707219-16304-1-git-send-email-josef@redhat.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1285707219-16304-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

please, if you add or change a command pay attention to update the man page 
too (man/btrfs.8.in).

See my comments below

On Tuesday, 28 September, 2010, Josef Bacik wrote:
> This command just implements the BTRFS_IOC_DISK_INFO ioctl.  It gets all the
> devices for a filesystem, reads /proc/partitions for the right dev info and
> spits out pretty names.
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  btrfs.c      |    4 ++
>  btrfs_cmds.c |  101 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  btrfs_cmds.h |    1 +
>  ioctl.h      |    8 ++++
>  4 files changed, 114 insertions(+), 0 deletions(-)
> 
> diff --git a/btrfs.c b/btrfs.c
> index ab5e57f..22b241b 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -91,6 +91,10 @@ static struct Command commands[] = {
>  	  "filesystem df", "<path>\n"
>  		"Show space usage information for a mount point\n."
>  	},
> +	{ do_disk_info, 1,
> +	  "filesystem disk-info", "<path>\n"
> +		"Show disks contained within this filesysten."
> +	},
>  	{ do_balance, 1,
>  	  "filesystem balance", "<path>\n"
>  		"Balance the chunks across the device."
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index 683aec0..b1a4d8d 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -835,6 +835,107 @@ int do_set_default_subvol(int nargs, char **argv)
>  	return 0;
>  }
>  
> +int do_disk_info(int nargs, char **argv)
> +{
> +	struct btrfs_ioctl_disk_info_args *args;
> +	char *path = argv[1];
> +	int devs;
> +	int fd;
> +	int ret;
> +	int i;
> +
> +	fd = open_file_or_dir(path);
> +	if (fd < 0) {
> +		fprintf(stderr, "Error: can't access '%s'\n", path);
> +		return 12;
> +	}
> +
> +	args = malloc(sizeof(*args));
> +	if (!args)
> +		return -ENOMEM;
> +
> +	args->num_devices = 0;
> +
> +	ret = ioctl(fd, BTRFS_IOC_DISK_INFO, args);
> +	if (ret) {
> +		printf("failed ioctl\n");
Please use
		fprintf(stderr,"ERROR: failed ioctl\n");

> +		free(args);
> +		return ret;
> +	}
> +
> +	if (!args->num_devices) {
> +		printf("no devs\n");
> +		free(args);
> +		return 0;
> +	}
> +
> +	devs = args->num_devices;
> +	args = realloc(args, sizeof(*args) + (devs * sizeof(dev_t)));
> +	if (!args) {
> +		printf("enomem\n");
Please use
		fprintf(stderr,"ERROR: not enough memory\n");
> +		return -ENOMEM;
> +	}
> +	args->num_devices = devs;
> +
> +	ret = ioctl(fd, BTRFS_IOC_DISK_INFO, args);
> +	if (ret) {
> +		printf("ioctl failed second time\n");
Please use
		fprintf(stderr,"ERROR: ioctl failed (second time)\n");

> +		free(args);
> +		return -ENOMEM;
> +	}
> +	close(fd);
> +
> +	fd = open_file_or_dir("/proc/partitions");

Why not

	f = fopen("/proc/partitions","r")

So you can avoid "f = fdopen(fd,"r")" and the "goto print"

> +	if (fd < 0) {
> +print:
> +		printf("Devices in %s\n", path);
> +		for (i = 0; i < args->num_devices; i++)
> +			printf("\t%d:%d\n", major(args->devices[i]),
> +			       minor(args->devices[i]));
> +		close(fd);
		^^^^^^^^^
why close fd ? ... ok, in case of fdopen(fd,"r") == 0

> +	} else {
> +		int major, minor;
> +		unsigned long long blocks;
> +		char buf[128];
> +		char name[32];
> +		FILE *f;
> +		int found_devices = 0;
> +

> +		f = fdopen(fd, "r");
> +		if (!f)
> +			goto print;
See my comments above 

> +
> +		printf("Devices in %s\n", path);
> +		while (!feof(f)) {
> +			char *blah;
> +
> +			memset(name, 0, 32);
> +			memset(buf, 0, 128);
> +
> +			blah = fgets(buf, 128, f);
> +
> +			ret = sscanf(buf, "%d %d %llu %32s", &major, &minor, 
&blocks, name);
> +			if (!ret)
> +				continue;
> +
> +			for (i = 0; i < args->num_devices; i++) {
> +				if (major(args->devices[i]) != major)
> +					continue;
> +				if (minor(args->devices[i]) != minor)
> +					continue;
> +				found_devices++;
> +				printf("\t/dev/%s\n", name);
> +				break;
> +			}
> +			if (found_devices == args->num_devices)
> +				break;
> +		}
> +		fclose(f);
> +	}
> +	free(args);
> +	return 0;
> +}
> +
>  int do_df_filesystem(int nargs, char **argv)
>  {
>  	struct btrfs_ioctl_space_args *sargs;
> diff --git a/btrfs_cmds.h b/btrfs_cmds.h
> index 7bde191..0b5038a 100644
> --- a/btrfs_cmds.h
> +++ b/btrfs_cmds.h
> @@ -31,4 +31,5 @@ int do_set_default_subvol(int nargs, char **argv);
>  int list_subvols(int fd);
>  int do_df_filesystem(int nargs, char **argv);
>  int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
> +int do_disk_info(int nargs, char **argv);
>  int do_find_newer(int argc, char **argv);
> diff --git a/ioctl.h b/ioctl.h
> index 776d7a9..4ace64f 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -19,6 +19,7 @@
>  #ifndef __IOCTL_
>  #define __IOCTL_
>  #include <asm/types.h>
> +#include <sys/types.h>
>  #include <linux/ioctl.h>
>  
>  #define BTRFS_IOCTL_MAGIC 0x94
> @@ -132,6 +133,11 @@ struct btrfs_ioctl_space_args {
>  	struct btrfs_ioctl_space_info spaces[0];
>  };
>  
> +struct btrfs_ioctl_disk_info_args {
> +	__u32 num_devices;
> +	__u64 devices[0];
> +};
> +
>  #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
> @@ -169,4 +175,6 @@ struct btrfs_ioctl_space_args {
>  #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
>  #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
>  				    struct btrfs_ioctl_space_args)
> +#define BTRFS_IOC_DISK_INFO _IOWR(BTRFS_IOCTL_MAGIC, 21, \
> +				  struct btrfs_ioctl_disk_info_args)
>  #endif
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

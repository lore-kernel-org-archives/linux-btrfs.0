From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH 1/5] Add support for read-only subvolumes.
Date: Mon, 25 Apr 2011 23:34:46 +0200
Message-ID: <4DB5E8F6.1020807@libero.it>
References: <1303733730-sup-9388@think> <1303739282-1675-1-git-send-email-philipp.andreas@gmail.com> <1303739282-1675-2-git-send-email-philipp.andreas@gmail.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	lizf@cn.fujitsu.com
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303739282-1675-2-git-send-email-philipp.andreas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Andreas,

On 04/25/2011 03:47 PM, Andreas Philipp wrote:
> Use BTRFS_IOC_CREATE_SNAP_V2 instead of BTRFS_IOC_CREATE_SNAP and add
> an option for the creation of a readonly snapshot.
> 
> Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
> ---
>  btrfs_cmds.c |   44 ++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index 8031c58..baec675 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -43,7 +43,7 @@
>  
>  #ifdef __CHECKER__

It is not related to your parch.. but does anyone know why we re-define
some constants if __CHECKER__ is defined ?

>  #define BLKGETSIZE64 0
> -#define BTRFS_IOC_SNAP_CREATE 0
> +#define BTRFS_IOC_SNAP_CREATE_V2 0
>  #define BTRFS_VOL_NAME_MAX 255
>  struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
>  static inline int ioctl(int fd, int define, void *arg) { return 0; }
> @@ -310,13 +310,34 @@ int do_subvol_list(int argc, char **argv)
>  int do_clone(int argc, char **argv)
>  {
>  	char	*subvol, *dst;
> -	int	res, fd, fddst, len;
> +	int	res, fd, fddst, len, optind = 0, readonly = 0;
>  	char	*newname;
>  	char	*dstdir;
>  
> -	subvol = argv[1];
> -	dst = argv[2];
> -	struct btrfs_ioctl_vol_args	args;
> +	while(1) {
> +		int c = getopt(argc, argv, "r");
> +		if (c < 0)
> +			break;
> +		switch(c) {
> +			case 'r':
> +				optind++;
> +				readonly = 1;
> +				break;
> +	                default:
> +				fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
> +				free(argv);
> +				return 1;
> +		}
> +	}
> +	if (argc - optind < 2) {
> +		fprintf(stderr, "Invalid arguments for defragment\n");
                                                       ^^^^^^^^^^^^

May be that you need to replace "defragment" with "subvolume snapshot" ?

> +		free(argv);
> +		return 1;
> +	}
> +
> +	subvol = argv[optind+1];
> +	dst = argv[optind+2];
> +	struct btrfs_ioctl_vol_args_v2	args;

Does the "standard C" allow to define a variable in the middle in a
function instead of in the begin ?
Anyway, even not required, I suggest to fill "args" by zero.

+	memset(&args, 0, sizeog(args));

>  
>  	res = test_issubvolume(subvol);
>  	if(res<0){
> @@ -371,12 +392,19 @@ int do_clone(int argc, char **argv)
>  		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
>  		return 12;
>  	}
> +	
> +	if (readonly) {
> +		args.flags |= BTRFS_SUBVOL_RDONLY;
> +		printf("Create a readonly snapshot of '%s' in '%s/%s'\n",
> +		       subvol, dstdir, newname);
> +	}
> +	else
> +		printf("Create a snapshot of '%s' in '%s/%s'\n",
> +		       subvol, dstdir, newname);
>  
It is not required, but I suggest to use also in the "else" the brackets
( {} ).

> -	printf("Create a snapshot of '%s' in '%s/%s'\n",
> -	       subvol, dstdir, newname);
>  	args.fd = fd;
>  	strcpy(args.name, newname);
> -	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE, &args);
> +	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
>  
>  	close(fd);
>  	close(fddst);

Regards
G.Baroncelli

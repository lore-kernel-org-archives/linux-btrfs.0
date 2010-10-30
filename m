From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH 3/3] btrfs: implement 'start-sync' and 'wait-sync' commands
Date: Sat, 30 Oct 2010 20:29:58 +0200
Message-ID: <201010302029.59062.kreijack@libero.it>
References: <1288461366-26914-1-git-send-email-sage@newdream.net> <1288461366-26914-3-git-send-email-sage@newdream.net>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288461366-26914-3-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 30 October, 2010, Sage Weil wrote:
> The 'start-sync' command initiates a sync, but does not wait for it to
> complete.  A transaction is printed that can be fed to 'wait-sync', which
> will wait for it to commit.
> 
> 'wait-sync' can also be used in combination with 'async-snapshot' to wait
> for an async snapshot creation to commit.

As previous, if you add or update a command, please update the man page too.

> 
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  btrfs.c      |    9 +++++++++
>  btrfs_cmds.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  btrfs_cmds.h |    2 ++
>  3 files changed, 60 insertions(+), 0 deletions(-)
> 
> diff --git a/btrfs.c b/btrfs.c
> index c4b9a31..d45ac1f 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -83,6 +83,15 @@ static struct Command commands[] = {
>  	  "filesystem sync", "<path>\n"
>  		"Force a sync on the filesystem <path>."
>  	},
> +	{ do_start_sync, 1,
> +	  "filesystem start-sync", "<path>\n"
> +	        "Start a sync on the filesystem <path>, and print the 
resulting\n"
> +	        "transaction id."
> +	},
> +	{ do_wait_sync, 2,
> +	  "filesystem wait-sync", "<path> <transid>\n"
> +	        "Wait for the transaction <transid> on the filesystem at 
<path> to commit."
> +	},
>  	{ do_resize, 2,
>  	  "filesystem resize", "[+/-]<newsize>[gkm]|max <filesystem>\n"
>  		"Resize the file system. If 'max' is passed, the filesystem\n"
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index 6da5862..5b5bb15 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -548,6 +548,55 @@ int do_fssync(int argc, char **argv)
>  	return 0;
>  }
>  
> +int do_start_sync(int argc, char **argv)
> +{
> +	int fd, res;
> +	char	*path = argv[1];
> +	__u64 transid;
> +
> +	fd = open_file_or_dir(path);
> +	if (fd < 0) {
> +		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> +		return 12;
> +	}
> +
> +	printf("StartSync '%s'\n", path);
> +	res = ioctl(fd, BTRFS_IOC_START_SYNC, &transid);
> +	close(fd);
> +	if( res < 0 ){
> +		fprintf(stderr, "ERROR: unable to fs-syncing '%s'\n", path);
> +		return 16;
> +	} else {
> +		printf("transid %llu\n", (unsigned long long)transid);
> +	}
> +
> +	return 0;
> +}
> +
> +int do_wait_sync(int argc, char **argv)
> +{
> +	int fd, res;
> +	char	*path = argv[1];
> +	__u64 transid = atoll(argv[2]);
> +
> +	fd = open_file_or_dir(path);
> +	if (fd < 0) {
> +		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> +		return 12;
> +	}
> +
> +	printf("WaitSync '%s' transid %llu\n", path, (unsigned long 
long)transid);
> +	res = ioctl(fd, BTRFS_IOC_WAIT_SYNC, &transid);
> +	close(fd);
> +	if( res < 0 ){
> +		fprintf(stderr, "ERROR: unable to wait-sync on '%s' transid 
%llu: %s\n", path,
> +			(unsigned long long)transid, strerror(errno));
> +		return 16;
> +	}
> +
> +	return 0;
> +}
> +
>  int do_scan(int argc, char **argv)
>  {
>  	int	i, fd;
> diff --git a/btrfs_cmds.h b/btrfs_cmds.h
> index c44dc79..e0e5ceb 100644
> --- a/btrfs_cmds.h
> +++ b/btrfs_cmds.h
> @@ -20,6 +20,8 @@ int do_create_snap_async(int nargs, char **argv);
>  int do_delete_subvolume(int nargs, char **argv);
>  int do_create_subvol(int nargs, char **argv);
>  int do_fssync(int nargs, char **argv);
> +int do_start_sync(int nargs, char **argv);
> +int do_wait_sync(int nargs, char **argv);
>  int do_defrag(int argc, char **argv);
>  int do_show_filesystem(int nargs, char **argv);
>  int do_add_volume(int nargs, char **args);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

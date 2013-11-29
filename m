Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31751 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3K2FMg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 00:12:36 -0500
Message-ID: <52982287.4040808@cn.fujitsu.com>
Date: Fri, 29 Nov 2013 13:13:43 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
CC: clm@fb.com, Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH] btrfs-progs: add options to sync filesystem after subvol
 delete
References: <1385657947-26145-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1385657947-26145-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 28 Nov 2013 17:59:07 +0100, David Sterba wrote:
> Subvolume deletion does not do a full transaction commit. This can lead
> to an unexpected result when the system crashes between deletion and
> commit, the subvolume directory will appear again. Add options to request
> filesystem sync after each deleted subvolume or after the last one.
> 
> If the command with sync option finishes succesfully, the subvolume(s)
> deletion status is safely stored on the media.
> 
> Userspace approach is more flexible than in-kernel. Related discussions:
> http://www.spinics.net/lists/linux-btrfs/msg22088.html
> http://www.spinics.net/lists/linux-btrfs/msg27240.html
> 
> CC: Alex Lyakas <alex.btrfs@zadarastorage.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
> 
> The option names may not be ideal, feel free to suggest better.
> 
>  cmds-subvolume.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  man/btrfs.8.in   | 23 ++++++++++++++---
>  2 files changed, 90 insertions(+), 10 deletions(-)
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index c6a5284a02a4..c124c3185252 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -202,24 +202,67 @@ int test_issubvolume(char *path)
>  }
>  
>  static const char * const cmd_subvol_delete_usage[] = {
> -	"btrfs subvolume delete <subvolume> [<subvolume>...]",
> +	"btrfs subvolume delete [options] <subvolume> [<subvolume>...]",
>  	"Delete subvolume(s)",
> +	"Delete subvolumes from the filesystem. The corresponding directory",
> +	"is removed instantly but the data blocks are removed later.",
> +	"The deletion does not involve full commit by default due to",
> +	"performance reasons (as a consequence, the subvolume may appear again",
> +	"after a crash). Use one of the --sync options to sync the filesystem",
> +	"via a btrfs specific ioctl.",
> +	"",
> +	"-s|--sync-after      call sync at the end of the operation",
> +	"-S|--sync-each       sync the filesystem after deleting each subvolume",
>  	NULL
>  };
>  
>  static int cmd_subvol_delete(int argc, char **argv)
>  {
> -	int	res, fd, len, e, cnt = 1, ret = 0;
> +	int	res, len, e, ret = 0;
> +	int cnt;
> +	int fd = -1;
>  	struct btrfs_ioctl_vol_args	args;
>  	char	*dname, *vname, *cpath;
>  	char	*dupdname = NULL;
>  	char	*dupvname = NULL;
>  	char	*path;
>  	DIR	*dirstream = NULL;
> +	int sync_mode = 0;
> +	struct option long_options[] = {
> +		{"sync-after", no_argument, NULL, 's'},	/* sync mode 1 */
> +		{"sync-each", no_argument, NULL, 'S'},	/* sync mode 2 */
> +		{NULL, 0, NULL, 0}
> +	};

Generally, we put it out of the functions.

> -	if (argc < 2)
> +	optind = 1;
> +	while (1) {
> +		int c;
> +
> +		c = getopt_long(argc, argv, "sS", long_options, NULL);
> +		if (c < 0)
> +			break;
> +
> +		switch(c) {
> +		case 's':
> +			sync_mode = 1;
> +			break;
> +		case 'S':
> +			sync_mode = 2;
> +			break;
> +		default:
> +			usage(cmd_subvol_delete_usage);
> +		}
> +	}
> +
> +	if (check_argc_min(argc - optind, 1))
>  		usage(cmd_subvol_delete_usage);
>  
> +	printf("Sync filesystem mode: %s\n",
> +		!sync_mode ? "none (default)" :
> +		sync_mode == 1 ? "at the end" : "after each");
> +
> +	cnt = optind;
> +
>  again:
>  	path = argv[cnt];
>  
> @@ -276,8 +319,6 @@ again:
>  	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
>  	e = errno;
>  
> -	close_file_or_dir(fd, dirstream);
> -
>  	if(res < 0 ){
>  		fprintf( stderr, "ERROR: cannot delete '%s/%s' - %s\n",
>  			dname, vname, strerror(e));
> @@ -285,14 +326,38 @@ again:
>  		goto out;
>  	}
>  
> +	if (sync_mode == 1) {
> +		res = ioctl(fd, BTRFS_IOC_SYNC);

It will flush all the dirty pages, it is unnecessary. I think BTRFS_IOC_{START, WAIT}_SYNC is better.

Thanks
Miao

> +		if (res < 0) {
> +			fprintf(stderr,
> +				"ERROR: unable to sync after '%s': %s\n",
> +				path, strerror(e));
> +			ret = 1;
> +		}
> +	}
> +
>  out:
>  	free(dupdname);
>  	free(dupvname);
>  	dupdname = NULL;
>  	dupvname = NULL;
>  	cnt++;
> -	if (cnt < argc)
> +	if (cnt < argc) {
> +		close_file_or_dir(fd, dirstream);
>  		goto again;
> +	}
> +
> +	if (sync_mode == 2 && fd != -1) {
> +		res = ioctl(fd, BTRFS_IOC_SYNC);
> +		e = errno;
> +		if (res < 0) {
> +			fprintf(stderr,
> +				"ERROR: unable to do final sync: %s\n",
> +				strerror(e));
> +			ret = 1;
> +		}
> +	}
> +	close_file_or_dir(fd, dirstream);
>  
>  	return ret;
>  }
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index b6203483296e..2d5c12e08640 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -8,7 +8,7 @@ btrfs \- control a btrfs filesystem
>  .SH SYNOPSIS
>  \fBbtrfs\fP \fBsubvolume create\fP [-i \fI<qgroupid>\fP] [\fI<dest>\fP/]\fI<name>\fP
>  .PP
> -\fBbtrfs\fP \fBsubvolume delete\fP \fI<subvolume>\fP [\fI<subvolume>...\fP]
> +\fBbtrfs\fP \fBsubvolume delete\fP [\fIoptions\fP] \fI<subvolume>\fP [\fI<subvolume>...\fP]
>  .PP
>  \fBbtrfs\fP \fBsubvolume list\fP [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fP
>  .PP
> @@ -168,9 +168,24 @@ times.
>  .RE
>  .TP
>  
> -\fBsubvolume delete\fR\fI <subvolume> \fP[\fI<subvolume>...\fP]\fR
> -Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not a
> -subvolume, \fBbtrfs\fR returns an error.
> +\fBsubvolume delete\fR [\fIoptions\fP] \fI<subvolume>\fP [\fI<subvolume>...\fP]\fR
> +Delete the subvolume(s) from the filesystem. If \fI<subvolume>\fR is not a
> +subvolume, \fBbtrfs\fR returns an error but continues if there are more arguments
> +to process.
> +
> +The corresponding directory is removed instantly but the data blocks are
> +removed later.  The deletion does not involve full commit by default due to
> +performance reasons (as a consequence, the subvolume may appear again after a
> +crash).  Use one of the --sync options to sync the filesystem via a btrfs
> +specific ioctl.
> +.RS
> +
> +\fIOptions\fP
> +.IP "\fB-s|--sync-after\fP" 5
> +call sync at the end of the operation
> +.IP "\fB-S|--sync-each\fP" 5
> +sync the filesystem after deleting each subvolume
> +.RE
>  .TP
>  
>  \fBsubvolume list\fR [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fR
> 


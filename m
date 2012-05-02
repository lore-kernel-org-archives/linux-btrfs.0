From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v2 1/5] btrfs: add command to zero out superblock
Date: Wed, 2 May 2012 16:28:43 +0200
Message-ID: <20120502142843.GD6740@twin.jikos.cz>
References: <1335876033-12201-1-git-send-email-kario@wit.edu.pl>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Hubert Kario <kario@wit.edu.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335876033-12201-1-git-send-email-kario@wit.edu.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 01, 2012 at 02:40:29PM +0200, Hubert Kario wrote:
> +static const char * const cmd_zero_dev_usage[] = {
> +	"btrfs device zero-superblock <device> [<device> ...]",

FYI, this step is named 'clear superblock' in kernel code as done after the
device is removed, and I suggest to consider to name the command like
'clear-superblock' or 'clear-sb'.

Also, kernel clears only the "superblock magic" string, ie. the
"_BHRfS_M" bytes. This leaves the rest of the superblock intact, for
possible recovery when it's cleared accidentally.

I had prototyped a similar utility (in perl, so nothing for progs
inclusion for now) and rewrote the magic string with _BHRf$_M ie. the
S -> $ for visual similarity with the action performed. This allows to
detect cleared superblocks and activate them back eventually.

I'm not sure if this is useful and sensible usecase, clearing superblock
is a one-time action anyway, so it's more for the sake of tool
flexibility.

To your implementation: I think adding a function doing the superblock
reset would be enough here. Something like this (in pseudocode):

for (i = 0 ; i < BTRFS_SUPER_MIRROR_MAX; i++) {
	bytenr = btrfs_sb_offset(i);
	"break if bytenr > device size"
	memset(superblock buffer, CLEARPATTERN, sizeof(...))
}
write_all_supers(root);


david


> +	"Remove btrfs filesystem superblock from devices.",
> +	"WARNING! This command will make filesystem residing on the devices",
> +	"completely unmountable!",
> +	NULL
> +};
> +
> +static int cmd_zero_dev(int argc, char **argv)
> +{
> +	int fd;
> +	char *file;
> +	int arg_processed;
> +	int ret = 0;
> +	int n;
> +	u64 device_len;
> +	int mixed_mode_needed = 1; /* keep btrfs_prepare_device() quiet */
> +	const int ZERO_END = 1;
> +
> +	if( argc < 2 ) {
> +		usage(cmd_zero_dev_usage);
> +	}
> +
> +	for(arg_processed = 1; arg_processed < argc; arg_processed++) {
> +		file = argv[arg_processed];
> +
> +		fd = open(file, O_RDWR);
> +		if (fd < 0) {
> +			fprintf(stderr, "Unable to open %s\n", file);
> +			ret |= 1;
> +			continue;
> +		}
> +
> +		n = btrfs_prepare_device(fd, file, ZERO_END, &device_len,
> +			&mixed_mode_needed);
> +		if (n) {
> +			fprintf(stderr, "Error when zeroing out %s\n", file);
> +			ret |= n;
> +		}
> +
> +		close(fd);
> +	}
> +
> +	return ret;
> +}
> +
>  const struct cmd_group device_cmd_group = {
>  	device_cmd_group_usage, NULL, {
>  		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
>  		{ "delete", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
>  		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
> +		{ "zero-superblock", cmd_zero_dev, cmd_zero_dev_usage, NULL, 0 },
>  		{ 0, 0, 0, 0, 0 }
>  	}
>  };
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index be478e0..a840f7e 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -39,6 +39,8 @@ btrfs \- control a btrfs filesystem
>  .PP
>  \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
>  .PP
> +\fBbtrfs\fP \fBdevice zero-superblock\fP\fI <device> [<device>...] \fP
> +.PP
>  \fBbtrfs\fP \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
>  .PP
>  \fBbtrfs\fP \fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
> @@ -230,6 +232,11 @@ Finally, if \fB--all-devices\fP is passed, all the devices under /dev are
>  scanned.
>  .TP
>  
> +\fBdevice zero-superblock\fR\fI <dev> [<dev>..]\fR
> +The space on the disk where btrfs metadata can reside is overwritten with
> +zeros.
> +.TP
> +
>  \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
>  Start a scrub on all devices of the filesystem identified by \fI<path>\fR or on
>  a single \fI<device>\fR. Without options, scrub is started as a background
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

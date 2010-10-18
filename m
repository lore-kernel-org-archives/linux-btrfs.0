From: Frank Kingswood <frank@kingswood-consulting.co.uk>
Subject: Re: [patch 2/4] Add an option to show ISO, binary or raw bytes counts
 using df.
Date: Mon, 18 Oct 2010 09:21:56 +0100
Message-ID: <4CBC03A4.4080600@kingswood-consulting.co.uk>
References: <20101017182643.297900488@carfax.org.uk> <20101017182706.430006857@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101017182706.430006857@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 17/10/10 19:26, hugo-lkml@carfax.org.uk wrote:
> Change btrfs filesystem df to allow the user to control the scales
> used for sizes in the output.
>
> Index: btrfs-progs-unstable/btrfs.c
> ===================================================================
> --- btrfs-progs-unstable.orig/btrfs.c	2010-10-17 18:43:57.000000000 +0100
> +++ btrfs-progs-unstable/btrfs.c	2010-10-17 18:47:36.000000000 +0100
> @@ -87,9 +87,10 @@
>   		"Show the info of a btrfs filesystem. If no<uuid>  or<label>\n"
>   		"is passed, info of all the btrfs filesystem are shown."
>   	},
> -	{ do_df_filesystem, 1,
> -	  "filesystem df", "<path>\n"
> +	{ do_df_filesystem, -1,
> +	  "filesystem df", "[-r|-b|-i]<path>\n"
>   		"Show space usage information for a mount point\n."
> +		"-r, -b, -i for raw (bytes), binary or ISO sizes."
>   	},

This seems to eat up the short option namespace a bit quickly.
Fileutils uses different names as well, it may be convenient for users to 
match its names:
	-h --human-readable   powers of 2**10
	-H --si   powers of 1000

>   	{ do_balance, 1,
>   	  "filesystem balance", "<path>\n"
> Index: btrfs-progs-unstable/btrfs_cmds.c
> ===================================================================
> --- btrfs-progs-unstable.orig/btrfs_cmds.c	2010-10-17 18:43:57.000000000 +0100
> +++ btrfs-progs-unstable/btrfs_cmds.c	2010-10-17 18:47:36.000000000 +0100
> @@ -841,7 +841,36 @@
>   	u64 count = 0, i;
>   	int ret;
>   	int fd;
> -	char *path = argv[1];
> +	char *path;
> +	int format = PRETTY_SIZE_BINARY;

Should the default not be to show sizes in bytes ("RAW")?

Frank


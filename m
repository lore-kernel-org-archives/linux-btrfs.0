From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/5] Add support for read-only subvolumes.
Date: Tue, 26 Apr 2011 13:50:51 +0800
Message-ID: <4DB65D3B.2080305@cn.fujitsu.com>
References: <1303733730-sup-9388@think> <1303739282-1675-1-git-send-email-philipp.andreas@gmail.com> <1303739282-1675-2-git-send-email-philipp.andreas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303739282-1675-2-git-send-email-philipp.andreas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

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
> +		free(argv);
> +		return 1;
> +	}
> +
> +	subvol = argv[optind+1];
> +	dst = argv[optind+2];
> +	struct btrfs_ioctl_vol_args_v2	args;
>  

I don't think this can compile.. This structure is added in the 3rd patch.

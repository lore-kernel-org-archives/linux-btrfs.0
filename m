From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/5] Add support for read-only subvolumes.
Date: Tue, 26 Apr 2011 14:06:07 +0800
Message-ID: <4DB660CF.8050509@cn.fujitsu.com>
References: <1303733730-sup-9388@think> <1303739282-1675-1-git-send-email-philipp.andreas@gmail.com> <1303739282-1675-2-git-send-email-philipp.andreas@gmail.com> <4DB5E8F6.1020807@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Goffredo Baroncelli <kreijack@libero.it>,
	Andreas Philipp <philipp.andreas@gmail.com>,
	linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: kreijack@inwind.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DB5E8F6.1020807@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

>> +	subvol = argv[optind+1];
>> +	dst = argv[optind+2];
>> +	struct btrfs_ioctl_vol_args_v2	args;
> 
> Does the "standard C" allow to define a variable in the middle in a
> function instead of in the begin ?
> Anyway, even not required, I suggest to fill "args" by zero.
> 
> +	memset(&args, 0, sizeog(args));
> 

It's necessary, otherwise args.unused[4] and args.transid will have
arbitrary value.

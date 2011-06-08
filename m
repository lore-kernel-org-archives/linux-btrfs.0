From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: avoid stack bloat in btrfs_ioctl_fs_info()
Date: Wed, 08 Jun 2011 15:23:32 +0800
Message-ID: <4DEF2374.5020905@cn.fujitsu.com>
References: <4DEEF352.7050401@cn.fujitsu.com> <4DEF206E.9000600@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DEF206E.9000600@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

>> -	if (copy_to_user(arg, &fi_args, sizeof(fi_args)))
>> -		return -EFAULT;
>> +	if (copy_to_user(arg, fi_args, sizeof(fi_args)))
> 
> sizeof(*fi_args)
> 
> will integrate that, thanks :)
> 

Oops, what a silly mistake!

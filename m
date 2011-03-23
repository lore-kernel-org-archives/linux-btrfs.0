From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: read-only subvolumes?
Date: Wed, 23 Mar 2011 17:25:28 +0800
Message-ID: <4D89BC88.5030406@cn.fujitsu.com>
References: <4D89ADA7.2000803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D89ADA7.2000803@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> Hi all,
> 
> When I am creating subvolumes I get this strange behavior. If I create
> a subvolume with a name longer than 4 characters it is read-only, if
> the name is shorter than 5 characters the subvolume is writeable as
> expected. I think it is since I upgraded to kernel version 2.6.38 (I
> do not create subvolumes on a regular basis.). I will compile one of
> the latest 2.6.37 kernels to see whether there the problem exists,
> too. Another interesting point is that previously created subvolumes
> are not affected.
> 
> Thanks,
> Andreas Philipp
> 
> thor btrfs # btrfs subvolume create 123456789
> Create subvolume './123456789'
> thor btrfs # touch 123456789/lsdkfj
> touch: cannot touch `123456789/lsdkfj': Read-only file system

This is really odd, but I can't reproduce it.

I created a btrfs filesystem on 2.6.37 kernel, and rebooted to latest
2.6.38+, and tried the procedures as you did, but nothing bad happend.

From: Arun Bhanu <btrfs@arunbhanu.com>
Subject: Re: compile btrfs for 2.6.27-rc9
Date: Sat, 11 Oct 2008 03:22:30 +0800
Message-ID: <20081010192230.GA6013@deepthought>
References: <20081010121206.GN20679@jeru.org>
Reply-To: Arun Bhanu <btrfs@arunbhanu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081010121206.GN20679@jeru.org>
List-ID: <linux-btrfs.vger.kernel.org>

* Xavier Nicollet (nicollet@jeru.org) wrote:
> Hello everyone,
> 
> I am trying to compile btrfs.ko (unstable) for 2.6.27-rc9.
> I copied btrfs part of Kbuild, and fs/btrfs to my 2.6.27-rc9 tree.
> 
> Then make modules modules_install
> However, I can't insmod btrfs.ko. Dmesg ouput:
> 
> [ 8973.920435] btrfs: no symbol version for struct_module
> [ 8994.375255] btrfs: no symbol version for struct_module
> [ 9049.174891] btrfs: no symbol version for struct_module
> [ 9125.963989] btrfs: no symbol version for struct_module
> [ 9178.504381] btrfs: no version for "struct_module" found: kernel
> tainted.
> [ 9178.513086] btrfs: Unknown symbol security_inode_mkdir
> 
> Is there a better way to do it ? I am running ubuntu.

If you use git, you will not have to manually copy the btrfs directory
and keep track of other changes(fs/Kconfig and fs/Makefile).

This is how I manage it with git. My knowledge of git is pretty bare
minimum so I am sure there are better ways of doing it. Anyway, here
goes.

You can replace all the "ab1-*" names with your own branch names. 
[1] $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
[2] $ cd linux-2.6
[3] $ git remote add btrfs git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

[4] $ git fetch btrfs
[5] $ git checkout -b ab1-v2.6.27 v2.6.27
[6] $ git branch ab1-btrfs btrfs/master
[7] $ git pull . ab1-btrfs

Now you have merged "btrfs" tree into the "linus" tree. Do your kernel
compile as usual and install the new kernel. If you don't need those
branches anymore delete them.
[8] $ git checkout master
[9] $ git branch -D ab1-btrfs
[10] $ git branch -D ab1-v2.6.27

When "linus" tree gets updated you can do a "git pull" to get the
changes. When "btrfs" tree has changes repeat from step 4 to build a new
kernel with btrfs.

> 
> Cheers,
> 
> -- 
> Xavier Nicollet
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-Arun

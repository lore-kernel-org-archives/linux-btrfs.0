From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: kernel BUG at fs/btrfs/tree-log.c:1669!
Date: Thu, 28 Jul 2011 10:13:28 +0800
Message-ID: <4E30C5C8.3090109@cn.fujitsu.com>
References: <4E304221.5050004@yahoo.com> <20110727171339.GA23320@carfax.org.uk> <4E305C09.1020204@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: Franck Martyn <franckmartyn@yahoo.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E305C09.1020204@yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

> I've try it without succes
> Here are the log
> 
> btrfsck /dev/sdb1
> couldn't open because of unsupported option features (8).
> btrfsck: disk-io.c:682: open_ctree_fd: Assertion `!(1)' failed.
> Abandon
> 
> btrfs-zero-log /dev/sdb1
> couldn't open because of unsupported option features (8).
> btrfs-zero-log: disk-io.c:682: open_ctree_fd: Assertion `!(1)' failed.
> Abandon
> 

You need to firstly apply the btrfs-progs patch below:

http://marc.info/?l=linux-btrfs&m=128988943421217&w=2

or pull the tmp branch of Chris' btrfs-progs tree, which contains that patch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git tmp

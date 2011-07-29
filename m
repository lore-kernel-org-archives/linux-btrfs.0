From: Franck Martyn <franckmartyn@yahoo.com>
Subject: Re: kernel BUG at fs/btrfs/tree-log.c:1669!
Date: Fri, 29 Jul 2011 16:17:06 +0200
Message-ID: <4E32C0E2.4060101@yahoo.com>
References: <4E304221.5050004@yahoo.com> <20110727171339.GA23320@carfax.org.uk> <4E305C09.1020204@yahoo.com> <4E30C5C8.3090109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E30C5C8.3090109@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

> You need to firstly apply the btrfs-progs patch below:
>
> http://marc.info/?l=linux-btrfs&m=128988943421217&w=2
>
> or pull the tmp branch of Chris' btrfs-progs tree, which contains that patch:
>
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git tmp
>

Thanx, this has solved my problem

Franck

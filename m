From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.37: Bug on btrfs while umount
Date: Thu, 06 Jan 2011 20:29:12 -0500
Message-ID: <1294363682-sup-7971@think>
References: <AANLkTikb2UhU3XwFWjon=BRiFgcAni54ZN7PVCBZDaVf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Drunkard Zhang <gongfan193@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <AANLkTikb2UhU3XwFWjon=BRiFgcAni54ZN7PVCBZDaVf@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Drunkard Zhang's message of 2011-01-06 20:25:37 -0500:
> Remote terminal hung while umount, here's dmesg:
> 
> [50010.838804] ------------[ cut here ]------------
> [50010.838931] kernel BUG at fs/btrfs/inode.c:1616!
> [50010.839053] invalid opcode: 0000 [#1] PREEMPT SMP
> [50010.839185] last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
> [50010.839307] CPU 0
> [50010.839313] Modules linked in: ipt_addrtype btrfs k10temp
> [50010.839541]
> [50010.839653] Pid: 1681, comm: btrfs-endio-wri Not tainted 2.6.37 #1

Could you please pull from the master branch of the btrfs unstable tree.
We had a late fix that is related to this.

-chris

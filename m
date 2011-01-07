From: Drunkard Zhang <gongfan193@gmail.com>
Subject: Re: 2.6.37: Bug on btrfs while umount
Date: Fri, 7 Jan 2011 09:36:20 +0800
Message-ID: <AANLkTimrZRG1nd+8m28VH+3GD_g3fWAULTuUqL3K+y1X@mail.gmail.com>
References: <AANLkTikb2UhU3XwFWjon=BRiFgcAni54ZN7PVCBZDaVf@mail.gmail.com> <1294363682-sup-7971@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1294363682-sup-7971@think>
List-ID: <linux-btrfs.vger.kernel.org>

>> [50010.838804] ------------[ cut here ]------------
>> [50010.838931] kernel BUG at fs/btrfs/inode.c:1616!
>> [50010.839053] invalid opcode: 0000 [#1] PREEMPT SMP
>> [50010.839185] last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
>> [50010.839307] CPU 0
>> [50010.839313] Modules linked in: ipt_addrtype btrfs k10temp
>> [50010.839541]
>> [50010.839653] Pid: 1681, comm: btrfs-endio-wri Not tainted 2.6.37 #1
>
> Could you please pull from the master branch of the btrfs unstable tree.
> We had a late fix that is related to this.
>
Thanks, trying..

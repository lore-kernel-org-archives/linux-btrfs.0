From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix memory leak in btrfs_defrag_file
Date: Fri, 02 Sep 2011 09:46:59 +0800
Message-ID: <4E603593.4060503@cn.fujitsu.com>
References: <201109011633.57877.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: diegocg@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201109011633.57877.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Diego Calleja wrote:
> kmemleak found this:
> unreferenced object 0xffff8801b64af968 (size 512):
>   comm "btrfs-cleaner", pid 3317, jiffies 4306810886 (age 903.272s)
>   hex dump (first 32 bytes):
>     00 82 01 07 00 ea ff ff c0 83 01 07 00 ea ff ff  ................
>     80 82 01 07 00 ea ff ff c0 87 01 07 00 ea ff ff  ................
>   backtrace:
>     [<ffffffff816875cc>] kmemleak_alloc+0x5c/0xc0
>     [<ffffffff8114aec3>] kmem_cache_alloc_trace+0x163/0x240
>     [<ffffffff8127a290>] btrfs_defrag_file+0xf0/0xb20
>     [<ffffffff8125d9a5>] btrfs_run_defrag_inodes+0x165/0x210
>     [<ffffffff812479d7>] cleaner_kthread+0x177/0x190
>     [<ffffffff81075c7d>] kthread+0x8d/0xa0
>     [<ffffffff816af5f4>] kernel_thread_helper+0x4/0x10
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> "pages" is not always freed. Fix it removing the unnecesary additional return.
> 
> Signed-off-by: Diego Calleja <diegocg@gmail.com>
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

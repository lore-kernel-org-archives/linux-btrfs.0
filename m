From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: wanted X found X-1 but you got X-2
Date: Mon, 02 Aug 2010 09:04:27 +0800
Message-ID: <4C56199B.8090400@cn.fujitsu.com>
References: <20100729131103.323870@gmx.net> <4C526516.30709@cn.fujitsu.com> <20100730071354.257500@gmx.net> <20100731163424.105410@gmx.net>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: liubo2009@cn.fujitsu.com, linux-btrfs@vger.kernel.org
To: Adi <adalbert.b@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100731163424.105410@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Adi

On Sat, 31 Jul 2010 18:34:24 +0200, Adi wrote:
> ok, i have tried the 2.6.35-rc6 kernel, as TiCPU on #btrfs suggested, but i also got an error. i don't think it has something to do with kcrypt, as i can mount another partition without any problems.
[snip]
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/async-thread.c:603!
> invalid opcode: 0000 [#1] PREEMPT
[snip]
> Call Trace:
>   [<c13fc670>] ? kcryptd_crypt+0x0/0x360
>   [<c10d99e1>] ? bio_endio+0x11/0x30
>   [<c10d99e1>] ? bio_endio+0x11/0x30
>   [<c10d99e1>] ? bio_endio+0x11/0x30
>   [<c1041032>] ? worker_thread+0xf2/0x230
>   [<c1040f40>] ? worker_thread+0x0/0x230
>   [<c156d3ab>] ? schedule+0x1ab/0x4c0
>   [<c10448d0>] ? autoremove_wake_function+0x0/0x40
>   [<c1040f40>] ? worker_thread+0x0/0x230
>   [<c10444f4>] ? kthread+0x74/0x80
>   [<c1044480>] ? kthread+0x0/0x80
>   [<c1002fb6>] ? kernel_thread_helper+0x6/0x10

It seems this problem is the same as the one I have fixed.
Could you try to applied the following patches and test again?
   http://lkml.org/lkml/2010/7/29/86
   http://lkml.org/lkml/2010/7/29/84
   http://lkml.org/lkml/2010/7/29/82

Thanks
Miao

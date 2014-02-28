Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1110 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaB1BUV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 20:20:21 -0500
Message-ID: <530FE3CE.70809@cn.fujitsu.com>
Date: Fri, 28 Feb 2014 09:18:06 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
References: <20140227190656.GA28338@merlins.org>
In-Reply-To: <20140227190656.GA28338@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Marc,

On 02/28/2014 03:06 AM, Marc MERLIN wrote:
> This does not happen consistently, but sometimes:
>
> PM: Preparing system for mem sleep
> Freezing user space processes ...
> (...)
>   Freezing of tasks failed after 20.002 seconds (1 tasks refusing to freeze, wq_busy=0):
>   btrfs           D ffff88017639c800     0 12239  12224 0x00000084
>    ffff880165ec1960 0000000000000086 ffff880165ec1fd8 ffff88017639c2d0
>    00000000000141c0 ffff88017639c2d0 ffff88007b874000 ffff8804062fa480
>    0000000000000000 ffff880175837ec0 ffff88007b874220 ffff880165ec1970
>   Call Trace:
>    [<ffffffff8160b0d9>] schedule+0x73/0x75
>    [<ffffffff8126e94c>] scrub_pages+0x27e/0x426
>    [<ffffffff81085062>] ? finish_wait+0x65/0x65
>    [<ffffffff81271732>] scrub_stripe+0xada/0xc9e
>    [<ffffffff812719cc>] scrub_chunk.isra.9+0xd6/0x10d
>    [<ffffffff81271c77>] scrub_enumerate_chunks+0x274/0x418
>    [<ffffffff81085000>] ? finish_wait+0x3/0x65
>    [<ffffffff812723bb>] btrfs_scrub_dev+0x254/0x3cb
>    [<ffffffff8116ddab>] ? __mnt_want_write+0x62/0x78
>    [<ffffffff81255c68>] btrfs_ioctl+0x1114/0x24b1
>    [<ffffffff81140698>] ? ____cache_alloc+0x1c/0x29b
>    [<ffffffff81140a06>] ? kmem_cache_alloc_node+0xef/0x179
>    [<ffffffff8160d7b3>] ? _raw_spin_unlock+0x17/0x2a
>    [<ffffffff81163ade>] do_vfs_ioctl+0x3d2/0x41d
>    [<ffffffff8116bd00>] ? __fget+0x6f/0x79
>    [<ffffffff81163b80>] SyS_ioctl+0x57/0x82
>    [<ffffffff8161426d>] system_call_fastpath+0x1a/0x1f
Could you run the following command when scrub is blocked, we can know more
why scrub is blocked here.

# echo w >  /proc/sysrq-trigger
# dmesg

Thanks,
Wang
>
> And then I end up with a hot laptop and a mostly dead battery in my backpack.
>
> As far as I know, this was not happening with 3.13, unless I'm doing
> something differently without knowing.
>
> My laptop went to sleep just fine while I was typing this Email, so I'm guessing
> it's only btrfs scrub that causes the problem with sleep.
>
> Marc


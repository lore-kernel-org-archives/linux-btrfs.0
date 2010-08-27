From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [2.6.35.3] BUG: unable to handle kernel NULL pointer dereference
 at (null)
Date: Fri, 27 Aug 2010 17:38:01 +0800
Message-ID: <4C778779.1090808@cn.fujitsu.com>
References: <20100826095357.GA7202@Pilar.aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100826095357.GA7202@Pilar.aei.mpg.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/26/2010 05:53 PM, Carlos R. Mafra wrote:
> Hi,
>
> I've just got this BUG: message in dmesg which I think is btrfs related.
>   
[...]

> [  148.152107] Call Trace:
> [  148.152113]  [<ffffffff8104e730>] ? process_timeout+0x0/0x10
> [  148.152118]  [<ffffffff8118a42d>] end_workqueue_fn+0x10d/0x130
> [  148.152122]  [<ffffffff811b98f0>] worker_loop+0xb0/0x5a0
> [  148.152126]  [<ffffffff811b9840>] ? worker_loop+0x0/0x5a0
> [  148.152130]  [<ffffffff8105b60e>] kthread+0x8e/0xa0
> [  148.152135]  [<ffffffff81003a54>] kernel_thread_helper+0x4/0x10
> [  148.152138]  [<ffffffff8105b580>] ? kthread+0x0/0xa0
> [  148.152142]  [<ffffffff81003a50>] ? kernel_thread_helper+0x0/0x10
> [  148.152144] Code: d3 ff ff 89 c2 b8 01 00 00 00 85 d2 75 56 4c 39 eb 77 51 0f 1f 80 00 00 00 00 48 89 de 49 8b 7c 24 10 48 c1 ee 0c e8 3f 21 ef ff <f6> 00 08 74 2a 48 89 c7 48 81 c3 00 10 00 00 e8 4b af ef ff 49 
> [  148.152176] RIP  [<ffffffff811b1301>] extent_range_uptodate+0x51/0xa0
> [  148.152180]  RSP <ffff880079acddd0>
> [  148.152182] CR2: 0000000000000000
> [  148.152185] ---[ end trace c11a5009b12451d7 ]---
>
>   

Hi, Carlos,
Did you hit this bug under heavy memory stress?

And, could you reproduce the bug? or show some reproduce steps for us?

After digging into extent_range_uptodate(), IMO, this NULL pointer bug that issued page 
can barely be hit. 

Maybe, due to heavy memory stress, a page of the extent_buffer has been freed before, 
which leads that it is missing in page_cache and return NULL.


thanks,
liubo


> Full dmesg is here
>
> http://www.aei.mpg.de/~crmafra/dmesg-2.6.35.3.txt
>
> Is there something else I should provide to help debug this?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   

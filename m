Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4191 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbaBXHUq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 02:20:46 -0500
Message-ID: <530AF25B.5050004@cn.fujitsu.com>
Date: Mon, 24 Feb 2014 15:18:51 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: 3.13.5 kernel hangs some processes with btrfs
References: <20140224061426.GB15937@merlins.org> <20140224061714.GC15937@merlins.org> <pan$5eb48$855696ce$5bb0f0dc$b9ce161e@cox.net> <20140224065847.GE15937@merlins.org>
In-Reply-To: <20140224065847.GE15937@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/24/2014 02:58 PM, Marc MERLIN wrote:
> On Mon, Feb 24, 2014 at 06:42:30AM +0000, Duncan wrote:
>> I believe there's a fix coming (a cancel that blows away the tracking
>> file if it finds it and no actual running scrub is the most obvious fix),
>> but meanwhile, see the /var/lib/btrfs/scrub.status.* files.  That's where
>> scrub state is stored, and manually blowing away the appropriate file
>> should clear btrfs' memory of the aborted scrub, so you can scrub start
>> properly.
> Ah, silly me, I thought this was all in the kernel and not in userspace.
>
> Yep, I cleared the stats, and that part is back to ok, thanks.
>
> I'm not getting btrfs hang on /mnt/btrfs_pool2 after reboot, so that's good.
>
> But I'm still seeing these, albeit less often.
> Any idea what they could be linked to?
> (I have a btrs send/receive going right now, it could hanging /mnt/btrfs_pool1

I noticed  scrub for /mnt/btrfs_pool1 is running more than 10000s....

Not sure if it is related to send/receive, but if you are still runing 
send/receive,
just terminate it and let's see if things will become better.

Also Josef gave a patch that can speed up send/receive a lot which has been
pused into btrfs-next, you can try it.

Thanks,
Wang
> in a way that affects smbd, but the array feels ok otherwise, weird...)
>   


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56200 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbaCCDT4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Mar 2014 22:19:56 -0500
Message-ID: <5313F45F.9090709@cn.fujitsu.com>
Date: Mon, 03 Mar 2014 11:17:51 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
References: <20140227190656.GA28338@merlins.org> <530FE3CE.70809@cn.fujitsu.com> <20140301050937.GD18300@merlins.org> <20140301152235.GA26926@merlins.org>
In-Reply-To: <20140301152235.GA26926@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Marc,

On 03/01/2014 11:22 PM, Marc MERLIN wrote:
> On Fri, Feb 28, 2014 at 09:09:37PM -0800, Marc MERLIN wrote:
>> On Fri, Feb 28, 2014 at 09:18:06AM +0800, Wang Shilong wrote:
>>> Could you run the following command when scrub is blocked, we can know more
>>> why scrub is blocked here.
>>>
>>> # echo w >  /proc/sysrq-trigger
>>> # dmesg
> Yes, there you go:
>
> (attached because it's too big for the list)
>
> http://marc.merlins.org/tmp/btrfs_nofreeze.txt
Could you please try the following patch, and let's see if it helps:

https://patchwork.kernel.org/patch/3680431/

This patch addressed a deadlock for device replace, but i guess scrub 
may also
trigger this problem if there are errors related to the disk.

BTW, is there  some errors related to scrub device, something like:

# btrfs device stat <device>

Thanks,
Wang
>
> Marc


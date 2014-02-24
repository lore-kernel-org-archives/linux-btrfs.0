Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22374 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbaBXG3j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 01:29:39 -0500
Message-ID: <530AE662.5090303@cn.fujitsu.com>
Date: Mon, 24 Feb 2014 14:27:46 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: 3.13.5 kernel hangs some processes with btrfs
References: <20140224061426.GB15937@merlins.org> <20140224061714.GC15937@merlins.org>
In-Reply-To: <20140224061714.GC15937@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/24/2014 02:17 PM, Marc MERLIN wrote:
> On Sun, Feb 23, 2014 at 10:14:26PM -0800, Marc MERLIN wrote:
>> Does someone know how I can debug further why this is hanging?
>>
>> It seems that accessing a certain directory on one of my btrfs filesystems
>> causes this.
>>
>> The rest of my system seems ok, as long as I'm not touching this filesystem.
>>
>> Is this a bug, or a performance problem?
> Mmmh, this bug might be part of the problem:
> gargamel:/mnt# btrfs scrub start btrfs_pool2
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel btrfs_pool2'.
> To see the status use 'btrfs scrub status [-d] btrfs_pool2'.
> gargamel:/mnt# btrfs scrub cancel btrfs_pool2
> ERROR: scrub cancel failed on btrfs_pool2: not running
> gargamel:/mnt# btrfs scrub status btrfs_pool2
> scrub status for cb9df6d3-a528-4afc-9a45-4fed5ec358d6
>          scrub started at Sun Feb 23 18:29:39 2014, running for 5 seconds
>          total bytes scrubbed: 0.00 with 0 errors
> gargamel:/mnt# btrfs scrub cancel btrfs_pool2
> ERROR: scrub cancel failed on btrfs_pool2: not running
> gargamel:/mnt# btrfs scrub status btrfs_pool2
> scrub status for cb9df6d3-a528-4afc-9a45-4fed5ec358d6
>          scrub started at Sun Feb 23 18:29:39 2014, running for 5 seconds
>          total bytes scrubbed: 0.00 with 0 errors
> gargamel:/mnt#
>
> Note that it says running for 5 seconds, but it started 4H ago.
>
> Any idea what's going on here?
What is dmesg output?

Did it output something like "Skip abort transaction"? Also
what is your mount option? did you enable nodatasum etc?

Thanks,
Wang
>
> Marc


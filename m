Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:55393 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbcGBReP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jul 2016 13:34:15 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by syrinx.knorrie.org (Postfix) with ESMTPSA id DA0E0600E8
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jul 2016 19:34:11 +0200 (CEST)
Subject: Re: Filesystem locks up, also with older kernel on any action after
 booting into 4.7-rc4 once
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <472f47d4-b6c9-072d-3fe4-a1ec2af141c7@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <acd41233-2895-fbfc-8277-5ca2a07c3eef@mendix.com>
Date: Sat, 2 Jul 2016 19:34:11 +0200
MIME-Version: 1.0
In-Reply-To: <472f47d4-b6c9-072d-3fe4-a1ec2af141c7@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/2016 07:14 PM, Hans van Kranenburg wrote:
> I just rebooted a VM into a 4.7 kernel. The joy didn't last long. After
> 177 seconds the btrfs data partition (root is on ext4) locked up. Worse,
> it keeps locking up on any action performed even when  rebooting it with
> older kernels again. D: The filesystem initially mounts fine, but then
> locks up again immediately.
>
> Linux stacheldraht 4.7.0-rc4-amd64 #1 SMP Debian 4.7~rc4-1~exp1
> (2016-06-20) x86_64 GNU/Linux
>
> ps output shows [btrfs-transaction] in D state:
>
> root      1108  0.0  0.0      0     0 ?        D    17:42   0:00  \_
> [btrfs-transacti]
>
> From dmesg:
>
> [blah blah blah]
>
> So, something happened inside the fs that makes it lock up every time I
> try to do anything with it...

I force-rebooted the poor thing again, and mounted the filesystem ro. It 
mounts without any complaint. I can see all files now, I can do sub list 
etc...

So I think I'm going to copy some data to a new filesystem on a new 
block device just in case. The thing has to move to new storage anyway 
it's about 100 subvolumes with about 150GB of data, so that's a nice 
excercise with send/receive.

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:55477 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbcETPv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 11:51:28 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Cc: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Amount of scrubbed data goes from 15.90GiB to 26.66GiB after =?iso-8859-1?Q?defragment_-r_-v_-clzo_on_a_fs_always_mounted_with_compres?=
 =?iso-8859-1?Q?s=3Dlzo?=
Date: Fri, 20 May 2016 17:51:15 +0200
MIME-Version: 1.0
Message-ID: <dee51010-3b20-429f-806f-87a877d9001e@linuxsystems.it>
In-Reply-To: <pan$106d2$20dff0d0$cff8ba20$86e58020@cox.net>
References: <264486fb-94ce-4040-a436-e9db5de9a203@linuxsystems.it>
 <pan$331b6$43ad41cc$c9aa5858$e14154bc@cox.net>
 <60018ed4-023e-4ca6-8f74-e19b8849de65@linuxsystems.it>
 <pan$106d2$20dff0d0$cff8ba20$86e58020@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On venerdì 13 maggio 2016 08:11:27 CEST, Duncan wrote:
> In theory the various btrfs dedup solutions out there should work as 
> well, while letting you keep the snapshots (at least to the extent 
> they're either writable snapshots so can be reflink modified

Unfortunately as you said dedup doesn't work with read-only snapshots (I 
only use read-only snapshots with snapper) :(

Does dedup's dedup-syscall branch 
(https://github.com/g2p/bedup/tree/wip/dedup-syscall) which uses the new 
batch deduplication ioctl merged in Linux 3.12 fix this? Unfortunately 
latest commit is from september :(

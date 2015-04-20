Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35902 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbbDTKeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 06:34:09 -0400
Message-ID: <5534D5FE.9080302@onsd.eu>
Date: Mon, 20 Apr 2015 12:33:34 +0200
From: =?UTF-8?B?Ik7DqW1veiBTYWludC1EaXppZXIsIE9saXZpZXIi?=
	<olivier@onsd.eu>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>
CC: linux-btrfs@vger.kernel.org
Subject: Re: unable to mount a btrfs file system kernel 3.19.2
References: <5534D201.7080803@onsd.eu> <20150420102705.GF18187@carfax.org.uk>
In-Reply-To: <20150420102705.GF18187@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh, I didn't see there were similar link in the wiki, my bad.
Thank you for your prompt answer :)

Olivier.

On 4/20/2015 12:27 PM, Hugo Mills wrote:
> On Mon, Apr 20, 2015 at 12:16:33PM +0200, "Némoz Saint-Dizier, Olivier" wrote:
>> Hello everyone,
>>
>> I have an issue with my ssd where a btrfs partition is located. I have a
>> /dev/sdb1 in ext4 for the /boot, and the rest of the ssd is /dev/sdb2
>> which is the root of my Archlinux. When I boot, it hangs up after
>> loading the kernel. So I tried with an Archlinux liveboot, and I have
>> the same behavior with the following trace in logs when I try to mount
>> the btrfs partition :
>>
>> Apr 11 16:25:56 archiso kernel: INFO: task mount:573 blocked for more than 120 seconds.
>> Apr 11 16:25:56 archiso kernel:       Not tainted 3.19.2-1-ARCH #1
> [snip]
>> btrfs-progs v3.19
>>
>> Linux archiso 3.19.2-1-ARCH #1 SMP PREEMPT Wed Mar 18 16:21:02 CET 2015 x86_64 GNU/Linux
>>
>> And the full output from journald is available there :
>> http://sprunge.us/jPMG
>>
>> Is it a known bug? Or does someone have an idea about how I could fix
>> this issue?
>    See the first issue here: https://btrfs.wiki.kernel.org/index.php/Gotchas
>
>    Hugo.
>


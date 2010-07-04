From: Yee-Ting Li <yee379@gmail.com>
Subject: Re: volume broken? btrfsck fails
Date: Sat, 3 Jul 2010 23:57:14 -0700
Message-ID: <8F5A3F6C-87B7-46F5-AB32-78A9C8A2A43D@gmail.com>
References: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com> <loom.20100701T144515-658@post.gmane.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Daniel Kozlowski <dan.kozlowski@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20100701T144515-658@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>


On 1 Jul 2010, at 05:51, Daniel Kozlowski wrote:
> I am also having the same problem with a slightly different setup. In My case I 
> cannot mount the filesystem. mount, btrfs-endio-met and kblockd/0 will all 
> continually run until the system freezes up and requires a power cycle.

have you tried mounting with '-o degraded'?

having monitored the system for a while, i also think that in fact it's btrfs that's killing my system. i'm on ubuntu 10.4 with:

$ uname -a
Linux htpc 2.6.32-22-server #36-Ubuntu SMP Thu Jun 3 20:38:33 UTC 2010 x86_64 GNU/Linux

using the default kernel module, but git'd out the tools.

following the other thread 'Is there a more aggressive fixer than btrfsck?' i suspect that we'll just have to wait until some actual fsck operations are available for btrfs :(

on my system, it's btrfs-endio-met (only 1 out of 4) and btrfs-transacti (1 out of 2) that is taking up all the cpu/io wait cycles.

i wonder if it's only certain files on the array that are hosed; if that's the case is there a way i can map the kernel messages to a real filename? i don't mind loosing the odd file on this array, but i don't fancy copying it all over to somewhere else (yeah-yeah, up to date backups blah blah!) - i figured given the momentum btrfs was gaining it would be much more stable than this :(

Yee.
Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:42586 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbcGTHff (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 03:35:35 -0400
Subject: Re: ENOSPC / no space on very large devices
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1659eb11-0025-d9d4-c590-2a4d721bb299@profihost.ag>
Cc: Jannik Winkel <j.winkel@profihost.ag>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <578F29C4.9030808@applied-asynchrony.com>
Date: Wed, 20 Jul 2016 09:35:32 +0200
MIME-Version: 1.0
In-Reply-To: <1659eb11-0025-d9d4-c590-2a4d721bb299@profihost.ag>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/16 07:31, Stefan Priebe - Profihost AG wrote:
> Hi list,
> 
> while i didn't had the problem for some month i'm now getting ENOSPC on
> a regular basis on one host.

Well, it's getting better. :)

> if i umount the volume i get traces (i already did a clear_cache 4 days
> ago to recalculate the space_tree):
> 
> [545031.675797] ------------[ cut here ]------------
> [545031.725166] WARNING: CPU: 1 PID: 17711 at
> fs/btrfs/extent-tree.c:5710 btrfs_free_block_groups+0x35a/0x400 [btrfs]()

This is "only" a warning, but as we can see below it indicates a real
problem. The warning was added only recently to for-next by the patch called
"Btrfs: warn_on for unaccounted spaces" [1], but I've had it in my tree
forever. Never seen the warning myself.

(snip)
> [545037.909700] BTRFS: space_info 4 has 18446743523026157568 free, is
> not full

Wow, ~18.4 exabytes really is a lot of free space. :)
So it looks like something underflowed the space_info and now things are
confused for about ~550 GB. Unfortunately I have no good idea how to fix
that. :(

> The kernel is something special - i'm using this one from holger:
> https://github.com/hhoffstaette/kernel-patches
> 
> which is basically a 4.4.15 + several patches especially a lot of btrfs
> patches up to 4.8 i think.

More like for-next with all the pagesize/sectorsize stuff carefully
avoided. I'm really looking forward to 4.8, this is becoming unwieldy..

-h

[1] https://git.kernel.org/cgit/linux/kernel/git/kdave/linux.git/commit/?h=for-next&id=d555b6c380c644af63dbdaa7cc14bba041a4e4dd


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbcFTMtV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 08:49:21 -0400
Date: Mon, 20 Jun 2016 14:49:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs: page allocation failure: order:1, mode:0x2204020
Message-ID: <20160620124902.GO4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b0e70e1a-6eb5-9f9f-86e0-9049ae12f470@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b0e70e1a-6eb5-9f9f-86e0-9049ae12f470@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 18, 2016 at 08:47:55PM +0200, Hans van Kranenburg wrote:
> Last night, one of my btrfs filesystems went read-only after a memory 
> allocation failure (logging attached).

According to the logs, the allocation itself happens out of btrfs so we
can't do much here.

More specifically, when creating a new subvolume and requesting an
anonymous block device (via get_anon_bdev), there's a call to request a
free id for it. This could ask for "order-1" ie 8kb of contiguous
memory. And it failed.

This depends on memory fragmentation, ie. how the pages are allocated
and freed over time. Tweaking vm.min_free_kbytes could help but it's not
designed to prevent memory allocations in such scenario.

The id range sturctures themselves do not need more than a 4k page, but
the slab cache tries to provide more objects per slab, I see this on my
box right now:

Excerpt from /proc/slabinfo:

idr_layer_cache      474    486   2096    3    2

where  3 == objperslab and 2 == pages per slab, which corresponds to the
8kb. This seems to depend on internal slab cache logic, and nothing I'd
like to go chaning right now.

Looking at the IDR structure sizes and possible tweaks, the idr_layer
object size is 2096 on 64bit machine and we cannot squeeze it to 2048 so
it fits the page better.

http://lxr.free-electrons.com/source/include/linux/idr.h#L21

The IDR_BITS is 8, which is 256 pointers, 8 bytes each, and summs up to
2048 on itself, and we need a few more members.

Permanent change of IDR_BITS to smalle value would have to be evaluated,
otherwise the 'ary' member of 'idr_layer' could be stored separately for
better alignment.

> I've seen this happen once before somewhere else, also during snapshot 
> creation, also with a 4.5.x kernel.
> 
> There's a bug report at Debian, in which is suggested to increase the 
> value of vm.min_free_kbytes:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=666021

[...]

> [2363000.815554] Node 0 Normal: 2424*4kB (U) 0*8kB 0*16kB 0*32kB 0*64kB 
> 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 9696kB

Just to confirm the fragmentation, there are no page orders higher than
0 (ie.  8k and up).

So, technically not a btrfs bug but we could get affected by it badly.

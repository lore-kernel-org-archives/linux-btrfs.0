Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43082 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751961AbdLDUiZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 15:38:25 -0500
Date: Mon, 4 Dec 2017 21:36:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: heuristic replace heap sort with radix sort
Message-ID: <20171204203626.GD3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171203213033.28258-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171203213033.28258-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 04, 2017 at 12:30:33AM +0300, Timofey Titovets wrote:
> Slowest part of heuristic for now is kernel heap sort()
> It's can take up to 55% of runtime on sorting bucket items.
> 
> As sorting will always call on most data sets to get correctly
> byte_core_set_size, the only way to speed up heuristic, is to
> speed up sort on bucket.
> 
> Add a general radix_sort function.
> Radix sort require 2 buffers, one full size of input array
> and one for store counters (jump addresses).
> 
> That increase usage per heuristic workspace +1KiB
> 8KiB + 1KiB -> 8KiB + 2KiB

This is acceptable.

> That is LSD Radix, i use 4 bit as a base for calculating,
> to make counters array acceptable small (16 elements * 8 byte).
> 
> That Radix sort implementation have several points to adjust,
> I added him to make radix sort general usable in kernel,
> like heap sort, if needed.
> 
> Performance tested in userspace copy of heuristic code,
> throughput:
>     - average <-> random data: ~3500 MiB/s - heap  sort
>     - average <-> random data: ~6000 MiB/s - radix sort

Sounds good!

> Changes:
>   v1 -> v2:
>     - Tested on Big Endian
>     - Drop most of multiply operations
>     - Separately allocate sort buffer
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>

The code looks good, there are some coding style issues and we don't use
the uintX_t types, I'll fix that.

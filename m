Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbaE1Q7H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 12:59:07 -0400
Date: Wed, 28 May 2014 18:59:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Buchbinder <abuchbinder@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-image: Fix a data race in build_chunk_tree.
Message-ID: <20140528165906.GR5346@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400478042-19837-1-git-send-email-abuchbinder@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400478042-19837-1-git-send-email-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 18, 2014 at 10:40:42PM -0700, Adam Buchbinder wrote:
> A mdrestore_struct was being written to without its mutex being held.
> This race was found with ThreadSanitizer; the relevant part of the report
> looks like this:
> 
> WARNING: ThreadSanitizer: data race (pid=18828)
>   Write of size 8 at 0x7fffffc3d088 by main thread:
>     #0 build_chunk_tree .../btrfs-progs/btrfs-image.c:2233
>     #1 __restore_metadump .../btrfs-progs/btrfs-image.c:2294
>     #2 restore_metadump .../btrfs-progs/btrfs-image.c:2345
>     #3 main .../btrfs-progs/btrfs-image.c:2545
> 
>   Previous read of size 8 at 0x7fffffc3d088 by thread T1 (mutexes: write M0):
>     #0 restore_worker .../btrfs-progs/btrfs-image.c:1636
> 
>   Location is stack of main thread.
> 
>   Mutex M0 created at:
>     #0 pthread_mutex_init ??:0
>     #1 mdrestore_init .../btrfs-progs/btrfs-image.c:1766
>     #2 __restore_metadump .../btrfs-progs/btrfs-image.c:2286
>     #3 restore_metadump .../btrfs-progs/btrfs-image.c:2345
>     #4 main .../btrfs-progs/btrfs-image.c:2545
> 
>   Thread T1 (tid=18830, running) created by main thread at:
>     #0 pthread_create ??:0
>     #1 mdrestore_init .../btrfs-progs/btrfs-image.c:1784
>     #2 __restore_metadump .../btrfs-progs/btrfs-image.c:2286
>     #3 restore_metadump .../btrfs-progs/btrfs-image.c:2345
>     #4 main .../btrfs-progs/btrfs-image.c:2545
> ---

Thanks. FYI, I've added your Signed-off-by line, same as in the other
patch you've sent.

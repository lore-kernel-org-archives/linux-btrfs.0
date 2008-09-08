From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs_tree_lock & trylock
Date: Mon, 08 Sep 2008 09:47:46 -0400
Message-ID: <1220881666.8537.3.camel@think.oraclecorp.com>
References: <20080908111059.GA8902@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080908111059.GA8902@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-09-08 at 13:10 +0200, Andi Kleen wrote:
> I did some btrfs RTFS over the weeking and I have a hard time understanding 
> what this code is attempting to do:
> 
>  28 int btrfs_tree_lock(struct extent_buffer *eb)
>  29 {
>  30         int i;
>  31 
>  32         if (mutex_trylock(&eb->mutex))
>  33                 return 0;
>  34         for (i = 0; i < 512; i++) {
>  35                 cpu_relax();
>  36                 if (mutex_trylock(&eb->mutex))
>  37                         return 0;
>  38         }
>  39         cpu_relax();
>  40         mutex_lock_nested(&eb->mutex, BTRFS_MAX_LEVEL - btrfs_header_level(e    b));
>  41         return 0;
>  42 }
> 
> The trylocks seem pretty pointless.
> I presume it can be all replaced with the mutex_lock_nested() in line 40.
> Also the return value seems pointless because noone checks it. Like
> in the appended patch. Or do I miss something?

The idea is to try to spin for a bit to avoid scheduling away, which is
especially important for the high levels.  Most holders of the mutex
let it go very quickly.

-chris



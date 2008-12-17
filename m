From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: compilation problem on last unstable
Date: Wed, 17 Dec 2008 13:14:47 -0500
Message-ID: <20081217181447.GA2986@tux64-01>
References: <loom.20081217T174132-393@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Michele Petrazzo <michele.petrazzo@unipex.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20081217T174132-393@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 17, 2008 at 05:43:50PM +0000, Michele Petrazzo wrote:
> Hi,
> I just tried to compile the last unstable version, but:
> 
>   CC [M]  /home/michele/btrfs-unstable-standalone/inode.o
> /home/michele/btrfs-unstable-standalone/inode.c: In function ???btrfs_new_inode???:
> /home/michele/btrfs-unstable-standalone/inode.c:3470: error: implicit
> declaration of function ???current_fsuid???
> /home/michele/btrfs-unstable-standalone/inode.c:3471: error: implicit
> declaration of function ???current_fsgid???
> /home/michele/btrfs-unstable-standalone/inode.c: In function 
> ???btrfs_cache_create???:
> /home/michele/btrfs-unstable-standalone/inode.c:4527: warning: passing argument
> 5 of ???kmem_cache_create??? from incompatible pointer type
> /home/michele/btrfs-unstable-standalone/inode.c: At top level:
> /home/michele/btrfs-unstable-standalone/inode.c:4966: warning: initialization
> from incompatible pointer type
> /home/michele/btrfs-unstable-standalone/inode.c:4970: warning: initialization
> from incompatible pointer type
> /home/michele/btrfs-unstable-standalone/inode.c:5024: warning: initialization
> from incompatible pointer type
> /home/michele/btrfs-unstable-standalone/inode.c:5030: warning: initialization
> from incompatible pointer type
> /home/michele/btrfs-unstable-standalone/inode.c:5040: warning: initialization
> from incompatible pointer type
> make[2]: *** [/home/michele/btrfs-unstable-standalone/inode.o] Error 1
> make[1]: *** [_module_/home/michele/btrfs-unstable-standalone] Error 2
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.26-1-686'
> make: *** [all] Error 2
> michele:~/btrfs-unstable-standalone$ 
> 
> 
> michele:~/btrfs-unstable-standalone$ uname -r
> 2.6.26-1-686
> 
> from debian 
Currently btrfs only compiles on 2.6.27 and above although support all
the way back to 2.6.18 is planned. I'm currently using Ubuntu 8.10 for
all btrfs testing.
> 
> Thanks,
> Michele
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

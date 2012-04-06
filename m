From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH v2] Btrfs, lockdep: get_restripe_target: use lockdep in
 BUG_ON
Date: Fri, 6 Apr 2012 23:05:55 +0300
Message-ID: <20120406200555.GA3414@zambezi.lan>
References: <1333570774-26462-1-git-send-email-bobbypowers@gmail.com>
 <1333591452-23264-1-git-send-email-bobbypowers@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <ak@linux.intel.com>, Jeff Mahoney <jeffm@suse.de>,
	Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
To: Bobby Powers <bobbypowers@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1333591452-23264-1-git-send-email-bobbypowers@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 04, 2012 at 10:04:12PM -0400, Bobby Powers wrote:
> spin_is_locked always returns 0 on non-SMP systems, which causes btrfs
> to fail the mount.  There is documentation pending as to why checking
> for spin_is_locked is a bad idea:
> 
> https://lkml.org/lkml/2012/3/27/413
> 
> The suggested lockdep_assert_held() is not appropriate in this case,
> as what get_restripe_target() is checking for is that either
> volume_mutex is held or balance_lock is held.  Luckily
> lockdep_assert_held() is a simple macro:
> 
> WARN_ON(debug_locks && !lockdep_is_held(l))
> 
> We can mimic the structure in get_restripe_target(), but we need to
> make sure lockdep_is_held() is defined for the !LOCKDEP case.
> 
> CC: Ilya Dryomov <idryomov@gmail.com>
> CC: Chris Mason <chris.mason@oracle.com>
> CC: Andi Kleen <ak@linux.intel.com>
> CC: Jeff Mahoney <jeffm@suse.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
> ---
>  fs/btrfs/extent-tree.c  |    5 +++--
>  include/linux/lockdep.h |    1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a844204..4d13eb1 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -24,6 +24,7 @@
>  #include <linux/kthread.h>
>  #include <linux/slab.h>
>  #include <linux/ratelimit.h>
> +#include <linux/lockdep.h>
>  #include "compat.h"
>  #include "hash.h"
>  #include "ctree.h"
> @@ -3158,8 +3159,8 @@ static u64 get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags)
>  	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
>  	u64 target = 0;
>  
> -	BUG_ON(!mutex_is_locked(&fs_info->volume_mutex) &&
> -	       !spin_is_locked(&fs_info->balance_lock));
> +	BUG_ON(debug_locks && !lockdep_is_held(&fs_info->volume_mutex) &&
> +	       !lockdep_is_held(&fs_info->balance_lock));
>  
>  	if (!bctl)
>  		return 0;
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index d36619e..94c0edb 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -392,6 +392,7 @@ struct lock_class_key { };
>  
>  #define lockdep_depth(tsk)	(0)
>  
> +#define lockdep_is_held(l)	(0)
>  #define lockdep_assert_held(l)			do { } while (0)
>  
>  #define lockdep_recursing(tsk)			(0)
> -- 
> 1.7.10.rc3.3.g19a6c

OK, Mitch's report prompted me to actually take a look.  This patch is
wrong: by defining lockdep_is_held(l) to 0 in !LOCKDEP case you
effectively mimic the behaviour of spin_is_locked() which is what
getting us in the first place.

get_restripe_target() interface is WIP so I will replace BUG_ON with a
comment and send a patch through btrfs tree.

Thanks,

		Ilya

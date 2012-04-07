From: Bobby Powers <bobbypowers@gmail.com>
Subject: Re: [PATCH v2] Btrfs, lockdep: get_restripe_target: use lockdep in BUG_ON
Date: Fri, 6 Apr 2012 21:06:15 -0400
Message-ID: <CAArOQ2Uyw=td97y8XQ-ijf+5prX88tT31VBOG9Dya=KV+=H8ig@mail.gmail.com>
References: <1333570774-26462-1-git-send-email-bobbypowers@gmail.com>
	<1333591452-23264-1-git-send-email-bobbypowers@gmail.com>
	<20120406200555.GA3414@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <ak@linux.intel.com>, Jeff Mahoney <jeffm@suse.de>,
	Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120406200555.GA3414@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 6, 2012 at 4:05 PM, Ilya Dryomov <idryomov@gmail.com> wrote=
:
> On Wed, Apr 04, 2012 at 10:04:12PM -0400, Bobby Powers wrote:
>> spin_is_locked always returns 0 on non-SMP systems, which causes btr=
fs
>> to fail the mount. =A0There is documentation pending as to why check=
ing
>> for spin_is_locked is a bad idea:
>>
>> https://lkml.org/lkml/2012/3/27/413
>>
>> The suggested lockdep_assert_held() is not appropriate in this case,
>> as what get_restripe_target() is checking for is that either
>> volume_mutex is held or balance_lock is held. =A0Luckily
>> lockdep_assert_held() is a simple macro:
>>
>> WARN_ON(debug_locks && !lockdep_is_held(l))
>>
>> We can mimic the structure in get_restripe_target(), but we need to
>> make sure lockdep_is_held() is defined for the !LOCKDEP case.
>>
>> CC: Ilya Dryomov <idryomov@gmail.com>
>> CC: Chris Mason <chris.mason@oracle.com>
>> CC: Andi Kleen <ak@linux.intel.com>
>> CC: Jeff Mahoney <jeffm@suse.de>
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: linux-kernel@vger.kernel.org
>> Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
>> ---
>> =A0fs/btrfs/extent-tree.c =A0| =A0 =A05 +++--
>> =A0include/linux/lockdep.h | =A0 =A01 +
>> =A02 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index a844204..4d13eb1 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -24,6 +24,7 @@
>> =A0#include <linux/kthread.h>
>> =A0#include <linux/slab.h>
>> =A0#include <linux/ratelimit.h>
>> +#include <linux/lockdep.h>
>> =A0#include "compat.h"
>> =A0#include "hash.h"
>> =A0#include "ctree.h"
>> @@ -3158,8 +3159,8 @@ static u64 get_restripe_target(struct btrfs_fs=
_info *fs_info, u64 flags)
>> =A0 =A0 =A0 struct btrfs_balance_control *bctl =3D fs_info->balance_=
ctl;
>> =A0 =A0 =A0 u64 target =3D 0;
>>
>> - =A0 =A0 BUG_ON(!mutex_is_locked(&fs_info->volume_mutex) &&
>> - =A0 =A0 =A0 =A0 =A0 =A0!spin_is_locked(&fs_info->balance_lock));
>> + =A0 =A0 BUG_ON(debug_locks && !lockdep_is_held(&fs_info->volume_mu=
tex) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0!lockdep_is_held(&fs_info->balance_lock));
>>
>> =A0 =A0 =A0 if (!bctl)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
>> index d36619e..94c0edb 100644
>> --- a/include/linux/lockdep.h
>> +++ b/include/linux/lockdep.h
>> @@ -392,6 +392,7 @@ struct lock_class_key { };
>>
>> =A0#define lockdep_depth(tsk) =A0 (0)
>>
>> +#define lockdep_is_held(l) =A0 (0)
>> =A0#define lockdep_assert_held(l) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 do { } while (0)
>>
>> =A0#define lockdep_recursing(tsk) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 (0)
>> --
>> 1.7.10.rc3.3.g19a6c
>
> OK, Mitch's report prompted me to actually take a look. =A0This patch=
 is
> wrong: by defining lockdep_is_held(l) to 0 in !LOCKDEP case you
> effectively mimic the behaviour of spin_is_locked() which is what
> getting us in the first place.
>
> get_restripe_target() interface is WIP so I will replace BUG_ON with =
a
> comment and send a patch through btrfs tree.

Hah, good point...

> Thanks,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Ilya

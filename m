From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v1 05/10] Btrfs: add nested locking mode for paths
Date: Fri, 23 Dec 2011 16:23:35 +0100
Message-ID: <4EF49CF7.8010606@jan-o-sch.net>
References: <cover.1324568415.git.list.btrfs@jan-o-sch.net> <108c7352f9047f90144360a5609816464b33afff.1324568416.git.list.btrfs@jan-o-sch.net> <20111222191617.GH19266@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org, lizf@cn.fujitsu.com, sensille@gmx.net
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111222191617.GH19266@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Am 22.12.2011 20:16, schrieb Chris Mason:
> On Thu, Dec 22, 2011 at 05:03:19PM +0100, Jan Schmidt wrote:
>> From: Arne Jansen<sensille@gmx.net>
>>
>> This patch adds the possibilty to read-lock an extent even if it is already
>> write-locked from the same thread. btrfs_find_all_roots() needs this
>> capability.
>
> I'd rather not add a nested flag to the locking code, lets just make the
> nesting explicitly allowed.
>
> You shouldn't need locks around lock->owner.  Either your process owns
> the lock (and it won't change away from your pid), or you don't own it
> and it won't be your pid.  Just make sure the owner field gets cleared
> when you do your final unlock.

Sounds good. I'll make a new patch the next days and send it. I'll also 
force-push it into the for-chris branch mentioned in the cover letter. 
So if anybody pulled that already, be warned.

> So, if you are the owner of a write lock, you can add more write locks
> or a read lock as required.
>
> Could you please describe the case where btrfs_find_all_roots needs
> this?

That's part of the patch set I ripped out of Arne's qgroup patches (I 
hope he speaks up in case my explanation is garbage). The idea is that 
find_all_roots should be callable even if you are currently holding a 
lock on the data extent or the leaf in question. In order to resolve 
non-shared refs, __resolve_indirect_ref needs so call btrfs_search_slot 
on the fs-tree and that would deadlock if we called it while holding any 
of the locks.

The current application for find_all_roots does not strictly require 
this bit, the caller won't have any of these locks (although I 
experimented with a version that locked the extent before calling 
find_all_roots while writing this patch set). But qgroups and btrfs send 
will both depend on that. I decided to include that bit here to avoid 
we're having multiple patch sets adding the same code later on.

-Jan

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37697 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753727AbdAIMGW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Jan 2017 07:06:22 -0500
Subject: Re: [RFC] Converging userspace and kernel code
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, David Sterba <dsterba@suse.com>
References: <512c15bf-3c4b-3b88-1106-a7d43386400f@suse.de>
 <65341974-d15f-408c-abad-98c2a5bb8743@cn.fujitsu.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <2a7a4b30-3a90-1aaf-b9ba-9269c58a31c9@suse.de>
Date: Mon, 9 Jan 2017 06:06:18 -0600
MIME-Version: 1.0
In-Reply-To: <65341974-d15f-408c-abad-98c2a5bb8743@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/08/2017 08:11 PM, Qu Wenruo wrote:
> 
> 
> At 01/08/2017 09:16 PM, Goldwyn Rodrigues wrote:
>>
>> 1. Motivation
>> While fixing user space tools for btrfs-progs, I found a couple of bugs
>> which are already solved in kernel space but were not ported to user
>> space. User space is a little ignored when it comes to fixing bugs in
>> the core functionality. XFS developers have already performed this and
>> the userspace and kernel code walks in lockstep for libxfs.
> 
> Personally speaking, I'm not a fan of re-using kernel code in btrfs-progs.
> 
> In fact, in btrfs-progs, we don't need a lot of kernel facilities, like
> page/VFS/lock(btrfs-progs works in single thread under most case).

The core functionality would be specific to btrfs algorithms. While I
agree it cannot do away with kernel components completely, we will be
minimizing the dependency of kernel components. The parts which interact
with kernel such as inode/dentry/etc handling would be moved out of this
core.

> 
> And that should make btrfs-progs easier to maintain.
> 
> Furthermore, there are cases while kernel is doing things wrong while
> btrfs-progs does it right.
> 
> Like RAID56 scrub, kernel scrub can screw up P/Q while (still
> out-of-tree though) scrub won't.
> 

Time to fix it?

> 
> Personally speaking, I'd like to see btrfs-progs as a lightweight
> re-implementation without the mess from kernel.
> Btrfs-progs and kernel can do cross-check, while btrfs-progs can be more
> developer friendly.

This cross-check, and lack of thereof, is what I wish to save. As for
being developer-friendly, you need to know the internal workings of the
kernel components to work on btrfs-progs. The core shall act as a
library on top of which btrfs-progs will be built/migrated.

> 
> (I'm already trying to re-implement btrfs_map_block() in btrfs-progs
> with a better interface in out-of-tree offline scrub patchset)
> 
>>
>>
>> 2. Implementation
>>
>> 2.1 Code Re-arranaging
>> Re-arrange the kernel code so that core functions are in a separate
>> directory "libbtrfs" or "core". (There is already libbtrfs_objects
>> keyword defined in Makefile.in, so I am not sure if we should use
>> libbtrfs, or perhaps just core). The core directory will contain
>> algorithms, function prototypes and implementations spcific to btrfs.
> 
> Well, we have kernel-lib/ for it already.
> And it sounds much like what you want.

While kernel-lib exists, it is not complete to perform a drop-in
replacement.

> 
> Further more, there is already work to separate fs/btrfs/ctree.h and
> include/uapi/linux/btrfs_tree.h (already done in kernel though).

Another advantage of performing this. doing the same thing twice ;)

> 
> We could start from the same thing in btrfs-progs.
> 
>>
>> Comparing the current situation, ctree.h is pretty "polluted" with
>> functions prototypes which do not belong there, the definition of which
>> are not in ctree.c. An example: functions which use struct dentry, inode
>> or other kernel component can be moved out of the core. Besides,
>> functions which could survive with btrfs_inode as opposed to inode
>> should be changed so. We would need new files to split the logic, such
>> as creating inode.c to keep all inode related code.
>>
>> 2.2 Kernel Stubs
>> Making the core directory a drop-in replacement will require kernel
>> stubs which would make some meaning in user-space. This may or may not
>> be included in kerncompat.h. Personally, I would prefer to move
>> kerncompat.h into kernel-stub linux/*.h files. The down-side is we could
>> have a lot of files and directories for stubs, not forgetting the ones
>> for trace/*.h or event asm/*.h.
> 
> Errr, I'm not a fan of 2.2 and 2.3 though.
> 
> Yes, we have cases that over 90% code can be reused from kernel, like
> raid6 recovery tables.
> 
> But that's almost pure algorithm part. (And I followed David's
> suggestion to put them into kernel-lib)
> 

Yes, it is algorithmic specific code which we want to pull. _Not_ the
entire fs/btrfs/*. This would require some additions to kernel-lib and
quite a few kernel stubs.

> For anything kernel specific, like ftrace/mutex/page/VFS, I prefer a
> lightweight re-write, which is easier to write and review.

And it should be so.

> 
> In my experience, I just used about 300 lines to rewrite
> btrfs_map_block(), compare to kernel 500+ lines and variant wrappers, no
> to mention easier to understand interface.
> Examples are:
> https://patchwork.kernel.org/patch/9488519/
> https://patchwork.kernel.org/patch/9488505/
> 
> 
> Especially since there may be more hidden bugs in kernel code.

Like Christoph said, We'd rather fix "hidden bugs" in both kernel and
tools rather than just the tools.

> 
> Thanks,
> Qu
> 
>>
>> 2.3 Flag day
>> Flag day would be the day we move to the new directory structure. Until
>> then, we send the patches with the current directory structure. After
>> flag day, all patches must be ported to the new directory structure. We
>> could request developers to repost/retest patches leading up to the flag
>> day.
>>
>>
>> 3. Post converging
>> Checks/scripts to make sure that patches which are pushed to kernel
>> space will not render user space tools uncompilable.
>>
>> While these are my (and my teams) thoughts, I would like suggestions
>> and/or criticism to improve the idea.
>>
> 
> 

-- 
Goldwyn

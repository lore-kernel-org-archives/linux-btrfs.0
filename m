Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935883AbdAJMOf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 07:14:35 -0500
Subject: Re: [RFC] Converging userspace and kernel code
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, David Sterba <dsterba@suse.com>
References: <512c15bf-3c4b-3b88-1106-a7d43386400f@suse.de>
 <1b68f099-53e8-1bc8-5ffc-2dd0b21a32ae@oracle.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <09ea1fbd-74a1-d9f5-ba86-bc7c9118d49f@suse.de>
Date: Tue, 10 Jan 2017 06:14:30 -0600
MIME-Version: 1.0
In-Reply-To: <1b68f099-53e8-1bc8-5ffc-2dd0b21a32ae@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/09/2017 09:28 PM, Anand Jain wrote:
> 
> Goldwyn,
> 
>  Could you add a list what functionality in btrfs-progs will
>  be using the 'core'. ?


There are too many to list. It would contain the algorithmic functions
of btrfs which would be able to interact with both kernel and btrfs-progs.



> 
> Thanks, Anand
> 
> 
> On 01/08/17 21:16, Goldwyn Rodrigues wrote:
>>
>> 1. Motivation
>> While fixing user space tools for btrfs-progs, I found a couple of bugs
>> which are already solved in kernel space but were not ported to user
>> space. User space is a little ignored when it comes to fixing bugs in
>> the core functionality. XFS developers have already performed this and
>> the userspace and kernel code walks in lockstep for libxfs.
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

-- 
Goldwyn

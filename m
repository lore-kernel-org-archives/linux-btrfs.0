Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49758 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GRHuY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 03:50:24 -0400
Received: by obbuo13 with SMTP id uo13so1779110obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2012 00:50:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5005BC11.2000701@gmx.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
	<CAHf9xvaj8sgku-e9ZSOEiQ2CqZ+xDibs5vuh0cWqv0K418ZTSQ@mail.gmail.com>
	<5005BC11.2000701@gmx.net>
Date: Wed, 18 Jul 2012 10:50:23 +0300
Message-ID: <CAHf9xvaEw0e=C_WorGCC_8QVhq8CAnLj6YSU9+RzFXTHjoUGUw@mail.gmail.com>
Subject: Re: [PATCH v1 00/15] Btrfs: subvolume quota groups (qgroups)
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Arne,
thanks for your comments.

On Tue, Jul 17, 2012 at 10:25 PM, Arne Jansen <sensille@gmx.net> wrote:
> On 07/17/2012 08:33 PM, Alex Lyakas wrote:
>> Jan,
>> I have studied to some extent the PDF and the code. I have some
>> questions; perhaps you can address them?
>>
>> 1) btrfs_qgroup_account_ref() calling btrfs_find_all_roots():
>> I understand that bytenr indicates some EXTENT_ITEM, which is a
>> back-reference for extent, which is perhaps a tree block (leaf or
>
> Not a backreference. The EXTENT_ITEM entry is the allocation of the
> extent. It also contains the back references.
>
>> node) or EXTENT_DATA. I also understand, that we want to receive a
>> list of subvolume roots, that reference this extent at some point in
>> time in the middle of a transaction. However, there is mentioning of
>> "finding all extents that reference this extent", which is something
>> basic I don't understand. How an extent can back-reference another
>
> Here, the forward reference is meant. Tree nodes and leaves are
> referenced by tree nodes, data extents are referenced by leaves.
>
>> extent? Also, how do we encounter roots (which is what we need in the
>> output) during this walking? Hope you can shed some light, or you can
>
> iirc the root backreferences itself, which is the criterion that we
> found a root.
>
>> let me continue digging in the code:)
>>
>> 2) btrfs_qgroup_account_ref() step 3:
>> I understand that at this step, we look at all roots that we cannot
>> reach from the new root (the one to/from which the ref is
>> added/removed). And we check the refcnt before/after addition/deletion
>> (respectively). Then we check that its refcnt before/after
>> addition/deletion equals to the number of reachable roots before/after
>> addition/deletion. I still don't understand fully why if these two
>> values are equal, we can update exclusive count?
>
> I would have to re-read the pdf, it's been a long time ;)
>
>> My partial understanding is that such root, let's say before addition,
>> was exclusive owner of the extent. And now (since this root is not
>> reachable from new root), we are adding the extent to some "disjoint"
>> qgroup, so the previous root is not exclusive owner anymore. Is this
>> correct direction?
>
> I think so. Drawing trees helps a lot here. Don't give up too easily,
> it took us 2 weeks to work out the algorithm ;)
>
>>
>> 3) The paper mentions "tracking groups" to account for
>> referenced/exclusive properly during snapshot creation. Looking at
>> btrfs-progs, I see that currently the user is expected to correctly
>> indicate which values should be copied from where, and kernel (more or
>> less) blindly copies those values. Is this correct?
>
> Yes. It might be useful to create a description language what you are
> going to snapshot from where and let progs take care that all tracking
> groups are set up properly. But that is an area for further research,
> currently it has to be done by hand.
>
>>
>> 4) GROUP_RELATION items:
>> We have two such items for every relation. How do we know which one is
>> the child and which is the parent? It looks from the kernel code that
>> it is expected that child-qgroupid < parent-qgroupid. Is this correct?
>> If yes, who is enforcing this?
>
> The qgroupid contains the level, and the parent always has to have a
> level greater than that of the child. I think that is checked somewhere.
> As the level is encoded into the upper bits, the above relation holds.

I saw the 16-48 bit separation in the paper, but did not find any
traces of that in the code. Probably there will not be more than 2^48
subvolumes/snapshots, so yes, this scheme works.

Alex.


>
> -Arne
>
>>
>> Thanks for your help,
>> Alex.
>>
>> On Thu, Jul 12, 2012 at 12:43 PM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
>>> This is a new version of Arne's qgroup patches from last October. The
>>> old patches didn't get the backref walking right, which is now based on
>>> the tree modification log.
>>>
>>> You can limit the space available to subvolumes or any group of
>>> subvolumes. You can determine the amount of space that will get freed
>>> when deleting a snapshot.
>>>
>>> The initial scan is still missing, so expect negative counters when you
>>> enable quotas on a non-empty volume and then delete stuff.
>>>
>>> Arne's introduction and concept description can still be found at
>>>
>>>         http://sensille.com/qgroups.pdf
>>>
>>> You can pull these patches from my git repository
>>>
>>>         git://git.jan-o-sch.net/btrfs-unstable qgroup
>>>
>>> The user mode patches required were sent at October 11, 2011 by Arne,
>>> subject "[PATCH v0] btrfs-progs: add qgroup commands".
>>>
>>> I tried to include some fair benchmark results with this cover letter.
>>> However, I tried several disk benchmarks from the phoronix test suite,
>>> none of them resulted in any write throughput decrease. I will have to
>>> create a more realistic setup on my own to benchmark the impact of
>>> qgroups (suggestions welcome). For now, I just wanted to get that patch
>>> set out :-)
>>>
>>> Thanks,
>>> -Jan
>>>
>>> Arne Jansen (11):
>>>   Btrfs: qgroup on-disk format
>>>   Btrfs: add helper for tree enumeration
>>>   Btrfs: check the root passed to btrfs_end_transaction
>>>   Btrfs: added helper to create new trees
>>>   Btrfs: qgroup state and initialization
>>>   Btrfs: Test code to change the order of delayed-ref processing
>>>   Btrfs: qgroup implementation and prototypes
>>>   Btrfs: quota tree support and startup
>>>   Btrfs: hooks to reserve qgroup space
>>>   Btrfs: add qgroup ioctls
>>>   Btrfs: add qgroup inheritance
>>>
>>> Jan Schmidt (4):
>>>   Btrfs: fix buffer leak in btrfs_next_old_leaf
>>>   Btrfs: join tree mod log code with the code holding back delayed refs
>>>   Btrfs: call the qgroup accounting functions
>>>   Btrfs: hooks for qgroup to record delayed refs
>>>
>>>  fs/btrfs/Makefile      |    2 +-
>>>  fs/btrfs/backref.c     |   30 +-
>>>  fs/btrfs/backref.h     |    3 +-
>>>  fs/btrfs/ctree.c       |  348 ++++++++----
>>>  fs/btrfs/ctree.h       |  233 +++++++-
>>>  fs/btrfs/delayed-ref.c |   56 +-
>>>  fs/btrfs/delayed-ref.h |   62 +--
>>>  fs/btrfs/disk-io.c     |  134 ++++-
>>>  fs/btrfs/disk-io.h     |    6 +
>>>  fs/btrfs/extent-tree.c |  119 ++++-
>>>  fs/btrfs/ioctl.c       |  244 +++++++-
>>>  fs/btrfs/ioctl.h       |   62 ++-
>>>  fs/btrfs/qgroup.c      | 1571 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>  fs/btrfs/transaction.c |   57 ++-
>>>  fs/btrfs/transaction.h |   11 +
>>>  15 files changed, 2696 insertions(+), 242 deletions(-)
>>>  create mode 100644 fs/btrfs/qgroup.c
>>>
>>> --
>>> 1.7.3.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

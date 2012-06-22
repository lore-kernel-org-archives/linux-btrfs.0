Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:35175 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab2FVOXV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 10:23:21 -0400
Message-ID: <4FE47FD6.9010205@fusionio.com>
Date: Fri, 22 Jun 2012 10:23:18 -0400
From: Josef Bacik <jbacik@fusionio.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>
Subject: Re: Deadlock in ctree.c?
References: <4FE45064.4090104@jan-o-sch.net> <4FE47372.6070101@fusionio.com> <4FE47563.8090102@jan-o-sch.net>
In-Reply-To: <4FE47563.8090102@jan-o-sch.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2012 09:38 AM, Jan Schmidt wrote:
> On Fri, June 22, 2012 at 15:30 (+0200), Josef Bacik wrote:
>> On 06/22/2012 07:00 AM, Jan Schmidt wrote:
>>> While debugging my tree mod log, after several hours of successful iteration I
>>> finally reached a dead lock. I got stacks with btrfs_next_leaf and
>>> push_leaf_left and looked into those.
>>>
>>> If I'm not mistaken, there is at least one deadlock situation between those two
>>> (I'm currently thinking about a second one). Basically, the problem is that
>>> btrfs_next_leaf has a leaf locked and wants a lock for the next (right) leaf,
>>> while push_leaf_left has a lock on another leaf and wants a lock for the
>>> previous (left) leaf.
>>>
>>> Assume that we've got two roots (subvolumes), both referencing the same two
>>> leafs in two really small trees:
>>>
>>>             r1     r2
>>>             |  \ /  |
>>>             |   X   |
>>>             |  / \  |
>>>             l1     l2
>>>
>>> Commented pseudo code that is meant to summarize the relevant code from ctree.c:
>>>
>>> Thread A in push_leaf_left, path is currently r2->l2:
>>>      btrfs_assert_tree_locked(path->nodes[1]); /* r2 */
>>>      /* also holds a lock at path->nodes[0] -> l2 */
>>>      left = read_node_slot(root, path->nodes[1], slot - 1); /* l1 */
>>>      btrfs_tree_lock(left);
>>> -> blocking to get lock on l1
>>>
>>> Thread B in btrfs_next_leaf, path is currently r1->l1:
>>>           path->keep_locks = 1;
>>>      btrfs_search_slot(...); /* locks r1, l1 */
>>>           level = 1;
>>>           while ...
>>>                   slot = path->slots[level] + 1;
>>>                   next = read_block_for_search(... slot ...);
>>>                   btrfs_tree_read_lock(next); /* l2 */
>>> -> blocking to get lock on l2
>>
>> l2 shouldn't be locked anymore, if we're in push_leaf_left it's because we
>> cow'ed l2 and are holding a lock on it, so really it has a lock on l2' and the
>> btrfs_next_leaf is trying to get a lock on l2 which it should be free to do.
>
> Each tree block is cowed only once per transaction, right? Lets assume l2 was
> cowed before any of the above threads started, we should end up with a lock on
> l2 even in push_leaf_left, because should_cow_block returns 0.
>

Except you'd never get to l2 in the case that it had already been 
cow'ed.  Thanks,

Josef

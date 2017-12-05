Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i6.italiaonline.it ([213.209.14.36]:45167 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752430AbdLESCC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 13:02:02 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [RFC] Improve subvolume usability for a normal user
To: Graham Cobb <g.btrfs@cobb.uk.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
 <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
 <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
 <22115bdd-75f6-eea1-923c-73f54955ee7e@cobb.uk.net>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <88e4e111-e9ca-15d5-f2f7-6b54091ea52b@libero.it>
Date: Tue, 5 Dec 2017 19:01:59 +0100
MIME-Version: 1.0
In-Reply-To: <22115bdd-75f6-eea1-923c-73f54955ee7e@cobb.uk.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/05/2017 04:42 PM, Graham Cobb wrote:
> On 05/12/17 12:41, Austin S. Hemmelgarn wrote:
>> On 2017-12-05 03:43, Qu Wenruo wrote:
>>>
>>>
>>> On 2017年12月05日 16:25, Misono, Tomohiro wrote:
>>>> Hello all,
>>>>
>>>> I want to address some issues of subvolume usability for a normal user.
>>>> i.e. a user can create subvolumes, but
>>>>   - Cannot delete their own subvolume (by default)
>>>>   - Cannot tell subvolumes from directories (in a straightforward way)
>>>>   - Cannot check the quota limit when qgroup is enabled
>>>>
>>>> Here I show the initial thoughts and approaches to this problem.
>>>> I want to check if this is a right approach or not before I start
>>>> writing code.
>>>>
>>>> Comments are welcome.
>>>> Tomohiro Misono
>>>>
>>>> ==========
>>>> - Goal and current problem
>>>> The goal of this RFC is to give a normal user more control to their
>>>> own subvolumes.
>>>> Currently the control to subvolumes for a normal user is restricted
>>>> as below:
>>>>
>>>> +-------------+------+------+
>>>> |   command   | root | user |
>>>> +-------------+------+------+
>>>> | sub create  | Y    | Y    |
>>>> | sub snap    | Y    | Y    |
>>>> | sub del     | Y    | N    |
>>>> | sub list    | Y    | N    |
>>>> | sub show    | Y    | N    |
>>>> | qgroup show | Y    | N    |
>>>> +-------------+------+------+
>>>>
>>>> In short, I want to change this as below in order to improve user's
>>>> usability:
>>>>
>>>> +-------------+------+--------+
>>>> |   command   | root | user   |
>>>> +-------------+------+--------+
>>>> | sub create  | Y    | Y      |
>>>> | sub snap    | Y    | Y      |
>>>> | sub del     | Y    | N -> Y |
>>>> | sub list    | Y    | N -> Y |
>>>> | sub show    | Y    | N -> Y |
>>>> | qgroup show | Y    | N -> Y |
>>>> +-------------+------+--------+
>>>>
>>>> In words,
>>>> (1) allow deletion of subvolume if a user owns it, and
>>>> (2) allow getting subvolume/quota info if a user has read access to it
>>>>   (sub list/qgroup show just lists the subvolumes which are readable
>>>> by the user)
>>>>
>>>> I think other commands not listed above (qgroup limit, send/receive
>>>> etc.) should
>>>> be done by root and not be allowed for a normal user.
>>>>
>>>>
>>>> - Outside the scope of this RFC
>>>> There is a qualitative problem to use qgroup for limiting user disk
>>>> amount;
>>>> quota limit can easily be averted by creating a subvolume. I think
>>>> that forcing
>>>> inheriting quota of parent subvolume is a solution, but I won't
>>>> address nor
>>>> discuss this here.
>>>>
>>>>
>>>> - Proposal
>>>>   (1) deletion of subvolume
>>>>
>>>>    I want to change the default behavior to allow a user to delete
>>>> their own
>>>>    subvolumes.
>>>>       This is not the same behavior as when user_subvol_rm_alowed
>>>> mount option is
>>>>    specified; in that case a user can delete the subvolume to which
>>>> they have
>>>>    write+exec right.
>>>>       Since snapshot creation is already restricted to the subvolume
>>>> owner, it is
>>>>    consistent that only the owner of the subvolume (or root) can
>>>> delete it.
>>>>       The implementation should be straightforward.
>>>
>>> Personally speaking, I prefer to do the complex owner check in user
>>> daemon.
>>>
>>> And do the privilege in user daemon (call it btrfsd for example).
>>>
>>> So btrfs-progs will works in 2 modes, if root calls it, do as it used
>>> to do.
>>> If normal user calls it, proxy the request to btrfsd, and btrfsd does
>>> the privilege checking and call ioctl (with root privilege).
>>>
>>> Then no impact to kernel, all complex work is done in user space.
>> Exactly how hard is it to just check ownership of the root inode of a
>> subvolume from the ioctl context?  You could just as easily push all the
>> checking out to the VFS layer by taking an open fd for the subvolume
>> root (and probably implicitly closing it) instead of taking a path, and
>> that would give you all the benefits of ACL's and whatever security
>> modules the local system is using.  
> 
> +1 - stop inventing new access control rules for each different action!

A subvolume is like a directory; In all filesystems you cannot remove an inode if you don't have write access to the parent directory. I assume that this is a POSIX requirement; and if so this should be true even for BTRFS.
This means that in order to remove a subvolume and you are not root, you should check all the contained directories. It is not sufficient to check one inode.

In the past I create a patch [1][2] which extended the unlink (2) syscall to allow removing a subvolume if:
a) the user is root  or
b.1) if the subvolume is empty and
b.2) the user has the write capability to the parent directory

This will solve all the problems:
a) removing a subvolume is like removing a directory; no different check is performed; no new (and strange) rule
b) an ordinary user can remove a subvolume, like a directory
c) is quite easy to implement

Root still have another way (more efficient) to remove a subvolume: he can invoke the BTRFS_IOC_SNAP_DESTROY, which doesn't need to traverse all the tree.

BR
G.Baroncelli


[1] https://www.spinics.net/lists/linux-btrfs/msg06499.html
[2] https://patchwork.kernel.org/patch/260301/
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:46717 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbdLFMZZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Dec 2017 07:25:25 -0500
Received: by mail-it0-f65.google.com with SMTP id t1so6929241ite.5
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Dec 2017 04:25:25 -0800 (PST)
Subject: Re: [RFC] Improve subvolume usability for a normal user
To: kreijack@inwind.it, Graham Cobb <g.btrfs@cobb.uk.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
 <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
 <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
 <22115bdd-75f6-eea1-923c-73f54955ee7e@cobb.uk.net>
 <88e4e111-e9ca-15d5-f2f7-6b54091ea52b@libero.it>
 <9320c224-7f4d-eeaa-d60f-755825f7944d@cobb.uk.net>
 <5a0216a6-03fc-53b1-5126-e6e5184e6cca@libero.it>
 <d80708a2-ae05-6758-47fc-971f92a72d1a@gmail.com>
 <9d96d5c3-44ca-751d-07b5-8f7675143dde@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <57a277a5-8f53-4b28-12e4-374eed4583cc@gmail.com>
Date: Wed, 6 Dec 2017 07:25:20 -0500
MIME-Version: 1.0
In-Reply-To: <9d96d5c3-44ca-751d-07b5-8f7675143dde@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-05 17:08, Goffredo Baroncelli wrote:
> On 12/05/2017 09:17 PM, Austin S. Hemmelgarn wrote:
>> On 2017-12-05 14:09, Goffredo Baroncelli wrote:
>>> On 12/05/2017 07:46 PM, Graham Cobb wrote:
>>>> On 05/12/17 18:01, Goffredo Baroncelli wrote:
>>>>> On 12/05/2017 04:42 PM, Graham Cobb wrote:
>>> [....]
>>>>>>>> Then no impact to kernel, all complex work is done in user space.
>>>>>>> Exactly how hard is it to just check ownership of the root inode of a
>>>>>>> subvolume from the ioctl context?  You could just as easily push all the
>>>>>>> checking out to the VFS layer by taking an open fd for the subvolume
>>>>>>> root (and probably implicitly closing it) instead of taking a path, and
>>>>>>> that would give you all the benefits of ACL's and whatever security
>>>>>>> modules the local system is using.
>>>>>>
>>>>>> +1 - stop inventing new access control rules for each different action!
>>>>>
>>>>> A subvolume is like a directory; In all filesystems you cannot remove an inode if you don't have write access to the parent directory. I assume that this is a POSIX requirement; and if so this should be true even for BTRFS.
>>>>> This means that in order to remove a subvolume and you are not root, you should check all the contained directories. It is not sufficient to check one inode.
>>>>>
>>>>> In the past I create a patch [1][2] which extended the unlink (2) syscall to allow removing a subvolume if:
>>>>> a) the user is root  or
>>>>> b.1) if the subvolume is empty and
>>>>> b.2) the user has the write capability to the parent directory
>>>>
>>>> That is also OK, as it follows a logical and consistent model without
>>>> introducing new rules, but it has two disadvantages with snapshots the
>>>> user creates and then wants to delete:
>>>>
>>>> i) they have to change the snapshot to readwrite to remove all the
>>>> contents -- how many users will know that that can even be done?
>>>
>>> I think that this is an orthogonal question.  However the user should use btrfs set....
>>>
>>> Anyway I am not against to use something more specific like "btrfs sub del...", where it could be possible to implement a more specific checks. I am only highlight that destroy a subvolume without looking to its content could break the POSIX rules
>> No, it doesn't break POSIX rules, because you can't do it with POSIX defined interfaces (not counting ioctls, but ioctls are by definition system dependent).
> 
> user$ mkdir -p dir1/dir2
> user$ touch dir1/dir2/file
> user$ sudo chown foo:foo dir1/dir2
> 
> user$ rm -rf dir1/
> rm: cannot remove 'dir1/dir2/file1': Permission denied
> 
> In a POSIX filesystem, you (as user) cannot remove file1.
> 
> But if instead of dir1 you have a subvolume (called sub1), and the check of removing the subvolume is performed only on the root of subvolume, you could remove it.
> 
> Is it a problem ? I think no, but I am not a security expert. But even if POSIX doesn't have the concept of subvolume, this is definitely a break of a POSIX rule.
Except it isn't a break of a POSIX rule, because deleting the subvolume 
doesn't go through regular POSIX API's (again, ioctl really doesn't 
count because it's designed for random extended stuff).  POSIX makes 
absolutely zero guarantees about the behavior of things not done through 
POSIX API's.  Yes, this doesn't use POSIX style permission checks, but 
it also doesn't violate POSIX standards either (because it's not defined 
in the POSIX standard, and things that aren't defined by the standards 
are explicitly stated to be implementation defined).

The data loss risk this entails is however the reason users can't delete 
subvolumes by default.
> 
> On the other side, if the user makes a snapshot of a subvolume containing a not owned and not empty directory, for the user it would be impossible to delete its snapshot (!).
I would argue that by default they shouldn't be able to make a snapshot 
because:
1. With the default behavior of users not being able to delete 
subvolumes, users can trivially cause a resource exhaustion situation 
that they can't resolve themself.
2. Whitelisting is usually better for security than blacklisting.
> 
> 
>>>
>>>>
>>>> ii) if the snapshot contains a file the user cannot remove then the user
>>>> cannot remove the snapshot at all (even though they could create it).
>>>
>>> It is the same for the other filesystem: if in a filesystem tree, there is a directory which is not changeable by the user, the user cannot remove all the tree. Again, I am only highlighting that there is a possible break of POSIX rules.
>> POSIX says nothing about non-permissions related reasons for not being able to remove a directory.
> Nobody has say the opposite
Claiming that it's potentially POSIX incompatible behavior directly 
implies that POSIX has provisions regarding non-permissions related 
reasons for not being able to remove a directory.
> 
>>    A subvolume is treated (too much in my opinion) like a mount point, regardless of whether or not it's explicitly mounted, and that seems to be most of why you can't remove it with unlink().
>>>
>>>>
>>>> That is why I preferred Austin's first proposal. I suppose your proposal
>>>> could be extended:
>>>>
>>>> a) the user is root  or
>>>> b.1) if the subvolume is empty and
>>>> b.2) the user has the write capability to the parent directory, or
>>>> c) the subvolume is readonly
>>>
>>> If a subvolume is marked read-only, the user has to change to RW via "btrfs property set...."
>> I actually do agree with this assessment to a certain extent, but the user has to be able to change the subvolume to be RW to begin with (and that _does_ need an in-kernel permissions check 
>> beyond just knowing whether you can access the subvolume).



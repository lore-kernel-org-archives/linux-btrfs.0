Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:33211 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752312AbdLETJS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 14:09:18 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [RFC] Improve subvolume usability for a normal user
To: Graham Cobb <g.btrfs@cobb.uk.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
 <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
 <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
 <22115bdd-75f6-eea1-923c-73f54955ee7e@cobb.uk.net>
 <88e4e111-e9ca-15d5-f2f7-6b54091ea52b@libero.it>
 <9320c224-7f4d-eeaa-d60f-755825f7944d@cobb.uk.net>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <5a0216a6-03fc-53b1-5126-e6e5184e6cca@libero.it>
Date: Tue, 5 Dec 2017 20:09:15 +0100
MIME-Version: 1.0
In-Reply-To: <9320c224-7f4d-eeaa-d60f-755825f7944d@cobb.uk.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/05/2017 07:46 PM, Graham Cobb wrote:
> On 05/12/17 18:01, Goffredo Baroncelli wrote:
>> On 12/05/2017 04:42 PM, Graham Cobb wrote:
[....]
>>>>> Then no impact to kernel, all complex work is done in user space.
>>>> Exactly how hard is it to just check ownership of the root inode of a
>>>> subvolume from the ioctl context?  You could just as easily push all the
>>>> checking out to the VFS layer by taking an open fd for the subvolume
>>>> root (and probably implicitly closing it) instead of taking a path, and
>>>> that would give you all the benefits of ACL's and whatever security
>>>> modules the local system is using.  
>>>
>>> +1 - stop inventing new access control rules for each different action!
>>
>> A subvolume is like a directory; In all filesystems you cannot remove an inode if you don't have write access to the parent directory. I assume that this is a POSIX requirement; and if so this should be true even for BTRFS.
>> This means that in order to remove a subvolume and you are not root, you should check all the contained directories. It is not sufficient to check one inode.
>>
>> In the past I create a patch [1][2] which extended the unlink (2) syscall to allow removing a subvolume if:
>> a) the user is root  or
>> b.1) if the subvolume is empty and
>> b.2) the user has the write capability to the parent directory
> 
> That is also OK, as it follows a logical and consistent model without
> introducing new rules, but it has two disadvantages with snapshots the
> user creates and then wants to delete:
> 
> i) they have to change the snapshot to readwrite to remove all the
> contents -- how many users will know that that can even be done?

I think that this is an orthogonal question.  However the user should use btrfs set....

Anyway I am not against to use something more specific like "btrfs sub del...", where it could be possible to implement a more specific checks. I am only highlight that destroy a subvolume without looking to its content could break the POSIX rules

> 
> ii) if the snapshot contains a file the user cannot remove then the user
> cannot remove the snapshot at all (even though they could create it).

It is the same for the other filesystem: if in a filesystem tree, there is a directory which is not changeable by the user, the user cannot remove all the tree. Again, I am only highlighting that there is a possible break of POSIX rules.

> 
> That is why I preferred Austin's first proposal. I suppose your proposal
> could be extended:
> 
> a) the user is root  or
> b.1) if the subvolume is empty and
> b.2) the user has the write capability to the parent directory, or
> c) the subvolume is readonly

If a subvolume is marked read-only, the user has to change to RW via "btrfs property set...."

> 
> However it is done, I think it is important that all normal VFS access
> rules (such as ACLs) are followed for the subvolume itself.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

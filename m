Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:44172 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752713AbdLEMlt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 07:41:49 -0500
Received: by mail-it0-f43.google.com with SMTP id b5so1167664itc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Dec 2017 04:41:48 -0800 (PST)
Subject: Re: [RFC] Improve subvolume usability for a normal user
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
 <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
Date: Tue, 5 Dec 2017 07:41:44 -0500
MIME-Version: 1.0
In-Reply-To: <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-05 03:43, Qu Wenruo wrote:
> 
> 
> On 2017年12月05日 16:25, Misono, Tomohiro wrote:
>> Hello all,
>>
>> I want to address some issues of subvolume usability for a normal user.
>> i.e. a user can create subvolumes, but
>>   - Cannot delete their own subvolume (by default)
>>   - Cannot tell subvolumes from directories (in a straightforward way)
>>   - Cannot check the quota limit when qgroup is enabled
>>
>> Here I show the initial thoughts and approaches to this problem.
>> I want to check if this is a right approach or not before I start writing code.
>>
>> Comments are welcome.
>> Tomohiro Misono
>>
>> ==========
>> - Goal and current problem
>> The goal of this RFC is to give a normal user more control to their own subvolumes.
>> Currently the control to subvolumes for a normal user is restricted as below:
>>
>> +-------------+------+------+
>> |   command   | root | user |
>> +-------------+------+------+
>> | sub create  | Y    | Y    |
>> | sub snap    | Y    | Y    |
>> | sub del     | Y    | N    |
>> | sub list    | Y    | N    |
>> | sub show    | Y    | N    |
>> | qgroup show | Y    | N    |
>> +-------------+------+------+
>>
>> In short, I want to change this as below in order to improve user's usability:
>>
>> +-------------+------+--------+
>> |   command   | root | user   |
>> +-------------+------+--------+
>> | sub create  | Y    | Y      |
>> | sub snap    | Y    | Y      |
>> | sub del     | Y    | N -> Y |
>> | sub list    | Y    | N -> Y |
>> | sub show    | Y    | N -> Y |
>> | qgroup show | Y    | N -> Y |
>> +-------------+------+--------+
>>
>> In words,
>> (1) allow deletion of subvolume if a user owns it, and
>> (2) allow getting subvolume/quota info if a user has read access to it
>>   (sub list/qgroup show just lists the subvolumes which are readable by the user)
>>
>> I think other commands not listed above (qgroup limit, send/receive etc.) should
>> be done by root and not be allowed for a normal user.
>>
>>
>> - Outside the scope of this RFC
>> There is a qualitative problem to use qgroup for limiting user disk amount;
>> quota limit can easily be averted by creating a subvolume. I think that forcing
>> inheriting quota of parent subvolume is a solution, but I won't address nor
>> discuss this here.
>>
>>
>> - Proposal
>>   (1) deletion of subvolume
>>
>>    I want to change the default behavior to allow a user to delete their own
>>    subvolumes.
>>    
>>    This is not the same behavior as when user_subvol_rm_alowed mount option is
>>    specified; in that case a user can delete the subvolume to which they have
>>    write+exec right.
>>    
>>    Since snapshot creation is already restricted to the subvolume owner, it is
>>    consistent that only the owner of the subvolume (or root) can delete it.
>>    
>>    The implementation should be straightforward.
> 
> Personally speaking, I prefer to do the complex owner check in user daemon.
> 
> And do the privilege in user daemon (call it btrfsd for example).
> 
> So btrfs-progs will works in 2 modes, if root calls it, do as it used to do.
> If normal user calls it, proxy the request to btrfsd, and btrfsd does
> the privilege checking and call ioctl (with root privilege).
> 
> Then no impact to kernel, all complex work is done in user space.
Exactly how hard is it to just check ownership of the root inode of a 
subvolume from the ioctl context?  You could just as easily push all the 
checking out to the VFS layer by taking an open fd for the subvolume 
root (and probably implicitly closing it) instead of taking a path, and 
that would give you all the benefits of ACL's and whatever security 
modules the local system is using.  Alternatively, quit treating 
subvolumes specially for `unlink()`, and make them behave like regular 
directories (and thus avoid the one possible complication resulting from 
home directories being subvolumes but needing to be owned by the users).

<rant>
This whole 'just make it a daemon' thing that's becoming the standard 
solution everywhere these days is crap in most cases (note that I'm not 
just singling out this proposal here).  Just because systemd does it 
doesn't make it a good idea, especially when it makes things like this 
far more opaque than they really need to be, which in turn makes it a 
pain in the arse to debug _anything_ to do with permissions beyond basic 
file access.
</rant>

In almost all cases, the desired check is to allow root, possibly admin 
users who have filesystem management permissions (usually exactly one 
group), and the owner.  That is trivial to implement with a single ACL 
entry and basic filesystem permissions without needing some special 
daemon to check them provided we route things through the VFS layer 
somehow.  In the rare cases that that's not what's wanted, then the 
system is almost certainly using an LSM, and the checks can be made there.
> 
>>
>>   (2) getting subvolume/quota info
>>
>>    TREE_SEARCH ioctl is used to retrieve the subvolume/quota info by btrfs-progs
>>    (sub show/list, qgroup show etc.). This requires the root permission.
>>    
>>    The easiest way to allow a user to get subvolume/quota info is just relaxing
>>    the permission of TREE_SEARCH. However, since all the tree information (inc.
>>    file name) will be exposed, this poses a sequrity risk and is not acceptable.
>>    
>>    So, I want to introduce 2 ioctls to get subvolume/quota info respectively for
>>    a normal user, which return only the info readable by the user:
>>    
>>     [subvolume info]
>>      Mainly search ROOT tree for ROOT_ITEM/ROOT_BACKREF, but check its read
>>     right by searching FS/FILE tree and comparing it with caller's uid.
>>    
>>     [quota info]
>>      Same as above, but mainly search QUOTA tree and only returns level 0 info.
>>    
>>    Also, in order to construct subvolume path, permission of INO_LOOKUP ioctl
>>    needs to be relaxed for the user who has read access to the subvolume.
> 
> Same method can apply to this either.
> 
> Thanks,
> Qu
>>
>>
>> - Summary of Proposal
>>   - Change the default behavior to allow a user to delete their own subvolumes
>>   - Add 2 new non-root ioctls to get subvolume/quota info for accessible subvolumes


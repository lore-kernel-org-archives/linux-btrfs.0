Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:36821 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932098AbdC1LpC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 07:45:02 -0400
Received: by mail-it0-f43.google.com with SMTP id e75so52794396itd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 04:45:01 -0700 (PDT)
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Moritz Sichert <moritz+linux@sichert.me>,
        Andrei Borzenkov <arvidjaar@gmail.com>, linux-btrfs@vger.kernel.org
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
 <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
 <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
 <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
 <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
 <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
 <3b03ab4a-a0c2-27df-c6e4-c5f60fd4b5db@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <24d10583-543f-cf1e-9f00-dd419a593f3d@gmail.com>
Date: Tue, 28 Mar 2017 07:44:56 -0400
MIME-Version: 1.0
In-Reply-To: <3b03ab4a-a0c2-27df-c6e4-c5f60fd4b5db@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-27 21:49, Qu Wenruo wrote:
>
>
> At 03/27/2017 08:01 PM, Austin S. Hemmelgarn wrote:
>> On 2017-03-27 07:02, Moritz Sichert wrote:
>>> Am 27.03.2017 um 05:46 schrieb Qu Wenruo:
>>>>
>>>>
>>>> At 03/27/2017 11:26 AM, Andrei Borzenkov wrote:
>>>>> 27.03.2017 03:39, Qu Wenruo пишет:
>>>>>>
>>>>>>
>>>>>> At 03/26/2017 06:03 AM, Moritz Sichert wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I tried to configure qgroups on a btrfs filesystem but was really
>>>>>>> surprised that when you snapshot a subvolume, the snapshot will
>>>>>>> not be
>>>>>>> assigned to the qgroup the subvolume was in.
>>>>>>>
>>>>>>> As an example consider the small terminal session in the
>>>>>>> attachment: I
>>>>>>> create a subvol A, assign it to qgroup 1/1 and set a limit of 5M on
>>>>>>> that qgroup. Then I write a file into A and eventually get "disk
>>>>>>> quota
>>>>>>> exceeded". Then I create a snapshot of A and call it B. B will
>>>>>>> not be
>>>>>>> assigned to 1/1 and writing a file into B confirms that no limits at
>>>>>>> all are imposed for B.
>>>>>>>
>>>>>>> I feel like I must be missing something here. Considering that
>>>>>>> creating a snapshot does not require root privileges this would mean
>>>>>>> that any user can just circumvent any quota and therefore make them
>>>>>>> useless.
>>>>>>>
>>>>>>> Is there a way to enforce quotas even when a user creates snapshots?
>>>>>>>
>>>>>>
>>>>>> Yes, there is always method to attach the subvolume/snapshot to
>>>>>> specified higher level qgroup.
>>>>>>
>>>>>> Just use "btrfs subvolume snapshot -i 1/1".
>>>>>>
>>>>>
>>>>> This requires cooperation from whoever creates subvolume, while the
>>>>> question was - is it possible to enforce it, without need for explicit
>>>>> option/action when snapshot is created.
>>>>>
>>>>> To reiterate - if user omits "-i 1/1" (s)he "escapes" from quota
>>>>> enforcement.
>>>>
>>>> What if user really want to create a subvolume assigned another group?
>>>>
>>>> You're implying a *policy* that if source subvolume belongs to a
>>>> higher level qgroup, then snapshot created should also follow that
>>>> higher level qgroup.
>>>>
>>>> However kernel should only provide *mechanisim*, not *policy*.
>>>> And btrfs does it, it provides method to do it, whether to do or not
>>>> is users responsibility.
>>>>
>>>> If you want to implement that policy, please do it in a higher level,
>>>> something like SUSE snapper, not in kernel.
>>>
>>> The problem is, I can't enforce the policy because *every user* can
>>> create snapshots. Even if I would restrict the btrfs executable so
>>> that only root can execute it, this doesn't help. As using the ioctl
>>> for btrfs is allowed for any user, they could just get the executable
>>> from somewhere else.
>> To reiterate and reinforce this:
>> If it is not possible to enforce new subvolumes counting for their
>> parent quota, and there is no option to prevent non-root (or
>> non-CAP_SYS_ADMIN) users from creating new subvolumes, then BTRFS
>> qgroups are useless on any system with shell access because a user can
>> trivially escape their quota restrictions (or hide from accounting) by
>> creating a new subvolume which is outside of their qgroup and storing
>> data there.
>>
>> Ideally, there should be an option to disable user subvolume creation
>> (it arguably should be the default, because of resource exhaustion
>> issues, but that's a separate argument), and there should be an option
>> in the kernel to force specific behavior.  Both cases are policy, but
>> they are policy that can only be concretely enforced _by the kernel_.
>>
>>
> The problem is, how should we treat subvolume.
>
> Btrfs subvolume sits in the middle of directory and (logical) volume
> used in traditional stacked solution.
>
> While we allow normal user to create/delete/modify dir as long as they
> follow access control, we require privilege to create/delete/modify
> volumes.
No, we require privilege to do certain modifications or delete 
subvolumes.  Regular users can create subvolumes with no privileges 
whatsoever, and most basic directory operations (rename, chown, chmod, 
etc) work just fine within normal UNIX DAC permissions.  Unless you're 
running some specially patched kernel or some LSM (SELinux possibly) 
that somehow restricts access to the ioctl, you can always create 
subvolumes.

This is part of the reason that I'm personally hesitant to use BTRFS on 
systems where end users have shell access, it's a DoS waiting to happen.
>
> Developers chose to treat btrfs subvolume as dir, makes it quite easy to
> operate for normal use case, sacrificing qgroup limit which is not a
> major function (or even did not exist) at that time.
>
> IIRC at the beginning time of btrfs, we don't have a full idea of use
> cases could be.
> This is common, a lot of problems(even bad design) can only be found
> after enough feedback from end users.
>
> Personally speaking, I prefer to restrict subvolume creation/deletion to
> privilege users only, and uses a daemon as a proxy to do such privilege
> operation.
> So we can do better accounting/access control without bothering the kernel.
I will agree that a daemon for this can be useful, but even if we add a 
mount option to restrict operations on subvolumes by normal users, we 
can still provide the option of a daemon.  On something like a single 
user system, there is not much advantage to having some complex access 
control in place.  I'm not saying we should put any kind of complex ACL 
into the kernel, but that we should at least have some all-or-nothing 
switch in the mount options that controls if unprivileged users can 
perform subvolume operations.  Ideally it would be just one option, but 
unfortunately we provided somewhat nonsensical initial semantics that we 
now have to continue to support.

Looking at the qgroup stuff specifically though, snapshots not 
inheriting their parent's qgroup seems really odd to me.  There are two 
things that come to mind, and I'd love to see both personally:
1. Provide an option to have snapshots inherit their parent's qgroup. 
This would eliminate the 'surprise' that initially sparked this 
discussion, and deal with tools that aren't qgroup aware.
2. Provide an option to specify the default qgroup for new subvolumes, 
instead of them being created with no qgroup.  This would cover the rest 
of things, and provide some further usefulness (for example, you could 
leave this default qgroup empty most of the time and have monitoring 
software alert you if it suddenly had data in it to detect stuff 
creating subvolumes behind your back).
Both sound more to me like they should probably be specified somewhere 
in the filesystem itself, not the mount options.
>
> But that makes a big behavior difference, I'm afraid this won't become
> true.
I'm definitely with you on having the ability to restrict subvolume 
operations to privileged users, I just don't feel that the suggested 
methodology is enough by itself.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24453 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752271AbdC1Btb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 21:49:31 -0400
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Moritz Sichert <moritz+linux@sichert.me>,
        Andrei Borzenkov <arvidjaar@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
 <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
 <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
 <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
 <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
 <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <3b03ab4a-a0c2-27df-c6e4-c5f60fd4b5db@cn.fujitsu.com>
Date: Tue, 28 Mar 2017 09:49:24 +0800
MIME-Version: 1.0
In-Reply-To: <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/27/2017 08:01 PM, Austin S. Hemmelgarn wrote:
> On 2017-03-27 07:02, Moritz Sichert wrote:
>> Am 27.03.2017 um 05:46 schrieb Qu Wenruo:
>>>
>>>
>>> At 03/27/2017 11:26 AM, Andrei Borzenkov wrote:
>>>> 27.03.2017 03:39, Qu Wenruo пишет:
>>>>>
>>>>>
>>>>> At 03/26/2017 06:03 AM, Moritz Sichert wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I tried to configure qgroups on a btrfs filesystem but was really
>>>>>> surprised that when you snapshot a subvolume, the snapshot will
>>>>>> not be
>>>>>> assigned to the qgroup the subvolume was in.
>>>>>>
>>>>>> As an example consider the small terminal session in the
>>>>>> attachment: I
>>>>>> create a subvol A, assign it to qgroup 1/1 and set a limit of 5M on
>>>>>> that qgroup. Then I write a file into A and eventually get "disk
>>>>>> quota
>>>>>> exceeded". Then I create a snapshot of A and call it B. B will not be
>>>>>> assigned to 1/1 and writing a file into B confirms that no limits at
>>>>>> all are imposed for B.
>>>>>>
>>>>>> I feel like I must be missing something here. Considering that
>>>>>> creating a snapshot does not require root privileges this would mean
>>>>>> that any user can just circumvent any quota and therefore make them
>>>>>> useless.
>>>>>>
>>>>>> Is there a way to enforce quotas even when a user creates snapshots?
>>>>>>
>>>>>
>>>>> Yes, there is always method to attach the subvolume/snapshot to
>>>>> specified higher level qgroup.
>>>>>
>>>>> Just use "btrfs subvolume snapshot -i 1/1".
>>>>>
>>>>
>>>> This requires cooperation from whoever creates subvolume, while the
>>>> question was - is it possible to enforce it, without need for explicit
>>>> option/action when snapshot is created.
>>>>
>>>> To reiterate - if user omits "-i 1/1" (s)he "escapes" from quota
>>>> enforcement.
>>>
>>> What if user really want to create a subvolume assigned another group?
>>>
>>> You're implying a *policy* that if source subvolume belongs to a
>>> higher level qgroup, then snapshot created should also follow that
>>> higher level qgroup.
>>>
>>> However kernel should only provide *mechanisim*, not *policy*.
>>> And btrfs does it, it provides method to do it, whether to do or not
>>> is users responsibility.
>>>
>>> If you want to implement that policy, please do it in a higher level,
>>> something like SUSE snapper, not in kernel.
>>
>> The problem is, I can't enforce the policy because *every user* can
>> create snapshots. Even if I would restrict the btrfs executable so
>> that only root can execute it, this doesn't help. As using the ioctl
>> for btrfs is allowed for any user, they could just get the executable
>> from somewhere else.
> To reiterate and reinforce this:
> If it is not possible to enforce new subvolumes counting for their
> parent quota, and there is no option to prevent non-root (or
> non-CAP_SYS_ADMIN) users from creating new subvolumes, then BTRFS
> qgroups are useless on any system with shell access because a user can
> trivially escape their quota restrictions (or hide from accounting) by
> creating a new subvolume which is outside of their qgroup and storing
> data there.
>
> Ideally, there should be an option to disable user subvolume creation
> (it arguably should be the default, because of resource exhaustion
> issues, but that's a separate argument), and there should be an option
> in the kernel to force specific behavior.  Both cases are policy, but
> they are policy that can only be concretely enforced _by the kernel_.
>
>
The problem is, how should we treat subvolume.

Btrfs subvolume sits in the middle of directory and (logical) volume 
used in traditional stacked solution.

While we allow normal user to create/delete/modify dir as long as they 
follow access control, we require privilege to create/delete/modify volumes.

Developers chose to treat btrfs subvolume as dir, makes it quite easy to 
operate for normal use case, sacrificing qgroup limit which is not a 
major function (or even did not exist) at that time.

IIRC at the beginning time of btrfs, we don't have a full idea of use 
cases could be.
This is common, a lot of problems(even bad design) can only be found 
after enough feedback from end users.

Personally speaking, I prefer to restrict subvolume creation/deletion to 
privilege users only, and uses a daemon as a proxy to do such privilege 
operation.
So we can do better accounting/access control without bothering the kernel.

But that makes a big behavior difference, I'm afraid this won't become true.

Thanks,
Qu



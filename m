Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from thorus.sichert.me ([78.47.115.25]:43051 "EHLO thorus.sichert.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751652AbdC0LEL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 07:04:11 -0400
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>, linux-btrfs@vger.kernel.org
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
 <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
 <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
 <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
From: Moritz Sichert <moritz+linux@sichert.me>
Message-ID: <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
Date: Mon, 27 Mar 2017 13:02:24 +0200
MIME-Version: 1.0
In-Reply-To: <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 27.03.2017 um 05:46 schrieb Qu Wenruo:
> 
> 
> At 03/27/2017 11:26 AM, Andrei Borzenkov wrote:
>> 27.03.2017 03:39, Qu Wenruo пишет:
>>>
>>>
>>> At 03/26/2017 06:03 AM, Moritz Sichert wrote:
>>>> Hi,
>>>>
>>>> I tried to configure qgroups on a btrfs filesystem but was really
>>>> surprised that when you snapshot a subvolume, the snapshot will not be
>>>> assigned to the qgroup the subvolume was in.
>>>>
>>>> As an example consider the small terminal session in the attachment: I
>>>> create a subvol A, assign it to qgroup 1/1 and set a limit of 5M on
>>>> that qgroup. Then I write a file into A and eventually get "disk quota
>>>> exceeded". Then I create a snapshot of A and call it B. B will not be
>>>> assigned to 1/1 and writing a file into B confirms that no limits at
>>>> all are imposed for B.
>>>>
>>>> I feel like I must be missing something here. Considering that
>>>> creating a snapshot does not require root privileges this would mean
>>>> that any user can just circumvent any quota and therefore make them
>>>> useless.
>>>>
>>>> Is there a way to enforce quotas even when a user creates snapshots?
>>>>
>>>
>>> Yes, there is always method to attach the subvolume/snapshot to
>>> specified higher level qgroup.
>>>
>>> Just use "btrfs subvolume snapshot -i 1/1".
>>>
>>
>> This requires cooperation from whoever creates subvolume, while the
>> question was - is it possible to enforce it, without need for explicit
>> option/action when snapshot is created.
>>
>> To reiterate - if user omits "-i 1/1" (s)he "escapes" from quota
>> enforcement.
> 
> What if user really want to create a subvolume assigned another group?
> 
> You're implying a *policy* that if source subvolume belongs to a higher level qgroup, then snapshot created should also follow that higher level qgroup.
> 
> However kernel should only provide *mechanisim*, not *policy*.
> And btrfs does it, it provides method to do it, whether to do or not is users responsibility.
> 
> If you want to implement that policy, please do it in a higher level, something like SUSE snapper, not in kernel.

The problem is, I can't enforce the policy because *every user* can create snapshots. Even if I would restrict the btrfs executable so that only root can execute it, this doesn't help. As using the ioctl for btrfs is allowed for any user, they could just get the executable from somewhere else.


Moritz

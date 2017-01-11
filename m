Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43954 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934141AbdAKKzi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 05:55:38 -0500
Subject: Re: [RFC] Converging userspace and kernel code
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, David Sterba <dsterba@suse.com>
References: <512c15bf-3c4b-3b88-1106-a7d43386400f@suse.de>
 <1b68f099-53e8-1bc8-5ffc-2dd0b21a32ae@oracle.com>
 <09ea1fbd-74a1-d9f5-ba86-bc7c9118d49f@suse.de>
 <d0a11a09-322d-89bc-1a15-598f6a14e6be@oracle.com>
 <d0c2e05d-0b7a-a782-80b8-e1776e7b6fdb@suse.de>
 <2dfce804-d1ba-d9e4-e7b3-9c726ff5b49b@oracle.com>
 <4e6b1087-6c6b-c071-7e67-a41c7f146a29@suse.de>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <7e72a54b-8250-927c-2f94-6db8bd1d2300@oracle.com>
Date: Wed, 11 Jan 2017 18:58:27 +0800
MIME-Version: 1.0
In-Reply-To: <4e6b1087-6c6b-c071-7e67-a41c7f146a29@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




>>>>>> Goldwyn,
>>>>>>
>>>>>>  Could you add a list what functionality in btrfs-progs will
>>>>>>  be using the 'core'. ?
>>>>>
>>>>>
>>>>> There are too many to list. It would contain the algorithmic functions
>>>>> of btrfs which would be able to interact with both kernel and
>>>>> btrfs-progs.
>>>>
>>>>  I am getting confused. How about a few from the btrfs-progs ?
>>>>
>>>>
>>>
>>> Functions such as open_ctree(), or the set/get functions. The idea is to
>>> keep the codebase of this core component the same in btrfs-progs and
>>> kernel.
>>
>>  The btrfs-progs open_ctree() is used for the offline functionality
>>  such as fsck...
>>
>>> As an example, see how XFS have done using libxfs. Something around the
>>> same lines.
>>>
>>
>>  Does XFS progs access the disks directly (without going through the
>>  kernel) while kernel has mounted the disk ? If yes, how does it
>>  maintain the consistency ? Calling sync for the sake of read access
>>  by the progs, is not a good idea as it causes jitters in the steady
>>  state IOPS for the applications. I have investigated these concerns
>>  at the data centers earlier.
>>
>
> I think you are misunderstanding the effort. The effort is not to use
> the common code simultaneously between the kernel and the progs, but to
> keep a common *codebase*. Both kernel and userspace would provide the
> same functionality as it is currently, though independently in their own
> right. IOW, this is not a data sync but a codebase sync.
>
> The objective (besides others) is to have faster bug resolution, and
> better "transfer" of logic from kernel to user space and vice versa.
>
> xfsprogs, depending on the operation used acts on the disk directly
> without the kernel mounting it (say mkfs or xfs_repair), or disk being
> mounted (say xfs_growfs)

  Thanks for clarifying. Once we had progs and kernel simultaneous
  disk access. Its been fixed now. Good, that idea is not coming
  back with this.

  Indeed this a nice effort to have it organized.

  Just a note: fsck, which is a strong consumer of open_ctree() in
  the unmounted mode, should go obsolete per the plan. Its an area
  which needs some help though.

Thanks, Anand


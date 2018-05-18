Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:52124 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752470AbeERMgx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 08:36:53 -0400
Received: by mail-it0-f66.google.com with SMTP id n202-v6so12949705ita.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 05:36:53 -0700 (PDT)
Subject: Re: [PATCH v2 0/3] btrfs: add read mirror policy
To: Anand Jain <anand.jain@oracle.com>, Jeff Mahoney <jeffm@suse.com>,
        dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180516100359.7752-1-anand.jain@oracle.com>
 <20180516223523.GG6649@twin.jikos.cz>
 <0ff3604a-4d67-4421-560f-40a87fe4001d@oracle.com>
 <157ec7fa-e271-ed60-d22b-290db8122734@gmail.com>
 <854f0e3c-9bc5-768b-1f85-b0de79ee5a73@suse.com>
 <792af75a-ece2-4734-2b68-e940092e7407@oracle.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <51d2dd75-9b8f-6a74-b06a-4cf3e004440a@gmail.com>
Date: Fri, 18 May 2018 08:36:51 -0400
MIME-Version: 1.0
In-Reply-To: <792af75a-ece2-4734-2b68-e940092e7407@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-18 04:06, Anand Jain wrote:
> 
> 
> Thanks Austin and Jeff for the suggestion.
> 
> I am not particularly a fan of mount option either mainly because
> those options aren't persistent and host independent luns will
> have tough time to have them synchronize manually.
> 
> Properties are better as it is persistent. And we can apply this
> read_mirror_policy property on the fsid object.
> 
> But if we are talking about the properties then it can be stored
> as extended attributes or ondisk key value pair, and I am doubt
> if ondisk key value pair will get a nod.
> I can explore the extended attribute approach but appreciate more
> comments.

Hmm, thinking a bit further, might it be easier to just keep this as a 
mount option, and add something that lets you embed default mount 
options in the volume in a free-form manner?  Then, you could set this 
persistently there, and could specify any others you want too.  Doing 
that would also give very well defined behavior for exactly when changes 
would apply (the next time you mount or remount the volume), though 
handling of whether or not an option came from there or was specified on 
the command-line might be a bit complicated.
> 
> 
> On 05/17/2018 10:46 PM, Jeff Mahoney wrote:
>> On 5/17/18 8:25 AM, Austin S. Hemmelgarn wrote:
>>> On 2018-05-16 22:32, Anand Jain wrote:
>>>>
>>>>
>>>> On 05/17/2018 06:35 AM, David Sterba wrote:
>>>>> On Wed, May 16, 2018 at 06:03:56PM +0800, Anand Jain wrote:
>>>>>> Not yet ready for the integration. As I need to introduce
>>>>>> -o no_read_mirror_policy instead of -o read_mirror_policy=-<devid>
>>>>>
>>>>> Mount option is mostly likely not the right interface for setting such
>>>>> options, as usual.
>>>>
>>>>    I am ok to make it ioctl for the final. What do you think?
>>>>
>>>>
>>>>    But to reproduce the bug posted in
>>>>      Btrfs: fix the corruption by reading stale btree blocks
>>>>    It needs to be a mount option, as randomly the pid can
>>>>    still pick the disk specified in the mount option.
>>>>
>>> Personally, I'd vote for filesystem property (thus handled through the
>>> standard `btrfs property` command) that can be overridden by a mount
>>> option.  With that approach, no new tool (or change to an existing tool)
>>> would be needed, existing volumes could be converted to use it in a
>>> backwards compatible manner (old kernels would just ignore the
>>> property), and you could still have the behavior you want in tests (and
>>> in theory it could easily be adapted to be a per-subvolume setting if we
>>> ever get per-subvolume chunk profile support).
>>
>> Properties are a combination of interfaces presented through a single
>> command.  Although the kernel API would allow a direct-to-property
>> interface via the btrfs.* extended attributes, those are currently
>> limited to a single inode.  The label property is set via ioctl and
>> stored in the superblock.  The read-only subvolume property is also set
>> by ioctl but stored in the root flags.
>>
>> As it stands, every property is explicitly defined in the tools, so any
>> addition would require tools changes.  This is a bigger discussion,
>> though.  We *could* use the xattr interface to access per-root or
>> fs-global properties, but we'd need to define that interface.
>> btrfs_listxattr could get interesting, though I suppose we could
>> simplify it by only allowing the per-subvolume and fs-global operations
>> on root inodes.
>>
>> -Jeff
>>


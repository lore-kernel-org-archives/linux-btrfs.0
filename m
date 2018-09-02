Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57949 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725759AbeICEIV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Sep 2018 00:08:21 -0400
Subject: Re: [PATCH 0/4] Userspace support for FSID change
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1535531754-29774-1-git-send-email-nborisov@suse.com>
 <bb73d8d0-0d41-8884-05ad-0d9c76872232@gmx.com>
 <cd1572a2-883b-48ce-0212-3b35373d8ef3@suse.com>
 <801d560f-a5d2-9b55-62ad-315c4bf0573d@gmx.com>
 <0c52829e-ab3f-ac8d-84c4-ac580aebff38@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <593e0a51-e87c-bb68-1c79-a83803dd9a66@gmx.com>
Date: Mon, 3 Sep 2018 07:50:27 +0800
MIME-Version: 1.0
In-Reply-To: <0c52829e-ab3f-ac8d-84c4-ac580aebff38@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/2 下午5:56, Nikolay Borisov wrote:
> 
> 
> On 29.08.2018 15:47, Qu Wenruo wrote:
>>
>>
>> On 2018/8/29 下午8:33, Nikolay Borisov wrote:
>>>
>>>
>>> On 29.08.2018 15:09, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2018/8/29 下午4:35, Nikolay Borisov wrote:
>>>>> Here is the userspace tooling support for utilising the new metadata_uuid field, 
>>>>> enabling the change of fsid without having to rewrite every metadata block. This
>>>>> patchset consists of adding support for the new field to various tools and 
>>>>> files (Patch 1). The actual implementation of the new -m|-M options (which are 
>>>>> described in more detail in Patch 2). A new misc-tests testcasei (Patch 3) which
>>>>> exercises the new options and verifies certain invariants hold (these are also
>>>>> described in Patch2). Patch 4 is more or less copy of the kernel conuterpart 
>>>>> just reducing some duplication between btrfs_fs_info and btrfs_fs_devices 
>>>>> structures.
>>>>
>>>> So to my understand, now we have another layer of UUID.
>>>>
>>>> Before we have one fsid, both used in superblock and tree blocks.
>>>>
>>>> Now we have 2 fsid, the one used in tree blocks are kept the same, but
>>>> changed its name to metadata_uuid in superblock.
>>>> And superblock::fsid will become a new field, and although they are the
>>>> same at mkfs time, they could change several times during its operation.
>>>>
>>>> This indeed makes uuid change super fast, only needs to update all
>>>> superblocks of the fs, instead of all tree blocks.
>>>>
>>>> However I have one nitpick of the design. Unlike XFS, btrfs supports
>>>> multiple devices.
>>>> If we have a raid10 fs with 4 devices, and it has already gone through
>>>> several UUID change (so its metadata uuid is already different from fsid).
>>>>
>>>> And during another UUID change procedure, we lost power while only
>>>> updated 2 super blocks, what will happen for kernel device assembly?
>>>>
>>>> (Although considering how fast the UUID change would happen, such case
>>>> should be super niche)
>>>
>>> Then I guess you will be fucked. I'm all ears for suggestion how to
>>> rectify this without skyrocketing the complexity. The current UUID
>>> rewrite method sets a flag int he superblock that FSID change is in
>>> progress and clears it once every metadatablock has been rewritten. I
>>> can piggyback on this mechanism but I'm not sure it provides 100%
>>> guarantee. Because by the some token you can set this flag, start
>>> writing the super blocks then lose power and then only some of the
>>> superblocks could have this flag set so we back at square 1.
>>
>> Well, forget it, considering how fast the new method is, such case
>> should be really rare.
>>
>>>
>>>>
>>>>>
>>>>> The intended usecase of this feature is to give the sysadmin the ability to 
>>>>> create copies of filesystesm, change their uuid quickly and mount them alongside
>>>>> the original filesystem for, say, forensic purposes. 
>>>>>
>>>>> One thing which still hasn't been set in stone is whether the new options 
>>>>> will remain as -m|-M or whether they should subsume the current -u|-U - from 
>>>>> the point of view of users nothing should change.
>>>>
>>>> Well, user would be surprised by how fast the new -m is, thus there is
>>>> still something changed :)
>>>>
>>>> I prefer to subsume current -u/-U, and use the new one if the incompat
>>>> feature is already set. Or fall back to original behavior.
>>>>
>>>> But I'm not a fan of using INCOMPAT flags as an indicator of changed
>>>> fsid/metadata uuid.
>>>> INCOMPAT feature should not change so easily nor acts as an indicator.
>>>>
>>>> That's to say, the flag should only be set at mkfs time, and then never
>>>> change unlike the 2nd patch (I don't even like btrfstune to change
>>>> incompat flags).
>>>>
>>>> E.g.
>>>> mkfs.btrfs -O metadata_uuid <device>, then we could use the new way to
>>>> change fsid without touching metadata uuid.
>>>> Or we could only use the old method.
>>>
>>> I disagree, I don't see any benefit in this but only added complexity.
>>> Can you elaborate more ?
>>
>> Well, the incompat feature is really introducing some incompatible
>> on-disk format change.
>> So if you're introducing the new metadata_uuid field, no matter if it
>> differs from fsid or not, it's a new field, and the incompat flag should
>> be set.
>>
>> To me, older kernel could recognize the new format when fsid matches
>> metadata uuid (since there in your current patchset, such case will not
>> have incompat flag set) is a little dangerous.
>>
>> What will happen if such old kernel/btrfs-progs tries to change fsid?
>> Older btrfs-progs doesn't know there is a new field, it will not touch
>> the metadata uuid field, just changing the fsid field along with all
>> tree blocks.
>>
>> This will cause a fs whose fsid doesn't match metadata uuid and has no
>> incompat flag set. This is definitely leading to compatibility problem.
> 
> Nope, when both fsid/metadata_uuid match and the INCOMPAT flag is not
> set then on-disk we never save the metadata_uuid value and this value is
> set only in-memory, the only thing on-disk is fsid.

In my opinion, this is already more complex than forced new INCOMPAT
flag all the time.

You're already using 4 different branches to workaround the
compatibility, which already looks more complex than all time INCOMPAT flag.

And to me, I didn't really think using all time INCOMPAT flag is a
problem at all.
If someone really want to use it, btrfstune could be changed to add
METADATA_UUID flag easily for old fs.
And if the feature is well received we could just make this feature as
default later.

Thanks,
Qu
> In this case if one
> decides to rewrite the fsuid then this is fine - btrfs-progs disallow
> using -m|-M when fsid rewrite is in progress. So when the fsid/metadata
> is not set to old progs the kernel continue working as-is. When it's
> changed then the incompat flags will prevent us from doing harmful
> modifications.



> 
>>
>> So we need to follow the incompat flags rule strictly, if on-disk format
>> is changed, we need the new incompat flag.
>>
>> Thanks,
>> Qu
>>>
>>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>> So this is something which 
>>>>> I'd like to hear from the community. Of course the alternative of rewriting 
>>>>> the metadata blocks will be assigne new options - perhaps -m|M ?
>>>>>
>>>>> I've tested this with multiple xfstest runs with the new tools installed as 
>>>>> well as running btrfs-progs test and have observed no regressions. 
>>>>>
>>>>> Nikolay Borisov (4):
>>>>>   btrfs-progs: Add support for metadata_uuid field.
>>>>>   btrfstune: Add support for changing the user uuid
>>>>>   btrfs-progs: tests: Add tests for changing fsid feature
>>>>>   btrfs-progs: Remove fsid/metdata_uuid fields from fs_info
>>>>>
>>>>>  btrfstune.c                                | 174 ++++++++++++++++++++++++-----
>>>>>  check/main.c                               |   2 +-
>>>>>  chunk-recover.c                            |  17 ++-
>>>>>  cmds-filesystem.c                          |   2 +
>>>>>  cmds-inspect-dump-super.c                  |  22 +++-
>>>>>  convert/common.c                           |   2 +
>>>>>  ctree.c                                    |  15 +--
>>>>>  ctree.h                                    |   8 +-
>>>>>  disk-io.c                                  |  62 ++++++++--
>>>>>  image/main.c                               |  25 +++--
>>>>>  tests/misc-tests/033-metadata-uuid/test.sh | 137 +++++++++++++++++++++++
>>>>>  volumes.c                                  |  37 ++++--
>>>>>  volumes.h                                  |   1 +
>>>>>  13 files changed, 431 insertions(+), 73 deletions(-)
>>>>>  create mode 100755 tests/misc-tests/033-metadata-uuid/test.sh
>>>>>
>>>>

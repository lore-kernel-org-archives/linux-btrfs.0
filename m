Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57482 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755406AbeAHF6n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 00:58:43 -0500
Subject: Re: [PATCH v2 1/2] btrfs: add support for SUPER_FLAG_CHANGING_FSID in
 btrfs.ko
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <20180108030512.22344-2-anand.jain@oracle.com>
 <20180108050409.727-1-anand.jain@oracle.com>
 <dffaa3c8-30d9-2ec0-4fac-3bb6457c7136@gmx.com>
 <dff5d2d7-ca88-393d-b33f-12368042358d@oracle.com>
 <23789f5a-e572-a1ae-52ae-263fc2fc3aeb@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <939c1f2d-1858-7b8e-9ad8-3e23937550d5@oracle.com>
Date: Mon, 8 Jan 2018 13:58:49 +0800
MIME-Version: 1.0
In-Reply-To: <23789f5a-e572-a1ae-52ae-263fc2fc3aeb@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/08/2018 01:25 PM, Qu Wenruo wrote:
> 
> 
> On 2018年01月08日 13:13, Anand Jain wrote:
>>
>>
>> On 01/08/2018 01:08 PM, Qu Wenruo wrote:
>>>
>>>
>>> On 2018年01月08日 13:04, Anand Jain wrote:
>>>> Userland sets SUPER_FLAG_CHANGING_FSID and resets it only when changing
>>>> fsid is complete. Its not a good idea to mount the device anything in
>>>> between, so this patch fails the mount if SB SUPER_FLAG_CHANGING_FSID
>>>> is set.
>>>>
>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>>     cc: wqu@suse.com
>>>> ---
>>>> v1->v2: Oops. Fix cut and paste error, remove ~. My bad.
>>>>
>>>>    fs/btrfs/disk-io.c              | 7 ++++++-
>>>>    include/uapi/linux/btrfs_tree.h | 1 +
>>>>    2 files changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index a69e5944dc08..0dd215258ff9 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -61,7 +61,8 @@
>>>>                     BTRFS_HEADER_FLAG_RELOC |\
>>>>                     BTRFS_SUPER_FLAG_ERROR |\
>>>>                     BTRFS_SUPER_FLAG_SEEDING |\
>>>> -                 BTRFS_SUPER_FLAG_METADUMP)
>>>> +                 BTRFS_SUPER_FLAG_METADUMP |\
>>>> +                 BTRFS_SUPER_FLAG_CHANGING_FSID)
>>>
>>> Still the same problem here.
>>>
>>> Since that super flag is excluded in btrfs_check_super_valid(), I didn't
>>> see any meaning including it into BTRFS_SUPER_FLAG_SUPP, and it will
>>> confuse later BTRFS_SUPER_FLAG_SUPP users.
>>
>>
>>   Anyway BTRFS_SUPER_FLAG_SUPP as such does not stop to mount, it
>>   just warns. So when there is a new flag which is not supported
>>   we get this warning. As in the case with BTRFS_SUPER_FLAG_METADUMP_V2.
>>   BTRFS_SUPER_FLAG_METADUMP_V2 in kernel is defined but not supported.
>>   However since we are supporting BTRFS_SUPER_FLAG_CHANGING_FSID, so
>>   adding to BTRFS_SUPER_FLAG_SUPP make sense to me. ?
> 
> We still refuse to mount the fs if CHANGING_FSID is set, which I believe
> should be called "unsupported"
 >
> On the other hand it would be better to include METADUMP_V2 into SUPP,
> as we allow it to be mounted and now kernel knows that flag, output a
> warning doesn't seems necessary now.
> 
> It would be even better to change the later SUPP flags checks, into
> something not only output some meaningless numeric flags, but also
> output the human readable flags if it's recognized but unsupported. (For
> CHANGIND_FSID).

  Originally [1] looks like there isn't any design specific reason not to
  fail the mount (which I didn't want to alter to fail) but just to warn.
  Will change it to fail.

[1]
  commit 319e4d0661e5323c9f9945f0f8fb5905e5fe74c3
     btrfs: Enhance super validation check

Thanks, Anand

> Thanks,
> Qu
> 
>>
>> Thanks, Anand
>>
>>
>>> Thanks,
>>> Qu
>>>
>>>>      static const struct extent_io_ops btree_extent_io_ops;
>>>>    static void end_workqueue_fn(struct btrfs_work *work);
>>>> @@ -3906,6 +3907,10 @@ static int btrfs_check_super_valid(struct
>>>> btrfs_fs_info *fs_info)
>>>>            btrfs_err(fs_info, "no valid FS found");
>>>>            ret = -EINVAL;
>>>>        }
>>>> +    if (btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_CHANGING_FSID) {
>>>> +        btrfs_err(fs_info, "SUPER_FLAG_CHANGING_FSID is set");
>>>> +        ret = -EINVAL;
>>>> +    }
>>>>        if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP)
>>>>            btrfs_warn(fs_info, "unrecognized super flag: %llu",
>>>>                    btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
>>>> diff --git a/include/uapi/linux/btrfs_tree.h
>>>> b/include/uapi/linux/btrfs_tree.h
>>>> index 38ab0e06259a..aff1356c2bb8 100644
>>>> --- a/include/uapi/linux/btrfs_tree.h
>>>> +++ b/include/uapi/linux/btrfs_tree.h
>>>> @@ -457,6 +457,7 @@ struct btrfs_free_space_header {
>>>>    #define BTRFS_SUPER_FLAG_SEEDING    (1ULL << 32)
>>>>    #define BTRFS_SUPER_FLAG_METADUMP    (1ULL << 33)
>>>>    #define BTRFS_SUPER_FLAG_METADUMP_V2    (1ULL << 34)
>>>> +#define BTRFS_SUPER_FLAG_CHANGING_FSID    (1ULL << 35)
>>>>        /*
>>>>
>>>
> 

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62866 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbaAWXog (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 18:44:36 -0500
Message-ID: <52E1A95D.9000903@fb.com>
Date: Thu, 23 Jan 2014 18:44:29 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix qgroup rescan to work with skinny metadata
References: <1390513554-32732-1-git-send-email-jbacik@fb.com> <CAL3q7H7WGFpYC9AuyhFPhNgudyUAmVA3mgGaqVY+Ay=Z9=0_2Q@mail.gmail.com>
In-Reply-To: <CAL3q7H7WGFpYC9AuyhFPhNgudyUAmVA3mgGaqVY+Ay=Z9=0_2Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/23/2014 06:42 PM, Filipe David Manana wrote:
> On Thu, Jan 23, 2014 at 9:45 PM, Josef Bacik <jbacik@fb.com> wrote:
>> Could have sworn I fixed this before but apparently not.  This makes us pass
>> btrfs/022 with skinny metadata enabled.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>   fs/btrfs/qgroup.c | 18 +++++++++++++-----
>>   1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index d22e0a1..7d04026 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1897,9 +1897,17 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>>          mutex_unlock(&fs_info->qgroup_rescan_lock);
>>
>>          for (; slot < btrfs_header_nritems(scratch_leaf); ++slot) {
>> +               u64 num_bytes;
>> +
>>                  btrfs_item_key_to_cpu(scratch_leaf, &found, slot);
>> -               if (found.type != BTRFS_EXTENT_ITEM_KEY)
>> +               if (found.type != BTRFS_EXTENT_ITEM_KEY ||
>> +                   found.type != BTRFS_METADATA_ITEM_KEY)
>>                          continue;
> Hi Josef,
>
> Shouldn't it be && instead of || ?
>
Yes it should, thanks,

Josef

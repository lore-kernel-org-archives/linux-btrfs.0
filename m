Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50217 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933343AbcIVNj3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 09:39:29 -0400
Subject: Re: [PATCH 4/4] writeback: introduce super_operations->write_metadata
To: Jan Kara <jack@suse.cz>
References: <1474405068-27841-1-git-send-email-jbacik@fb.com>
 <1474405068-27841-5-git-send-email-jbacik@fb.com>
 <20160922114828.GN2834@quack2.suse.cz>
CC: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <jack@suse.com>, <viro@zeniv.linux.org.uk>,
        <dchinner@redhat.com>, <hch@lst.de>, <linux-mm@kvack.org>,
        <hannes@cmpxchg.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <3dd716eb-dc3e-991c-ac97-a0245890383c@fb.com>
Date: Thu, 22 Sep 2016 09:36:53 -0400
MIME-Version: 1.0
In-Reply-To: <20160922114828.GN2834@quack2.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/2016 07:48 AM, Jan Kara wrote:
> On Tue 20-09-16 16:57:48, Josef Bacik wrote:
>> Now that we have metadata counters in the VM, we need to provide a way to kick
>> writeback on dirty metadata.  Introduce super_operations->write_metadata.  This
>> allows file systems to deal with writing back any dirty metadata we need based
>> on the writeback needs of the system.  Since there is no inode to key off of we
>> need a list in the bdi for dirty super blocks to be added.  From there we can
>> find any dirty sb's on the bdi we are currently doing writeback on and call into
>> their ->write_metadata callback.
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>  fs/fs-writeback.c                | 72 ++++++++++++++++++++++++++++++++++++----
>>  fs/super.c                       |  7 ++++
>>  include/linux/backing-dev-defs.h |  2 ++
>>  include/linux/fs.h               |  4 +++
>>  mm/backing-dev.c                 |  2 ++
>>  5 files changed, 81 insertions(+), 6 deletions(-)
>>
>
> ...
>
>> +	if (!done && sb->s_op->write_metadata) {
>> +		spin_unlock(&wb->list_lock);
>> +		wrote += writeback_sb_metadata(sb, wb, work);
>> +		spin_unlock(&wb->list_lock);
> 		^^^
> 		spin_lock();
>
> Otherwise the patch looks good to me. So feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
> after fixing the above.
>

Yup I hit this as soon as I started testing so I'll go ahead and add your 
reviewed-by.  I'll resend the whole series after these changes have actually 
gone through some testing since it seems you are happy with the overall 
direction.  Thanks,

Josef


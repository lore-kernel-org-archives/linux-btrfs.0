Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1644 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750970AbbLJBYp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 20:24:45 -0500
Subject: Re: [PATCH v2] btrfs: Introduce new mount option to disable tree log
 replay
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <1449555033-25075-1-git-send-email-quwenruo@cn.fujitsu.com>
 <2728328.xh2dYaTluQ@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5668D444.9010808@cn.fujitsu.com>
Date: Thu, 10 Dec 2015 09:24:20 +0800
MIME-Version: 1.0
In-Reply-To: <2728328.xh2dYaTluQ@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chandan Rajendra wrote on 2015/12/08 15:36 +0530:
> On Tuesday 08 Dec 2015 14:10:33 Qu Wenruo wrote:
>> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
>> option to get real readonly mount, like "norecovery" in ext* and xfs.
>>
>> Since the new parse_options() need to check new flags at remount time,
>> so add a new parameter for parse_options().
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> v2:
>>    Make RO check mandatory for btrfs_parse_options().
>>    Add btrfs_show_options() support for nologreplay.
>>
>>    Document for btrfs-mount(5) will follow after the patch being merged.
>> ---
>>   Documentation/filesystems/btrfs.txt |  7 +++++++
>>   fs/btrfs/ctree.h                    |  4 +++-
>>   fs/btrfs/disk-io.c                  |  7 ++++---
>>   fs/btrfs/super.c                    | 29 +++++++++++++++++++++++++----
>>   4 files changed, 39 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/filesystems/btrfs.txt
>> b/Documentation/filesystems/btrfs.txt index c772b47..7ad5b93 100644
>> --- a/Documentation/filesystems/btrfs.txt
>> +++ b/Documentation/filesystems/btrfs.txt
>> @@ -168,6 +168,13 @@ Options with (*) are default options and will not show
>> in the mount options. notreelog
>>   	Enable/disable the tree logging used for fsync and O_SYNC writes.
>>
>> +  nologreplay
>> +	Disable the log tree replay at mount time to prevent devices get
>> +	modified. Must be use with 'ro' mount option.
>> +	A filesystem mounted with the 'nologreplay' option cannot
>> +	transition to a read-write mount via remount,rw - the filesystem
>> +	must be unmounted and remounted if read-write access is desired.
>> +
>
> May be the following is slightly better ...
>
> Disable the log tree replay at mount time to prevent filesystem from getting
> modified. Must be used with 'ro' mount option.  A filesystem mounted with the
> 'nologreplay' option cannot transition to a read-write mount via remount,rw -
> the filesystem must be unmounted and mounted back again if read-write access
> is desired.

Thanks for the review and advice.

Since I'm not a native English speaker, I'll follow your advice.
(Yeah, remount in my patch is confusing.)

I'll update it to v3 with Document update only

Thank,
Qu
>
> Aside from above, everything else looks good to me.
>
> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>



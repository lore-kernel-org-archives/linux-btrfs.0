Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53686 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030532AbeBNOwA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 09:52:00 -0500
Subject: Re: [PATCH v2] btrfs: fix endianness compatibility during the SB RW
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
References: <20180212153749.19705-1-anand.jain@oracle.com>
 <20180213030046.14093-1-anand.jain@oracle.com>
 <358780ca-cb85-4de1-f849-3a642d3fc2c7@gmx.com>
 <500c44b5-0c99-100f-6a70-a79d3ad8a388@oracle.com>
 <20180213175510.GB3003@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5caed65c-79b1-5e12-78a0-47cffb220ca0@oracle.com>
Date: Wed, 14 Feb 2018 22:53:19 +0800
MIME-Version: 1.0
In-Reply-To: <20180213175510.GB3003@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/14/2018 01:55 AM, David Sterba wrote:
> On Tue, Feb 13, 2018 at 06:27:13PM +0800, Anand Jain wrote:
>> On 02/13/2018 05:01 PM, Qu Wenruo wrote:
>>> On 2018年02月13日 11:00, Anand Jain wrote:
>>>> Fixes the endianness bug in the fs_info::super_copy by using its
>>>> btrfs_set_super...() function to set values in the SB, as these
>>>> functions manage the endianness compatibility nicely.
>>>>
>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>
>>> Also went through all btrfs_super_block SETGET functions, greping using
>>> \><member name>, seems that there are still some left here:
>>>
>>> fs/btrfs/sysfs.c:
>>> In both btrfs_sectorsize_show() and btrfs_clone_alignment_show():
>>> 	return snprintf(buf, PAGE_SIZE, "%u\n",
>>> 			fs_info->super_copy->sectorsize);
>>>
>>> In btrfs_nodesize_show():
>>> 	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->nodesize);

  Thinking again on the printf they are fine without the endianness
  functions, because it is printing the values from the memory to
  buf/stdout, which was previously read from the disk (which
  possibly written by the opposite endianness system). Here, there
  is no endianness changes that will be required for it to be written
  out using printf.

>>    Oh. Thanks. Will fix. Maybe it's a good idea to add sysfs fixes
>>    into a new patch.

> I'd prefer a single patch as it fixes the same problem for one
> structure, the context of use is not that important to justify 2
> patches.

  Agree.

> I went through the possible uses of superblock again and did not find
> anything else than the update_super_roots and sysfs read handlers. There
> are some direct uses of super block members, like label, sys_array, uuid
> that are passed unconverted and must be accessed via the set/get
> helpers.

  AFAIK byte arrays btrfs_super_block::(label, sys_chunk_array, fsid)
  are not affected by endianness, as memory access for the array starts
  from the zero in both endianness. And the lowest granularity affected
  by the endianness is a byte.

> In some places the superblock is put to a temporary variable so simple
> grep may miss these.
> 
>>> And what about cc this to stable kernel?
>>> IIRC it's a very critical problem for btrfs.
> 
> If the filesystem is always used on a same endianity host, this will not
> be a problem. Moving between opposite endianity hosts will report bogus
> numbers in sysfs and the backup root would not be restored correctly.
> 
> As this is not common, I'd rate thats as a bugfix for stable, but "only"
> a serious one.

  agree.

>>> Maybe cc: stable@vger.kernel.org # v3.2+?
>>
>>    Thanks for the suggestion. Will do. Any idea what if the patch which
>>    applied on mainline ends up conflict on LTS, so write a separate patch
>>    to stable?
> 
> If the patch does not apply to some older stable branch, all involved
> people get a mail from stable team and have an opportunity to send an
> updated version of the patch.
> 
> Regarding the long-term branches, I would consider 4.4 and up. Anything
> older is a plus but fixing merge conflicts is more likely there so I
> think the respective maintainers would either fix it by themselves or
> ask for help.

  ok.

  Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

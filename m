Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39902 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbcJGPO5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Oct 2016 11:14:57 -0400
Subject: Re: [PATCH] btrfs: relocation: Fix NULL pointer access and leaking
 qgroups in btrfs_recover_relocation
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20161006080337.31691-1-quwenruo@cn.fujitsu.com>
 <4bdf1336-dc97-4dcb-1095-a2545419e95a@suse.de>
 <82aef874-2fc1-15fc-8e50-04c087051489@cn.fujitsu.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <87fed166-76a0-1e1c-c305-2251fcd2a37d@suse.de>
Date: Fri, 7 Oct 2016 10:14:52 -0500
MIME-Version: 1.0
In-Reply-To: <82aef874-2fc1-15fc-8e50-04c087051489@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/06/2016 09:32 PM, Qu Wenruo wrote:
> 
> 
> At 10/07/2016 02:00 AM, Goldwyn Rodrigues wrote:
>> Hi Qu,
>>
>> On 10/06/2016 03:03 AM, Qu Wenruo wrote:
>>> We fixed balance qgroup leaking by introducing
>>> qgroup_fix_relocated_data_extents(), but it only covers normal balance
>>> routine well.
>>>
>>> For case btrfs_recover_relocation() routine, since rc->stage or
>>> rc->data_inode are not initialized, we either skip
>>> qgroup_fix_relocated_data_extents() or just cause NULL pointer access.
>>>
>>> Since we skip qgroup_fix_relocated_data_extents() in
>>> btrfs_recover_relocation(), we will still leak qgroup numbers for that
>>> routine.
>>>
>>> In the fix, we won't use data_inode any longer, as at the timing of the
>>> qgroup fix, noone will modify data_reloc tree any longer, so path
>>> locking should be good enough.
>>>
>>> And add check against rc->merge_reloc_tree, so we can detect if we are
>>> in btrfs_recover_relocation() routine and continue qgroup fix.
>>
>> While testing this patch, I realized the original problem of qgroup
>> values being incorrect after a balance, has returned... or probably was
>> not solved completely. I tried it with the shell script sent sometime
>> back. The script fails when I checkout fix df2c95f33e0a2 as well.
>>
>> I remember it did not appear when I tested it last, so it is possible
>> that some other change has affected this.
>>
>> Would recommend to hold off this until the balance issue is not
>> completely fixed.
>>
>> For reference, the test script is:
>>
>> #!/bin/bash -x
>>
>> MNT="/mnt"
>> DEV="/dev/vdb"
>>
>> mkfs.btrfs -f $DEV
>> mount -t btrfs $DEV $MNT
>>
>> mkdir $MNT/snaps
>> echo "populate $MNT with some data"
>> #cp -a /usr/share/fonts $MNT/
>> cp -a /usr/ $MNT/ &
>> for i in `seq -w 0 8`; do
>>         S="$MNT/snaps/snap$i"
>>         echo "create and populate $S"
>>         btrfs su snap $MNT $S;
>>         cp -a /boot $S;
>> done;
>>
>> #let the cp from above finish
>> wait
>>
>> btrfs fi sync $MNT
>>
>> btrfs quota enable $MNT
>> btrfs quota rescan -w $MNT
>> btrfs qg show $MNT
>>
>> umount $MNT
>>
>> mount -t btrfs $DEV $MNT
>>
>>
>> time btrfs balance start --full-balance $MNT
>>
>> umount $MNT
>>
>> btrfsck $DEV
>>
>>
> 
> Thanks for the report.
> 
> Yes, the script can reproduce the problem, almost 100% possibility.
> 
> But it also takes a long time to run.(Partly because of the slow
> find_parent_nodes function call).
> 
> I tried to simplify it by using inline extent to bumping the tree level
> and use small file extents to reduce IO.
> But no good reproducer yet.
> 
> Did you remember which kernel version you tested the original fix?
> Maybe it could provide some clue.
> 

They work for 4.7.0 for sure. I know they work for a couple of 4.8-rc
versions as well. I haven't got down to bisecting them as yet, but now
it seems that another patch is affecting these.

-- 
-- 
Goldwyn

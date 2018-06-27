Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:36891 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932549AbeF0I5r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 04:57:47 -0400
Subject: Re: Enabling quota may not correctly rescan on 4.17
To: Nikolay Borisov <nborisov@suse.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
 <bceb24d5-fa2f-b019-fc60-146fa7a62844@gmx.com>
 <9f158a77-fb11-1b77-d67a-e64f42e67e51@jp.fujitsu.com>
 <4de99ad4-bde4-9148-1e59-d1bae0a93bdb@gmx.com>
 <187a6671-9a80-bcbb-56d2-1d3ea90b905b@gmx.com>
 <40d77148-d3e7-265b-bf5c-e8a5ea7ead6b@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d2f5334e-1296-97fc-e125-e9087a576fe0@gmx.com>
Date: Wed, 27 Jun 2018 16:57:34 +0800
MIME-Version: 1.0
In-Reply-To: <40d77148-d3e7-265b-bf5c-e8a5ea7ead6b@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月27日 16:47, Nikolay Borisov wrote:
> 
> 
> On 27.06.2018 11:38, Qu Wenruo wrote:
>>
>>
>> On 2018年06月27日 16:34, Qu Wenruo wrote:
>>>
>>>
>>> On 2018年06月27日 16:25, Misono Tomohiro wrote:
>>>> On 2018/06/27 17:10, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> On 2018年06月26日 14:00, Misono Tomohiro wrote:
>>>>>> Hello Nikolay,
>>>>>>
>>>>>> I noticed that commit 5d23515be669 ("btrfs: Move qgroup rescan
>>>>>> on quota enable to btrfs_quota_enable") in 4.17 sometimes causes
>>>>>> to fail correctly rescanning quota when quota is enabled.
>>>>>>
>>>>>> Simple reproducer:
>>>>>>
>>>>>> $ mkfs.btrfs -f $DEV
>>>>>> $ mount $DEV /mnt
>>>>>> $ dd if=/dev/urandom of=/mnt/file bs=1000 count=1000
>>>>>> $ btrfs quota enbale /mnt
>>>>>> $ umount /mnt
>>>>>> $ btrfs check $DEV
>>>>>> ...
>>>>>> checking quota groups
>>>>>> Counts for qgroup id: 0/5 are different
>>>>>> our:            referenced 1019904 referenced compressed 1019904
>>>>>> disk:           referenced 16384 referenced compressed 16384
>>>>>> diff:           referenced 1003520 referenced compressed 1003520
>>>>>> our:            exclusive 1019904 exclusive compressed 1019904
>>>>>> disk:           exclusive 16384 exclusive compressed 16384
>>>>>> diff:           exclusive 1003520 exclusive compressed 1003520
>>>>>> found 1413120 bytes used, error(s) found
>>>>>> ...
>>>>>>
>>>>>> This can be also observed in btrfs/114. (Note that progs < 4.17
>>>>>> returns error code 0 even if quota is not consistency and therefore
>>>>>> test will incorrectly pass.)
>>>>>
>>>>> BTW, would you please try to dump the quota tree for such mismatch case?
>>>>>
>>>>> It could be a btrfs-progs bug which it should skip quota checking if it
>>>>> found the quota status item has RESCAN flag.
>>>>
>>>> Yes, this is what I see after running btrfs/114 (/dev/sdh1 is scratch dev):
>>>>
>>>> $ sudo btrfs check -Q /dev/sdh1
>>>> Checking filesystem on /dev/sdh1
>>>> UUID: d07f6028-0ae7-40d4-ac45-01a4505ddcfb
>>>> Print quota groups for /dev/sdh1
>>>> UUID: d07f6028-0ae7-40d4-ac45-01a4505ddcfb
>>>> Counts for qgroup id: 0/5 are different
>>>> our:            referenced 170999808 referenced compressed 170999808
>>>> disk:           referenced 16384 referenced compressed 16384
>>>> diff:           referenced 170983424 referenced compressed 170983424
>>>> our:            exclusive 170999808 exclusive compressed 170999808
>>>> disk:           exclusive 16384 exclusive compressed 16384
>>>> diff:           exclusive 170983424 exclusive compressed 170983424
>>>>
>>>>
>>>> $ sudo btrfs inspect-internal dump-tree -t quota /dev/sdh1
>>>> btrfs-progs v4.17
>>>> quota tree key (QUOTA_TREE ROOT_ITEM 0)
>>>> leaf 213958656 items 3 free space 16096 generation 9 owner QUOTA_TREE
>>>> leaf 213958656 flags 0x1(WRITTEN) backref revision 1
>>>> fs uuid d07f6028-0ae7-40d4-ac45-01a4505ddcfb
>>>> chunk uuid 78d753d0-eeb7-4c3e-b825-b6c2c5de5c7a
>>>>         item 0 key (0 QGROUP_STATUS 0) itemoff 16251 itemsize 32
>>>>                 version 1 generation 9 flags ON scan 30572545
>>>
>>> Scan is not -1 and flags is only ON, without RESCAN.
>>>
>>>>         item 1 key (0 QGROUP_INFO 0/5) itemoff 16211 itemsize 40
>>>>                 generation 7
>>>>                 referenced 16384 referenced_compressed 16384
>>>>                 exclusive 16384 exclusive_compressed 16384
>>>>         item 2 key (0 QGROUP_LIMIT 0/5) itemoff 16171 itemsize 40
>>>>                 flags 0
>>>>                 max_referenced 0 max_exclusive 0
>>>>                 rsv_referenced 0 rsv_exclusive 0
>>>> total bytes 26843545600
>>>> bytes used 171769856
>>>> uuid d07f6028-0ae7-40d4-ac45-01a4505ddcfb
>>>>
>>>>
>>>> And if I mount+rescan again:
>>>>
>>>> $ sudo mount /dev/sdh1 /mnt
>>>> $ sudo btrfs quota rescan -w /mnt
>>>> $ sudo umount /mnt
>>>>
>>>> $ sudo btrfs check -Q /dev/sdh1
>>>> Checking filesystem on /dev/sdh1
>>>> UUID: d07f6028-0ae7-40d4-ac45-01a4505ddcfb
>>>> Print quota groups for /dev/sdh1
>>>> UUID: d07f6028-0ae7-40d4-ac45-01a4505ddcfb
>>>> Counts for qgroup id: 0/5
>>>> our:            referenced 170999808 referenced compressed 170999808
>>>> disk:           referenced 170999808 referenced compressed 170999808
>>>> our:            exclusive 170999808 exclusive compressed 170999808
>>>> disk:           exclusive 170999808 exclusive compressed 170999808
>>>>
>>>> $ sudo btrfs inspect-internal dump-tree -t quota /dev/sdh1
>>>> btrfs-progs v4.17
>>>> quota tree key (QUOTA_TREE ROOT_ITEM 0)
>>>> leaf 31309824 items 3 free space 16096 generation 13 owner QUOTA_TREE
>>>> leaf 31309824 flags 0x1(WRITTEN) backref revision 1
>>>> fs uuid d07f6028-0ae7-40d4-ac45-01a4505ddcfb
>>>> chunk uuid 78d753d0-eeb7-4c3e-b825-b6c2c5de5c7a
>>>>         item 0 key (0 QGROUP_STATUS 0) itemoff 16251 itemsize 32
>>>>                 version 1 generation 13 flags ON scan 213827585
>>>
>>> Still doesn't look good.
>>>
>>> In v4.17.2 (sorry, just checking the behavior on my host), after correct
>>> rescan + sync, if we don't have RESCAN flag, we should have scan set to -1.
>>>
>>> While in in v4.18-rc1, it doesn't reset the scan progress to -1 after
>>> finished.
>>> And just as explained in previous reply, if later dirty extents are
>>> after scan progress, it won't be accounted.
>>> So this explains everything.
>>>
>>> We just need to find why scan progress is not set correctly after rescan
>>> is finished.
>>
>> OK, in fact this is my fault, not Nikolay's.
>> My bad. Sorry, Nikolay.
>>
>> It's caused by my commit, ff3d27a048d9 ("btrfs: qgroup: Finish rescan
>> when hit the last leaf of extent tree").
>>
>> Where I added another exit path for qgroup_rescan_leaf(), and in that
>> case it doesn't set the progress.
>> I'll send out the fix soon.
> 
> 
> I'm confused why I'm not hitting this on David's misc-next branch.

I think btrfs/114 may not be the best case to hit it.
The best way to hit the bug should be some modified version of
btrfs/017, extra write after rescan should trigger it.
(My new test case will go that way)

> Also your commit landed on 4.18, meaning Misono shouldn't have observed
> the issue on 4.17.

Yep, but the difference behavior of quota status item looks pretty
convincing (along with the code), and no possibility is involved, so I
prefer to believe my observation.

Thanks,
Qu

> Misono, did you reproduce the issue on 4.17 if not
> you might want to revise your bisection process since if my patch was to
> blame it should have failed on 4.17 whereas Qu's patch landed in 4.18 so
> it should have been fairly obvious if this was introduced in 4.17 or 4.18.
> 
>>
>> Thanks,
>> Qu
>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>>         item 1 key (0 QGROUP_INFO 0/5) itemoff 16211 itemsize 40
>>>>                 generation 11
>>>>                 referenced 170999808 referenced_compressed 170999808
>>>>                 exclusive 170999808 exclusive_compressed 170999808
>>>>         item 2 key (0 QGROUP_LIMIT 0/5) itemoff 16171 itemsize 40
>>>>                 flags 0
>>>>                 max_referenced 0 max_exclusive 0
>>>>                 rsv_referenced 0 rsv_exclusive 0
>>>> total bytes 26843545600
>>>> bytes used 171769856
>>>> uuid d07f6028-0ae7-40d4-ac45-01a4505ddcfb
>>>>
>>>>>
>>>>> Thanks,
>>>>> Qu> 
>>>>>>
>>>>>> My observation is that this commit changed to call initial quota rescan
>>>>>> when quota is enabeld instead of first comit transaction after enabling
>>>>>> quota, and therefore if there is something not commited at that time,
>>>>>> their usage will not be accounted.
>>>>>>
>>>>>> Actually this can be simply fixed by calling "btrfs rescan" again or
>>>>>> calling "btrfs fi sync" before "btrfs quota enable".
>>>>>>
>>>>>> I think the commit itself makes the code much easier to read, so it may
>>>>>> be better to fix the problem in progs (i.e. calling sync before quota enable).
>>>>>>
>>>>>> Do you have any thoughts?
>>>>>>
>>>>>> Thanks,
>>>>>> Tomohiro Misono
>>>>>>
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

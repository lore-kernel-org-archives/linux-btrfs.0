Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61012 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750786AbdGNGLZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 02:11:25 -0400
Subject: Re: Btrfs check reports errors, filesystem seems fine
To: Filippe LeMarchand <gasinvein@gmail.com>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <2049018.boNrIqZ5uI@carbide> <4618180.XOrZWPbqUa@carbide>
 <e4d80f77-6032-b312-8719-ab0725123051@gmx.com> <1890561.EoWiig1PuT@carbide>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f30b6059-e146-ebe8-cfc9-f3ae675bd620@gmx.com>
Date: Fri, 14 Jul 2017 14:11:06 +0800
MIME-Version: 1.0
In-Reply-To: <1890561.EoWiig1PuT@carbide>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your dump.

We're clear what is the direct cause of the problem.

It's one corrupted DIR_ITEM causing the problem.
And further more, original mode btrfs check can't detect it, and we will 
fix it soon.

The corrupted DIR_ITEM is as the following:
	item 72 key (79177 DIR_ITEM 54846528) itemoff 12380 itemsize 88
		location key (4222342 INODE_ITEM 0) type FILE
		transid 170929 data_len 0 name_len 14
		name: deprecated.sxt
		location key (13590433 INODE_ITEM 0) type FILE
		transid 796448 data_len 0 name_len 14
		name: deprecated.txt

For dir inode 79177, it has 2 child inodes, with name "deprecated.txt" 
(ino=4222342) and "deprecated.sxt" (ino=13590433)

But something goes wrong here:

1) Hash of "deprecated.sxt" doesn't match 54846528

2) Inode backref of inode 4222342 thinks its filename is "deprecated.txt"
Also captured by dump:
	item 40 key (4222342 INODE_REF 79177) itemoff 7189 itemsize 24
		inode ref index 417 namelen 14 name: deprecated.txt

3) DIR_INDEX also shows that filename for inode 4222342 should be 
"deprecated.txt"
	item 87 key (79177 DIR_INDEX 417) itemoff 11757 itemsize 44
		location key (4222342 INODE_ITEM 0) type FILE
		transid 170929 data_len 0 name_len 14
		name: deprecated.txt

So generic speaking, it's DIR_ITEM wrong and causing the problem.

But the root reason is still unknown.

What I can see is, the corrupted DIR_ITEM points to an very old inode, 
its mtime is back to 2016-09-07.
While the good DIR_ITEM points to newer inode, whose mtime is just 
2017-05-02.

But more weird, there should not be two child inodes with the same 
filename ("depercated.txt", I assume the sxt one is caused by a memory 
bit corruption).

So, any details on the operation with util-linux/deprecated.txt will 
help us to locate the root cause in kernel.

Thanks,
Qu


On 2017年07月12日 21:11, Filippe LeMarchand wrote:
> Done, files added to same GDrive folder with corresponding names.
> If it matters, subvol 4546 is my root filesystem (r/w snapshot created with snapper rollback), and 5134 is its snapshot.
> 
> In a letter dated Wednesday, July 12, 2017 15:44:52 MSK user Qu Wenruo wrote:
>>
>> On 2017年07月12日 19:12, Filippe LeMarchand wrote:
>>>> Maybe something wrong in grep happened which skip "(79177" ?
>>> Yes, my bad. Now I used grep -E "\(79177| 79177" pattern, file on GDrive updated.
>>
>> It looks much better, thanks.
>>
>>>
>>> And btrfs check --mode=lowmem gives this:
>>>
>>> checking extents
>>> ERROR: extent[1609877700608, 94208] referencer count mismatch (root: 260, owner: 61720, offset: 6742016) wanted: 2, have: 5
>>> ERROR: extent[1630301675520, 39583744] referencer count mismatch (root: 260, owner: 5847554, offset: 0) wanted: 36, have: 114
>>> ERROR: extent[1658646986752, 10551296] referencer count mismatch (root: 274, owner: 283675, offset: 0) wanted: 2, have: 5
>>> ERROR: extent[1672239132672, 84381696] referencer count mismatch (root: 274, owner: 2521382, offset: 0) wanted: 21, have: 25
>>> ERROR: errors found in extent allocation tree or chunk allocation
>>
>> Looks much like an exposed lowmem mode bug.
>> Feel free to ignore these error from extent tree, they are just false
>> alerts.
>>
>>> checking free space cache
>>> checking fs roots
>>> ERROR: root 4546 DIR_ITEM[79177 54846528] relative INODE_REF missing namelen 14 filename deprecated.sxt filetype 1
>>
>> The error report is much better than original mode, and that's what I need.
>>
>> Now I can wipe out all other noise as we know exactly which tree and
>> which DIR_ITEM/INODE_REF is causing the problem.
>>
>> Would you please update the dump result with "-t 4546" passed to
>> btrfs-debug-tree like:
>>
>> # btrfs-debug-tree -t 4546 <device>| grep 79177
>>
>> Only "-t 4546" is added, to only dump the result of subvolume 4546.
>> As always, all 3 grep results (2 "deprecated" and one 79177) need to be
>> updated.
>>
>> And it seems that my previous assumption is still right for this case.
>> If it's caused by kernel, your dump would definitely help us to locate
>> the problem.
>>
>>> ERROR: root 4546 INODE REF[4222342 79177] and DIR_ITEM[79177 54846528] mismatch namelen 14 filename deprecated.txt filetype 1
>>> ERROR: root 5134 DIR_ITEM[79177 54846528] relative INODE_REF missing namelen 14 filename deprecated.sxt filetype 1
>>
>> Also for root 5134 please.
>>
>> Thanks,
>> Qu
>>
>>> ERROR: errors found in fs roots
>>> Checking filesystem on /dev/sda2
>>> UUID: 12c84aa3-ce65-4390-807e-a72cc8a7445e
>>> found 153429872640 bytes used, error(s) found
>>> total csum bytes: 121991672
>>> total tree bytes: 1940160512
>>> total fs tree bytes: 1683767296
>>> total extent tree bytes: 103841792
>>> btree space waste bytes: 310722480
>>> file data blocks allocated: 842455031808
>>>    referenced 159286636544
>>>
>>> In a letter from Wednesday, July 12, 2017 10:15:18 MSK user Qu Wenruo wrote:
>>>> Sorry for the late reply.
>>>>
>>>> After investigating the dumps, I found the output is quite strange.
>>>>
>>>> 1) Mismatching output.
>>>> In "btrfs-debug-tree-grep-79177.txt" I found only 79177 as offset for
>>>> INODE_REF is here, while 79177 as objectid for DIR_ITEM/DIR_INDEX is not
>>>> here at all.
>>>>
>>>> While in "btrfs-debug-tree-grep-deprecated-txt.txt" there is epected
>>>> 79177 DIR_ITEM/DIR_INDEX.
>>>>
>>>> Maybe something wrong in grep happened which skip "(79177" ?
>>>>
>>>> 2) Mismatched hash
>>>> The main problem I found is that, for key (79177 DIR_ITEM 54846528), the
>>>> number 54846528 is the hash(crc32c) of filename, and it contains 2
>>>> items, one for "deprecated.txt" and one for "deprecated.sxt".
>>>>
>>>> But we found that 54846528 only matches the hash for "deprecated.txt",
>>>> not "deprecated.sxt".
>>>>
>>>> I think that's the main problem.
>>>>
>>>> BTW, would you please try "btrfs check --mode=lowmem" to see if lowmem
>>>> mode reports similar (well, output may differ) error?
>>>>
>>>> If lowmem mode also reports error on such DIR_ITEM, I'm pretty sure
>>>> that's the problem.
>>>>
>>>> However it may take some time before we can fix it in repair mode.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>
>>>>
>>>> 在 2017年07月04日 21:24, Filippe LeMarchand 写道:
>>>>> Sure, here it is:
>>>>> https://drive.google.com/drive/folders/0B1ax9Am81gx9YjJBVVA0LXRHeGc
>>>>>
>>>>> In a letter dated Tuesday, July 4, 2017 16:16:36 MSK user Lu Fengqi wrote:
>>>>>> On Mon, Jul 03, 2017 at 08:34:52AM +0800, Qu Wenruo wrote:
>>>>>>>
>>>>>>>
>>>>>>> At 07/01/2017 07:59 PM, Filippe LeMarchand wrote:
>>>>>>>> Hello everyone.
>>>>>>>>
>>>>>>>> I have an btrfs root partition on Intel 530 ssd, which mounts without errors and seem to work fine,
>>>>>>>> but `btrfs check` gives me foloowing output (and --repair doesn't remove errors):
>>>>>>>>
>>>>>>>> enabling repair mode
>>>>>>>> Checking filesystem on /dev/sda2
>>>>>>>> UUID: 12c84aa3-ce65-4390-807e-a72cc8a7445e
>>>>>>>> checking extents
>>>>>>>> Fixed 0 roots.
>>>>>>>> checking free space cache
>>>>>>>> cache and super generation don't match, space cache will be invalidated
>>>>>>>> checking fs roots
>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>
>>>>>>> This means that in dir whose inode number is 79177, it has a child inode
>>>>>>> pointer pointing to depercated.sxt.
>>>>>>>
>>>>>>> But it doesn't have dir index and corresponding inode ref, which is breaking
>>>>>>> the cross reference rule of btrfs.
>>>>>>>
>>>>>>> Would you please run the following command to dump needed info for us to
>>>>>>> debug?
>>>>>>>
>>>>>>> # btrfs-debug-tree /dev/sda2 | grep 79177 -C 10
>>>>>>>
>>>>>>> and
>>>>>>>
>>>>>>> # btrfs-debug-tree /dev/sda2 | grep deprecated.sxt -C 10
>>>>>>>
>>>>>>> and
>>>>>>>
>>>>>>> # btrfs-debug-tree /dev/sda2 | grep deprecated.txt -C 10
>>>>>>>
>>>>>>>
>>>>>>> Considering the output has both .txt and .sxt, I think that's the problem.
>>>>>>> But such bit-flip should be detected by tree block csum.
>>>>>>> I'm not sure what's wrong with it.
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Qu
>>>>>>>
>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>> checking csums
>>>>>>>> checking root refs
>>>>>>>> found 23421812736 bytes used err is 0
>>>>>>>> total csum bytes: 21531608
>>>>>>>> total tree bytes: 776650752
>>>>>>>> total fs tree bytes: 711278592
>>>>>>>> total extent tree bytes: 36798464
>>>>>>>> btree space waste bytes: 116002036
>>>>>>>> file data blocks allocated: 850546470912
>>>>>>>>      referenced 27611987968
>>>>>>>>
>>>>>>>> Is it dangerous and what should I do about it?
>>>>>>>>
>>>>>>>> I also tried --clear-space-cache, but it just removes the line about space cache.
>>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>>> I'm afraid that your mail may be rejected because the attachment size
>>>>>> exceeds the allowable limit(100kB) of btrfs mailing list. Could you
>>>>>> share the attachment by google drive?
>>>>>>
>>>>>> Lastly, while Qu's timing is too tight, I will assist you on this issue.
>>>>>>

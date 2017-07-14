Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50452 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753519AbdGNMle (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 08:41:34 -0400
Subject: Re: Btrfs check reports errors, filesystem seems fine
To: Filippe LeMarchand <gasinvein@gmail.com>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <2049018.boNrIqZ5uI@carbide> <3453103.9rW5SPuTga@carbide>
 <9d6a7f37-277d-af66-96d0-f239fe32c308@gmx.com> <15005101.YYELHnmqn7@carbide>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <78e9bf0d-c8e9-f735-ad30-ed76affd8e07@gmx.com>
Date: Fri, 14 Jul 2017 20:41:22 +0800
MIME-Version: 1.0
In-Reply-To: <15005101.YYELHnmqn7@carbide>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月14日 20:26, Filippe LeMarchand wrote:
> So, my options are
> a) Delete and re-create sobvolume
> b) Try btrfs check --repair --mode original (if original mode is default, it already didn't help)

Then --repair doesn't help now.

> c) Do nothing and wait for further update

Further update plan includes:
c) Update btrfs check --repair to handle your case.
    This will take some time for us to test and other guys to review.

d) Create a special purposed btrfs-corrupt-block patch for your image.
    This will fix your fs, but only for your fs.
    Not a generic solution, but at least it should work.

For now, it's recommend to backup important data, in case both c) and d) 
fail.

Thanks,
Qu
> ?
> 
> In a letter from Friday, July 14, 2017 15:11:05 MSK user Qu Wenruo wrote:
>>
>> On 2017年07月14日 20:04, Filippe LeMarchand wrote:
>>>> Currently possible solution may be deleting the whole subvolume.
>>> Can btrfs send (to external drive) and then btrfs receive back fix it? Or should I use simple cp/rsync?
>>
>> You could try if you have backup.
>>
>> Personally speaking, I'm not sure if it will work or make things worse.
>> Such hash and name mismatch is really rare, I don't know how kernel send
>> will handle it.
>>
>>>    
>>>> If you have full backup, then you could try it.
>>> It is my root subvolume (sensitive data is on other ones), thus it is expendable. Can btrfs check --repair damage other subvolumes?
>>
>> Unfortunately, it may corrupt other subvolumes.
>> But from your fsck output, the possibility of corruption is not that
>> high AFAIK.
>>
>> I recommend to backup other good subvolumes/snapshots using send and
>> receive just in case.
>>
>>>
>>>> Any idea about the reproducer? Or just random memory corruption?
>>> No idea why and no idea when. This partition is about year and a half old, and I did btrfs check for the first time just about a month ago.
>>> Also I ran memtest recently and it didn't find any errors.
>>
>> Well, that's common.
>> I'll focus on checking your dump result to make a special purposed
>> btrfs-corrupt-block to fix your situation if no other method works for you.
>>
>> Thanks,
>> Qu
>>
>>>
>>> In a letter from Friday, July 14, 2017 14:28:58 MSK user Qu Wenruo wrote:
>>>>
>>>> On 2017年07月14日 18:12, Filippe LeMarchand wrote:
>>>>> First "rm" on deprecated.txt worked, but file is still there. Neither the file, nor its parent directory cannot be deleted:
>>>>>
>>>>> $ sudo rm /usr/share/doc/packages/util-linux/deprecated.txt
>>>>> rm: cannot remove '/usr/share/doc/packages/util-linux/deprecated.txt': No such file or directory
>>>>>
>>>>> $ sudo rm -rf /usr/share/doc/packages/util-linux/
>>>>> rm: cannot remove '/usr/share/doc/packages/util-linux/': Directory not empty
>>>>>
>>>>> $ sudo ls -l /usr/share/doc/packages/util-linux/
>>>>> ls: cannot access '/usr/share/doc/packages/util-linux/deprecated.txt': No such file or directory
>>>>> total 0
>>>>> -????????? ? ? ? ?            ? deprecated.txt
>>>>
>>>> Similar behavior is also detected using manually crafted image in our
>>>> environment.
>>>>
>>>> Su Yue have sent patches to enhance error detection and test case for
>>>> it, but repairing is not supported.
>>>>
>>>>>
>>>>> Reinstall of util-linux package gives me two of that file (and also two files present on previous snapshot):
>>>>>
>>>>> $ ls -l /usr/share/doc/packages/util-linux/
>>>>> total 104
>>>>> -rw-r--r-- 1 root root 18092 Jul 20  2016 COPYING
>>>>> -rw-r--r-- 1 root root  1391 Jul 20  2016 COPYING.BSD-3
>>>>> -rw-r--r-- 1 root root 26530 Jul 20  2016 COPYING.LGPLv2.1
>>>>> -rw-r--r-- 1 root root  1824 Jul 20  2016 COPYING.UCB
>>>>> -rw-r--r-- 1 root root   555 Jul 20  2016 README.licensing
>>>>> -rw-r--r-- 1 root root  3257 Jul 20  2016 blkid.txt
>>>>> -rw-r--r-- 1 root root  2264 Jul 20  2016 cal.txt
>>>>> -rw-r--r-- 1 root root  1913 Jul 20  2016 col.txt
>>>>> -rw-r--r-- 1 root root  2825 May  2 13:17 deprecated.txt
>>>>> -rw-r--r-- 1 root root  2825 May  2 13:17 deprecated.txt
>>>>> -rw-r--r-- 1 root root   992 Jul 20  2016 getopt.txt
>>>>> -rw-r--r-- 1 root root  2437 Nov  2  2016 howto-debug.txt
>>>>> -rw-r--r-- 1 root root   148 Jul 20  2016 hwclock.txt
>>>>> -rw-r--r-- 1 root root  2617 Jul 20  2016 modems-with-agetty.txt
>>>>> -rw-r--r-- 1 root root   522 Jul 20  2016 mount.txt
>>>>> -rw-r--r-- 1 root root   448 Jul 20  2016 pg.txt
>>>>>
>>>>> So, is this situation actually dangerous? And what can I do to gather more information for you?
>>>>
>>>> The situation won't be worse. I'd recommend not to take any snapshot of
>>>> those subvolumes (4546 and 5134) to limit the corruption to those
>>>> subvolumes.
>>>>
>>>> However there is also no easy way to fix it yet.
>>>>
>>>> Currently possible solution may be deleting the whole subvolume.
>>>> If no further error happens, it may be fixed.
>>>>
>>>> IIRC btrfs check --repair in original mode has
>>>> DIR_ITEM/DIR_INDEX/INODE_REF repair function, but I'm not sure if it can
>>>> handle it well.
>>>> Btrfs check --repair *MAY* fix it, or it may make things worse.
>>>> If you have full backup, then you could try it.
>>>> Otherwise, don't try it at all.
>>>>
>>>> Other solution includes a specific repair program just for your case.
>>>> We can modify btrfs-corrupt-block to just delete the corrupted DIR_ITEM
>>>> (".sxt" one) and related DIR_INDEX/INODE_REF.
>>>> But I'll only choose this if you really need to fix it as soon as possible.
>>>>
>>>> At least we have solution for it.
>>>> I'm more concerned about how this happened.
>>>>
>>>> Any idea about the reproducer? Or just random memory corruption?
>>>>
>>>> Thanks,
>>>> Qu
>>>>>
>>>>> In a letter from Friday, July 14, 2017 9:11:06 MSK user Qu Wenruo wrote:
>>>>>> Thanks for your dump.
>>>>>>
>>>>>> We're clear what is the direct cause of the problem.
>>>>>>
>>>>>> It's one corrupted DIR_ITEM causing the problem.
>>>>>> And further more, original mode btrfs check can't detect it, and we will
>>>>>> fix it soon.
>>>>>>
>>>>>> The corrupted DIR_ITEM is as the following:
>>>>>> 	item 72 key (79177 DIR_ITEM 54846528) itemoff 12380 itemsize 88
>>>>>> 		location key (4222342 INODE_ITEM 0) type FILE
>>>>>> 		transid 170929 data_len 0 name_len 14
>>>>>> 		name: deprecated.sxt
>>>>>> 		location key (13590433 INODE_ITEM 0) type FILE
>>>>>> 		transid 796448 data_len 0 name_len 14
>>>>>> 		name: deprecated.txt
>>>>>>
>>>>>> For dir inode 79177, it has 2 child inodes, with name "deprecated.txt"
>>>>>> (ino=4222342) and "deprecated.sxt" (ino=13590433)
>>>>>>
>>>>>> But something goes wrong here:
>>>>>>
>>>>>> 1) Hash of "deprecated.sxt" doesn't match 54846528
>>>>>>
>>>>>> 2) Inode backref of inode 4222342 thinks its filename is "deprecated.txt"
>>>>>> Also captured by dump:
>>>>>> 	item 40 key (4222342 INODE_REF 79177) itemoff 7189 itemsize 24
>>>>>> 		inode ref index 417 namelen 14 name: deprecated.txt
>>>>>>
>>>>>> 3) DIR_INDEX also shows that filename for inode 4222342 should be
>>>>>> "deprecated.txt"
>>>>>> 	item 87 key (79177 DIR_INDEX 417) itemoff 11757 itemsize 44
>>>>>> 		location key (4222342 INODE_ITEM 0) type FILE
>>>>>> 		transid 170929 data_len 0 name_len 14
>>>>>> 		name: deprecated.txt
>>>>>>
>>>>>> So generic speaking, it's DIR_ITEM wrong and causing the problem.
>>>>>>
>>>>>> But the root reason is still unknown.
>>>>>>
>>>>>> What I can see is, the corrupted DIR_ITEM points to an very old inode,
>>>>>> its mtime is back to 2016-09-07.
>>>>>> While the good DIR_ITEM points to newer inode, whose mtime is just
>>>>>> 2017-05-02.
>>>>>>
>>>>>> But more weird, there should not be two child inodes with the same
>>>>>> filename ("depercated.txt", I assume the sxt one is caused by a memory
>>>>>> bit corruption).
>>>>>>
>>>>>> So, any details on the operation with util-linux/deprecated.txt will
>>>>>> help us to locate the root cause in kernel.
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>
>>>>>> On 2017年07月12日 21:11, Filippe LeMarchand wrote:
>>>>>>> Done, files added to same GDrive folder with corresponding names.
>>>>>>> If it matters, subvol 4546 is my root filesystem (r/w snapshot created with snapper rollback), and 5134 is its snapshot.
>>>>>>>
>>>>>>> In a letter dated Wednesday, July 12, 2017 15:44:52 MSK user Qu Wenruo wrote:
>>>>>>>>
>>>>>>>> On 2017年07月12日 19:12, Filippe LeMarchand wrote:
>>>>>>>>>> Maybe something wrong in grep happened which skip "(79177" ?
>>>>>>>>> Yes, my bad. Now I used grep -E "\(79177| 79177" pattern, file on GDrive updated.
>>>>>>>>
>>>>>>>> It looks much better, thanks.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> And btrfs check --mode=lowmem gives this:
>>>>>>>>>
>>>>>>>>> checking extents
>>>>>>>>> ERROR: extent[1609877700608, 94208] referencer count mismatch (root: 260, owner: 61720, offset: 6742016) wanted: 2, have: 5
>>>>>>>>> ERROR: extent[1630301675520, 39583744] referencer count mismatch (root: 260, owner: 5847554, offset: 0) wanted: 36, have: 114
>>>>>>>>> ERROR: extent[1658646986752, 10551296] referencer count mismatch (root: 274, owner: 283675, offset: 0) wanted: 2, have: 5
>>>>>>>>> ERROR: extent[1672239132672, 84381696] referencer count mismatch (root: 274, owner: 2521382, offset: 0) wanted: 21, have: 25
>>>>>>>>> ERROR: errors found in extent allocation tree or chunk allocation
>>>>>>>>
>>>>>>>> Looks much like an exposed lowmem mode bug.
>>>>>>>> Feel free to ignore these error from extent tree, they are just false
>>>>>>>> alerts.
>>>>>>>>
>>>>>>>>> checking free space cache
>>>>>>>>> checking fs roots
>>>>>>>>> ERROR: root 4546 DIR_ITEM[79177 54846528] relative INODE_REF missing namelen 14 filename deprecated.sxt filetype 1
>>>>>>>>
>>>>>>>> The error report is much better than original mode, and that's what I need.
>>>>>>>>
>>>>>>>> Now I can wipe out all other noise as we know exactly which tree and
>>>>>>>> which DIR_ITEM/INODE_REF is causing the problem.
>>>>>>>>
>>>>>>>> Would you please update the dump result with "-t 4546" passed to
>>>>>>>> btrfs-debug-tree like:
>>>>>>>>
>>>>>>>> # btrfs-debug-tree -t 4546 <device>| grep 79177
>>>>>>>>
>>>>>>>> Only "-t 4546" is added, to only dump the result of subvolume 4546.
>>>>>>>> As always, all 3 grep results (2 "deprecated" and one 79177) need to be
>>>>>>>> updated.
>>>>>>>>
>>>>>>>> And it seems that my previous assumption is still right for this case.
>>>>>>>> If it's caused by kernel, your dump would definitely help us to locate
>>>>>>>> the problem.
>>>>>>>>
>>>>>>>>> ERROR: root 4546 INODE REF[4222342 79177] and DIR_ITEM[79177 54846528] mismatch namelen 14 filename deprecated.txt filetype 1
>>>>>>>>> ERROR: root 5134 DIR_ITEM[79177 54846528] relative INODE_REF missing namelen 14 filename deprecated.sxt filetype 1
>>>>>>>>
>>>>>>>> Also for root 5134 please.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Qu
>>>>>>>>
>>>>>>>>> ERROR: errors found in fs roots
>>>>>>>>> Checking filesystem on /dev/sda2
>>>>>>>>> UUID: 12c84aa3-ce65-4390-807e-a72cc8a7445e
>>>>>>>>> found 153429872640 bytes used, error(s) found
>>>>>>>>> total csum bytes: 121991672
>>>>>>>>> total tree bytes: 1940160512
>>>>>>>>> total fs tree bytes: 1683767296
>>>>>>>>> total extent tree bytes: 103841792
>>>>>>>>> btree space waste bytes: 310722480
>>>>>>>>> file data blocks allocated: 842455031808
>>>>>>>>>       referenced 159286636544
>>>>>>>>>
>>>>>>>>> In a letter from Wednesday, July 12, 2017 10:15:18 MSK user Qu Wenruo wrote:
>>>>>>>>>> Sorry for the late reply.
>>>>>>>>>>
>>>>>>>>>> After investigating the dumps, I found the output is quite strange.
>>>>>>>>>>
>>>>>>>>>> 1) Mismatching output.
>>>>>>>>>> In "btrfs-debug-tree-grep-79177.txt" I found only 79177 as offset for
>>>>>>>>>> INODE_REF is here, while 79177 as objectid for DIR_ITEM/DIR_INDEX is not
>>>>>>>>>> here at all.
>>>>>>>>>>
>>>>>>>>>> While in "btrfs-debug-tree-grep-deprecated-txt.txt" there is epected
>>>>>>>>>> 79177 DIR_ITEM/DIR_INDEX.
>>>>>>>>>>
>>>>>>>>>> Maybe something wrong in grep happened which skip "(79177" ?
>>>>>>>>>>
>>>>>>>>>> 2) Mismatched hash
>>>>>>>>>> The main problem I found is that, for key (79177 DIR_ITEM 54846528), the
>>>>>>>>>> number 54846528 is the hash(crc32c) of filename, and it contains 2
>>>>>>>>>> items, one for "deprecated.txt" and one for "deprecated.sxt".
>>>>>>>>>>
>>>>>>>>>> But we found that 54846528 only matches the hash for "deprecated.txt",
>>>>>>>>>> not "deprecated.sxt".
>>>>>>>>>>
>>>>>>>>>> I think that's the main problem.
>>>>>>>>>>
>>>>>>>>>> BTW, would you please try "btrfs check --mode=lowmem" to see if lowmem
>>>>>>>>>> mode reports similar (well, output may differ) error?
>>>>>>>>>>
>>>>>>>>>> If lowmem mode also reports error on such DIR_ITEM, I'm pretty sure
>>>>>>>>>> that's the problem.
>>>>>>>>>>
>>>>>>>>>> However it may take some time before we can fix it in repair mode.
>>>>>>>>>>
>>>>>>>>>> Thanks,
>>>>>>>>>> Qu
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> 在 2017年07月04日 21:24, Filippe LeMarchand 写道:
>>>>>>>>>>> Sure, here it is:
>>>>>>>>>>> https://drive.google.com/drive/folders/0B1ax9Am81gx9YjJBVVA0LXRHeGc
>>>>>>>>>>>
>>>>>>>>>>> In a letter dated Tuesday, July 4, 2017 16:16:36 MSK user Lu Fengqi wrote:
>>>>>>>>>>>> On Mon, Jul 03, 2017 at 08:34:52AM +0800, Qu Wenruo wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> At 07/01/2017 07:59 PM, Filippe LeMarchand wrote:
>>>>>>>>>>>>>> Hello everyone.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I have an btrfs root partition on Intel 530 ssd, which mounts without errors and seem to work fine,
>>>>>>>>>>>>>> but `btrfs check` gives me foloowing output (and --repair doesn't remove errors):
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> enabling repair mode
>>>>>>>>>>>>>> Checking filesystem on /dev/sda2
>>>>>>>>>>>>>> UUID: 12c84aa3-ce65-4390-807e-a72cc8a7445e
>>>>>>>>>>>>>> checking extents
>>>>>>>>>>>>>> Fixed 0 roots.
>>>>>>>>>>>>>> checking free space cache
>>>>>>>>>>>>>> cache and super generation don't match, space cache will be invalidated
>>>>>>>>>>>>>> checking fs roots
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>>>>>>>
>>>>>>>>>>>>> This means that in dir whose inode number is 79177, it has a child inode
>>>>>>>>>>>>> pointer pointing to depercated.sxt.
>>>>>>>>>>>>>
>>>>>>>>>>>>> But it doesn't have dir index and corresponding inode ref, which is breaking
>>>>>>>>>>>>> the cross reference rule of btrfs.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Would you please run the following command to dump needed info for us to
>>>>>>>>>>>>> debug?
>>>>>>>>>>>>>
>>>>>>>>>>>>> # btrfs-debug-tree /dev/sda2 | grep 79177 -C 10
>>>>>>>>>>>>>
>>>>>>>>>>>>> and
>>>>>>>>>>>>>
>>>>>>>>>>>>> # btrfs-debug-tree /dev/sda2 | grep deprecated.sxt -C 10
>>>>>>>>>>>>>
>>>>>>>>>>>>> and
>>>>>>>>>>>>>
>>>>>>>>>>>>> # btrfs-debug-tree /dev/sda2 | grep deprecated.txt -C 10
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> Considering the output has both .txt and .sxt, I think that's the problem.
>>>>>>>>>>>>> But such bit-flip should be detected by tree block csum.
>>>>>>>>>>>>> I'm not sure what's wrong with it.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Thanks,
>>>>>>>>>>>>> Qu
>>>>>>>>>>>>>
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
>>>>>>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
>>>>>>>>>>>>>> checking csums
>>>>>>>>>>>>>> checking root refs
>>>>>>>>>>>>>> found 23421812736 bytes used err is 0
>>>>>>>>>>>>>> total csum bytes: 21531608
>>>>>>>>>>>>>> total tree bytes: 776650752
>>>>>>>>>>>>>> total fs tree bytes: 711278592
>>>>>>>>>>>>>> total extent tree bytes: 36798464
>>>>>>>>>>>>>> btree space waste bytes: 116002036
>>>>>>>>>>>>>> file data blocks allocated: 850546470912
>>>>>>>>>>>>>>         referenced 27611987968
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Is it dangerous and what should I do about it?
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I also tried --clear-space-cache, but it just removes the line about space cache.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> --
>>>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>>>>>>
>>>>>>>>>>>> I'm afraid that your mail may be rejected because the attachment size
>>>>>>>>>>>> exceeds the allowable limit(100kB) of btrfs mailing list. Could you
>>>>>>>>>>>> share the attachment by google drive?
>>>>>>>>>>>>
>>>>>>>>>>>> Lastly, while Qu's timing is too tight, I will assist you on this issue.
>>>>>>>>>>>>

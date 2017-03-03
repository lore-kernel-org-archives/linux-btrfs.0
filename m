Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55160 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751470AbdCCBmH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Mar 2017 20:42:07 -0500
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already
 exists
To: Marc Joliet <marcec@gmx.de>, <linux-btrfs@vger.kernel.org>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de>
 <11009787.rdtfuSitqF@thetick>
 <185b5213-f036-04f8-cf8f-fbe5f3351139@cn.fujitsu.com>
 <1714469.dJ89oe0hXx@thetick>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <905fd8af-b3b5-343a-09b1-c2f569e8dd19@cn.fujitsu.com>
Date: Fri, 3 Mar 2017 09:00:10 +0800
MIME-Version: 1.0
In-Reply-To: <1714469.dJ89oe0hXx@thetick>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/02/2017 05:43 PM, Marc Joliet wrote:
> On Thursday 02 March 2017 08:43:53 Qu Wenruo wrote:
>> At 02/02/2017 08:01 PM, Marc Joliet wrote:
>>> On Sunday 28 August 2016 15:29:08 Kai Krakow wrote:
>>>> Hello list!
>>>
>>> Hi list
>>
>> [kernel message snipped]
>>
>>>> Btrfs --repair refused to repair the filesystem telling me something
>>>> about compressed extents and an unsupported case, wanting me to take an
>>>> image and send it to the devs. *sigh*
>>>
>>> I haven't tried a repair yet; it's a big file system, and btrfs-check is
>>> still running:
>>>
>>> # btrfs check -p /dev/sdd2
>>> Checking filesystem on /dev/sdd2
>>> UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
>>> parent transid verify failed on 3829276291072 wanted 224274 found 283858
>>> parent transid verify failed on 3829276291072 wanted 224274 found 283858
>>> parent transid verify failed on 3829276291072 wanted 224274 found 283858
>>> parent transid verify failed on 3829276291072 wanted 224274 found 283858
>>
>> Normal transid error, can't say much about if it's harmless, but at
>> least some thing went wrong.
>>
>>> Ignoring transid failure
>>> leaf parent key incorrect 3829276291072
>>> bad block 3829276291072
>>
>> That's some what a big problem for that tree block.
>>
>> If this tree block is extent tree block, no wonder why kernel output
>> kernel warning and abort transaction.
>>
>> You could try "btrfs-debug-tree -b 3829276291072 <device>" to show the
>> content of the tree block.
>
> # btrfs-debug-tree -b 3829276291072 /dev/sdb2
> btrfs-progs v4.9
> node 3829276291072 level 1 items 70 free 51 generation 292525 owner 2
> fs uuid f97b3cda-15e8-418b-bb9b-235391ef2a38
> chunk uuid 1cee580c-3442-4717-9300-8514dd8ff297
>         key (3828594696192 METADATA_ITEM 0) block 3828933423104 (934798199)
> gen 292523
>         key (3828594925568 METADATA_ITEM 0) block 3829427818496 (934918901)
> gen 292525
>         key (3828595109888 METADATA_ITEM 0) block 3828895723520 (934788995)
> gen 292523
>         key (3828595232768 METADATA_ITEM 0) block 3829202751488 (934863953)
> gen 292524
>         key (3828595412992 METADATA_ITEM 0) block 3829097209856 (934838186)
> gen 292523
>         key (3828595572736 TREE_BLOCK_REF 33178) block 3829235073024
> (934871844) gen 292524
>         key (3828595744768 METADATA_ITEM 0) block 3829128351744 (934845789)
> gen 292524
>         key (3828595982336 METADATA_ITEM 0) block 3829146484736 (934850216)
> gen 292524
>         key (3828596187136 METADATA_ITEM 1) block 3829097234432 (934838192)
> gen 292523
>         key (3828596387840 TREE_BLOCK_REF 33527) block 3829301653504
> (934888099) gen 292525
>         key (3828596617216 METADATA_ITEM 0) block 3828885737472 (934786557)
> gen 292523
>         key (3828596838400 METADATA_ITEM 0) block 3828885741568 (934786558)
> gen 292523
>         key (3828597047296 METADATA_ITEM 0) block 3829320552448 (934892713)
> gen 292525
>         key (3828597231616 METADATA_ITEM 0) block 3828945653760 (934801185)
> gen 292523
>         key (3828597383168 METADATA_ITEM 0) block 3829276299264 (934881909)
> gen 292525
>         key (3828597641216 METADATA_ITEM 1) block 3829349351424 (934899744)
> gen 292525
>         key (3828597866496 METADATA_ITEM 0) block 3829364776960 (934903510)
> gen 292525
>         key (3828598067200 METADATA_ITEM 0) block 3828598321152 (934716387)
> gen 292522
>         key (3828598259712 METADATA_ITEM 0) block 3829422968832 (934917717)
> gen 292525
>         key (3828598415360 TREE_BLOCK_REF 33252) block 3828885803008
> (934786573) gen 292523
>         key (3828598665216 METADATA_ITEM 0) block 3828937863168 (934799283)
> gen 292523
>         key (3828598829056 METADATA_ITEM 0) block 3828885811200 (934786575)
> gen 292523
>         key (3828599054336 METADATA_ITEM 0) block 3829363744768 (934903258)
> gen 292525
>         key (3828599246848 METADATA_ITEM 0) block 3828915838976 (934793906)
> gen 292523
>         key (3828599504896 METADATA_ITEM 0) block 3829436194816 (934920946)
> gen 292525
>         key (3828599672832 METADATA_ITEM 0) block 3828905140224 (934791294)
> gen 292523
>         key (3828599771136 METADATA_ITEM 0) block 3829333323776 (934895831)
> gen 292525
>         key (3828599988224 METADATA_ITEM 0) block 3829087199232 (934835742)
> gen 292523
>         key (3828600135680 METADATA_ITEM 0) block 3828885827584 (934786579)
> gen 292523
>         key (3828600389632 METADATA_ITEM 0) block 3829436284928 (934920968)
> gen 292525
>         key (3828600528896 METADATA_ITEM 0) block 3829316214784 (934891654)
> gen 292525
>         key (3828600729600 METADATA_ITEM 0) block 3828885905408 (934786598)
> gen 292523
>         key (3828600934400 METADATA_ITEM 0) block 3829384486912 (934908322)
> gen 292525
>         key (3828601143296 METADATA_ITEM 0) block 3829423611904 (934917874)
> gen 292525
>         key (3828601356288 METADATA_ITEM 0) block 3829113688064 (934842209)
> gen 292524
>         key (3828601556992 METADATA_ITEM 0) block 3829134540800 (934847300)
> gen 292524
>         key (3828601696256 METADATA_ITEM 0) block 3829181837312 (934858847)
> gen 292524
>         key (3828601823232 METADATA_ITEM 0) block 3829157421056 (934852886)
> gen 292524
>         key (3828602015744 TREE_BLOCK_REF 32943) block 3829316218880
> (934891655) gen 292525
>         key (3828602245120 METADATA_ITEM 0) block 3829207601152 (934865137)
> gen 292524
>         key (3828602384384 METADATA_ITEM 0) block 3828933246976 (934798156)
> gen 292523
>         key (3828602531840 METADATA_ITEM 0) block 3829346013184 (934898929)
> gen 292525
>         key (3828602740736 METADATA_ITEM 0) block 3828916629504 (934794099)
> gen 292523
>         key (3828602990592 METADATA_ITEM 0) block 3829160525824 (934853644)
> gen 292524
>         key (3828603097088 METADATA_ITEM 0) block 3828933267456 (934798161)
> gen 292523
>         key (3828603195392 METADATA_ITEM 0) block 4632523673600 (1130987225)
> gen 292474
>         key (3828603293696 TREE_BLOCK_REF 32827) block 3829160529920
> (934853645) gen 292524
>         key (3828603453440 METADATA_ITEM 0) block 3828886011904 (934786624)
> gen 292523
>         key (3828603711488 METADATA_ITEM 0) block 3829299806208 (934887648)
> gen 292525
>         key (3828603940864 METADATA_ITEM 0) block 3829325082624 (934893819)
> gen 292525
>         key (3828604145664 METADATA_ITEM 0) block 3828886040576 (934786631)
> gen 292523
>         key (3828604321792 METADATA_ITEM 0) block 3829207818240 (934865190)
> gen 292524
>         key (3828604538880 METADATA_ITEM 0) block 3829347282944 (934899239)
> gen 292525
>         key (3828604796928 METADATA_ITEM 1) block 3829304320000 (934888750)
> gen 292525
>         key (3828605042688 METADATA_ITEM 0) block 3829159145472 (934853307)
> gen 292524
>         key (3828605239296 METADATA_ITEM 0) block 3829170442240 (934856065)
> gen 292524
>         key (3828605505536 METADATA_ITEM 0) block 3829360103424 (934902369)
> gen 292525
>         key (3828605698048 METADATA_ITEM 0) block 3829362032640 (934902840)
> gen 292525
>         key (3828605915136 METADATA_ITEM 0) block 3829336616960 (934896635)
> gen 292525
>         key (3828606103552 METADATA_ITEM 0) block 3829360107520 (934902370)
> gen 292525
>         key (3828606291968 METADATA_ITEM 0) block 3829210537984 (934865854)
> gen 292524
>         key (3828606504960 METADATA_ITEM 0) block 3829406662656 (934913736)
> gen 292525
>         key (3828606754816 METADATA_ITEM 0) block 3829345562624 (934898819)
> gen 292525
>         key (3828606943232 METADATA_ITEM 0) block 3829342674944 (934898114)
> gen 292525
>         key (3828607156224 METADATA_ITEM 0) block 3829444628480 (934923005)
> gen 292525
>         key (3828607324160 METADATA_ITEM 0) block 3829087207424 (934835744)
> gen 292523
>         key (3828607561728 METADATA_ITEM 0) block 3829313220608 (934890923)
> gen 292525
>         key (3828607680512 METADATA_ITEM 0) block 3829370867712 (934904997)
> gen 292525
>         key (3828607930368 METADATA_ITEM 0) block 3829411094528 (934914818)
> gen 292525
>         key (3828608180224 METADATA_ITEM 0) block 3829299822592 (934887652)
> gen 292525
>
> I wonder, though, whether that is still the same block or whether it has been
> replaced during the past two weeks of FS usage.

It's a tree block of extent tree.
So the problem is all about extent tree now.

>
>> If it's an extent tree block, then I'm afraid that's the problem.
>> Not sure if repair can repair such problem, but at least from what I see
>> in btrfs-progs fsck self testcases, it doesn't handle extent tree error
>> well.
>
> OK
>
>>> ERROR: errors found in extent allocation tree or chunk allocation
>>> block group 4722282987520 has wrong amount of free space
>>> failed to load free space cache for block group 4722282987520
>>> checking free space cache [O]
>>> root 32018 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32089 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32091 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32092 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32107 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32189 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32190 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32191 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32265 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32266 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32409 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32410 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32411 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32412 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32413 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32631 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32632 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32633 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32634 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32635 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32636 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32718 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>>
>>> root 32732 inode 95066 errors 100, file extent discount
>>>
>>> Found file extent holes:
>>>         start: 413696, len: 4096
>>
>> File extent holes are completely fine, one of the few problems we can
>> fix safely in btrfs-check.
>
> Yeah, I found that out myself by searching my btrfs ML archive.
>
>> But previous extent tree one is not.
>
> OK
>
>> If lowmem mode also reports the same problems only (file extent discount
>> + extent tree error), then there is a chance that --init-extent-tree may
>> help.
>>
>> But it will be super time consuming though.
>
> Alright, in that case, I'll just reformat the partition and start my backups
> over from scratch once btrfs-check is done running (I'll post the current
> output in another Email).
>
> FWIW, as per my later messages, after mounting with clear_cache and letting
> btrfs-cleaner finish, btrfs-check did *not* print out those errors after
> running again.  It's now about two weeks later that the file system is showing
> problems again.

If btrfs-check didn't print out *any* error, then it should be mostly 
fine. (Unless there is some case we don't expose yet)

The problem should be caused by kernel AFAIK.

>
> Oh, and just in case it's relevant, the file system was created with btrfs-
> convert (a long time, maybe 1.5 years ago, though; it was originally ext4).

Not sure if it's related.
But at least for that old convert, it's chunk layout is somewhat rare 
and sometimes even bug-prone.

Did you balance the btrfs after convert? If so, it should be more like a 
traditional btrfs then.

Personally speaking I don't think it is relative for your bug, but much 
like a normal extent tree corruption seen in mail list.

Thanks,
Qu

>
> [...]
>
> Greetings
>



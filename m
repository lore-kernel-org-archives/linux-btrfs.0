Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30274 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933180AbaLLIx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 03:53:56 -0500
Message-ID: <548AAD21.3000000@cn.fujitsu.com>
Date: Fri, 12 Dec 2014 16:53:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 00/13] btrfs-progs:fsck: Add inode nlink mismatch and
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>	<20141210123750.GA27601@twin.jikos.cz>	<5488EA3D.9080905@cn.fujitsu.com>	<CAL3q7H6gmX9wZFxjb_ryHjzbaqq_5W+e9aHj+FNqcfsbuRNstw@mail.gmail.com>	<548A378F.6020101@cn.fujitsu.com> <CAL3q7H6OWFRPdWeKVABbbdAigW6PAx4oFF6=q8vSU-s0Y7EPzQ@mail.gmail.com>
In-Reply-To: <CAL3q7H6OWFRPdWeKVABbbdAigW6PAx4oFF6=q8vSU-s0Y7EPzQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v4 00/13] btrfs-progs:fsck: Add inode nlink mismatch and
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年12月12日 16:34
> On Fri, Dec 12, 2014 at 12:32 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> -------- Original Message --------
>> Subject: Re: [PATCH v4 00/13] btrfs-progs:fsck: Add inode nlink mismatch and
>> From: Filipe David Manana <fdmanana@gmail.com>
>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Date: 2014年12月11日 19:07
>>> On Thu, Dec 11, 2014 at 12:50 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> wrote:
>>>> -------- Original Message --------
>>>> Subject: Re: [PATCH v4 00/13] btrfs-progs:fsck: Add inode nlink mismatch
>>>> and
>>>> From: David Sterba <dsterba@suse.cz>
>>>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> Date: 2014年12月10日 20:37
>>>>> On Tue, Dec 09, 2014 at 04:27:19PM +0800, Qu Wenruo wrote:
>>>>>> The patchset introduce two new repair function and some helpers to
>>>>>> archive a huge goal:
>>>>>>      Repair btrfs whose fs tree's non-root leaf/node is corrupted when
>>>>>> no
>>>>>>      duplication is valid.
>>>>>>
>>>>>> The two new repair functions are:
>>>>>>      repair_inode_nlinks():
>>>>>>        Repair any inode nlink related problem.
>>>>>>        From fixing the nlink number and related
>>>>>>        inode_ref/dir_index/dir_item to recovering file name and file
>>>>>> type
>>>>>>        and salvage them into the lost+found dir.
>>>>>>        This does not only fix a case that some users reported but also
>>>>>>        cooperate with repair_inode_no_item() function to salvaged
>>>>>> heavily
>>>>>>        damaged inode to lost+found dir.
>>>>>>
>>>>>>      repair_inode_no_item():
>>>>>>        Repair case for inode_item missing case, which is quite common
>>>>>> when
>>>>>>        fs tree leaf/node is missing.
>>>>>>        This only does the inode item rebuild. Later recovery like move
>>>>>> it
>>>>>>        to lost+found dir is done by repair_inode_nlinks().
>>>>>>
>>>>>> The main helper is the repair_btree() function, which will drops the
>>>>>> corrupted non-root leaf/node and rebalance the tree to keep the
>>>>>> correctness of the btree.
>>>>> Sounds a bit intrusive, but under the circumstances I don't see anything
>>>>> better to do.
>>>> Better non-destructive but less generic method may be introduced later.
>>>> My dream is to inspect each key and its item to rebuild each member, but
>>>> it
>>>> would takes a long long time
>>>> to implement.
>>>>>
>>>>>> With this patchset, even a non-root leaf/node is corrupted and no
>>>>>> duplication survived, btrfsck can still repair it to a mountable
>>>>>> status.
>>>>>> (And normal rw should also be OK,)
>>>>>>
>>>>>> The remaining unfixable problems will be inode nbytes error with file
>>>>>> extent discounts error, which may be fixed in next patchset.
>>>>>>
>>>>>> Cc David:
>>>>>> Sorry for the huge change in the patchset and merge the old inode nlink
>>>>>> repair with new inode item rebuild patchset.
>>>>> No problem, the incremental changelogs helped a lot.
>>>>>
>>>>>> Since when developing inode item rebuild patchset, I found the old
>>>>>> nlink
>>>>>> cooperated very bad with item rebuild and there is some duplicated
>>>>>> codes
>>>>>> between the two patchset, no to mention the math lib introduced by
>>>>>> nlink
>>>>>> repair patch.
>>>>>> So I decided to somewhat rebase the nlink repair patchset to provide
>>>>>> better generality.
>>>>> Great, the patchset looks good for merge, I'm adding it to 3.18. From
>>>>> now on please send only incremental changes and not the whole patchset.
>>>>> Thanks.
>>>> Thanks, this should be the last large update patchset.
>>>> Later work will focus on file extent recovery and should not interfere
>>>> with
>>>> this patch.
>>>>
>>>> Thanks.
>>>> Qu
>>> Can we please get some tests too?
>>> Add some broken fs images, document what is broken and the expected
>>> result after running the repair code (besides verifying the repair
>>> worked for every single inode of course)...
>>>
>>> thanks
>> Tests are definitely needed, I tested this by randomly corrupt a leaf of
>> fstree, which contains contents of my /etc,
>> and run repair.
>>
>> But the problem is that, we can't add tests like other btrfsck using
>> btrfs-image dump, since it will fail to dump
>> a btree-broken btrfs.
>> And if we add test image directly, it may takes up several MB as a binary
>> image dump.
>>
>> Any good idea about how to add test case without btrfs-image support?
> Very simple solution.
>
> Do:
>
> 1) Create an empty file;
> 2) Use it as the backing file for a loop device;
> 3) Run mkfs.btrfs against the loop device;
> 4) Mount it;
> 5) Populate the fs;
> 6) Umount it;
> 7) Corrupt some nodes or leafs (by zeroing them out for e.g.);
> 8) Create a tarball from the backing file like this: ZX_OPT=-9 tar
> cJSvf foobar.tar.xz run.sh backing_file
> 9) Add the tarball to the fsck-tests directory;
> 10) Make the test run fsck against the backing file extracted from the
> tarball - fsck can operate against regular files, and not only against
> devices.
>
> I did that a couple months ago, see:
>
> http://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git/tree/tests/fsck-tests.sh?h=v3.17.x#n30
>
> Exactly because for some kinds of damage in a filesystem btrfs-image won't work.
>
> Thanks.
Oh, thanks for pointing out the fact that btrfs-progs tests can handle 
raw dump image.

I'll try to pick some good size image for it.
(Currently I use 1G file for test, I must find a smaller one)

Thanks,
Qu
>> Thanks,
>> Qu
>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>
>


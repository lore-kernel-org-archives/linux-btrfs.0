Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63329 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751125AbbIXG36 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 02:29:58 -0400
Subject: Re: [PATCH 0/4] btrfs: update qgroups in drop snapshot
To: Mark Fasheh <mfasheh@suse.de>
References: <1442952948-21389-1-git-send-email-mfasheh@suse.de>
 <20150922211251.GA17854@wotan.suse.de> <5602031A.1080905@cn.fujitsu.com>
 <20150923214926.GD17854@wotan.suse.de>
CC: <linux-btrfs@vger.kernel.org>, <jbacik@fb.com>, <clm@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5603985A.1020701@cn.fujitsu.com>
Date: Thu, 24 Sep 2015 14:29:46 +0800
MIME-Version: 1.0
In-Reply-To: <20150923214926.GD17854@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2015/09/23 14:49 -0700:
> On Wed, Sep 23, 2015 at 09:40:42AM +0800, Qu Wenruo wrote:
>> Thanks for all your work on this.
>> Comment on test case is inlined below.
>
> No problem, thanks for the review Qu!
>
>
>>> +# Create an fs tree of a given height at a target location. This is
>>> +# done by agressively creating inline extents to expand the number of
>>> +# nodes required. We also add an traditional extent so that
>>> +# drop_snapshot is forced to walk at least one extent that is not
>>> +# stored in metadata.
>>> +#
>>> +# NOTE: The ability to vary tree height for this test is very useful
>>> +# for debugging problems with drop_snapshot(). As a result we retain
>>> +# that parameter even though the test below always does level 2 trees.
>>> +_explode_fs_tree () {
>>> +    local level=$1;
>>> +    local loc="$2";
>>> +    local bs=4095;
>>> +    local cnt=1;
>>> +    local n;
>>> +
>>> +    if [ -z $loc ]; then
>>> +	echo "specify location for fileset"
>>> +	exit 1;
>>> +    fi
>>> +
>>> +    case $level in
>>> +	1)# this always reproduces level 1 trees
>>> +	    n=10;
>>
>> I'd prefer a more accurate calculation based on nodesize.
>> That would allow using any possible nodesize.
>
> How do we query nodesize? 'btrfs fi show' doesn't seem to give it.

Duncan provided 'btrfs-show-super', that's one possible method.
Although you will need to grep output from it.

But the problem is, why you need to query nodesize?
As in the testcase, the nodesize is given by yourself, just a new 
parameter should handle it.

>
>
> But yeah in theory that sounds nice, I can certainly try it out. I'm not
> really sure how complicated we want this whole function to be though. Right
> now it should always work on all platforms.
>

Yeah, your immediate number is OK, I'd just like to put it to a minimum.
And hope to make such test fast enough to be in 'quick' group.

>
>> For example for $nodesize larger than 4K
>> l1_min_n = int(($nodesize - 101) / (4095 + 21 + 17)) + 1
>>
>> And for 4K nodesize,
>> 2 2K inline extent will cause the fs_tree to be 2 level.
>> As 4K nodeize won't allow 4095 inline extent length.
>>
>> 101 is sizeof(struct btrfs_header).
>> So $nodesize - 101 is the available space for a leaf.
>> And 4095 is the maximum inline extent length, 21 is the inline
>> file_extent header length,offsetof(struct btrfs_file_extent_item,
>> disk_bytenr).
>> 17 is sizeof(struct btrfs_disk_key).
>>
>> Above is the maximum value in theory, in fact leaf will be split
>> more early than hitting the number.
>> So the max_n should be good enough to create desired tree level, and
>> make script run a little faster.
>>
>>> +	    ;;
>>> +	2)# this always reproduces level 2 trees
>>> +	    n=1500
>> For level 2 and higher tree, it will be
>> l2_min_n = l1_min_n * (($nodesize - 101) / 33 +1) ^ ($level - 1)
>>
>> 101 is still header size.
>> 33 is sizeof(struct btrfs_key_ptr)
>>
>>> +	    ;;
>>> +	3)# this always reproduces level 3 trees
>>> +	    n=1000000;
>>> +	    ;;
>>> +	*)
>>> +	    echo "Can't make level $level trees";
>>> +	    exit 1;
>>> +	    ;;
>>> +    esac
>>> +
>>> +    mkdir -p $loc
>>> +    for i in `seq -w 1 $n`;
>>> +    do
>>> +	dd status=none if=/dev/zero of=$loc/file$i bs=$bs count=$cnt
>>> +    done
>>> +
>>> +    bs=131072
>>> +    cnt=1
>>> +    dd status=none if=/dev/zero of=$loc/extentfile bs=$bs count=$cnt
>>> +}
>>> +
>>> +# Force the default leaf size as the calculations for making our btree
>>> +# heights are based on that.
>>> +run_check _scratch_mkfs "--nodesize 16384"
>>
>> When using given nodesize, it's better to consider other arch like
>> AA64 or other arch which support 64K pagesize.
>> (btrfs doesn't support subpage size nodesize, which means if using
>> nodesize smaller than pagesize, it won't be mounted)
>>
>> I got informed several times when submitting qgroup related test case.
>> See btrfs/017 and btrfs/091.
>>
>> But on the other hand, using 64K nodesize is somewhat overkilled and
>> will make the test takes more time.
>>
>> If it's OK to ignore 64K pagesize case, I'd prefer to use 4K
>> nodesize, which will be much faster to create fs tree with 2~3
>> levels.
>
> Right, so 64K nodesize is the most 'compatible' nodesize.
>
>
>>> +_scratch_mount
>>> +
>>> +# populate the default subvolume and create a snapshot ('snap1')
>>> +_explode_fs_tree 1 $SCRATCH_MNT/files
>>> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap1
>>> +
>>> +# create new btree nodes in this snapshot. They will become shared
>>> +# with the next snapshot we create.
>>> +_explode_fs_tree 1 $SCRATCH_MNT/snap1/files-snap1
>>> +
>>> +# create our final snapshot ('snap2'), populate it with
>>> +# exclusively owned nodes.
>>> +#
>>> +# As a result of this action, snap2 will get an implied ref to the
>>> +# 128K extent created in the default subvolume.
>>> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2
>>> +_explode_fs_tree 1 $SCRATCH_MNT/snap2/files-snap2
>>> +
>>> +# Enable qgroups now that we have our filesystem prepared. This
>>> +# will kick off a scan which we will have to wait for.
>>> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
>>> +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
>>> +
>>> +# Remount to clear cache, force everything to disk
>>> +_scratch_unmount
>>> +_scratch_mount
>>
>> Is there anything special that needs to use umount/mount other than sync?
>
> A couple times now it's been to my advantage to force btrfs to reread the
> file trees. It might not be strictly necessary any more.
>
>
>>> +# Finally, delete snap1 to trigger btrfs_drop_snapshot(). This
>>> +# snapshot is most interesting to delete because it will cause some
>>> +# nodes to go exclusively owned for snap2, while some will stay shared
>>> +# with the default subvolume. That exercises a maximum of the drop
>>> +# snapshot/qgroup interactions.
>>> +#
>>> +# snap2s imlied ref from to the 128K extent in files/ can be lost by
>>> +# the root finding code in qgroup accounting due to snap1 no longer
>>> +# providing a path to it. This was fixed by the first two patches
>>> +# referenced above.
>>> +_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap1
>>> +
>>> +# There is no way from userspace to force btrfs_drop_snapshot to run
>>> +# at a given time (even via mount/unmount). We must wait for it to
>>> +# start and complete. This is the shortest time on my tests systems I
>>> +# have found which always allows drop_snapshot to run to completion.
>>> +sleep 45
>>
>> Does "btrfs subv delete -c" help here?
>
> Unfortunately not :( We need to wait for drop_snapshot() to get run. That
> flag (from memory) just waits for the initial orphaning transaction to
> finish.

Too sad. :(
Also pointed out by Dave Chinner, if use such immediate number to wait, 
it may not be reproducible on other systems.

>
>
>>> +
>>> +_scratch_unmount
>>> +
>>> +# generate a qgroup report and look for inconsistent groups
>>> +#  - don't use _run_btrfs_util_prog here as it captures the output and
>>> +#    we need to grep it.
>>> +$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV 2>&1 | grep -E -q "Counts for qgroup.*are different"
>>> +if [ $? -ne 0 ]; then
>>> +    status=0
>>> +fi
>> Quite a nice idea to use btrfsck to check qgroup validation.
>>
>> But I don't see the reason not to use _run_btrfS_util_progs, as I
>> don't think it's needed to grep.
>>
>> If there is a bug in return value of btrfsck, then I'm OK with it as
>> a workaround.
>>
>> But if btrfsck --qgroup-report will return non-zero when it finds a
>> qgroup mismatch, I think is better to just call
>> _run_btrfs_util_prog, as it has judgment for return value check.
>
> btrfsck --qgroup-report returns zero unless there was an issue generating
> the report so the grep there is the only way to catch this consistently.

Oh, that's another btrfsck bug to fix.
Quite a lot of return value bugs are still in btrfsck codes.

Thanks,
Qu

>
> Thanks again,
> 	--Mark
>
> --
> Mark Fasheh
>

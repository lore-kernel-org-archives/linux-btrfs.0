Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28408 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaBJVk1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 16:40:27 -0500
Message-ID: <52F9473E.4000209@oracle.com>
Date: Mon, 10 Feb 2014 22:40:14 +0100
From: Koen De Wit <koen.de.wit@oracle.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>, jbacik@fb.com
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: Btrfs: add test for large metadata blocks
References: <1391793285-935-1-git-send-email-koen.de.wit@oracle.com> <20140207224934.GH13647@dastard> <52F5EB3B.5030902@oracle.com> <20140209230259.GK13647@dastard>
In-Reply-To: <20140209230259.GK13647@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/10/2014 12:02 AM, Dave Chinner wrote:
> On Sat, Feb 08, 2014 at 09:30:51AM +0100, Koen De Wit wrote:
>> On 02/07/2014 11:49 PM, Dave Chinner wrote:
>>> On Fri, Feb 07, 2014 at 06:14:45PM +0100, Koen De Wit wrote:
>>> 	echo -n "$xattr_value" | md5sum
>>> 	${ATTR_PROG} -Lq -s attr_$char -V $xattr_value $file
>>> 	${ATTR_PROG} -Lq -g attr_$char $file | md5sum
>>> 	${ATTR_PROG} -Lq -g attr_$char $lnkfile | md5sum
>>>
>>> is all that neds to be done here.
>> The problem with this is that the length of the output will depend on the page size. The code above runs for every valid leafsize, which can be any multiple of the page size up to 64KB, as defined in the loop initialization:
>>      for leafsize in `seq $pagesize_kb $pagesize_kb 64`; do
> That's only a limit on the mkfs leafsize parameter, yes? An the
> limiation is that the leaf size can't be smaller than page size?
>
> So really, the attribute sizes that are being tested are independent
> of the mkfs parameters being tested. i.e:
>
> 	for attrsize in `seq 4 4 64`; do
> 		if [ $attrsize -lt $pagesize ]; then
> 			leafsize=$pagesize
> 		else
> 			leafsize=$attrsize
> 		fi
> 		$BTRFS_MKFS_PROG -l $leafsize $SCRATCH_DEV
>
> And now the test executes a fixed loop, testing the same attribute
> sizes on all the filesystems under test. i.e. the attribute sizes
> being tested are *independent* of the mkfs parameters being tested.
> Always test the same attribute sizes, the mkfs parameters simply
> vary by page size.

OK, thanks for the suggestion!  I implemented it like this in v3, I just changed the calculation of the leafsize because it must be a multiple of the pagesize. (A leafsize of 12KB is not valid for systems with 8KB pages.)

>>>> +_scratch_unmount + +# Some illegal leafsizes + +_scratch_mkfs
>>>> -l 0 2>> $seqres.full +echo $?
>>> Same again - you are dumping the error output into a different
>>> file, then detecting the error manually. pass the output of
>>> _scratch_mkfs through a filter, and let errors cause golden
>>> output mismatches.
>> I did this to make the golden output not depend on the output of
>> mkfs.btrfs, inspired by
>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=commit;h=fd7a8e885732475c17488e28b569ac1530c8eb59
>> and
>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=commit;h=78d86b996c9c431542fdbac11fa08764b16ceb7d
>> However, in my opinion the test should simply be updated if the
>> output of mkfs.btrfs changes, so I agree with you and I fixed this
>> in v2.
> While I agree with the sentiment, I'm questioning the
> implementation. i.e. you've done this differently to every other
> test that needs to check for failures. run_check woul dbe just
> fine, as would be simply filtering the output of mkfs.

run_check will make the test fail if the return code differs from 0, and Josef brought up an example scenario (MKFS_OPTIONS="-O skinny-metadata") where mkfs.btrfs produces additional output.

In v3, I implemented the failure check similar to btrfs/022:

         _scratch_mkfs -l $1 >>$seqres.full 2>&1
         [ $? -ne 0 ] || _fail "'$1' is an illegal value for the" \
                 "leafsize option, mkfs should have failed."

Is this the right way?


Thanks,
Koen.

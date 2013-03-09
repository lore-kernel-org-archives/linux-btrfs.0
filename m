Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47729 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3CIRso (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Mar 2013 12:48:44 -0500
Message-ID: <513B75FB.7050905@sandeen.net>
Date: Sat, 09 Mar 2013 11:48:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Koen De Wit <koen.de.wit@oracle.com>
CC: xfs@oss.sgi.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: xfstests: 299: moving and deleting sparse copies on btrfs
References: <50F9C324.5010502@oracle.com> <513B75CD.2050400@sandeen.net>
In-Reply-To: <513B75CD.2050400@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/9/13 11:47 AM, Eric Sandeen wrote:
> On 1/18/13 3:48 PM, Koen De Wit wrote:
>> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
> 
> same comments as the others; looks good otherwise.

(whoops, cc: btrfs list)

> -Eric
> 
>> ---
>> 299     |   69 
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   299.out |    4 +++
>>   2 files changed, 73 insertions(+), 0 deletions(-)
>>   create mode 100644 299
>>   create mode 100644 299.out
>>
>> diff --git a/299 b/299
>> new file mode 100644
>> index 0000000..0ddb022
>> --- /dev/null
>> +++ b/299
>> @@ -0,0 +1,69 @@
>> +#! /bin/bash
>> +# FS QA Test No. 299
>> +#
>> +# Moving and deleting cloned ("reflinked") files on btrfs:
>> +#   - Create a file and a reflink
>> +#   - Move both to a directory
>> +#   - Delete the original (moved) file, check that the copy still exists.
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2013, Oracle and/or its affiliates.  All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#-----------------------------------------------------------------------
>> +#
>> +# creator
>> +owner=koen.de.wit@oracle.com
>> +
>> +seq=`basename $0`
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1    # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +    cd /
>> +    rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common.rc
>> +. ./common.filter
>> +
>> +# real QA test starts here
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +
>> +_require_cp_reflink
>> +
>> +TESTDIR1=$TEST_DIR/test-$seq.$$
>> +mkdir $TESTDIR1
>> +
>> +$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original > /dev/null
>> +cp --reflink $TESTDIR1/original $TESTDIR1/copy
>> +mkdir $TESTDIR1/subdir
>> +mv $TESTDIR1/original $TESTDIR1/subdir/original_moved
>> +mv $TESTDIR1/copy $TESTDIR1/subdir/copy_moved
>> +md5sum $TESTDIR1/subdir/original_moved | $AWK_PROG 'END {print $1}'
>> +md5sum $TESTDIR1/subdir/copy_moved | $AWK_PROG 'END {print $1}'
>> +rm $TESTDIR1/subdir/original_moved
>> +md5sum $TESTDIR1/subdir/copy_moved | $AWK_PROG 'END {print $1}'
>> +rm -rf $TESTDIR1/subdir
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/299.out b/299.out
>> new file mode 100644
>> index 0000000..f06eb2b
>> --- /dev/null
>> +++ b/299.out
>> @@ -0,0 +1,4 @@
>> +QA output created by 299
>> +42d69d1a6d333a7ebdf64792a555e392
>> +42d69d1a6d333a7ebdf64792a555e392
>> +42d69d1a6d333a7ebdf64792a555e392
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


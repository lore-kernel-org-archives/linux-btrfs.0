Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab3JWRpN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 13:45:13 -0400
Message-ID: <52680B23.9020604@redhat.com>
Date: Wed, 23 Oct 2013 12:45:07 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>, Eryu Guan <eguan@redhat.com>,
        xfs@oss.sgi.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] xfstests btrfs/020: test device replace on RO btrfs
References: <1382527446-16053-1-git-send-email-eguan@redhat.com> <1382546683-454-1-git-send-email-eguan@redhat.com> <526801EF.8030307@giantdisaster.de>
In-Reply-To: <526801EF.8030307@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/23/13 12:05 PM, Stefan Behrens wrote:
> On Thu, 24 Oct 2013 00:44:43 +0800, Eryu Guan wrote:
>> btrfs replace on readonly fs should not be allowed.
>>
>> Regression test case for commit:
>> bbb651e Btrfs: don't allow the replace procedure on read only filesystems
>>
>> Signed-off-by: Eryu Guan <eguan@redhat.com>
>> ---
>> v2: Address Eric's review
>>  - use truncate to create fs image instead of writing to each file
>>
>>  tests/btrfs/020     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/020.out |  2 ++
>>  tests/btrfs/group   |  1 +
>>  3 files changed, 87 insertions(+)
>>  create mode 100755 tests/btrfs/020
>>  create mode 100644 tests/btrfs/020.out
>>
>> diff --git a/tests/btrfs/020 b/tests/btrfs/020
>> new file mode 100755
>> index 0000000..7464bd0
>> --- /dev/null
>> +++ b/tests/btrfs/020
>> @@ -0,0 +1,84 @@
>> +#! /bin/bash
>> +# FS QA Test No. btrfs/020
>> +#
>> +# btrfs device replace test on RO fs
>> +#
>> +# Regression test for commit:
>> +# bbb651e Btrfs: don't allow the replace procedure on read only filesystems
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
>> +#
>> +#-----------------------------------------------------------------------
>> +#
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +
>> +status=1	# failure is the default!
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -f $tmp.*
>> +	$UMOUNT_PROG $loop_mnt
>> +	_destroy_loop_device $loop_dev1
>> +	losetup -d $loop_dev2 >/dev/null 2>&1
>> +	_destroy_loop_device $loop_dev3
>> +	rm -rf $loop_mnt
>> +	rm -f $fs_img1 $fs_img2 $fs_img3
>> +}
>> +
>> +trap "_cleanup ; exit \$status" 0 1 2 3 15
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +_supported_fs btrfs
>> +_supported_os Linux
> 
> It is still unclear to me why everybody adds this "_supported_os Linux"
> to the Btrfs tests. Is it because loop devices are used in this
> particular test btrfs/020 or is it because of Btrfs itself?
> tests/btrfs/001..010 and tests/btrfs/012..020 contain the "_supported_os
> Linux".

Historically xfstests could be run on IRIX & Linux, so some tests needed
to differentiate for the capabilities of the OS.

We could probably look at how _supported_os works, and make sure that
if it's absent, it means "no OS restrictions" and document it as such.

"_supported_fs btrfs" is probably sufficient to know that we can run this
test; if btrfs is ever ported to, say, Solaris, it *should* run there too.  ;)

-Eric


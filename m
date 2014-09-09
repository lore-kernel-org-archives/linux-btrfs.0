Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53805 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbaIIPlk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Sep 2014 11:41:40 -0400
Message-ID: <540F1FB6.1070506@sandeen.net>
Date: Tue, 09 Sep 2014 10:41:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>, Eryu Guan <eguan@redhat.com>
CC: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/15 v2] btrfs: new test to run btrfs balance and subvolume
 test simultaneously
References: <1409233676-22787-1-git-send-email-eguan@redhat.com> <1409233676-22787-2-git-send-email-eguan@redhat.com> <20140908100127.GF30012@dastard>
In-Reply-To: <20140908100127.GF30012@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/8/14 5:01 AM, Dave Chinner wrote:
> On Thu, Aug 28, 2014 at 09:47:42PM +0800, Eryu Guan wrote:
>> Run btrfs balance and subvolume create/mount/umount/delete simultaneously,
>> with fsstress running in background.
>>
>> Signed-off-by: Eryu Guan <eguan@redhat.com>
>> ---
>>   common/rc           |  24 ++++++++++
>>   tests/btrfs/059     | 129 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/059.out |   2 +
>>   tests/btrfs/group   |   1 +
>>   4 files changed, 156 insertions(+)
>>   create mode 100755 tests/btrfs/059
>>   create mode 100644 tests/btrfs/059.out
>>
>> diff --git a/common/rc b/common/rc
>> index 16da898..c1a7b9e 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -2375,6 +2375,30 @@ _get_free_inode()
>>   	echo $nr_inode
>>   }
>>
>> +_btrfs_stress_balance()
>> +{
>> +	local btrfs_mnt=$1
>> +	while true; do
>> +		$BTRFS_UTIL_PROG balance start $btrfs_mnt
>> +	done
>> +}
>> +
>> +_btrfs_stress_subvolume()
>> +{
>> +	local btrfs_dev=$1
>> +	local btrfs_mnt=$2
>> +	local subvol_name=$3
>> +	local subvol_mnt=$4
>> +
>> +	mkdir -p $subvol_mnt
>> +	while true; do
>> +		$BTRFS_UTIL_PROG subvolume create $btrfs_mnt/$subvol_name
>> +		$MOUNT_PROG -o subvol=$subvol_name $btrfs_dev $subvol_mnt
>> +		$UMOUNT_PROG $subvol_mnt
>> +		$BTRFS_UTIL_PROG subvolume delete $btrfs_mnt/$subvol_name
>> +	done
>> +}
>> +
>
> I'm thinking that we need to start separating common/rc in
> filesystem specific include files. Not necessary for this series,
> but we really need to so using this file as a dumping ground for
> shared code rather than for init and config stuff.
>
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -fr $tmp.*
>> +}
>
> Really dangerous, that. if $tmp is empty, then that will remove
> everything under / (i.e. 'cd /; rm -rf .*'). You shouldn't be using
> subdirs under $tmp - if you need lots of temporary data for the
> test, it should be under $TESTDIR, not on the root filesystem.

FWIW, there are a several other tests which do this, at least:

tests/generic/003-1356-    cd /
tests/generic/003:1365:    rm -rf $tmp.*

tests/generic/273-1120-	cd /
tests/generic/273:1126:	rm -rf $tmp.*

tests/generic/320-1280-	cd /
tests/generic/320:1286:	rm -rf $tmp.*

tests/xfs/287-1248-	cd /
tests/xfs/287-1254-	umount $SCRATCH_MNT 2>/dev/null
tests/xfs/287:1287:	rm -rf $tmp.*

Should probably clean those up for safety and to avoid further cut and paste ...

-Eric

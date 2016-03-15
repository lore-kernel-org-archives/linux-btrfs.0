Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37039 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750912AbcCOB0j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 21:26:39 -0400
Subject: Re: [PATCH v4 0/6] Btrfs in-band de-duplication test cases
To: "Darrick J. Wong" <darrick.wong@oracle.com>
References: <1457512424-9215-1-git-send-email-quwenruo@cn.fujitsu.com>
 <56E66EBF.8000105@cn.fujitsu.com> <20160314172430.GA5769@birch.djwong.org>
CC: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56E7642D.6030607@cn.fujitsu.com>
Date: Tue, 15 Mar 2016 09:23:57 +0800
MIME-Version: 1.0
In-Reply-To: <20160314172430.GA5769@birch.djwong.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Darrick J. Wong wrote on 2016/03/14 10:24 -0700:
> On Mon, Mar 14, 2016 at 03:56:47PM +0800, Qu Wenruo wrote:
>> Please don't merge this patchset.
>>
>> As the there is some naming undecided recently.
>>
>> The abbreviation 'dedup' may be changed to 'dedupe'.
>> I'll update them when all related parts is settled down.
>
> There's already a 'dedupe' group in xfstests for testing the out-of-band ioctl
> that duperemove uses.  I wondered if that factored into your decision to use
> 'dedup' as the group name for the inband tests.

Not exactly. The largest reason I chose 'dedup' is that zfs uses the 
same abbreviation.
(And I forgot other kernel part is already using 'dedupe')

Although I did want to make some difference with out-of-band dedupe, but 
the extra 'e' is not distinguishable enough.


And since btrfs community choose to use 'dedupe' and kernel conversion 
is already done, it has already affected the test cases.
For example, since new kernel uses 'dedupe' in /sys/fs/btrfs/features/, 
old "_require_btrfs_fs_feature dedup" will just fail and skipped the 
test case.

>
> Seeing as other filesystems are beginning to support the OOB ioctls and might
> never support the in-band stuff btrfs is doing, what do people think about
> keeping the out-of and in-band dedup tests in separate groups to make it clear
> which dedupe feature each test is aiming to validate?

This is a good idea.
IMHO it can be done by changing group naming only.
Like naming inband dedupe group to "inband_dedupe" instead of current 
"dedupe"? (OOB not touched and uses the old "dedupe")


BTW, if I understand it right, for a fs to support OOB ioctl, the fs 
must support CoW.
And if a fs support CoW, it's not that hard to implement inband dedupe.
Btrfs just adds about 2K lines to implement it.
If removing btrfs specific on-disk backend related codes, it would be 
about 1K ~ 1.5K new lines.
(Yes, btrfs inband dedupe supports 2 different hash storage backends)

Thanks,
Qu

>
> There's no technical requirement to do this since we can always add feature
> tests if the inband tests ever become generic, but I do see value in being able
> to test one interface without having the tests for the other interface piling
> on the output (and being able to tell which interface at a glance).
>
> --D
>
>>
>> Thanks,
>> Qu
>>
>>
>> Qu Wenruo wrote on 2016/03/09 16:33 +0800:
>>> Since we are push btrfs in-band de-duplication for v4.6, it's better to
>>> add test cases for this new feature.
>>>
>>> Except the first basic function test, the rest are all regression test
>>> which we found during the development.
>>> We also found some bugs from the generic test, but we need some fstests
>>> option allowing us to enable dedup for any test case.
>>> (We did it by hack _scratch_mount and _test_mount to enable dedup for
>>> any test case)
>>>
>>> Use the sequence number starts from 200 to avoid any possible conflicts.
>>> The './new' script returns some hole number which is not proper for
>>> such related test case set.
>>> Hopes it's not too hard for maintainer to modify the sequence number.
>>>
>>> v1:
>>>    Btrfs mail list internal use only
>>> v2:
>>>    Add test case 203 to test balance race
>>> v3:
>>>    Follow Dave's comment to use more existing fstest infrastructure.
>>>    Also fix a small bug in the 1st which forgot to remove old macros
>>> v4:
>>>    Enhance test 203 to cover both dedup backend
>>>    Add new test 204, a specific regression test for balance and dedup.
>>>
>>> Qu Wenruo (6):
>>>    fstests: rename _require_btrfs to _require_btrfs_subcommand
>>>    fstests: btrfs: Add basic test for btrfs in-band de-duplication
>>>    fstests: btrfs: Add testcase for btrfs dedup enable disable race test
>>>    fstests: btrfs: Add per inode dedup flag test
>>>    fstests: btrfs: Test inband dedup with balance.
>>>    fstests: btrfs: Test for btrfs dedup tree balance bug
>>>
>>>   common/defrag       |  13 +++++++
>>>   common/rc           |   2 +-
>>>   tests/btrfs/004     |   2 +-
>>>   tests/btrfs/048     |   2 +-
>>>   tests/btrfs/059     |   2 +-
>>>   tests/btrfs/200     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   tests/btrfs/200.out |  21 ++++++++++
>>>   tests/btrfs/201     |  98 ++++++++++++++++++++++++++++++++++++++++++++++
>>>   tests/btrfs/201.out |   2 +
>>>   tests/btrfs/202     | 108 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   tests/btrfs/202.out |  15 ++++++++
>>>   tests/btrfs/203     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   tests/btrfs/203.out |   5 +++
>>>   tests/btrfs/204     |  74 +++++++++++++++++++++++++++++++++++
>>>   tests/btrfs/204.out |   2 +
>>>   tests/btrfs/group   |   5 +++
>>>   16 files changed, 565 insertions(+), 4 deletions(-)
>>>   create mode 100755 tests/btrfs/200
>>>   create mode 100644 tests/btrfs/200.out
>>>   create mode 100755 tests/btrfs/201
>>>   create mode 100644 tests/btrfs/201.out
>>>   create mode 100755 tests/btrfs/202
>>>   create mode 100644 tests/btrfs/202.out
>>>   create mode 100755 tests/btrfs/203
>>>   create mode 100644 tests/btrfs/203.out
>>>   create mode 100755 tests/btrfs/204
>>>   create mode 100644 tests/btrfs/204.out
>>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32739 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751052AbcGAAV4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 20:21:56 -0400
Subject: Re: [PATCH v5 0/4] Btrfs in-band de-duplication test cases
To: Mark Fasheh <mfasheh@suse.de>
References: <20160630092439.27693-1-quwenruo@cn.fujitsu.com>
 <20160630185553.GA26224@wotan.suse.de>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <46ff6e94-aeae-c649-4844-d25d346955b3@cn.fujitsu.com>
Date: Fri, 1 Jul 2016 08:21:49 +0800
MIME-Version: 1.0
In-Reply-To: <20160630185553.GA26224@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not yet.

This is for btrfs internal review.
Since I'm still not sure if current ioctl is settled.

Until ioctl interface and user-tools command are settled, such test 
cases won't be sent to fstests.

Thanks,
Qu

At 07/01/2016 02:55 AM, Mark Fasheh wrote:
> Hi Qu, you might want to CC fstests@vger.kernel.org on these patches.
>
> Thanks,
> 	--Mark
>
> On Thu, Jun 30, 2016 at 05:24:35PM +0800, Qu Wenruo wrote:
>> Btrfs in-band de-duplication test case for in-memory backend.
>>
>> v5:
>>   Due to kernel ioctl change, add FORCE flag for "dedupe enable" ioctl call.
>> v4:
>>   Due to kernel patchset re-organization, remove on-disk backend test cases
>> v3:
>>   Add new test cases for on-disk backend with metadata balance
>> v2:
>>   Add new test cases for on-disk backend with full balance
>>
>>
>> Qu Wenruo (4):
>>   fstests: rename _require_btrfs to _require_btrfs_subcommand
>>   fstests: btrfs: Add basic test for btrfs in-band de-duplication
>>   fstests: btrfs: Add testcase for btrfs dedupe and metadata balance
>>     race test
>>   fstests: btrfs: Test inband dedupe with data balance.
>>
>>  common/defrag       |  13 ++++++
>>  common/rc           |   2 +-
>>  tests/btrfs/004     |   2 +-
>>  tests/btrfs/048     |   2 +-
>>  tests/btrfs/059     |   2 +-
>>  tests/btrfs/200     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/200.out |  22 ++++++++++
>>  tests/btrfs/201     | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/201.out |   2 +
>>  tests/btrfs/203     | 110 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/203.out |   3 ++
>>  tests/btrfs/group   |   3 ++
>>  12 files changed, 385 insertions(+), 4 deletions(-)
>>  create mode 100755 tests/btrfs/200
>>  create mode 100644 tests/btrfs/200.out
>>  create mode 100755 tests/btrfs/201
>>  create mode 100644 tests/btrfs/201.out
>>  create mode 100755 tests/btrfs/203
>>  create mode 100644 tests/btrfs/203.out
>>
>> --
>> 2.9.0
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> Mark Fasheh
>
>



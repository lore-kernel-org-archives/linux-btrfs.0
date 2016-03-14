Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47538 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754813AbcCNH5C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 03:57:02 -0400
Subject: Re: [PATCH v4 0/6] Btrfs in-band de-duplication test cases
To: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
References: <1457512424-9215-1-git-send-email-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56E66EBF.8000105@cn.fujitsu.com>
Date: Mon, 14 Mar 2016 15:56:47 +0800
MIME-Version: 1.0
In-Reply-To: <1457512424-9215-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please don't merge this patchset.

As the there is some naming undecided recently.

The abbreviation 'dedup' may be changed to 'dedupe'.
I'll update them when all related parts is settled down.

Thanks,
Qu


Qu Wenruo wrote on 2016/03/09 16:33 +0800:
> Since we are push btrfs in-band de-duplication for v4.6, it's better to
> add test cases for this new feature.
>
> Except the first basic function test, the rest are all regression test
> which we found during the development.
> We also found some bugs from the generic test, but we need some fstests
> option allowing us to enable dedup for any test case.
> (We did it by hack _scratch_mount and _test_mount to enable dedup for
> any test case)
>
> Use the sequence number starts from 200 to avoid any possible conflicts.
> The './new' script returns some hole number which is not proper for
> such related test case set.
> Hopes it's not too hard for maintainer to modify the sequence number.
>
> v1:
>    Btrfs mail list internal use only
> v2:
>    Add test case 203 to test balance race
> v3:
>    Follow Dave's comment to use more existing fstest infrastructure.
>    Also fix a small bug in the 1st which forgot to remove old macros
> v4:
>    Enhance test 203 to cover both dedup backend
>    Add new test 204, a specific regression test for balance and dedup.
>
> Qu Wenruo (6):
>    fstests: rename _require_btrfs to _require_btrfs_subcommand
>    fstests: btrfs: Add basic test for btrfs in-band de-duplication
>    fstests: btrfs: Add testcase for btrfs dedup enable disable race test
>    fstests: btrfs: Add per inode dedup flag test
>    fstests: btrfs: Test inband dedup with balance.
>    fstests: btrfs: Test for btrfs dedup tree balance bug
>
>   common/defrag       |  13 +++++++
>   common/rc           |   2 +-
>   tests/btrfs/004     |   2 +-
>   tests/btrfs/048     |   2 +-
>   tests/btrfs/059     |   2 +-
>   tests/btrfs/200     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/200.out |  21 ++++++++++
>   tests/btrfs/201     |  98 ++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/201.out |   2 +
>   tests/btrfs/202     | 108 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/202.out |  15 ++++++++
>   tests/btrfs/203     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/203.out |   5 +++
>   tests/btrfs/204     |  74 +++++++++++++++++++++++++++++++++++
>   tests/btrfs/204.out |   2 +
>   tests/btrfs/group   |   5 +++
>   16 files changed, 565 insertions(+), 4 deletions(-)
>   create mode 100755 tests/btrfs/200
>   create mode 100644 tests/btrfs/200.out
>   create mode 100755 tests/btrfs/201
>   create mode 100644 tests/btrfs/201.out
>   create mode 100755 tests/btrfs/202
>   create mode 100644 tests/btrfs/202.out
>   create mode 100755 tests/btrfs/203
>   create mode 100644 tests/btrfs/203.out
>   create mode 100755 tests/btrfs/204
>   create mode 100644 tests/btrfs/204.out
>



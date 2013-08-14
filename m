Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:47884 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933115Ab3HNWSG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 18:18:06 -0400
Message-ID: <520C023C.5050307@sgi.com>
Date: Wed, 14 Aug 2013 17:18:36 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2] xfstest: add a test for btrfs device replace operation
References: <1375285960-4039-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1375285960-4039-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/31/2013 10:52 AM, Stefan Behrens wrote:
> This test performs btrfs device replace tests with all possible profiles
> (single/dup/mixed/raid0/raid1/raid10), one round with the '-r' option
> to 'btrfs replace start' and one round without this option. The
> cancelation is tested only once and with the dup/single profile for
> metadata/data.
>
> This test takes 181 seconds on my SSD equiped test box and 237s on
> spinning disks. Almost all the time is spent when the filesystem is
> populated with test data. The replace operation itself takes less than
> a second for all the tests, except for the test that is marked as
> 'thorough' which will run for about 8 seconds on my test box.
>
> The amount of tests done depends on the number of devices in the
> SCRATCH_DEV_POOL. For full test coverage, at least 5 devices should
> be available (e.g. 5 partitions). With less than 2 entries in
> SCRATCH_DEV_POOL, the test is not executed.
>
> The source and target devices for the replace operation are arbitrarily
> chosen out of SCRATCH_DEV_POOl. Since the target device mustn't be
> smaller than the source device, the requirement for this test is that
> all devices have _exactly_ the same size. If this is not the case, the
> test terminates with _notrun.
>
> To check the filesystems after replacing a device, a scrub run is
> performed, a btrfsck run, and finally the filesystem is remounted.
>
> This commit depends on my other commit:
> "xfstest: don't remove the two first devices from SCRATCH_DEV_POOL"
>
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
> V1 -> V2:
> Major reworking in order to address all the comments from Eric Sandeen's
> review.
>
>   common/config       |   1 +
>   tests/btrfs/317     | 273 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/317.out |   3 +
>   tests/btrfs/group   |   1 +
>   4 files changed, 278 insertions(+)
>
Hey Stefan,

Thanks for submitting this patch. This patch had not been reviewed 
before I pulled in commit aab6d4e
"xfstests: renumber existing btrfs tests to start with 1"

Will you please rebase this off the current xfstests tree.

Thanks
--Rich



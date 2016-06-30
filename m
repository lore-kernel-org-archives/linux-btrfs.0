Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbcF3S5j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 14:57:39 -0400
Date: Thu, 30 Jun 2016 11:55:53 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 0/4] Btrfs in-band de-duplication test cases
Message-ID: <20160630185553.GA26224@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20160630092439.27693-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160630092439.27693-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu, you might want to CC fstests@vger.kernel.org on these patches.

Thanks,
	--Mark

On Thu, Jun 30, 2016 at 05:24:35PM +0800, Qu Wenruo wrote:
> Btrfs in-band de-duplication test case for in-memory backend.
> 
> v5:
>   Due to kernel ioctl change, add FORCE flag for "dedupe enable" ioctl call.
> v4:
>   Due to kernel patchset re-organization, remove on-disk backend test cases
> v3:
>   Add new test cases for on-disk backend with metadata balance
> v2:
>   Add new test cases for on-disk backend with full balance
> 
> 
> Qu Wenruo (4):
>   fstests: rename _require_btrfs to _require_btrfs_subcommand
>   fstests: btrfs: Add basic test for btrfs in-band de-duplication
>   fstests: btrfs: Add testcase for btrfs dedupe and metadata balance
>     race test
>   fstests: btrfs: Test inband dedupe with data balance.
> 
>  common/defrag       |  13 ++++++
>  common/rc           |   2 +-
>  tests/btrfs/004     |   2 +-
>  tests/btrfs/048     |   2 +-
>  tests/btrfs/059     |   2 +-
>  tests/btrfs/200     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/200.out |  22 ++++++++++
>  tests/btrfs/201     | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/201.out |   2 +
>  tests/btrfs/203     | 110 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/203.out |   3 ++
>  tests/btrfs/group   |   3 ++
>  12 files changed, 385 insertions(+), 4 deletions(-)
>  create mode 100755 tests/btrfs/200
>  create mode 100644 tests/btrfs/200.out
>  create mode 100755 tests/btrfs/201
>  create mode 100644 tests/btrfs/201.out
>  create mode 100755 tests/btrfs/203
>  create mode 100644 tests/btrfs/203.out
> 
> -- 
> 2.9.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
Mark Fasheh

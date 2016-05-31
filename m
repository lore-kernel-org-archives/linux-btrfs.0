Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbcEaTvo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 15:51:44 -0400
Date: Tue, 31 May 2016 12:51:42 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: add test for qgroup handle de-refer
Message-ID: <20160531195142.GA7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1464660234-14562-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464660234-14562-1-git-send-email-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for this test.

On Tue, May 31, 2016 at 10:03:54AM +0800, Lu Fengqi wrote:
> +echo "Start balance" >>$seqres.full
> +_btrfs_stress_balance -d $SCRATCH_MNT >/dev/null 2>&1 &
> +balance_pid=$!
> +
> +# 30s is enough to trigger bug
> +sleep $((30*$TIME_FACTOR))
> +kill $fsstress_pid $balance_pid
> +wait
> +
> +# kill _btrfs_stress_balance can't end balance, so call btrfs balance cancel
> +# to cancel running or paused balance.
> +$BTRFS_UTIL_PROG balance cancel $SCRATCH_MNT &> /dev/null
> +
> +rm -rf $SCRATCH_MNT/*
> +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
> +units=`_btrfs_qgroup_units`
> +$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' | \
> +	$AWK_PROG '{print $2" "$3}'

Wouldn't it be better here to just have btrfsck check for inconsistencies?
If you look at tests/btrfs/122 this is what I mean:

+# generate a qgroup report and look for inconsistent groups
+$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV 2>&1 | \
+                       grep -q -E "Counts for qgroup.*are different"
+if [ $? -ne 0 ]; then
+       status=0
+fi

That way we're not keying on some specific value showing up but instead that
qgroup validation passes (which is really what we want to test).

Thanks,
	--Mark

--
Mark Fasheh

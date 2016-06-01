Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48844 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755805AbcFADaX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 23:30:23 -0400
Subject: Re: [PATCH] fstests: btrfs: add test for qgroup handle de-refer
To: Mark Fasheh <mfasheh@suse.de>
References: <1464660234-14562-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160531195142.GA7633@wotan.suse.de>
CC: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
From: luke <lufq.fnst@cn.fujitsu.com>
Message-ID: <cd4858fc-3b41-d23d-ff1d-0cc9ed1a4bc7@cn.fujitsu.com>
Date: Wed, 1 Jun 2016 11:30:08 +0800
MIME-Version: 1.0
In-Reply-To: <20160531195142.GA7633@wotan.suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/01/2016 03:51 AM, Mark Fasheh wrote:
> Thanks for this test.
>
> On Tue, May 31, 2016 at 10:03:54AM +0800, Lu Fengqi wrote:
>> +echo "Start balance" >>$seqres.full
>> +_btrfs_stress_balance -d $SCRATCH_MNT >/dev/null 2>&1 &
>> +balance_pid=$!
>> +
>> +# 30s is enough to trigger bug
>> +sleep $((30*$TIME_FACTOR))
>> +kill $fsstress_pid $balance_pid
>> +wait
>> +
>> +# kill _btrfs_stress_balance can't end balance, so call btrfs balance cancel
>> +# to cancel running or paused balance.
>> +$BTRFS_UTIL_PROG balance cancel $SCRATCH_MNT &> /dev/null
>> +
>> +rm -rf $SCRATCH_MNT/*
>> +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
>> +units=`_btrfs_qgroup_units`
>> +$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' | \
>> +	$AWK_PROG '{print $2" "$3}'
> Wouldn't it be better here to just have btrfsck check for inconsistencies?
> If you look at tests/btrfs/122 this is what I mean:
>
> +# generate a qgroup report and look for inconsistent groups
> +$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV 2>&1 | \
> +                       grep -q -E "Counts for qgroup.*are different"
> +if [ $? -ne 0 ]; then
> +       status=0
> +fi
>
> That way we're not keying on some specific value showing up but instead that
> qgroup validation passes (which is really what we want to test).
>
> Thanks,
> 	--Mark
>
> --
> Mark Fasheh
>
>
OK, I will try this and update this patch.

Thanks,
Lu



Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4073423EAB3
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 05:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451440; cv=none; b=K8Zbq45bpahMYB9XAYkgIEQ9fWQM612MiiDUWEAkMzgh7FiZixM8Z8ClciZQpu1/MiPh3z1nk3WbCk0FObv6XdaAYLJKNU965LeTKDCpweD/LI+I+OZIv1mKN7WON4C/vBKOD5B+FcZR7pcGUrTp063WbC+BKTe3vs5PLV1Jr68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451440; c=relaxed/simple;
	bh=3e9SiRKcWHS9ChsHVSHF+uM5EEFUbuFlECpo//TqlII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R6TDEz9wi5X+AdXgB8pB3JUEf0x50sGP5D7bYcLxBOh/WBinRjKsVPg3IySdtJBN69hPzcxqTuslN2sqttwJTOzl6UYAoFGyylJ5KalfR3BWxSYd+E43a2KF9/DXA6edW6P+91koEcYejd1Y67ZrsyE2qUH3K4ALdL6pVuDS7Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M9dr2h6C; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M9dr2h6C"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49e6deb520eso37494235e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 22:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789451435; x=1790056235; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=783anirVWONh/oz0xxvDDlSMuGXZraHnSMsLPgRBIkU=;
        b=M9dr2h6CtYrCsOI7fFkEG56kNBetiis0z6yAgzk3PCmZMdPT6P/apurSpwWLswdlqA
         QddXYakklUoUxSjALOhoapATotdOpF45tY54lZCK897i905fz4j+kpKy2c2DV5ibroB5
         HKVAx+MpT/fnd1bOUo0tHESbMhtYzBGa/01DB3VKbuDbQZRR7KuNrdn38dku788QflTO
         CoQspKbaMNDdAdjx6BziQCrArD5CbYYVzXXBvwt0hXnnhgP8xt4anfWpSWNbga6soGnc
         ZLjze11kX6hpHGrOzcVPExQukojE+ZfF2puNwvt9kmh30Z5phFvBt2OMoxL+lu8EpABl
         x73g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789451435; x=1790056235;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=783anirVWONh/oz0xxvDDlSMuGXZraHnSMsLPgRBIkU=;
        b=Uc4FCe71FiUlQENtYOgD81x5ecLQL4fcVGysP63bwc1cqBGMq3wwnedEjiAkPpkIOf
         t9dtipKKGsWaf0k/h7pT1tRCiJgFo1f77G3G35u3zKL5P+G1WTw0tj9At4hukPTVhuaz
         UYATIGLZvH0zd0FEeqNzm978hrAEHs2n83Gpskz3C8Ipj0S9pByEpEfUzvlohHuXq24t
         LJwJDpKuZVuXTX1ZVVU2RTnhFLbdzdUpMRU9kryCECQVhl1bfkcZ3JYTV4xL+BBCospG
         Vy7sCmtnGSiqiPf8y5giC684fPK8ax+2tNsK69xLMsTYkep6Lk/OMD/u+xUS27ePmxmf
         cymw==
X-Gm-Message-State: AFuF++k7YRY+JbM7+dXfpAVMWeY15dLoxmScpWQumpvGP/1y6iEfAZGU
	BSIPRC1rxpHOsYzC4bPRqgUGHJjOelsh054HdANWgsjQu2ZN8GbwpcZaCBbbq/7PxCTrfj1Q/Bw
	cAfQ2z3BSUQ==
X-Gm-Gg: AYBFou0yeRFokUonXWea11no9NDI2kEjDhKsib/azkd5VJSoBrk4SPQYP/23gLEYoV/
	vY0OLt8mpsNcArLltL2XMVz43FDK/mqZRoBAIToDrAI7nRatFhBSnOteEKXzycHtjaQkMprlzgs
	/4F9dlJtkdSfgtdljJmT/H4R+9/oUAW8MARJgaZcIlV36RhXnIOr9UWRto1zrV8YpVLnDZQFeYz
	+qypI0bzJv2OZjtAu/758eMJAJAIWzxipGKK7V1aW6S50F+nIzPCxX39Uyg3NMP5a96p5vICuJd
	w5KrlzVqVw2G97vWEderjn3uY2DvLc1dXv1AX4B+np2nakrnR2o139OWBq+5XlMxQk6NF6pS6dq
	HFda/H1uRcJyqr3AOntsz5qyqTGTqMOkfebm6uNDc5Kb5Rzu2PLENHm6j6cRUTEc0zzZ+t5YQGr
	Js4SrDc6BzII9ajYGSSB8x35Oe78SwqRZ9kwUgDhbpO2z0ddWIkIDUB7l/LKRIj8k=
X-Received: by 2002:a05:600c:6298:b0:49c:dada:f57f with SMTP id 5b1f17b1804b1-49e7a65ce97mr62270465e9.7.1789451435308;
        Mon, 14 Sep 2026 22:50:35 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4e51449sm27225487eec.5.2026.09.14.22.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 22:50:34 -0700 (PDT)
Message-ID: <afd05402-fdc9-47bf-87a0-df37a513b853@suse.com>
Date: Tue, 15 Sep 2026 15:20:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: test qgroup limit handling on fsverity
 rollback
To: Daniel Linjama <daniel@dev.linjama.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
References: <20260915053815.307674-1-daniel@dev.linjama.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20260915053815.307674-1-daniel@dev.linjama.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/15 15:08, Daniel Linjama 写道:
> Test that the subvolume and the filesystem stay writable when an fsverity
> enable and its rollback hit the qgroup limit, and that the subvolume is
> still reachable after a remount with no verity or orphan items left behind.
> 
> This exercises a bug fixed by the kernel patch with subject:
> "btrfs: handle lack of space when cleaning up verity items"
> 
> Assisted-by: LLM
> Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
> ---
>   tests/btrfs/354     | 131 ++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/354.out |   2 +
>   2 files changed, 133 insertions(+)
>   create mode 100755 tests/btrfs/354
>   create mode 100644 tests/btrfs/354.out
> 
> diff --git a/tests/btrfs/354 b/tests/btrfs/354
> new file mode 100755
> index 0000000..e3f6716
> --- /dev/null
> +++ b/tests/btrfs/354
> @@ -0,0 +1,131 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Daniel Linjama.  All Rights Reserved.
> +#
> +# FS QA Test 354
> +#
> +# Test that a failed fsverity enable in a subvolume whose qgroup is at its
> +# limit leaves the filesystem usable.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick qgroup limit verity
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	_restore_fsverity_signatures
> +	rm -f $tmp.*
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/verity
> +
> +# real QA test starts here
> +
> +_require_scratch_verity
> +_require_btrfs_command inspect-internal dump-tree
> +_require_btrfs_command quota

_require_btrfs_command quota rescan -w


> +_require_no_compress
> +_require_scratch_size $((2 * 1024 * 1024))
> +_disable_fsverity_signatures
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: handle lack of space when cleaning up verity items"
> +
> +subv=$SCRATCH_MNT/sub
> +target=$subv/target
> +
> +prepare()
> +{
> +	_scratch_mkfs_verity &>> $seqres.full
> +	_scratch_mount
> +	$BTRFS_UTIL_PROG quota enable $SCRATCH_MNT >> $seqres.full 2>&1
> +	_qgroup_rescan $SCRATCH_MNT >> $seqres.full 2>&1

Use "-w" option, or the rescan may not finish in time before the workload.

> +	_btrfs subvolume create $subv
> +	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT sub)
> +	$BTRFS_UTIL_PROG qgroup limit 200M 0/$subvolid $SCRATCH_MNT >> $seqres.full 2>&1
> +}
> +
> +create_target()
> +{
> +	dd if=/dev/zero of=$target bs=1M count=128 status=none
> +	sync
> +}
> +
> +fill_qgroup()
> +{
> +	local i=0
> +
> +	while dd if=/dev/zero of=$subv/filler.$i bs=1M count=4 status=none 2>/dev/null; do
> +		sync
> +		i=$((i + 1))
> +		[ $i -gt 200 ] && break

This is so hard to read.

Why not just a regular for loop?
And what the point of doing 200 loops?

If you just want to make sure to hit the quota limit, you don't need so 
many loops.
You can just do a 40MiB write (which should fail halfway), sync, retry 
the write until the write failed to write any bytes.

> +	done
> +	sync
> +	echo "fillers written: $i" >> $seqres.full
> +	$BTRFS_UTIL_PROG qgroup show -re $SCRATCH_MNT >> $seqres.full 2>&1
> +}
> +
> +enable_fsverity()
> +{
> +	if _fsv_enable $target >> $seqres.full 2>&1; then
> +		_notrun "could not exhaust the qgroup limit, verity enable succeeded"
> +	fi
> +}
> +
> +check_rollback()
> +{
> +	touch $SCRATCH_MNT/canary 2>> $seqres.full || \
> +		echo "filesystem was forced read-only by the failed verity enable"
> +	if $FSVERITY_PROG measure $target >> $seqres.full 2>&1; then
> +		echo "verity is enabled on the target after a failed enable"
> +	fi
> +}
> +
> +check_remount()
> +{
> +	_scratch_unmount
> +	_try_scratch_mount >> $seqres.full 2>&1 || \
> +		_fail "cannot mount the filesystem after the failed verity enable"
> +	ls $subv >/dev/null 2>> $seqres.full || \
> +		echo "cannot read the subvolume after the failed verity enable"
> +	dd if=$target of=/dev/null bs=1M count=1 status=none 2>> $seqres.full || \
> +		echo "cannot read the target file after the failed verity enable"
> +	_scratch_unmount
> +}
> +
> +check_leftover_items()
> +{
> +	local dump=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t $subvolid $SCRATCH_DEV)
> +	local verity_items=$(echo "$dump" | grep -c 'VERITY_\(DESC\|MERKLE\)_ITEM')
> +	local orphans=$(echo "$dump" | grep -c 'ORPHAN_ITEM')
> +
> +	echo "$dump" >> $seqres.full
> +	[ "$verity_items" -eq 0 ] || \
> +		echo "$verity_items verity items left behind by the failed enable"
> +	[ "$orphans" -eq 0 ] || \
> +		echo "$orphans orphan items left behind by the failed enable"
> +}
> +
> +check_subvol_mount()
> +{
> +	_try_scratch_mount -o subvol=sub >> $seqres.full 2>&1 || \
> +		_fail "cannot mount the quota limited subvolume on its own"
> +}
> +
> +prepare
> +create_target
> +fill_qgroup
> +enable_fsverity
> +check_rollback
> +check_remount
> +check_leftover_items
> +check_subvol_mount
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/354.out b/tests/btrfs/354.out
> new file mode 100644
> index 0000000..8bc7ecf
> --- /dev/null
> +++ b/tests/btrfs/354.out
> @@ -0,0 +1,2 @@
> +QA output created by 354
> +Silence is golden


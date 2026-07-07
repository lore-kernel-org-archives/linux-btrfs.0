Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24337372661;
	Tue,  7 Jul 2026 11:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783422574; cv=none; b=XixMpstmdtWUSmrRkP9/aFWoI7xQUJ50wuxbMAZ0983sFm7nQYrFfmfd8c53FC1x5mlwD8G6U+oUJykfgQVPz9RYOGJ1ro9s/xIE/RTehF0m1C3joTk79Tpz5dMecNGPApdswzjdz4bt7rG07BqlUWcPzHyUWrBGMHGxwnXgdAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783422574; c=relaxed/simple;
	bh=IxDoCG++Zl/an30TuIlHkqFiObjHFAgE0M6So04dHN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=p2Vp2yY30y9IuRjSnKyD5nA1q0l0eZ6q5VoemJtU9PK5ZhQFmOG1dFdl5NZpfFBOWSdayLJsiYF58483BcF59SJZ+Jhorg4uLMYusfr9x8I6RVX8LmL2W4RC26aslkRt1ZfJlFo/7bQOtcfzh6/CWFi8uDiSsbk+oVVHTdxC6cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LUUEaAxN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LUUEaAxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0BB1F000E9;
	Tue,  7 Jul 2026 11:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783422572;
	bh=/druuVNRLX/zTJ8E5KrSZZFq2RPfkm+gR3zfqyvs/Zo=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=LUUEaAxN9oEGBN/RvOxDw90uwtg4fII/bgHBdrSEJFRYc4BM4TkOPmAeeLabNsE0k
	 kRfrghPJOxV7pRsoBNrKyIgta7iXfAyreLt4ZSZMGbA+lIoe/RcDfPIyy6tm/XFhdP
	 lP4h2hPsj0VoMzpQuJ42EjIySK+MbMsQ0e5/s84lHvoJh8rS5fcMsqfAZ5AEXP7uLl
	 3esEJaGgi+DSrTfL9JddOqtTjJeiBpncWK4QoCQyzzuSGHp/ughjvWMO/tLJvv6mX3
	 gYnFsO7sH+fJn711syQqy16vOW8bTIl8L+jqD3orm6BQw7IWAUrfyIRxHlhp+FGi9I
	 OKVmpdn+bSPeQ==
Message-ID: <43a58866-1bb4-474a-a4da-d5cae5ff02f3@kernel.org>
Date: Tue, 7 Jul 2026 19:09:30 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: generic: add a basic cachestat test case
To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20260707001807.31931-1-wqu@suse.com>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20260707001807.31931-1-wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/7/26 08:18, Qu Wenruo wrote:
> The test case is inspired by LTP, where there is a regression on 64K
> page size systems with btrfs, that after a fsync, cachestat() still
> report dirty pages.
> 
> The test case itself is pretty simple, fill the file with a buffered write that is
> 1/2/4/8/16 page sized, call cachestat() to make sure the cached/dirtied
> number match the page number.
> 
> Then do a fsync(), and make sure the dirty page number reduced to 0
> meanwhile cached is still the same.
> 
> Link: https://bugzilla.suse.com/show_bug.cgi?id=1270397
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/generic/798     | 57 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/798.out |  2 ++
>  2 files changed, 59 insertions(+)
>  create mode 100755 tests/generic/798
>  create mode 100644 tests/generic/798.out
> 
> diff --git a/tests/generic/798 b/tests/generic/798
> new file mode 100755
> index 00000000..4328475e
> --- /dev/null
> +++ b/tests/generic/798
> @@ -0,0 +1,57 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 798
> +#
> +# Basic tests for cachestate()
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +_require_xfs_io_command "cachestat"
> +_require_scratch
> +
> +pagesize=$(_get_page_size)
> +
> +for num_page in 1 2 4 8 16; do
> +	size=$(($pagesize * $num_page))
> +
> +	echo "=== Test with $num_page pages ===" >> $seqres.full
> +	_scratch_mkfs > /dev/null
> +	_scratch_mount
> +
> +	# Basic cached number reporting
> +	$XFS_IO_PROG -f -c "pwrite -b $pagesize 0 $size" \
> +		$SCRATCH_MNT/foobar >> $seqres.full
> +	$XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.output
> +	cat $tmp.output >> $seqres.full
> +	cached=$(cat $tmp.output | cut -f1 -d, | awk '{print $2}')
> +	dirtied=$(cat $tmp.output | cut -f2 -d, | awk '{print $2}')
> +
> +	if [ "$cached" -ne "$num_page" ]; then
> +		_fail "cached not matching the page number"
> +	fi
> +
> +	if [ "$cached" -ne "$dirtied" ]; then
> +		_fail "dirited not matching the page number"
> +	fi
> +	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar >> $seqres.full
> +
> +	# Test dirty page number reporting after a fsync.
> +	$XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.output
> +	cat $tmp.output >> $seqres.full
> +	_scratch_unmount
> +	cached=$(cat $tmp.output | cut -f1 -d, | awk '{print $2}')
> +	dirtied=$(cat $tmp.output | cut -f2 -d, | awk '{print $2}')
> +
> +	if [ "$cached" -ne "$num_page" ]; then
> +		_fail "cached not matching the page number"
> +	fi
> +	if [ "$dirtied" -ne 0 ]; then
> +		_fail "dirtied pages not zero"
> +	fi
> +done
> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/generic/798.out b/tests/generic/798.out
> new file mode 100644
> index 00000000..216d6e93
> --- /dev/null
> +++ b/tests/generic/798.out
> @@ -0,0 +1,2 @@
> +QA output created by 798
> +Silence is golden


Nice.

Reviewed-by: Anand Jain <asj@kernel.org>


Thanks

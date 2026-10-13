Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B39152E076
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 18:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791914910; cv=none; b=blzm7s8K1xvQG/1aUm/7viU7QYMG8euGtHcWkRcSlEoq1X0uKWKTUc7OL2MzfY4fMzQRtWXurQA+y/yY8F/dF98nyhDIg/tgT8IX099qTZFWmvixOQXex1dSsZubNa12CStHjrEjpNKGjDNiLR8no3fF7AIANx50wJmUcYFrG0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791914910; c=relaxed/simple;
	bh=LZPKGkI1Yv5YmO3ttQTiYNy6rcCEdTnLwf6hyjEz834=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=t1KN+1X7buugUeNvSX2tohHdv+vQdSBM/i/qk7+A0hwsZoXg9BlpWbLt7jABCIQhgOEKpaGX40qCvQ2kBFmlgLPF3iDuMEP5BE91sbjb8UaoaVLX6CmwsSsdb4AKH8QeEAx3Kq0C16Ng6GEA84ZrGFpOaT1KwraQxo/gSdd31vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ceir0auE; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ceir0auE"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-35834f72d94so5876848eec.0
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 11:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791914907; x=1792519707; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gprYPlgfoQpVrxbMi9RFaOy8N2la4zZ3lXLuamJ3l58=;
        b=ceir0auENeBv6v5QJ7PjvNtmeqh2aVzlHv653mxaDPAn2AROrGjlMobKK2JqUK5WRP
         1N7Lp1/zx/LWh/vIdD4A6jjT602WNuNCROd8onvbQgo8+f60Xj9Mhb2WySF/51bDbpX3
         Fn2f8bFPKSVwX1tuFwxrWLJzebOdzfaaH3dpWHRNrE149sImxCMZesLi978FxmA0d32Z
         y8weHH00VYtvWMRHuOrzTuSu+awpRx4sZEqIRKz4gsNKhN82ZSf8KkMZ+bC/T3CNTTgI
         8uBURsNgipjQfFhuxhe8Ttn1UghdduHwY2Dz2+7Oaw/lP/BRV/LqkVE3VYJ5iwqjRa6I
         kZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791914907; x=1792519707;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gprYPlgfoQpVrxbMi9RFaOy8N2la4zZ3lXLuamJ3l58=;
        b=QjA1S/hZ77K5PvYOdcVBH3r0NwOebxNhyrh2HZTjv5SHKvgUnVEsrUdrXxKWzAEU6K
         VoliuGLKiDf9qQEJ1e6nWW6f9j5RW1KuW7FnSOVViDVStrLVuEOm3+aECzr4MY0yIlMp
         bvlmaA9zN4scFrjmqCLqXQKSgfRc3X9P4xiMeTrkZ/OJqoTAcoqAf3kjNOTrZa/clt2Y
         uoP7yE5TdxexBjloDAkPC6NnpgUOmkpCzmKXs4aHEq6xiftr4aqsAqL017mo4YIIIPy9
         f/Vmd/Ptpl94hma7TQILmpb8FubA8kuFO7OvtW4in+cVmSNzleCoLxS58pwmyVOjM3Jb
         32Ow==
X-Forwarded-Encrypted: i=1; AKwUvBxftMJjIjhT6IF3LIU51o3cNsrlGNSyGgkTNQtEIzoIOE/3o6kDnpcOu27MqEU6VpvGKgTtw3pkw24jKw==@vger.kernel.org
X-Gm-Message-State: AFq9FYK8oLsHS93tv1KiOcWQhC7X5tlyJU76ic12LxoYaKi0nFmOfrzY
	LW/wTHRAdsylkfpQUDs5RN2ieSpeoLJMzUxQlCwKoK0f3aUkEh55Mo0EqPOnnhIo
X-Gm-Gg: AYBFou0ZrA2YMLejKvTRIC+Twyu8deOCuFsl7ONAa+WSiAdrsnyG7Y+edI+V4epVexk
	QYazcIarjbxN8MrBubBdNCHapmdlv2qr9MaHU3W7APu8nxs4d5HkM+MWUlHkPfJXKDelUgFYY+1
	wRsRs9ZAn8wwNsgRx/h2qCsh6mIfV6hQ6l98OMWw6bkcWrqCJA/QdYlU1QlL/nOBojjC0CJp/Q8
	xx/hpGci9n6bYMNEUpZYAhqsX48DTPoh7uoej4bBdTFhxROr9vEZunNiVrS3C8/SXvWxPC9frgy
	4A1yxrEbBEGUNLrrnU+gV/baMsj8elc7CDeV4ESh1Dn6f4TntGi8n6Ve3WTGFEemNvrp3nHvc2A
	7eJVdVkeeDa8zItIIdONrO9iuhrTD3DMJU0krpcgM+LHu4kKBTaE47SPcDhHA5l3eNJEfjQu8bI
	uvtA2WBXlaHucnOQk2Z+XnTQpuqq1934XO0ADq/7yMieEt0FlJSsg0A1YW5yMKP1U099awygmWD
	+Zgu1Mxudjpx5H1xK6I68SfZaVudzl4qsFOMLqA2ghZqloEwEU9Muz5gcHoqffwEbJaCpFkLuVq
	I9bO
X-Received: by 2002:a05:693c:8954:20b0:351:8cc4:e18b with SMTP id 5a478bee46e88-3537dfb8632mr16917641eec.20.1791914906817;
        Tue, 13 Oct 2026 11:08:26 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:97af:ddc7:ec87:e5c4:79f7? ([2406:7400:56:97af:ddc7:ec87:e5c4:79f7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35ca33b4065sm7841600eec.4.2026.10.13.11.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 11:08:26 -0700 (PDT)
Message-ID: <ea99086d-94ea-4b44-a2f2-076047fb22d4@gmail.com>
Date: Tue, 13 Oct 2026 23:38:21 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dhruva G <goledhruva@gmail.com>
Subject: Re: [PATCH 1/3] btrfs: exercise NOCOMPRESS range and EOF handling
To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 Zorro Lang <zlang@kernel.org>, linux-btrfs@vger.kernel.org,
 Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <cover.1791395660.git.goledhruva@gmail.com>
 <b99615bd-9b7c-48b6-ac70-d450a606388c@gmail.com>
 <2920bc87-3d1e-4bfa-99cc-8b4af37fec5e@suse.com>
Content-Language: en-US
In-Reply-To: <2920bc87-3d1e-4bfa-99cc-8b4af37fec5e@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 12-10-2026 03:30, Qu Wenruo wrote:
> 
> 
> 在 2026/10/12 06:10, Dhruva G 写道:
>> Check that a bounded --nocomp request rewrites compressed extents in the
>> selected range while distant untouched regions still point to their
>> original compressed storage.
>> Cover a partial final sector, zero length, a length extending past EOF,
>> start at EOF, and the empty-file no-op. Preserve contents and sizes across
>> the conversion and a remount.
>>
>> Add shared FIEMAP and integrity helpers for the NOCOMPRESS tests. Require
>> full mapping coverage and inspect every overlapping extent so holes and
>> partly converted ranges cannot pass. Include a small ioctl helper to
>> probe kernel support and check errno without btrfs-progs translation.
>>
>> Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
>> ---
>>   .gitignore                |   1 +
>>   common/btrfs_nocomp       | 134 ++++++++++++++++++++++++++++++++++++++
>>   src/Makefile              |   2 +-
>>   src/btrfs_defrag_nocomp.c |  63 ++++++++++++++++++
>>   tests/btrfs/355           |  80 +++++++++++++++++++++++
>>   tests/btrfs/355.out       |   2 +
>>   6 files changed, 281 insertions(+), 1 deletion(-)
>>   create mode 100644 common/btrfs_nocomp
>>   create mode 100644 src/btrfs_defrag_nocomp.c
>>   create mode 100755 tests/btrfs/355
>>   create mode 100644 tests/btrfs/355.out
>>
>> diff --git a/.gitignore b/.gitignore
>> index 0b6b9452..1bfa12ef 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -216,6 +216,7 @@ tags
>>   /src/truncate
>>   /src/t_btrfs_received_uuid_ioctl
>>   /src/btrfs_ioctl
>> +/src/btrfs_defrag_nocomp
>>   
>>   # Symlinked files
>>   /tests/generic/035.out
>> diff --git a/common/btrfs_nocomp b/common/btrfs_nocomp
>> new file mode 100644
>> index 00000000..7e2111e1
>> --- /dev/null
>> +++ b/common/btrfs_nocomp
>> @@ -0,0 +1,134 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) Meta Platforms, Inc. and affiliates.
>> +# Helpers for BTRFS_DEFRAG_RANGE_NOCOMPRESS tests.
> 
> I don't like a dedicated file just do all those.
> Why not put them into common/btrfs?
> 
>> +
>> +_nc_require()
> 
> And "nc" is too generic, _require_btrfs_defrag_nocompress() would make 
> more sense.
> 
> All the namings here look just some temporary scaffolding, not for 
> generic purposes.

Agreed. I'll move the shared helpers into common/btrfs and use more descriptive names in v2.

> 
>> +{
>> +	_require_scratch
>> +	_require_test_program btrfs_defrag_nocomp
>> +	_require_xfs_io_command fiemap ranged
>> +	_require_btrfs_command filesystem defragment --nocomp
>> +	_require_btrfs_no_nodatacow
>> +	_require_btrfs_no_nodatasum
>> +	_require_btrfs_no_autodefrag
>> +	_require_btrfs_support_sectorsize 4096
>> +	_wants_kernel_commit 009b2056cb25 \
>> +		"btrfs: defrag: add flag to force no-compression"
>> +}
>> +
>> +_nc_write()
>> +{
>> +	$XFS_IO_PROG -f -c "pwrite -S $4 -b 128K $2 $3" -c fsync "$1" \
>> +		>> "$seqres.full" 2>&1 || _fail "write failed: $1"
>> +}
>> +
>> +_nc_probe()
>> +{
>> +	local result
>> +
>> +	_nc_write "$SCRATCH_MNT/probe" 0 131072 0x5a
>> +	result=$($here/src/btrfs_defrag_nocomp "$SCRATCH_MNT/probe" 0 131072) ||
>> +		_fail "NOCOMPRESS probe failed"
> 
> Why we need such dedicated probe program while the kernel is already 
> rejecting unknown flags with ENOTTY?
> 
> And I think this probing should also be done inside the 
> _require_btrfs_defrag_nocompress().

Agreed. I'll do this in v2.

> 
>> +	case "$result" in
>> +	OK) ;;
>> +	EOPNOTSUPP|ENOTTY) _notrun "kernel does not support NOCOMPRESS" ;;
>> +	*) _fail "unexpected NOCOMPRESS probe result: $result" ;;
>> +	esac
>> +	rm -f "$SCRATCH_MNT/probe"
>> +}
>> +
>> +_nc_defrag()
>> +{
>> +	local file="${@: -1}"
>> +
>> +	$BTRFS_UTIL_PROG filesystem defragment --nocomp "$@" \
>> +		>> "$seqres.full" 2>&1 || _fail "NOCOMPRESS defrag failed"
>> +	$XFS_IO_PROG -c fsync "$file" >> "$seqres.full" 2>&1 ||
>> +		_fail "fsync after defrag failed"
>> +}
>> +
>> +_nc_map()
>> +{
>> +	$XFS_IO_PROG -c "fiemap -v $2 $3" "$1" > "$tmp.nc-map" \
>> +		2>> "$seqres.full" || _fail "fiemap failed: $1"
>> +	cat "$tmp.nc-map" >> "$seqres.full"
>> +}
>> +
>> +# FIEMAP prints logical offsets in 512-byte units. Check every overlapping
>> +# extent and complete coverage, so a hole or a partly converted range fails.
>> +# The caller supplies byte offsets and lengths, including a partial EOF sector.
>> +_nc_check_range()
> 
> This looks a little overkilled to me.
> > For regular hole/compression flags, what about filtering out the 
> non-hole logical bytenr (e.g. replace them with 'XXX' or 'regular'), 
> then output to the stdout, and use golden output to verify?


For patch 3, the test also needs to distinguish compressed inline extents from compressed non-inline extents.
_filter_fiemap_flags 1 retains the encoded flag, but currently filters out the inline flag.

Would you prefer a small opt-in extension to retain the inline flag, or a test-local filter?
With the extension, existing callers would retain their current output, and the inline test could use:
_filter_fiemap_flags 1 1.

Thanks for reviewing and suggestions!

Regards,
Dhruva Gole

Received: from mail-yx1-f65.google.com (mail-yx1-f65.google.com [74.125.224.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571B330EF68
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774395617; cv=none; b=o5h/8jX9WsmKoyCKMS+wJPQAApLrN6M16v4zEVYVd05Zekku2fz2Z/4y09PhP//604djW0SBRCpmmd9MXkqYBbprsK7rjMOioCcWRrH0f+oGrgXRe46KzUiwbiUzffXqLvkfAZKZJqmkvrMBX4Qt3j2TqnF7k0wltVPuSLgLJGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774395617; c=relaxed/simple;
	bh=r9gjSYIjP6ljCTjXQL0cbTWCBIMLbqgC/sBRFaWEca0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4ZTh61wbjztPbMbucva5n2V7AQ1iBg97QKUKCF3jXHDeerr8lp+BqcLk4hK6gpyNaQkMuqaqNF1lQ+Th3A7ppy6vcDUX/vVqhaabOjIsYnGq+cpObVH9f8FNtfV8CkRUEIh6o8gQCl91xUDFO68muBpff+l+giOIV7aC+4VxC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cuajoa+3; arc=none smtp.client-ip=74.125.224.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cuajoa+3"
Received: by mail-yx1-f65.google.com with SMTP id 956f58d0204a3-64ad8435f46so5267093d50.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 16:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774395615; x=1775000415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCX9KWt3A0asKt7lWJtB0L84UdTOx1zabyzk7QfBhdk=;
        b=cuajoa+3hmCJsRYqWpOL+joModyHGsPmkjj36DhGlHPPDxvm1PrwogeeRoxX50+mf8
         z67IBxjC5U4IC9U0qm7+xLoFa3bqZtzJzmJMe4zxEPU4eiAibSuGK8pcrAq0hH62ekIl
         TeLhCjsbBHuoUf+Hz9/wUrz3O0RNdMV7zCb4yAQASI6oR1oongtPOyfDJp2CuPVAbaA+
         vEUXIcVzwqz0sJ4LTUSIfHGPVQv/ebrKNv6GAsbJH7J9exI1lzwov0mgs6Ae2fM2UY8b
         20r5gZAXfiIqyhZxwmoCiiAIatsAykj+u/SiLZpT0ybUfEfnWTVfFZ399TF9KI4Mh1Hg
         8mhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774395615; x=1775000415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LCX9KWt3A0asKt7lWJtB0L84UdTOx1zabyzk7QfBhdk=;
        b=OmKu8Ky4+8Nk4+C9Qn042+nq21XZkQjup98cheM9ZePE6PeAgE3Ou15vlkSokUfLDZ
         x0ybl5e/3I2djHk6MDk3saTuD32UTVo2COL9rhmJnX2d2R8imgPNzbhrKMaKijTky90/
         X3xzhZuadrsxJgSA4xLot+Vpu7viuqtU+E3PYXHKyxMtIH4IfH5HGcFacU0sE2Mn8vge
         BuSdmtxzND5eAOmtypbDX+6jToFNsaE28I5I8j9hXqecPvvv8EM+zddHEH2TfvSVJJbX
         Ke9Q9x7ntYDDyPryvj6WNu+dKXLzqQguVT/9RDgtr+NuEwvpOhjpj8baT3WN5YMUJit3
         Cxvg==
X-Gm-Message-State: AOJu0YxFhhcdVLt+tarev3vMrMh9AHWZyaTFSFZ+yTc4WmIXnVsursF/
	wXXKQMM+B2mBBfKjO/Gpv4FSMsb3ZKKPl8ZiqeZSV/Yk6f0Jp+eNkqIzgZbI9E8p
X-Gm-Gg: ATEYQzyDsr7cjgIwDUOSACNHmPDF6XNacyOG5GcFcqG4fjqBxzfbfZR4QjJ03gUKaoF
	KFmLIyH/DOGlF7uqwysKuZt5E0UUiC5raOfv0hZ6Tj35KXfJy4PlAGzJJS0j2JFKRxoitqGaHfe
	9FDygXAUtWp+qDdugY7sWirmEDAXU9zCybq2UuQc9EhCn3wAYsQaSAWKVBdvs+o4lf8Z6rqRC5D
	zQCjDISz8wvCmAGbmBYxpsy2ldtu2Xd/65kH4TkYlEJ5klCw28fm2OSxaDTcVBVTLG6q/n2lvtD
	Ou9PZ8e9z8czWp0KZ/ZXdu8AF8Ho3J6G3kesgr9vyPovJjZVLHD2PUGv7102jABf1ZZseIvOdvH
	Yl2e+ztludOSZ3e8nvOk1HKMsYoKQB1MF70QLLaCXZDDIEah9vUHT49p11ZzakRGS1IfoZMd+wQ
	NHqcP4GuEXp1cATJu8HA==
X-Received: by 2002:a05:690e:169e:b0:64e:a2a8:f31d with SMTP id 956f58d0204a3-64ee608475bmr1354110d50.7.1774395615403;
        Tue, 24 Mar 2026 16:40:15 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5a::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64edbfbaac0sm1612125d50.14.2026.03.24.16.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 16:40:15 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: Leo Martins <loemra.dev@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	fstests@vger.kernel.org
Subject: Re: [PATCH] generic/747: handle ENOSPC gracefully during write/delete cycles
Date: Tue, 24 Mar 2026 16:39:43 -0700
Message-ID: <20260324234010.590043-1-loemra.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <efcb3c8470bf099534fec1c1745780eba445e111.1774394322.git.loemra.dev@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 24 Mar 2026 16:33:26 -0700 Leo Martins <loemra.dev@gmail.com> wrote:

Forgot to CC fstests mailing list.

> generic/747 consistently fails on btrfs in my fstests setup, with an
> ~88% failure rate across multiple runs on kernels ranging from v6.9 to
> v7.0-rc5. This is not a regression but a pre-existing issue since the
> test was added.
> 
> The test fills a filesystem to 95% then does mixed write/delete cycles,
> using statfs to decide whether to write or delete. However, statfs
> f_bavail may overestimate the actual available space. On btrfs, the
> statfs implementation documents its estimate as "a close approximation"
> (fs/btrfs/super.c). At high fill levels the discrepancy between what
> statfs reports and what the filesystem can actually allocate becomes
> significant, causing dd to hit ENOSPC even though statfs indicated
> there was room.
> 
> This is not a filesystem bug. The filesystem correctly rejects the
> write when it cannot reserve space. The test's purpose is to stress
> garbage collection through write/delete churn, not to validate space
> accounting.
> 
> Handle ENOSPC by cleaning up the partial file and making room:
> 
> In _direct_fillup: break out of the fill loop (we're full enough).
> In _mixed_write_delete: delete a file to free space and retry. If
> writes fail 10 consecutive times, _fail the test as that indicates a
> real filesystem issue rather than a transient statfs discrepancy.
> 
> Redirect dd stderr to seqres.full so errors are preserved for
> debugging without polluting the expected output.
> 
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> ---
>  tests/generic/747 | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/tests/generic/747 b/tests/generic/747
> index 44834186..35de3ccb 100755
> --- a/tests/generic/747
> +++ b/tests/generic/747
> @@ -35,11 +35,7 @@ _create_file() {
>  
>  	POSIXLY_CORRECT=yes dd if=/dev/zero of=${file_name} \
>  		bs=${bs} count=$(( $file_sz / ${bs} )) \
> -		status=none $dd_extra  2>&1
> -
> -	if [ $? -ne 0 ]; then
> -		_fail "Failed writing $file_name"
> -	fi
> +		status=none $dd_extra  2>>$seqres.full
>  }
>  
>  _total_M() {
> @@ -69,7 +65,10 @@ _direct_fillup () {
>  	while [ $(_used_percent) -lt $fill_percent ]; do
>  		local fsz=$(_get_random_fsz)
>  
> -		_create_file $testseq $fsz "oflag=direct conv=fsync"
> +		if ! _create_file $testseq $fsz "oflag=direct conv=fsync"; then
> +			rm ${SCRATCH_MNT}/data_${testseq}
> +			break
> +		fi
>  		testseq=$((${testseq} + 1))
>  	done
>  }
> @@ -79,14 +78,25 @@ _mixed_write_delete() {
>  	local total_M=$(_total_M)
>  	local to_write_M=$(( ${overwrite_percentage} * ${total_M} / 100 ))
>  	local written_M=0
> +	local enospc_retries=0
> +	local max_enospc_retries=10
>  
>  	while [ $written_M -lt $to_write_M ]; do
>  		if [ $(_used_percent) -lt $fill_percent ]; then
>  			local fsz=$(_get_random_fsz)
>  
> -			_create_file $testseq $fsz "$dd_extra"
> -			written_M=$((${written_M} + ${fsz}/${M}))
> -			testseq=$((${testseq} + 1))
> +			if ! _create_file $testseq $fsz "$dd_extra"; then
> +				rm ${SCRATCH_MNT}/data_${testseq}
> +				_delete_random_file
> +				enospc_retries=$((enospc_retries + 1))
> +				if [ $enospc_retries -ge $max_enospc_retries ]; then
> +					_fail "failed to write after $max_enospc_retries consecutive ENOSPC attempts"
> +				fi
> +			else
> +				written_M=$((${written_M} + ${fsz}/${M}))
> +				testseq=$((${testseq} + 1))
> +				enospc_retries=0
> +			fi
>  		else
>  			_delete_random_file
>  		fi
> -- 
> 2.52.0

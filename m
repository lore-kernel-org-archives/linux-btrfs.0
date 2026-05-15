Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B05440B6D8;
	Fri, 15 May 2026 16:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864145; cv=none; b=s2slHVJDV7wRN+4ned/XgrySP5vX+7Sb5dHWoKQN7EJsJ56PIQrQUAxDk9rDdlkbOf+IgevTQ/equUM0if9MpZZ6Z6FDjVi+Ovz0kBk79fmyusu6SXlQ009iQbBxLL+shRgCFzQL/YRDgnQM+QW5D05LzK9oIni7nU8AC8Fe8eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864145; c=relaxed/simple;
	bh=P7THp2aJWxhHxVi+7cvCLm1OOtK9LcNoKQGsJhZqvn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UBcoIdlJPpxs494uB/QmAF9ARtrsS814q1DOrmHp+wdxd36jN6kYgL++DtHSOE3uI6+svLQinNKlDYO5GpwTxGPsJhPr5dJyKwS2BE4dFHgtpwxqQ5OlfPpUPGn9pdAv9hL0SUckC306LpEBNOqV/9niN/jEUEs/rn0DayYP9rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjX0bsT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjX0bsT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D145C2BCB0;
	Fri, 15 May 2026 16:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864145;
	bh=P7THp2aJWxhHxVi+7cvCLm1OOtK9LcNoKQGsJhZqvn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PjX0bsT13kqxUyNQBJDJbTYQHvU8I7DKOUU+NqUckvIQGhBP+EFWin6w4GrvVSH85
	 aoMeCKHyBkxMK2El6mqduAfEtPUcY6B3xiNxFEhKr4x5iY7OhCpIs5jpsTar8Vr3G0
	 ryUM1bty79t4p7Ac+WRvPkVN4QOJ5M0v2uYz8aMGfIODc7gKoxHpxFgDHfCUZ4rBBS
	 Ys9Eb88/QfcTxVIVf6oSxQ5ChVS+GhiGHrOu9/Bocdpe0wFk9Bq65N0YeMlVx5FWDV
	 g6n3FS83fwPDWvglQLeXJKZW6+l+rf9PzFNgP/cxVI+U9fOgugJCHuhxDKKPzIGMxL
	 /fdMe5Z4WbF5Q==
Date: Sat, 16 May 2026 00:55:39 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Long An <lan@suse.com>
Subject: Re: [PATCH v2] fstests: btrfs/340: add support for older
 kernels/progs
Message-ID: <agdOBcKgPn3s7_u0@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Long An <lan@suse.com>
References: <ed76cf7d6a0ad2a98e5730015dd4fc6514fc2343.1778749477.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed76cf7d6a0ad2a98e5730015dd4fc6514fc2343.1778749477.git.wqu@suse.com>

On Thu, May 14, 2026 at 06:34:39PM +0930, Qu Wenruo wrote:
> The test case will fail on older distros like SLE12-SP5, there are two
> problems on the test case itself:
> 
> - Requires "--sync" option from "btrfs qgroup show" subcommand
>   That option was introduecd in v4.9.1, thus there are still some older
>   distros using that very old version.
> 
> - Not all kernels support quick inherit
>   The kernel commit introducing the quick inherit is 6.9, thus some
>   supported LTS kernels do not have that commit.
> 
>   In that case qgroup will just be marked inconsistent, this will cause
>   the later "btrfs qgroup show" command to output a warning due to the
>   inconsistent flag.
> 
> Fix both problems by:
> 
> - Require "--sync" option from "btrfs qgroup show" subcommand
>   So older distros will just skip the test.
> 
> - Redirect all output from "btrfs qgroup show" to $seqres.full
>   So older kernels can still pass the test case by marking qgroup
>   inconsitent.
> 
> Reported-by: Long An <lan@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Fix the mismatch between the commit message and the test case change
>   Forgot to amend the changes before sending.
> 
> - Fix a bug in the stderr redirect
>   The stdout redirect should be put last.

Sorry, did I miss part of the discussion? Why did v2 switch to notrun for
older tools instead of using the compatible `btrfs filesystem sync` from v1?
Was there something wrong with the v1 method :)

Thanks,
Zorro

> ---
>  tests/btrfs/340 | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/btrfs/340 b/tests/btrfs/340
> index 872f790cb975..eff76d0b633c 100755
> --- a/tests/btrfs/340
> +++ b/tests/btrfs/340
> @@ -16,6 +16,7 @@ _fixed_by_kernel_commit 68d4b3fa18d7 \
>  # For the automatic fsck at unmount.
>  _require_scratch
>  _require_btrfs_qgroup_report
> +_require_btrfs_command qgroup show --sync
>  
>  # This will imply mkfs and enable regular qgroup.
>  _require_scratch_qgroup
> @@ -39,7 +40,12 @@ _btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full
>  # without marking qgroup inconsistent.
>  _btrfs subv snap -i 1/1 $SCRATCH_MNT/subv1 $SCRATCH_MNT/snap1
>  echo "After quick inherit:" >> $seqres.full
> -_btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full
> +# Redirect all output to seqres.full including stderr.
> +# For older kernels without quick inherit support, it will mark
> +# qgroup inconsistent, which will output a warning about the inconsistent
> +# numbers. Here we rely on the final btrfs check to catch any qgroup number
> +# errors, thus no need to bother that possible warning.
> +_btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full 2>&1
>  
>  echo "Silence is golden"
>  _exit 0
> -- 
> 2.54.0
> 
> 

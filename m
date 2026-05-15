Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD273CFF66;
	Fri, 15 May 2026 16:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778863520; cv=none; b=uGaKxZV1JL0Ut5PBPZezzVy7e9zoeB8uxspmXOg1fwv9quttWmC57Xri7vIvnwmkNvrXtUCJCoi8f6B5yPOjRQhMzXsUtKvFv8vqFQ/S8YSewEJoMIK0vaTZ45bCJipG8LB2t524wdAfgnWn/RSQJqTsdO1cnNqql/79kiPhFBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778863520; c=relaxed/simple;
	bh=DPoeo2DLShOU1aPMHIydfB43ymIdDlU++Zn3SOFtiY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sE99T5TtNy+dAFbltS99ue1fAr3PISxCNm3I34oLyqoJI3OrhWiUfmFJwUoqyeLr/JN0Ohel5UFlOjgABMMLiRJAolBU+h0IcLPAGt5EUSo4+ioNZ1uto2wDBD4Cu6Ltyndz5ldkDNldh0sf+GBmZihOUtMSrW0QynC5+0XKnXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vDV8GyRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vDV8GyRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55309C2BCB3;
	Fri, 15 May 2026 16:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778863520;
	bh=DPoeo2DLShOU1aPMHIydfB43ymIdDlU++Zn3SOFtiY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vDV8GyRGGySLcOtiqFS/H1BRFYTKxJlxh6JSVZoBSJUYcGph7Ysrp1nCsbHvfEs3I
	 bDhX8iHIqosMgHeWjc2uLJrGpNT0mEPcGrT+ZKgCSqa6jQMXJ3szvocewdH/WZEZwm
	 J1jd81OeASDQSwWysHayweJm57Cc2IE1g0+eC3I7lTkYk3Wi4+w+WDE/1p6SGEmcUc
	 pKwj2abybzrbmtgkPSiObbI5/PB5jY18naDmsRZ7IRyVPD3xzAEcuQ31ObyTY9wyvf
	 u4Zxp7djcvFknKxgIOT4DoG30bs4kAuOX6mwjDvMMCJ9DowAxkpRQyLhX8felUL+KW
	 TZG66IWO34PcA==
Date: Sat, 16 May 2026 00:45:12 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Long An <lan@suse.com>
Subject: Re: [PATCH] fstests: btrfs/340: add support for older kernels/progs
Message-ID: <agdMkn0SyWLZsj3h@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Long An <lan@suse.com>
References: <4fa82130c72f55560967d0deaafb68a69a2e7ccb.1778738100.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fa82130c72f55560967d0deaafb68a69a2e7ccb.1778738100.git.wqu@suse.com>

On Thu, May 14, 2026 at 03:25:02PM +0930, Qu Wenruo wrote:
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
>  tests/btrfs/340 | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/btrfs/340 b/tests/btrfs/340
> index 872f790cb975..fc0b8d48adaa 100755
> --- a/tests/btrfs/340
> +++ b/tests/btrfs/340
> @@ -39,7 +39,14 @@ _btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full
>  # without marking qgroup inconsistent.
>  _btrfs subv snap -i 1/1 $SCRATCH_MNT/subv1 $SCRATCH_MNT/snap1
>  echo "After quick inherit:" >> $seqres.full
> -_btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full
> +# Sync the fs so that the qgroup numbers are properly updated.
> +_btrfs filesystem sync $SCRATCH_MNT

Just out of curiosity, `sync $SCRATCH_MNT` can achieve the same effect here, right?
Regardless, it definitely makes more sense to use Btrfs's own sync command in this
context.

Reviewed-by: Zorro Lang <zlang@kernel.org>

> +
> +# Redirect all output to seqres.full including stderr.
> +# For older kernels without quick inherit support, it will mark
> +# qgroup inconsistent, which can pollute the golden output.
> +# Here we rely on the final btrfs check to catch any qgroup number errors.
> +_btrfs qgroup show -p $SCRATCH_MNT >> $seqres.full
>  
>  echo "Silence is golden"
>  _exit 0
> -- 
> 2.54.0
> 
> 

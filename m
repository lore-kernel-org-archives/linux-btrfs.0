Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF9D2DC355
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2026 16:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769702687; cv=none; b=V5nRl9Sy7V/fDrCyn6hSgVDhbNGoC5zRQx+/bfxtAJe8dfrJOl8PsOe3QRezBbUYOpQvIC1ggqh0zlO9hej+TQPaTv8kmk3vZNKgTRDEbb94YnKaOgTtiV6Wnw6Trv3+OUXOKYC/wk9BmgyaZPxutnKaY9FDLpN4ph3rz5f0Kcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769702687; c=relaxed/simple;
	bh=4niGVtwxrRp9bQB3NHWEvVlA4ChaoKAJ7EgZpcCkY9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o3g8Z3IDnYzbpAuQ5ophOVgadGAI9wcHz53OP1B06DGc7bEzTtm998K/HtCflUqnSu1fxHwvctufE+K+GReexFKUlyr444lyJyADQK52zNsfnuCjAl8SKXTqpKcXiynbc+9RewUeLAKdU2KzYE/2kk7rGmsViROhRA6fgqnMvug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nd8MMq/B; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FhT/hx9i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nd8MMq/B";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FhT/hx9i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769702685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0mo0YI1VAMZKaWZpvoAA2d7WpeTK/KkTsMqb8ufoP4Q=;
	b=Nd8MMq/B4A9kbPlfqk3KPqitZXRwxELOMAa+YjRymUqLK6i36kU9pQ0NiaHDSLCzCkC/K/
	DSZy/pqRakyD5L+QFXq7zBd432ljax0izvMkBI1D7LN8dgaMHLYaQLgDg3kTJahTsEljHv
	Qsk3c9Ll8pJoGAiJjFPVsQRtuQVkYDI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-FT2fVKTTOPyLz5FvQ6B7bA-1; Thu, 29 Jan 2026 11:04:43 -0500
X-MC-Unique: FT2fVKTTOPyLz5FvQ6B7bA-1
X-Mimecast-MFC-AGG-ID: FT2fVKTTOPyLz5FvQ6B7bA_1769702682
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c38781efcso1134710a91.2
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2026 08:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769702682; x=1770307482; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0mo0YI1VAMZKaWZpvoAA2d7WpeTK/KkTsMqb8ufoP4Q=;
        b=FhT/hx9iX+rG67cyKFScmhmYpHBF+Ma5UzrM9fyQlfbT1ljHDdbp604CK1i3mVZatx
         /W8VifvOROyuvXjVhVAxx9uR5ESrsBmnf9nNWocnqibEi4vQFS7VNpTlIm3Ww3yPVqoR
         KGRRT4sSJ3TJGBsvl1ivZLNkW9mV4OsrUeJgo/lI5fMNQTK6XTi+mRDAviinm7m3FduQ
         QAmtcsNsNf4N0+tiDhQNs9IRo4e/28CVX45jViMphKxl5RrzvfcsB6IfZrWebWe97MUZ
         7waeyEwGp6c21Y1iiOL+sUC6mNvjT4CtHrN7cQBXsnbJktCbfS7zmEbCqqxeBEc4sH1T
         FAHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769702682; x=1770307482;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0mo0YI1VAMZKaWZpvoAA2d7WpeTK/KkTsMqb8ufoP4Q=;
        b=H3xmJbikmjFIjtZN6qMgr08yPhy8BXYgz7+7k/iCmPaYfCRV/PMMzoNNUhBvtJ1hB8
         YvZZdS9MAdOMbLhvEdxevSGu3ugcXh0anvqsDqlAVyr7+uVeXvIIqWy2fIxMKfYZRxZo
         LkkxdWg/QfVEakjDS5F1ZAOouNk6pXMFAPrELwzCUUxXTHSTsHpXGwKPotdVymOoeTn0
         nQ6wXCiyZCu+bomS4GE1jAFmHCVV6v9Q2R1BXjpEKzKfj/7ilhSPe/7TaPT6Ii8NMAoO
         zdlspUJ/Bv6xv3usfCvIVe3NXG2SPjm1cboMvgbbjV2suUHy/9kpImFSVG+RYpcFkuPN
         VuJA==
X-Forwarded-Encrypted: i=1; AJvYcCUBlREle1P0FLui1ECDvZYLLL8e1KYRqX4VrJyLhSVFeWPt2oBHIqvqkinsmDTtEksoQ3QczCpbABNibw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/XSR+t/btBGMQWChZQ/COPYJ+WWdXycmAgXfTRwW9WfHQJz49
	341LF8nuOorFm6wfoHAdxXqJO03uk8eBZhMvxDsAkGpmledkKmYeiB3ayIMx3zBpoYDAJwFSX8X
	hryGpYog1vLpS+QW19vwojH+UWaVqbWDshYExjNI4WbhVkGyeu466thw0ZyFwirPr
X-Gm-Gg: AZuq6aLwAl/su8wRA0ta95GdZUBQLwD78ImlKEryHmQ01HdUC9WY6A1uVo3XpxI9Rb8
	JVkoBO+geHbyehXMRa07OHMibOKk3nK1RzEPmD7YqvIiytaUKYrDaLep/2xPWnaKkkgUeBxOZyd
	5uWdtGCw+OQSfUaUNEFFUj2cf3QlNZ0mN00Lb8nWF9Cr493PBRQ/yLvW1o+l839gvevmPk7zKps
	SUXM+ilnMFtpJH3+84yxcpqyqkaROzMtyHEQX36sju9+RZONL4179NOkUTzYGpukoIZ1xfDk/pB
	aFJcVcY/6n3gSRdg4Taet/aSMZzkRiRGR41HMq14y9YDB6p/+O4x/tzeXPN3hXOIa6PNE7EDPKG
	N2FtAINOZx3BjOtg1RCdHj6Tdj2tFjFzVbsonFwdZdUE4R38ImQ==
X-Received: by 2002:a17:90a:fc4f:b0:352:b674:2592 with SMTP id 98e67ed59e1d1-3543b30564bmr11224a91.7.1769702682134;
        Thu, 29 Jan 2026 08:04:42 -0800 (PST)
X-Received: by 2002:a17:90a:fc4f:b0:352:b674:2592 with SMTP id 98e67ed59e1d1-3543b30564bmr11191a91.7.1769702681575;
        Thu, 29 Jan 2026 08:04:41 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3542dbad222sm16202a91.0.2026.01.29.08.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 08:04:40 -0800 (PST)
Date: Fri, 30 Jan 2026 00:04:35 +0800
From: Zorro Lang <zlang@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] generic: add missing kernel commit IDs to tests 784 and
 785
Message-ID: <20260129160435.4g6mvwsldqogiybh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <ac7a142858d625cb5921568918b1b9615a650f25.1769525657.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac7a142858d625cb5921568918b1b9615a650f25.1769525657.git.fdmanana@suse.com>

On Tue, Jan 27, 2026 at 03:01:52PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The respective kernel patches are already in Linus' tree (landed in
> v6.19-rc2), so update the tests to include the commit IDs.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---

Thanks for this update,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/784 | 2 +-
>  tests/generic/785 | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/784 b/tests/generic/784
> index 5d972cce..f7fb6272 100755
> --- a/tests/generic/784
> +++ b/tests/generic/784
> @@ -25,7 +25,7 @@ _cleanup()
>  _require_scratch
>  _require_dm_target flakey
>  
> -[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit 266273eaf4d9 \
>  	"btrfs: don't log conflicting inode if it's a dir moved in the current transaction"
>  
>  _scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> diff --git a/tests/generic/785 b/tests/generic/785
> index d918de4f..6c3a1c36 100755
> --- a/tests/generic/785
> +++ b/tests/generic/785
> @@ -27,7 +27,7 @@ _require_scratch
>  _require_dm_target flakey
>  _require_fssum
>  
> -[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit 5630f7557de6 \
>  	"btrfs: do not skip logging new dentries when logging a new name"
>  
>  _scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> -- 
> 2.47.2
> 
> 


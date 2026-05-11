Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC6223EA89;
	Mon, 11 May 2026 14:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778509925; cv=none; b=uW/fRE4zJTPisEiy3lYL6HtBYECXDATM73+hfylsUgj2aKip/ORgHC6am5U/BZkg3aQs7BNUUiSjob6akXJDFjsKlDVd91mZ9b0bn3+VbtdkX8FHr1omLxl3m7xYNdAsaARbTAg0AnTui1UlC0PX8VAsu2js3FsxBV70CqtA2Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778509925; c=relaxed/simple;
	bh=/RKw7kH+KMNf/PQLIMqG0+EaqvwtjPdXEiODgy4J3kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+MZY1mq7rGBUbTNxw/ylpCIK6J9j/3llqDkTo/QtFspc+wdea5DCUAqIoKTDyyr2e43k5zmbpeVC/NHM0E3GVCdgFYOcPkg/pJ9d2zcvq07Woy4AigIcY65ksyr8BQd72Hm7Xjy7mD5O/rtzijUU2ZiE/uQFAlcjgsA8Bh21P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EACLXwPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EACLXwPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FABC2BCB0;
	Mon, 11 May 2026 14:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778509924;
	bh=/RKw7kH+KMNf/PQLIMqG0+EaqvwtjPdXEiODgy4J3kk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EACLXwPyKgGdW5Ny3+3QBsPeOPxnENk6j9ItoyYziP37dI+npmbdW7DQzNmHfg6IE
	 unAzq3vB9A03lkvoz3PSSxhziXu0Yxy/xoB0PzTxEEJyrfLgmWHzO2FTyXmNp2lg13
	 W0YJI0AH0L+wxkamcn8MY+9MmNrV9ynKAEbG75nEK/tR3byuOioXR6mwQy0+jFJmNR
	 BpVcOpKniAGPpTxeN9lOe4aF+FnPbEeOQZcWZH8Y3nIdpxFmCLtS38RNZqSn8/Cf9H
	 9f4zePbq9+89QkfR5BfH6knmxf7xvkwP3nyZOQizax7uMkNbM6w/Tyb5iT/4jv9mf+
	 gnpFK0juxwXxQ==
Date: Mon, 11 May 2026 22:31:56 +0800
From: Zorro Lang <zlang@kernel.org>
To: Disha Goel <disgoel@linux.ibm.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org, fdmanana@kernel.org, 
	quwenruo.btrfs@gmx.com, anajain.sg@gmail.com
Subject: Re: [PATCH v3 1/2] common/dmlogwrites: add _require_log_writes_sized
 helper
Message-ID: <agHm1zCSzmZ1DL4a@zlang-mailbox>
Mail-Followup-To: Disha Goel <disgoel@linux.ibm.com>, 
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, djwong@kernel.org, fdmanana@kernel.org, quwenruo.btrfs@gmx.com, 
	anajain.sg@gmail.com
References: <20260508144701.68561-1-disgoel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508144701.68561-1-disgoel@linux.ibm.com>

On Fri, May 08, 2026 at 08:17:00PM +0530, Disha Goel wrote:
> Add a new helper function _require_log_writes_sized() to check if the
> LOGWRITES_DEV meets a minimum size requirement.
> 
> This is useful for tests that use dm-log-writes with additional space
> requirements, such as creating LVM snapshots during log replay or tests
> that generate large amounts of logged I/O operations.
> 
> The function takes a size parameter in KB, calls _require_log_writes()
> internally, and skips the test if LOGWRITES_DEV is smaller than the
> required size.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Suggested-by: Anand Jain <anajain.sg@gmail.com>
> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
> ---
> v2 -> v3:
> - Fixed variable declaration order - declare all local variables at the
>   beginning of the function
> - Use $size instead of $1 for clarity in the comparison
> 
>  common/dmlogwrites | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/common/dmlogwrites b/common/dmlogwrites
> index a27e1966..b457ef7f 100644
> --- a/common/dmlogwrites
> +++ b/common/dmlogwrites
> @@ -14,6 +14,22 @@ _require_log_writes()
>  	_require_test_program "log-writes/replay-log"
>  }
>  
> +# Require a log writes device of a minimum size
> +# $1: minimum size in KB
> +_require_log_writes_sized()

Makes sense to me. Although I think we can support 'size checking' in original
_require_log_writes helper too, but I don't have objection on this change. Thanks

Reviewed-by: Zorro Lang <zlang@kernel.org>

> +{
> +	local size=$1
> +	local devsize
> +
> +	[ $# -eq 1 ] || _fail "_require_log_writes_sized: expected size param"
> +
> +	_require_log_writes
> +
> +	devsize=$(_get_device_size $LOGWRITES_DEV)
> +	[ $devsize -lt $size ] && \
> +		_notrun "LOGWRITES_DEV too small, ${devsize}KB < ${size}KB"
> +}
> +
>  # Starting from v4.15-rc1, DAX support was added to dm-log-writes, but note
>  # that it doesn't track the data that we write via the mmap(), so we can't do
>  # any data integrity checking. We can only verify that the metadata writes for
> -- 
> 2.45.1
> 

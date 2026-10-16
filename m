Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A03B43BDDD;
	Fri, 16 Oct 2026 07:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792136882; cv=none; b=JDh12cxvv37nPohtjbWHF6nIBeC7KEDoi/YLAH9h/NeJgWNEk8fN88QK++nC2hvEdB+dlI2Nngq78N3s+J36v3HtVbfu9s/Q8qJQ7ZTqPH+FNdSKFQVRwLsAdpPz+ZgR3Il4dNogu62AloxSoRNfMkWoQx0A/mOz4FdbXvHuWhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792136882; c=relaxed/simple;
	bh=NhQzE/uU8cMIrQvKzf4v3bIMTofFI+vtU+4CLfV2wQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzEqidiZLPdsuiW2eK7FuvSa7uNMOB0lsexxJV9UhrQn2X4fZJGh8ALHtJ1FHgXPS+QsofyJgO+WjqwKBP1WA4fV8VH54xkMxqct0aReF7wTpw5Qb2cUMYAvPFrCSRUVw4aGVZer0nxEvPRfeLnNPIAwETHobAVktNSwhcs7DKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aj9bf57O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aj9bf57O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D8A1F000C8;
	Fri, 16 Oct 2026 07:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792136877;
	bh=TXbuQ+Kz8hy+yyDaUB31iUmMBgbyHhoGEo79qN/aGRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aj9bf57ORBFjzhWMcdLpLM0jodEhFk7yElK+r25cRSCBUIBiTcGh0pdEVdZjJERA/
	 /yRL63UwFDWiHtvWG4/avFKP0oODLE1RHUC7YGloA7IRAQB3vpA6mFZMS8YQ44AdO9
	 p4vdpvt1OAkzN9jY0+4LsZi5RFlBiUug4WzwJPkQ+OjTHf7at50rTCEhlSjCFOKI1+
	 C0mnTUB2UF7QFpqRX8uBet8IipivWFfqfuvNTZdB4aG8mH+99wynVnRl+SXuvtj+om
	 iSteCb+gLWNrhGQtTGzW5n1LFSaFj9hAZcHxfNTIc9tEZDU/dZcGcMHdWt0JbvlQi8
	 42WSt0NgqtRTA==
Date: Fri, 16 Oct 2026 00:47:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v3] fstests: generic: add a test case to check fsverity
 reads
Message-ID: <20261016074756.GD3049@sol>
References: <20261011222613.10793-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011222613.10793-1-wqu@suse.com>

On Mon, Oct 12, 2026 at 08:56:13AM +1030, Qu Wenruo wrote:
> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> +	"btrfs: fix the fsverity callback where unexpected range is verified"

Even without that commit, 'kvm-xfstests -c btrfs generic/807' still
passes.  Under what circumstances will this test fail?

> +# Read the file, unpatched btrfs will verify blocks outside the read range and
> +# trigger fs-verity warnings.
> +# But the read itself should still be fine, as the failed part will be retried.
> +cat "$SCRATCH_MNT/foobar" > /dev/null

How about using md5sum and putting the expected value in the .out file,
so the contents are validated too?

> +# Check for any kernel warnings from fs-verity on file corruption.
> +if _check_dmesg_for "FILE CORRUPTED!"; then
> +	echo "fs-verity detected corruption"
> +fi

Is there a way to use the fserror support being added by
https://lore.kernel.org/fsverity/20261002223705.2175542-2-aalbersh@kernel.org/
instead of relying on the unstable text printed to the kernel log?  If
the string is changed at all, this test will become ineffective.

- Eric

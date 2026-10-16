Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EB625B09E;
	Fri, 16 Oct 2026 08:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792139066; cv=none; b=eEfMxUtkIbRMaAC2L4bXfpb/co+UQinFJfEQ1Jc2spmXaCMJNXValoZgwD/5FKtJv9hdUvgZ6oxp3jG5Fjye/+ih547S/n3upYVtQ+vyvl3UINYTNQHdcyu8OsYHHt1+L3hUM5jxXtwPhiVOwsPumAR6pRMFdPoeXTpdElzTk2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792139066; c=relaxed/simple;
	bh=gsCkbXrLIXVA37R1ta1JzF+wYGHPncuhrdVytEsj6wQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o4ZZ5uXJrscoiCtW4w64yntD5k4UbLDmbhRC30CH3hJB525p2MQ8jQarq2SmSyLzatiGskvRRbSesSEFq9Ix1fGkDkXXVTyg4r0qyh7F+WKo/bmdF8qvlVlrD1esNDH8LudLapCVDuwOA6Jbn24vBop+N9j7U+KTmZQ1SclQBMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UCjp9PBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCjp9PBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04041F000C4;
	Fri, 16 Oct 2026 08:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792139064;
	bh=GlEGrUbnHKP1BjsOjFzfwjsha3/IUQkYBUBacJtTU64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UCjp9PBqGKme3Tn/lebea9zVie0zNnLfc0P+BBr4KNTe9uYEbFMECg3D6aZNwlQSR
	 78HWe5l9TWv0yXOzNpOh5XUiYUeyVfgrBUhDYmldOqBNO0Gw6x95OPEoJigiMa7Fmm
	 wEsXzDLrjQMKnnMTKuZTPu0lkVtP6/CPgBQQG9c45fEBQwzWJnJ89b/26NraqkVShV
	 YmhV2WACGlM67qKVB7SbbPFgqUbRLgYYfbEMUis2ew2AAVj5bwoNMISAHE1R7FqIxX
	 YtZlERcfR9GVe7dZkxtV5Ql2ksz1ipsJVeBg00e3krQauV1W1ZFJARHL0ljKNEJChc
	 C/v7H3Wk7XzCA==
Date: Fri, 16 Oct 2026 01:24:22 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v3] fstests: generic: add a test case to check fsverity
 reads
Message-ID: <20261016082422.GA1894@sol>
References: <20261011222613.10793-1-wqu@suse.com>
 <20261016074756.GD3049@sol>
 <eac493e2-8bd6-4584-bd90-7601a210f802@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eac493e2-8bd6-4584-bd90-7601a210f802@suse.com>

On Fri, Oct 16, 2026 at 06:35:05PM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/10/16 18:17, Eric Biggers 写道:
> > On Mon, Oct 12, 2026 at 08:56:13AM +1030, Qu Wenruo wrote:
> > > +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> > > +	"btrfs: fix the fsverity callback where unexpected range is verified"
> > 
> > Even without that commit, 'kvm-xfstests -c btrfs generic/807' still
> > passes.  Under what circumstances will this test fail?
> 
> It need as least 7.2 upstream, which enables large data folios for btrfs by
> default.
> 
> And I can always reproduce it here, mind to provide more info about the
> passed run?

This is on the latest mainline (2f2f7eeef8b0).  Not sure what else
you're looking for.

> > > +# Read the file, unpatched btrfs will verify blocks outside the read range and
> > > +# trigger fs-verity warnings.
> > > +# But the read itself should still be fine, as the failed part will be retried.
> > > +cat "$SCRATCH_MNT/foobar" > /dev/null
> > 
> > How about using md5sum and putting the expected value in the .out file,
> > so the contents are validated too?
> 
> That won't catch the problem.

I know, but it might as well be checked too.

- Eric

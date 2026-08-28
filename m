Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A366385D7B;
	Fri, 28 Aug 2026 09:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787910896; cv=none; b=MFF/7Yk//fF7v4vvvWUHj33b0iI/W2tSCXn0C4KNVgj/T2HpEyokN8/W3rfI1MkNL3ZryqHpRFT4JJ4edCQZqaN6vHcrtxvEJRJRjb/w1ZWQRHpNG0//lNlPEzK+HlRK8N8+ruajOYxvKahlmLVJtXK74cbwGa36Jt+Lihf12J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787910896; c=relaxed/simple;
	bh=PY4KaIEAj+V8h99m1+zxyRFXgm67Hy1hkr1u0Df3Ejw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxQmyLsJyogEzLcPjczd2l6a6bs7X0lqD/a4N9AUn6SgTqiHdEXUAVte+EoGG3wvq87/b028LTSRwZZ26W1Tr19R5c++Tr6cFGLByq5wqb5474b4Sk2+yg3P1AcyeZCScDUeo/sHMC9LtbRpGETlgQP48HpR5QUrtZR+HV1ODOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AclBVnX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AclBVnX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294331F00A3A;
	Fri, 28 Aug 2026 09:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787910895;
	bh=LByt+f93jbQ9rhJ1Bj4PqBJdJta3wOytvTXyxSTazJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AclBVnX0LEhE18P+PTm6DABd+omzg8W+Lw3ZUS467Pnh2plZUu6HtsayVbcjlMkC5
	 YN749uEWh7+nubCH7PML6D6KqdN8Jveb9TPSHTsWyOB8GC1JizfYuYI3s6KOYM6WGA
	 oe0t5vAh3miNfEpyikwJ3K50pj7GJWh9UwF7zAthWNxHE+uKQ9X3bt4CWROdjW6pTy
	 rkXmfQwh+3YEuOviUd/+juXgaHZ8pAO/x3g9YV2JkzFjaprJxMzVWoxxf+pA0oAU4D
	 IBLvB69uu5wrRIITpMoYoiXNYwNknjVirc9I3+hd5W1u2uytuZ5DkKvAWOCjBnbgSP
	 97ux//P6bNR8w==
Date: Fri, 28 Aug 2026 17:54:49 +0800
From: Zorro Lang <zlang@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] fstests: misc fixes for zoned btrfs
Message-ID: <apFZlAt-u7T2dTEN@zlang-mailbox>
Mail-Followup-To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
 <apBg3n-J7PP2nD0M@zlang-mailbox>
 <c14a1467-c813-48b6-982e-b877f4e5d843@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c14a1467-c813-48b6-982e-b877f4e5d843@wdc.com>

On Fri, Aug 28, 2026 at 09:20:34AM +0200, Johannes Thumshirn wrote:
> On 8/27/26 6:09 PM, Zorro Lang wrote:
> > On Wed, Aug 19, 2026 at 03:16:00PM +0200, Johannes Thumshirn wrote:
> > > Misc fixes for test failures (and a typo) when running fstests with
> > > zoned btrfs.
> > > 
> > > Changes to v1:
> > > - use _require_xfs_io_command "fpunc"
> > > 
> > > Johannes Thumshirn (5):
> > >    common/btrfs: fix awk field separator in _check_temp_fsid
> > >    btrfs/199: skip on zoned devices
> > >    generic/746: skip on zoned btrfs
> > >    btrfs/284: skip on zoned devices
> > >    generic/781: fix copyright
> > Hi Johannes,
> > 
> > Except for [PATCH 3/5], which still has some open points to discuss, the other
> > 4 patches have all been acked. Given that this is a misc fixes series, would
> > you prefer that I merge the 4 accepted patches first, or wait to take the whole
> > series together? Either way works for me.
> 
> 
> Can you merge the other 4 and I'll try to get around and incorporate the
> feedback to 3/5 ASAP and send as a standalone patch?

Sure, you can take a look at those 4 patches in the "patches-in-queue" branch
first.

>
> Thanks,
> 
> Johannes
> 
> 

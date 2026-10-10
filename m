Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E4835C1AD
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 07:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791618629; cv=none; b=HyHDrKtOswJWjjTCTjO/q1Ykm8F8wkqpXkfggoz4Jd2vkNe7imlU9FfDkZZKkWj0FC8YOZOYC9FlDb2zmicAKfhTjLYXQ1WtZnclri7+b377qQK7FdbTZEPlVe1UeZE8jmLIghOYa+oHgrDLdrhjuV2rmUuQRMXT2mx2Zr1UPpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791618629; c=relaxed/simple;
	bh=w+syYV2HNn+5D8VrjzjJ5xYpKCMoDWmyULcbMR3axE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRLtkC07yKlxRJJD1Rqtbc0Pzqd2mXf3gjAiwm3BV+ALY9ZQO3OWGtFa1lr4jaNylATa76v/8spYYXruHpG4+sW8tAn1aqgY22muy23q15SAN43X95CoqGWd3fzFsLkDncRvfycRtaJcozxh2JMYft33KCX/iX7cLxDjuA18Obs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YqGOYhDG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqGOYhDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C131F000FF;
	Sat, 10 Oct 2026 07:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791618628;
	bh=m9xQJRKwKNirwv0DszCOBPTXepHvyZO5pt0yVQ+NSms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YqGOYhDGXO9l1smCOXvX7iK0A9zexyLZfno9/yGZrRPk2lS/Vg3OyLXlRwKKF+w22
	 JHedMAOMwymK8467VJ7vsffTRdaT/N9Gq9UJMgaU4vbsjk64qgnAtDsX6np1za3egu
	 UuDbBIuWxezDd7BxYPVtYd59KIsYzc0tWIoxOvn7K3F1W3mkrm7a/4jBhIIuEt9L+I
	 iFz/kBF8j+LvjNwhdUKJJzCmtYsCP37L+zOlB8nnRuhxoGvjnydMaKIWpG0KBLRQTQ
	 epEKlRkYYLnBaQlddfTIkmOjeYiqnA5Pw5wme5MbE5LXyJfYWWxWLYlGheU3W4JzYj
	 12ETR8UQVjubQ==
Date: Sat, 10 Oct 2026 09:50:23 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Roger =?iso-8859-1?Q?Alas=E0?= <vonbloom@gmail.com>
Subject: Re: [PATCH v2] btrfs: fix the fsverity callback where unexpected
 range is verified
Message-ID: <20261010075023.GA1946@quark>
References: <15f4ef9f50e1f4af375e45cf976717041f1a96d4.1791613764.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15f4ef9f50e1f4af375e45cf976717041f1a96d4.1791613764.git.wqu@suse.com>

On Sat, Oct 10, 2026 at 04:59:49PM +1030, Qu Wenruo wrote:
> [BUG]
> There is a bug report that on v7.2 kernel, compressed extents with
> fsverity enabled can lead to warnings like the following:
> 
>  fs-verity (dm-3, inode 257): FILE CORRUPTED! pos=7471104, level=-1, want_hash=sha256:bedf0e7bc93b48694db719001a8d3e79229cc58ee638b41d4149193505090774, real_hash=sha256:ad7facb2586fc6e966c004d7d1d16b024f5805ff7cb47c7a85dabd8b48892ca7
> 
> The read itself eventually succeeds, and no read error is returned to
> user space.
> 
> [CAUSE]
> Since v7.2 btrfs has enabled large data folio support, now a folio can
> contain multiple blocks even if the page size matches the fs block size.
> And even before that, btrfs already has block size < page size support,
> thus all involved code should assume a folio can contain multiple
> blocks.
> 
> However the function btrfs_verify_folio() calls fsverity_verify_folio(),
> which verifies the whole folio, even if the read range only covers part
> of the folio.
> 
> This forces fsverity to verify garbage data that is not yet read from
> disk, and causes verification failure.
> 
> This is a long-standing bug, but previously it only affected bs < ps
> cases which is not that common.
> Now with the large folio support, it's much easier to trigger with bs ==
> ps cases.
> 
> [FIX]
> Instead of calling fsverity_verify_folio(), call
> fsverity_verify_blocks() to verify only the read range.
> 
> Reported-by: Roger Alasà <vonbloom@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAELqY9==Ter2XQPRp=gjW5T75T+7kcZCXpn5roF2L6tY6mQNxw@mail.gmail.com/
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Tested-by: Roger Alasà <vonbloom@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Please add 'Cc: stable@vger.kernel.org'

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric

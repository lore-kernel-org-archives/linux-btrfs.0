Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C290D494A00;
	Fri,  5 Jun 2026 08:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649316; cv=none; b=V1xFGQAbTp7/UY6J/B+AKElHnP4YcKDFZavjvHuqYgaDhUuXZALi40Andpx/UaiKuNsu7cM5mTy6WVA5efTnS69p1tjtklFdO61wtOv3nAkIeFtT4tlv+WIZZD5f/3G6s2Bp4MEFWeXf3kdA8z/9GbNnpJhpbsWKtSNC3XGXllU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649316; c=relaxed/simple;
	bh=NEJA55B1jSKEw5GaZK/oaxMWpgzmz1OtIwOjNaoi+zw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e3JhRQn5GJEuDuQ1K7BEQSMzd0ps+6wYcYd1hvcoMlLYHyPwnCxK24fkyyPmW+yrYcfTP0DLrNGA5oZSVBIH0MTmNovwjprQ1q8J4JZZ0GCFfhsm819DlOqm8gw/xi7bL4UHESwBYs9DZQlHN9pc2yDQy5zdU8j+u5snNDfCvzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=QSrO+16n; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="QSrO+16n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NEJA55B1jSKEw5GaZK/oaxMWpgzmz1OtIwOjNaoi+zw=; b=QSrO+16n5oiqgu60+EaPOiNbFf
	stAbQCEPMKhABONC9+joPt3vwfDyR9/X1VspFSfDF/jpwe5WRMLx2aGY5HyLY1341GqTgQ2bX3oVf
	xo6z0mnOw3G5B6TUtIE/5lw5oBxPrRBiG9Q7pCTYz4vodvjSErWZNdEPZ7QuIjazlWFDCjpf5h9iU
	kRe3OUFr4Z7ztJ6uhjyvKXwYGpCISYowILmJrOCH6BRSl9qlkgOBqaLvaD3mBe1hhTKzGaRIH1ygB
	Rx9GADAxpqqOMW891w4MmKIe2pVtc0lRtahV38X1yf33phnbrzMYTfXTA28V/X1DMposWuy6V1JI8
	t+R+0pSQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wVQE8-005AgX-1t;
	Fri, 05 Jun 2026 08:48:28 +0000
Date: Fri, 5 Jun 2026 01:48:24 -0700
From: Breno Leitao <leitao@debian.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Marco Crivellari <marco.crivellari@suse.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Drop WQ_PERCPU from ordered_flags in
 btrfs_init_workqueues()
Message-ID: <aiKNJN8w9Zq2s-Zy@gmail.com>
References: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
 <aiFKsSlaq-_VBGtZ@gmail.com>
 <20260604215811.GB3915915@ax162>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604215811.GB3915915@ax162>
X-Debian-User: leitao

On Thu, Jun 04, 2026 at 02:58:11PM -0700, Nathan Chancellor wrote:
> Could you please pick up this patch for -next to clear up this warning?
> Not sure if this was on your radar since it is a btrfs change.

Why not getting this through the btrfs tree, given this is a btrfs
change?

--breno

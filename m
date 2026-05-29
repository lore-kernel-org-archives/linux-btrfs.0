Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870BA326930;
	Fri, 29 May 2026 09:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780045369; cv=none; b=NCIjyON6KfwBTK8G5M3BdtOGJeC+P8x8mamXF7W5+p00Dv+ubIuC8hN5ftbCa71Zas92dX8tjSoD6FaOJbEma3sC7gXxcCm+fUXuzNdzkdytZiMuujEkZLJLNa4v2pG/E0xpZKVZAhl3BnZaxF2qPVyIDTQbZyvQwnxVQPib8sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780045369; c=relaxed/simple;
	bh=E9SGioHdaiyNDjffWGZLOT3Aud1z7Z5wVnxNK2qa8xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7QAfrKH8+Kv7mo1in4bCdk5DngHq7nZcsQ2RQ9QZQkBv/67kcMYW4ijiS0Y2qncBqQnZcyFa4bSJXwCbxUYexKxn3eDLPejLkki7+ZZmOZUclDEJyU0uBvLYMhtGngsOQBAB4NEoKPQApR4IjZZ2QCpsd+pX5zPEiWSMAG0gik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PdaXX2Xm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PdaXX2Xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415B31F00893;
	Fri, 29 May 2026 09:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780045368;
	bh=NY7cw3MXJfHKk5ZESWi1LozZjh67IEzAA25bdaW2LCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PdaXX2XmhTDyeHYufyzLnEZ0Yn5wcKlihQk0tLl5Q1ugNqc+3rL2OypMW8cp9SSLq
	 VFtu3nb75J+lPrGzoZAQHYNWjqCBQC14u7nHYGAJnUwYo6EQRV/iftO2VmQ6b/Bwh6
	 ISRkn5YKLvahf1YmSmBzTDBxwoKvcgTlm/wE0St8E86aYROB0xBrxgo7YdjzyyDHvp
	 jqNNOu0nOjNObb7jW874ae/J5JgeCCEw9bteHZEGdeckAQ1JRbOov1EL7rceW+4PCI
	 Uyzy2WovhAUOZqfZp2s2G7tsaMSXQK+GR2OAvN9095SeXA8g4AdleO2i4JdPXdWVm/
	 eZFzrT+UXxwhg==
Date: Fri, 29 May 2026 17:02:42 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic/362: remove the old file to reflect new
 mount options
Message-ID: <ahlU702Bo_QRTCCY@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, 
	Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20260526070055.60193-1-wqu@suse.com>
 <ahaQjYYQWcuOaRaq@infradead.org>
 <e9fc0374-4a97-4cab-8f9d-9de39587cbec@suse.com>
 <ahbrvyNg65OjGhpS@infradead.org>
 <bea8a50b-4a14-4351-a56a-d295b90750b5@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bea8a50b-4a14-4351-a56a-d295b90750b5@suse.com>

On Thu, May 28, 2026 at 07:12:24AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/5/27 22:33, Christoph Hellwig 写道:
> > On Wed, May 27, 2026 at 04:20:38PM +0930, Qu Wenruo wrote:
> > > > I'd rather add a copy of the test that runs on the scratch device
> > > > that can control the environment.  Or maybe just change the test
> > > > to use the scratch device?
> > > 
> > > I'm completely happy with using scratch device instead of test dev.
> > > 
> > > If no special reason to use test dev, the next update will go scratch dev
> > > instead.
> > 
> > I went back and re-read this.  What is the special mount option you
> > change?   If you want to always exercise this as nocow, maybe add a new
> > btrfs test that is a copy and uses the scratch device?  Or am I
> > misunderstanding something?
> > 
> 
> My point is, the current script prevent the test case to respect certain
> mount options, thus reduce the coverage.
> 
> E.g. in a multi-section fstests setup, default and nodatasum mount options
> are defined in different sections, and default mount option will be run
> first.
> 
> Then the next nodatasum section will still utilize the old inode created
> with regular default options, thus reduce the coverage.
> 
> 
> Sure, a dedicated btrfs copy will help, but that will introduce duplication.
> Not sure what is the proper way to handle such situation.

If there is a specific btrfs bug (commit) that can be 100% reproduced by
slightly modifying this case (e.g. use a specific mkfs or mount option),
I think it’s worth splitting it into a separate test case for better
test coverage and known issue tracking.

Thanks,
Zorro

> 
> 
> For now I'll follow Filipe's review to use _cleanup() to delete those
> involves test cases.
> 
> Thanks,
> Qu
> 

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A774A99C1;
	Mon, 31 Aug 2026 17:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788196887; cv=none; b=LmfbHCDAIgAO5xTBZ4HTqk4P/QFs+DldB83p1cG23jB7pKJpqt51y5QPDu7XMzot9RfavF03LYgODejM2Nga1vXHqkhJ8JUU7XN/8DjLik/pODr0PVJkYnfqe0wA4h7LHelnT56vnvqT9XDmIp0MCtlRlHNCWeHnowM4cta5VwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788196887; c=relaxed/simple;
	bh=3jic7HS0wvAA4oMkaDrt2hmPOevvpsCS8jSDtKAOiTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IckkaqLzkIN9abrGfiu39ltf3RcWGl6gcG9GJ8596ETS65SXxpHjiPwxP62QYHf/wo+vLP5bnaiaBnYtAXZE0VtNl7pQVWef8JZTU1rYOk6NMuYkmSr1RtSc7WSFsQZEBiK5jLlpXD0rmTqejJ8Dsw4gLcDGYvkJ6I0EOQLFagY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTPRpAPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTPRpAPT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 800491F000E9;
	Mon, 31 Aug 2026 17:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788196885;
	bh=x4iiAI5FbU8Qw4EpivTF4nKQ+Rj/3lSL1bGUFxftEgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dTPRpAPT2eKpMNyPk2GmqETiLEJuZp1jomv2kHGaM/fGfhmTihcny9ImFO1eLFfsZ
	 ww0uG07xTK7ULLw0nUelyRwTWSdDgJEZa1p151qQZrIJsh4uRjVNa2PcRksXA/0dgB
	 wWRnu2SFYW4kWTVSp3qZxmnr7PBNFsqSXdsI2s4Wf7AtG77YrdQ3225+uPwbckMZ5U
	 37V13/SHdB2GvXpiuxuKeU98NCsnuVxTtMH9IXFxdqRC6HXOZiAKqMbgrNheICEJDU
	 Uw4xLeDPxzsxuxLTvj6G69dQbfqWxIohNlalX5mUWyO2zYZT9+9qh8a1MEq+GhsBmz
	 QPYKSSwUFr4DA==
Date: Mon, 31 Aug 2026 10:21:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs/333: require scratch before checking encoded reads
Message-ID: <20260831172125.GI839663@frogsfrogsfrogs>
References: <20260831104200.2269-1-prabhakar.pujeri@dell.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831104200.2269-1-prabhakar.pujeri@dell.com>

On Mon, Aug 31, 2026 at 10:42:00AM +0000, Prabhakar Pujeri wrote:
> _require_btrfs_iouring_encoded_read() formats and mounts the scratch
> device while checking for encoded-read support.  Without a configured
> scratch device, the test therefore fails before reaching its existing
> _require_scratch call.
> 
> Move _require_scratch before the encoded-read check so the test is skipped
> before its first scratch operation.
> 
> Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>

That looks right to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/btrfs/333 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/btrfs/333 b/tests/btrfs/333
> index 6214d7c..9dcdf1c 100755
> --- a/tests/btrfs/333
> +++ b/tests/btrfs/333
> @@ -13,6 +13,7 @@ _begin_fstest auto quick compress rw io_uring ioctl
>  
>  _require_command src/btrfs_encoded_read
>  _require_command src/btrfs_encoded_write
> +_require_scratch
>  _require_btrfs_iouring_encoded_read
>  # Encoded writes are reject for inodes with the NODATASUM flag, so we must skip
>  # the test if running with either the nodatasum or nodatacow (which implies
> -- 
> 2.55.0
> 
> 

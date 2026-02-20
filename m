Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4AC32E724;
	Fri, 20 Feb 2026 13:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771593657; cv=none; b=Ppr/l/z5dbkfFntDFN1LFnh5tNohac+MxmjdUpGhxcm1P+vSjrvf7oPm1MEDey/nrA5jwmKgymZvvwtwZDORiOe9rMGQNBgIMdQpAsfj9r5utYPXQru23KZcmPLbEIQTU/kYnfWGChEoLGNrFcN2iAhHnOGifJA74JEynmZA2Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771593657; c=relaxed/simple;
	bh=+/qPuPAVaJSpihzZa+SDcXfGfdnlNwfaWfbPw+GQyDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/JY4U2gcUgmYQUtsbmvkAKDlXFggQ02BkbPvkNgRF75eOCIxGJX6NAtAMUjsmrnQsffX+9Jgl/TH/k9pjhc+lOpeef9azT0SZ0OfmXZNMR1+PT1bVWP0JkpEo7JU/srH29eWrKnMXGGzodPspH2wnBwl1HSwdxlksP3hjPEsFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A54vb1jV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A54vb1jV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF06C116D0;
	Fri, 20 Feb 2026 13:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771593656;
	bh=+/qPuPAVaJSpihzZa+SDcXfGfdnlNwfaWfbPw+GQyDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A54vb1jV4QD7H3Ux0lg52BYY/99wnh+upsYDRaL4oQb7hvedAZnI5J9ZLjHCfx1LC
	 RbtHtu26J98IFj1pQkmSsbPPk7dddpiQW908RewGu1C5100prQymd9wPl6zVkG5jai
	 uwqvxsEXf7xcQqsN9rRuvQYmP+Ea9SDs0riDn5kw=
Date: Fri, 20 Feb 2026 14:20:53 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org,
	johannes.thumshirn@wdc.com, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix chunk map leak in btrfs_map_block() after
 btrfs_chunk_map_num_copies()
Message-ID: <2026022052-aqueduct-gallows-a487@gregkh>
References: <20260220130209.5020-1-mark@harmstone.com>
 <CAL3q7H6RnMw=GLAuv20u0e8azr5Tyr_wXFKKjUEgvp3iFAak_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H6RnMw=GLAuv20u0e8azr5Tyr_wXFKKjUEgvp3iFAak_g@mail.gmail.com>

On Fri, Feb 20, 2026 at 01:07:27PM +0000, Filipe Manana wrote:
> On Fri, Feb 20, 2026 at 1:02 PM Mark Harmstone <mark@harmstone.com> wrote:
> >
> > Fix a chunk map leak in btrfs_map_block(): if we return early with -EINVAL,
> > we're not freeing the chunk map that we've just looked up.
> >
> > Signed-off-by: Mark Harmstone <mark@harmstone.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 0ae653fbec2b ("btrfs: reduce chunk_map lookups in btrfs_map_block()")
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> Side note: if there's a Fixes tag, we don't need a CC stable tag
> anymore nowadays.

Not true at all, please read:

    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

You HAVE to have a cc: stable if you know you want it to be added to a
stable tree.  If you do not do that, you are at the mercy of "when Greg
and Sasha get bored and attempt to pick up things that maintainers
forgot about".

thanks,

greg k-h

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793793580;
	b=GU1ZXOcVWdebi2ZR5HccG9gABWlj1ezB8z7gKni+xmBTICRQ+zQQpc6TkyVoAROPSv+n
	 pWqVAhKb4yCBpQAlGgZaKX9fNVchwYfY4gWT7Nl9bUqmzbY/XsC5nj+ED4CnIlDqj+2LE
	 wlhCTxwObn1JSUDnX116kOqWOmvNR3IFIQh8pD1qxULiy8xOQkCx8tY1yIe0JKZCCA4sB
	 tw8UnUWVnC28/nnX8knL//+BUd5Sk1vp+C9LvIMvk18OyqxchZyGANImhJKwYWUe9LURa
	 rqLgadEuOILcNKar9Xlf/+HjDGfWXMIwC3whuFrK21QdjMFl4vlElJ5FulUwYB1hJnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793793580;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BkxAcssqhwrfNZxxJ2vO5PwNZOlikVUGFuoBFpDKXJI=;
	b=oRpM9HWA+CJh8XiEXTt+SHqkFtMsFWu1S97omLYz7zjQqJ5nGrSQt+4/4oragOkdcP8b
	 9Cj51kr4mGeOUJ+eQ2FrhYWMODQbQ/f6xRrC6NxppkccPi54G74AG8z9ex28Db4CGzyz/
	 +62qIHC5yu76zAXo7qWYIhxLUff0xSiaInojORvm1u2IQmsIjnAJxRZq1Drz7KznefN/P
	 g0+OV0hZpNbzcQUDSMwpRvRTx/pdmgwsNJLSiVM4FEcx/5vMjmYx707DTTJySNFYY10jh
	 wm9nFgHGkOTSa0QRD3ms2fcK7UCftlWIIy7J7m5egfV6eO6/6NV16wDiE/g3WGm91fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FjRRlWkH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BA7606A326
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 11:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FjRRlWkH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7FF1F00A15
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 11:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793793580;
	bh=BkxAcssqhwrfNZxxJ2vO5PwNZOlikVUGFuoBFpDKXJI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FjRRlWkHaxwfRwqJrzCnbAPkUDxseOy6iFpd9vQdZ+nc5w6kKYS/q63X2xhCXr3OV
	 DUlOn+Zq1AVcPvnVILNE3GT8gkGZhKzsIhe/GZstoH5VgFNCocx+mnbo3Rh+oMNnyL
	 uA8AOt1jkt9fMyUaK2YuMGMj2j2OgvO6rFbw2py2P9hyN/7nBB+ZLVGGal5opiWm+1
	 b5Kb0R5eD2OvFukZezuHqj15/YMcJS/8gzKfVz9iCdswj24ZC7PZdZjrNbJdL8+cH+
	 yoN2nAGKizF1yn7Pnne0n3bGIJ8jFArml6gIB/nNcvXYs0Q3rVdX8x96hm3Kaw/kyT
	 GO9a/OdyncfNQ==
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-7777fa8f1ccso145645137.3
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 03:59:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwm4dVD+rIsH5VNNuNSg86CD3lfKOtzCqA1zwz22aVMUBeJtekAVCvI/nmNjyJ6d9SaM36orA3MTeYksw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9+WDS0FOWX28blSKqgwYAGhwlZFlZZ8a/UaIwHlaNGqhOPY5jB
	bLQPyWEdUEe2KWt/sBR+GJ+qCJHa5YB2rd2cjhDM0WzoygjQElnKMfiqASzW3uP8aj9zj9qCmE5
	qlZB3AiuLcNiRi/mHWjDXxdSxQ5JT6d0=
X-Received: by 2002:a05:6102:6058:b0:7cc:95ed:30c9 with SMTP id
 ada2fe7eead31-7d0726402e2mr4408220137.29.1793793579252; Wed, 04 Nov 2026
 03:59:39 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <c284dccd8c27a6434e56ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com>
 <aurorIaI3EAocPQE@infradead.org> <514c3590-27bd-42e0-b248-ec422a58e502@gmx.com>
In-Reply-To: <514c3590-27bd-42e0-b248-ec422a58e502@gmx.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 4 Nov 2026 11:59:02 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5SFM3QGHnpEdgJepBzC0g9SEouDvpjkcdW4DCzquAVTA@mail.gmail.com>
X-Gm-Features: AclHuK8CfLAXX3Uyq-1Y2PvDwJwk52Te-BNl06jAdLbsZFDLox3ksFGyCG9W1sw
Message-ID: <CAL3q7H5SFM3QGHnpEdgJepBzC0g9SEouDvpjkcdW4DCzquAVTA@mail.gmail.com>
Subject: Re: [PATCH RFC] btrfs: wait for encoded writes in fast fsync
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 8:15=E2=80=AFAM Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>
>
>
> =E5=9C=A8 2026/11/4 18:41, Christoph Hellwig =E5=86=99=E9=81=93:
> > On Wed, Nov 04, 2026 at 05:40:46PM +1030, Qu Wenruo wrote:
> >> This is only covering encoded IO, not direct IO.
> >>
> >> As we should not mix direct and buffered IO in the first place, fsync(=
)
> >> definitely counts as a function in the buffered IO family.
> >
> > It absolutely does not.  fsync/fdatasync covers all data and metadata
> > changes.  It is a fundamental part of O_DIRECT data integrity
> > operations to write back metadata and to flush disk caches.
>
> Even if there is a direct write in the fly? How would you even detect
> it, there is no dirty page cache in the range.

In btrfs direct IO writes lock the inode (vfs lock), create ordered
extents and then unlock.
Fsync always locks the inode (in exclusive/write mode), so it will see
the ordered extents and take proper action.

>

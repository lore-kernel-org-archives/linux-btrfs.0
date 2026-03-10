Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0AD40DFB1
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 13:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773150048; cv=none; b=iZwDoRkrbLTFiSRk2SZEAX3dRmCnkNMoA/mjZMy6PZcQgMUJTDyNb48xbk+nfGAMy5cqyx7Um/B6lRUmXgbAsJmvShHTpRzRjehf8fQwVqlhBCSLxcVYKBb3ievaw7SuxEDpsPIa5xgoGLvmT+IPumtNqLvsYNJ/BfjttFTskcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773150048; c=relaxed/simple;
	bh=EMW9Sr4WgrFhXTOPAzIcV47orF4/J2jE1f9BIXSit8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ENcTpD8THB+QqIBPSxlZH9y3/RP0R/M2DmR6UB3Z40uDoC0u/ArP0MbEsI7NUDR+NfkzuNVv4TPZblIY8J5Cns24YiJDMfNBYcj3RDlrC+corfpH6V74l472w4Sv1L+fCnC1N5oczLyAI8YswvL5Ni1/ZKEo7agrZ+7J3YHLEfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kadi4Uaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kadi4Uaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84EBC19425
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 13:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773150047;
	bh=EMW9Sr4WgrFhXTOPAzIcV47orF4/J2jE1f9BIXSit8U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kadi4UaqscTIYPZWnJNdVKOngoPgZ0RyvnwsL6JhErfyXyXaKp7dsYOlpfyQxM8GU
	 50SICPLkG08ydUS8M8c153UhMs3JvtXXIQuJSuQ5IHX+cMiIPRk4eLKWMOPg75nGRb
	 WTYqP2TYiLJxFiqjZ+IzLGzqYRxJZjW5Luv929l0IMOwi9GLv29l2L/FluNZPIUuh7
	 o1VPk82wZzIYmPz0PVCHS99ONPT/d2vLeNgh+l1wqddYKdDYqMS67e0LW8rJi2MhgV
	 qMvcvYC8BBdKku1cZJh3t1lr54sbDRmXzdeO/M6x8LRQ/UFoO7xCRIsSR60Jg2B9t3
	 PirfZlid/9U9g==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b9704cd6951so183355666b.3
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 06:40:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUnWIrGXjdE9VwUPvyNDKmRdAz7TsdXDrWIitj7pMw/xDAVm59ehmYJ+qI5jckQbVZ5q9AveFiH3he56Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwuFoxGYDJOS8KfZUXzHPZSUf6Fym/2TGxUA7mxlKdv/Sc2Pv3Q
	9/y6Gtlu/bjhf12t3eo0vS5OWJ/mgSGiSoIuDVyGglKbEf/dVCy/rJfu5iVxUpef7PNQI0q7xnL
	BiAWuDSYwLJLDzNDrRDEf+xd9NzRcp/s=
X-Received: by 2002:a17:907:3c91:b0:b97:3db:c7cb with SMTP id
 a640c23a62f3a-b9703dbe04cmr339433766b.46.1773150046254; Tue, 10 Mar 2026
 06:40:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a1e2690efeb8570651894567d80511144424fb5e.1772106022.git.fdmanana@suse.com>
 <aarmPHmLnGtvhUcO@infradead.org> <CAL3q7H5r5_FuTSUM_5TqFGFPSZ4qC=qG49_JuLpUfzFCa=8YyQ@mail.gmail.com>
 <abAZDvPLRbCeQh1D@infradead.org>
In-Reply-To: <abAZDvPLRbCeQh1D@infradead.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 10 Mar 2026 13:40:09 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7GhATX4hMqtgvJzLS2G8qoWwD8nYPFwQ771WgMjacVUg@mail.gmail.com>
X-Gm-Features: AaiRm53Kc58VM1mM17n1jX-p2JmPqwHKRjIa7PRoPZT29Fu1Vxy2VRUM4JT9Q5g
Message-ID: <CAL3q7H7GhATX4hMqtgvJzLS2G8qoWwD8nYPFwQ771WgMjacVUg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: test create a bunch of files with name hash collision
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 1:13=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Fri, Mar 06, 2026 at 02:55:23PM +0000, Filipe Manana wrote:
> > > Umm, file systems must handle an unlimited number of name collisions.
> > > While going read-only is of course really bad, just rejecting them
> > > can also pretty easily break things.
> >
> > I don't think in practice we get a large enough number of names with a
> > crc32c hash collision in btrfs.
>
> That's not the point.  Posix and Linux file systems don't have an
> error code or defined condition for adding this file name would cause
> a hash collision and we were to lazy to deal with it.

No one is disagreeing with you Christoph.

What I was saying is that giving support for an unlimited number of
collisions would require an update to the on-disk format, which is a
lot of work as it implies metadata changes, feature incompatibility
bits, updating the user space tools, etc.
Given the work that would be needed and the fact no users have
complained about this (to my knowledge at least), the motivation for
such big changes isn't much.

>
> > Adding support for an unlimited number of collisions is simply not
> > easily doable, it would require an on-disk format change (new key
> > type, item, etc, update btrfs-progs, etc).
> > The motivation for that is very low, as I'm not aware of users ever com=
plaining.
>
> Well, how would they know this happened?  The users only sees the file
> system acting weird in completely unpredictable ways.

Because no one reported -EOVERFLOW errors when creating files. I
haven't seen it in more than 12 years at least - sure it doesn't mean
there isn't someone who hasn't hit it, but we don't know about it.

What this test is doing is to verify we don't turn the fs into RO mode
after -EOVERFLOW - which is actually a regression we had since 2022,
and could be used as a sort of denial of service.
This is a useful test for us btrfs developers to make sure we don't
regress on that.

You may disagree with not allowing an unlimited number of hash
collisions, but that is another topic and doesn't invalidate this test
(and that's part of the reason why it's a btrfs specific test).


>

Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893D037F33C
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 20:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787688430; cv=pass; b=Zm7wGETHOSzYqFSA8Pp/B4FPH+pQ8OtxWhtArdvDZhiPfLAPAaJR5a0Vi7tTQDW8QYZP6opzclk3tyhA+4AqxI7QbhRPWCasHGv0kk7nN6dz+c3z5wJI684bFuzgbSkdcZaODtBJzYGff41W5WsB3pxn9LocqUHcIA5vEv4P0gU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787688430; c=relaxed/simple;
	bh=YuDwdWxWI5Vzf2u31gjFFz05KsfDHJyOtaNcUhXTBZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PcH7YU2tm92QW7Psa5P61fyecfK71MoDLTps9eiLxE7T6lVG7zRfOks+6KF4TCfqF9XN4JBbbBQmkhUnqNcv+nEBDRkbWPmqVRc4XnE2KmTudAiQIw1/byBEELeB80Zhjyv+DlguXIqG5uxJHIGevddsr9kq8i920GCS2AJxh4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NKpEO3uP; arc=pass smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NKpEO3uP"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ccdf36f63dso33795ad.0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 13:07:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787688429; cv=none;
        d=google.com; s=arc-20260327;
        b=NI1WdpvTwIgkBxpgtvoDf7dsfADa5SsAS32sQiTY+9YOYlv3kMC3Drct2cxCA5ReH/
         vS26DXgm2gKdhY7SWBugEmbTv+RukZCuYbhhIu9/FyfQ3PX1PGcdg2H/xwaKqgkq7JZU
         Rd9nAZvWf9aQI6MYtKhoyVpwOThazMVLSzDcEfCgyjmFfwPJKpzUWg9QQkLw201bQwSl
         gficDDsBtWTL4TolpKP/FladllIdNYvRZK4MJDZs56LTk0bn9C8XLrCjKfx+c+ugjnWC
         aetwTZvCdFTgsbebm6lIphNTomLhh5GLvXWrRaiFSMOsZCsy4lkg1LE6YwMt57q692HY
         thCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QmpPvlugr4sJVMK76hZIVWaN8XuXLrWZ5bMIrs2ohCE=;
        fh=81cS1GBPCfc0CcExvy3JEWoSo6yekNzbNs243q6GwoU=;
        b=gWxGc3HRv384HwvOXl/uq82YC0ISq6sK5Akm6oLDccbQlIN9LolagXb/esTLeAKoAJ
         t4HryD3h3GMs7f7UeexlM8dh+AnLC3iBeEz4KuBfLsa5iqhKykpv/XR+d1P8xkV6gVYI
         rqrJAmmyWpih7eziIuKARkPsDF/9GcdHNK1sdgXSvuEY1oVQTWeFmQu/HQbqpl4p3EaS
         AhA/M2g00az5S8SIcgkNZzTzFF+AVG3+4roudLdgvYeiARW+vXdc8y132hpkdSiD6Den
         S6HQJaE4+u1lyFrurkGNQUnE8l13il8Z0UGzpsZro2GV4rbbMyaIP1QXydeaBbU2SIZF
         OKIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787688429; x=1788293229; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QmpPvlugr4sJVMK76hZIVWaN8XuXLrWZ5bMIrs2ohCE=;
        b=NKpEO3uP3XiMvqGfLcqjvFeuJ8D5jsq8I30qKsRalF3gtJ3h4tH5Lafr1necQfKysZ
         XQRl7e2mqv37A2Y/hJoax2/URWgHbgF2/9EV7ks01fPYeDmugp3BOYx/jOQ5mfF4wh1q
         dwEZ1M8UNmRseI9gwbmaY8S1g6twVjXOhhGNJFTN0V6xYaVLSe5URyBq2sAcCeaW02zk
         lOtxG5ieucnN1r2q0ZuCkOW/k4vvZNLBGn5ByYKUilxok7L0S27kYw7+IVB08EPcvwU9
         g/orUJwfXzxLC72dfLYIKNoFLdSJ9opP8lsBuAR3J2zIgqq3dnNK+qz55nJ84H9kgK6p
         z7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787688429; x=1788293229;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QmpPvlugr4sJVMK76hZIVWaN8XuXLrWZ5bMIrs2ohCE=;
        b=bN8HCx/Wo4o4b/BH4LZP3UEQgtIgVr2mXX261HShKFIBkk8IHp1d0+KX1mtSKIeuWD
         sHim+4KjtZK3IE7u+q4tyrwlGf1oiTsH/TIgOA1g5QUJ5q0OcMaStpLILQItBIN/nS1m
         MqAK/1or8iBTzzIIh8yLK4CWzfnDJiBOIjMwWpg/i/IiqRLJSiTAvBKZaz78GlvTyWwa
         DJjTBeoH1qPWMwwHLPRFUUeweiYBEARlsoGCYIyh1ept4oOEhBDL6VgiKbhCSZ7vlw7a
         R+8n9FDQ83Gj/GHdYNYoZrfq6fQ7mxmAEwG0EJX+/Kb7wlF9oS2/KdVgorMgvk7Zmi36
         kXvQ==
X-Forwarded-Encrypted: i=1; AHgh+RoXpMWPxo41KrvOzd/rFvxD62HJAzbuUL2cZ1uSeMfFr7mC2qUBD/ZcnSGtSvk0DCMFEwNO/ZZXvUsbOA==@vger.kernel.org
X-Gm-Message-State: AFuF++me4D3EZiVNkxUMXfFPximI+p7H1FLEm+OiDoPB8Wydy8TKOynk
	jzRLq8baLYWyqNVlXtjDLbY377oT2H0YJbj47nfphlveQ8cvGk+ySzP1XJc1mNd64ekzjOG5c/w
	8Kn9hVdfEkh1UueaKsLxIuJYrYd4hpWKvNv1VXTjM
X-Gm-Gg: AR+sD1100GVUaKi2t9FZS8brGMfPoIT4/0anSv0Z5DKmdLiv26kjzuUOzg+uyu1BbAk
	cxL2lvv1c4+lKJrjvtKa1VBvfeHA1u4hSp/zIyfJ80HEd8dpP/OV1cQ4wNbPed3OL35YkPgk6kX
	pWuelNo05CKxc1R32leat0bs18nApFvmn+w1XftrNXhXumY8o3dOTdcHDGvZ+ov+SwwTQpRpY0w
	x1a0hFMJM7/mqnqZNi7+MSvjRgzVjkTc5D61mgoFhmfYuMjkmsFMX9/pZ5u8O9CsYvKP6dNvF15
	QmfbR1EpRrTFIVQNAAfXMFeIfajioC4Iy47EnEBQxyW2HYpfALG9td/8Bb9eywPChpFbtXSkx95
	EbJyeqIsad8WR8dquIzUbUEl1RpXf0Q==
X-Received: by 2002:a17:903:4b4f:b0:2d5:c090:3810 with SMTP id
 d9443c01a7336-2d70baa1fdemr376215ad.2.1787688428259; Tue, 25 Aug 2026
 13:07:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
 <ao3y8TtEGjniZ_4f@casper.infradead.org>
In-Reply-To: <ao3y8TtEGjniZ_4f@casper.infradead.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 22:06:30 +0200
X-Gm-Features: AcwNN1U7imKfFFWcqWcxt2X9g3kXc7_YW65q6sOXIrpi9lP4BGYdXKwulbCkr7w
Message-ID: <CAG48ez1yGUcS6AgtPXnmPQDmVCnJyptu64YGsTw=9vxAN9BO6Q@mail.gmail.com>
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>, 
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 9:54=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
> On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > Could we strictly ban using get_user_pages*() for write access, and
> > use the unpin_*() helpers to somehow enforce that folios are always
> > dirtied on unpin? I guess the problem with that is that we have no
> > state that tracks whether the pin was read-only, and finding free bits
> > in struct page to keep track of this is hard?
>
> We'd need a count, not just a bit or two.  A pincount for all folios
> is on its way (eventually) but I wans't planning on tracking writable vs
> read-only pins.

My thinking was that once a folio has been pinned writably one time,
it should be fine to mark it as dirty every time it is unpinned, even
if some of those pins were read-only?

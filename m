Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795024254;
	b=2BniAMpVVxcYK6nLxcD7vMO3H+ABx9qkkohhoOgrOL4/2Tch30h9ylaNpwV1ypANn3XF
	 01Z8Wwu8oerFLiNXN089l9QFScCWSwPf9x/nIEMFVyOUUZuPibgcF3z7pXZd+TiU1afAi
	 mgU8lHFI/bDt1o1vGNGrNfCjlvUqEAPGC0apo+lu8ukHWsreQkXtBlns3C379/+FtMR5X
	 Vs2+7xDBHgsljEFot6Efsi6w3yDrrYYYt5N6CBMrOk4kl1mDImHcbVKTHlbO3NEhzncSa
	 9tH3ZOGJ/dfcDfA15cPwk0ryRolWSAWK+biUkU6AOccu//waMy6x6jtJ9nmFhbLINEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
	b=Yrx98AtAfja4XG5NqSIbssKYon8zF5JN0ozajQv5CXO6rSTHU/2ozm4Q73lAfCqyySAZ
	 J6dTfYP2xIifSvbmyScdLxe6pM1eNzMNr84mTZhsnW9oXhq1NSdA3SK0SYdr1z7BfiEDA
	 JaRb+7YIY0iKeQJ2ruGnCaQEJ7L3nUupKuD5eJBX5PyOkWz+X/3OXNBnsr3xupIiUDjuu
	 Ml1yfE9dpOo+FgNIaJCUCJI3WJ4epgQRb5awMnKKlYIYXDkz9eRlTn/12GnXJG6OQHnF9
	 DfiAebS5cDA4hZ2v8KoSVr+W0aue887gd9sxnCiT70FhnO4w7wgu8I3XysqYN+qEl2g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t0urFzns;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7C060A2607
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 17:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC7C060A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t0urFzns
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b88bc47e23so1682330a12.2
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 09:50:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795024252; cv=none;
        d=google.com; s=arc-20260327;
        b=ELguhm2JgxCSWPEs/EVUxVY+t4L7EpeqPGwT8GIH1g8K0nAILxFgVCCEsPJcl6qXMl
         mQIX7h92Fiy3svxXb8LrHu+Mh/M1GMhtdA06ZYkIn21MSLs+WEONKIcNmo9IjwNyZAlQ
         T5c5BlPWQ56ZtPfuvWxi1+wY11oJ+grQLE5ojbztwIH0deAbzxvcCY5ETU29yL0zoHAP
         WzpGiPScrionn7kMi410aZHgCX5RCOm802R56gzY2IQH8kU4SXeOspYC84oe6qpMzFng
         EFMskRBATuoglzBSsLFXH3CP241EiyKaVEMEAwZa8g44LEBPifJ6kBtxYLoT+cihof4R
         wG2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
        fh=iovrvlZ1tyec5+VRX2cnIQB9Q79C2r/BnGw3nqJOwiQ=;
        b=eUDhw9aidp4UYA/zcqGuaxIpD5y5u32oyRSHNNwWct7PWNxeP875IzL+MRkbjxc6Zm
         3eW2jfIQzaoQR9tNH2f0AkCM97vBgzN2FewtvT0P1YqyMLJj/01sRG8bMgiveqqBEmaf
         UgRiXKHiwZd3g+s6NCE5js/Y267DY5zuLm6htIZSBgbq5uogvbs9Mi3FbGfeIbXWcCK7
         oKixUJblmtcIm7MU/nsOJSwKWV7/qNBLa8yljHqQv+GL623WNzQKjMr7pmzVRh+x6Kdu
         o8bnaZsXXnPvBjWLr73sYXODholpp4lPt/ZONl/JqzVtlL9dBY4uHSPu24z9+y94X48R
         890A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795024252; x=1795629052; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
        b=t0urFznsvrKRqixemRUZFc9mgXym3XN1YMBmj0waBLyV3CsdgnHy8xmpMpLBOjvFSO
         4OyVbjrHe3QbmjmaFHziwXJZHZ3OpkdyrRZKOYWCdCJexvqSmUuVu4fnaP7X0VKW/H2Q
         uU2+obaBKEAHGKd8XWt2iDtAO+W46sMhQn7B0F4IN3mylmD+1QrZ9esi0QvoH9kZT9bX
         EBKM7Z1u6o+AxA5zR70zZUIovWhwqLZJa6oEexWqxHL96XtNRn01UmHNOonMpcB3gc6f
         RbyVXVt9WSJBogGVLF5lTsidaWxQ5lTI8ZoKmu6C/MRJ9rExNu7Xb6AIdnGzmI6derxu
         Duww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795024252; x=1795629052;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
        b=rjTM+uUxdZ05dbky1lQekQamdntlr9ritbd3purujRvn8weNPv0WMWJUBfcCdrnuJl
         hpPBg8bPMzIAu6Uuqx8g+d1ahEtKvELolYWc+yaHIq85kydgvMOYoOtl+7eHIWHrTz6h
         2eh5HulZfeF1JhhTyBFqWWBGqOlOE/ek0bXKWtw6HDyKME+QY7GT20FSkEyL6+fTYAKw
         Y8ASDthQwsPpCexVItWCvwNjWmeQ1hyeSf6963XkJm1gcgrhPXVqRJ3XLRn6gU2jeGHM
         MonfcBSY3km9m0GBajFSiRaq7wAaZOG4qTO8gnAzpqMVVMq4RL1dk+QezB8ugaT/+RmI
         pDQA==
X-Forwarded-Encrypted: i=1; AL+hErG3RTSE5h6uZ1qZllGjETiSmKg2P6uYReQqwpBYQYJKHhcGu1t1pGChHyRL1omjEMPcwMpPsZxgF9OI2A==@vger.kernel.org
X-Gm-Message-State: APuU4Z9Hxoq6jnKCznvmbNtUAmJiNhAi2NoUkWMXpSqrDHbsYY6e/3Ex
	9xN7xx6UU5T0n2pyaHR94hs54pn3IGrs58KhsRMpT4QPlG9TDU2VzZv97+w3hmkip7hlPqkB3mQ
	wBCAYXGALbyMUKh2qt5Trru7ozzQwNMk=
X-Gm-Gg: AYBFou0FjCcVh6Oyf/o+ndfrD/coJj0RGOyqRwY1TnHgTKvp8wvr0BN2YH3e4sP8Zhz
	eoUtxj9GgRX59jj/ATb7i0holTVLynPI7dVlZlz7kGFesPTiytK4P/5+tjDwJtMPGSV1QBzGftI
	nULnPWRXtHtLxNXGMyQV5rimh9cqMh6cjcXntK+jZVHACkOTVUgNXx0dIV48FOcWXFWpTdIH0Am
	4c4thLfaTDjrQqKRh+ACrP0AV1kUPXv9F7TMKG1lpLjZxwFB+uXr4Pgxjpg5uDlfQDMOYpKaJFl
	poV2ZVeoV6uVJrR7WzoViZMlN0GxGakR0oZeDPf6b2MW5CP02cxYVRSFmJokes3eIoCMyJzTE4P
	caMqVACNZMr+iEIW30ojy3kXlEzv0JIcOMuxbJ5jKPVuggVtVe5fwI6BDjcCEXwxo8+Uwo7ap0Y
	UH/VETIFBYP3umGtQ=
X-Received: by 2002:a05:6402:5411:b0:6b7:df0c:18d0 with SMTP id
 4fb4d7f45d1cf-6b8a2e6d881mr1966295a12.11.1795024252167; Wed, 18 Nov 2026
 09:50:52 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261118142613.be3r3s6kobkkxnz4@pali>
 <DMYFBDIV4Y08.35ZKR5G86U1H7@gmail.com> <20261118151605.lqtn5fz423kuswk5@pali>
 <DMYHPLWKPSH3.MUM1IIZZIWNR@gmail.com> <CAOQ4uxiwpdC-fKkqS5kiZ515q9MenC0jX4USV1idN7h2njx45Q@mail.gmail.com>
 <7126bdd0ff59e9ea9bc58702af2ecb38096330e8.camel@kernel.org>
In-Reply-To: <7126bdd0ff59e9ea9bc58702af2ecb38096330e8.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 18:50:40 +0100
X-Gm-Features: AclHuK8-cETfcc5mQcfuFgReFzNL3uUqtJJFv8XHOum7KdV27M9jJ90gtN64MvU
Message-ID: <CAOQ4uxidYWNVmoPgxKrxesXTxpMB-JqUZx9p6xXZWD5m+hJ+JA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/10] add provenance time (ptime)
To: Jeff Layton <jlayton@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	exfat@lists.linux.dev, ntfs3@lists.linux.dev, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 6:36=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Wed, 2026-11-18 at 18:28 +0100, Amir Goldstein wrote:
...
> > Guys,
> >
> > Let's take a step back.
> >
> > If this discussion is proving anything is that the btime/ptime
> > duality is a big headache and it's going to be a source of confusion to=
 users
> > even if we come up with some smart pants consistent semantics.
> >
> > As Jeff writes, I think we should consider making btime mutable
> > be a per-fs choice and not an API limitation.
> >
> > A filesystem can even decide to store both the forensics btime
> > alongside the user settable crtime.
> >
> > There are some precedents in xfs with settable UUID which is
> > a different field then the origin UUID from mkfs.
> >
> > Fs that have immutable btime have a few choices:
> > 1. Keep it immutable
> > 2. Start making it muttbale (like the Win fs)
> > 3. Start making the user visible btime (STATX_BTIME) mutable
> >     but keep the forensics btime on-disk for, well, forensics
> >
> > If btime becomes settable via options 2 or 3, this could require
> > admin opt-in (e.g. tune2fs -O crtime).
> >
> > With option 3 the crtime feature would be ROCOMPAT
> > With option 2, it could probably be COMPAT. Maybe.
> >
> > If we accept this story and the major fs maintainers are
> > in agreement with this plan, then I think the missing piece
> > is making the "settable mask" visible to users via the new API.
> >
> > IOW, we need to somehow export FS_XFLAG_RDONLY_MASK
> > to userspace instead of only exporting the supported mask.
> > And then with the addition of xflags_mask, we could also
> > -EINVAL on users trying to set readonly flags/values.
> >
> > Perhaps a single xflags_settable_mask is enough.
> >
> > For file_setattr(), xflags_mask is anyway a set-those mask.
> > For file_getattr(), does it matter if we get an answer
> > Filesystem does not support casefold on this file
> > OR
> > Filesystem does not have casefold on this file and
> > you cannot set casefold on this file
> >
> > It's kind of the same, isn't it?
> >
> > What do you say?
> >
> > Shall we drop PTIME in favor of "is BTIME settable?" API?
> > Leaving STATX_BTIME exactly as is.
> >
> >
>
> +1
>
> I think this is the better approach.
>
> Looking over some of the earlier discussions around this since 2010
> (!?!): I think some of the XFS devs objected to making it settable for
> forensic reasons. So, on XFS you might need to rev the on-disk format
> if you want to do it there to preserve the "historical" btime, and
> maybe some xfs userland work to make it accessible for forensics.

XFS_IOC_FSBULKSTAT will likely continue to publish the original bs_btime.
if a mutable field is added it could be published as bs_crtime.

For forensics this should be enough.

>
> For the record, the statx manpage documents the btime field very
> sparsely:
>
>        stx_btime
>               The file's creation timestamp.
>
> There is no documented guarantee that this will be immutable, AFAICT.

Yes, and it really isn't immutable for cifs already.
It's just that we don't have a standard API to change it.

Thanks,
Amir.

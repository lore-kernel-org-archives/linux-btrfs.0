Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEB0388394
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 02:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774321082; cv=pass; b=aO0f3tTWQSCbky6iyFS1bjq9LXOLVlDC+D23bettdaFrnYdVAqLRub5Ef1J2lP7fPv6ga/kULFAxH9WVV1EXWSLgdUFVGXas/jZ42IbieowMMuqmJjzMN1a6SXnpDnv4PeIiooO5PspatCU3a+HEh52KyOmmaQ6mCCigLoJqBOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774321082; c=relaxed/simple;
	bh=5IL39tZuamPycTA2s4YBZD+YbaPTHgRQCUi50dpbzUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kHR5X8Rri1qYvhuIfPgQnHd/eSYWgiszuvD7d3kxwcpk0jZ3YMwjGJis0djnSRp2rQrjGU7wbBIn81EhV1fAD22R9shDbrU2MDlQTrUpN4t75jWA8Th/EauYjH0Tr4kp2Z9/pVKgoOLXiBErROlozy9qdkE91TrtSionoWaN8R4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WfydFu/3; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WfydFu/3"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b982518b73fso159079166b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 19:58:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774321080; cv=none;
        d=google.com; s=arc-20240605;
        b=a4aGH0XAsUcd4tgT6ZwCPgYfsNiY0ddPNbgq7tBWW4ecqLF8g2WljtAu6UldXR7vpx
         XrZCpHP5414Jm5fHp9q1hXMZI4GueRiDxPlnZgWvsU+SiBxde8u/b6olq+61yW3o82Ss
         zQcZeZ9c4kJnMGaT4GYT426HKLZFktMyVq/4CT8LiOn9LbXgEzKAbM2t/QBoESCdKrFB
         lD8kBKqD7egfR7yi4LzAogiReLpBt+qkegs0N9JjMBx/nB0vJ2+xdnbpzssherl++3U+
         GPwkIysMp+YHaELydRDEOKTI6aidsn9edWtyfH8HM3mYXqWhF4qDY0TBFomH7POPr+jZ
         bYjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M354F8P0LheCjQFeoIcJbRMyTMMbZnLsLJRoIG4JM+M=;
        fh=tgVViCzrLdWVEB6JuQtJaL/CYBMdIH0nmm6DSdCtFGc=;
        b=eC2x4Q3Ak0L+rgtGvS/gj4EkBPHOBrApUG84Of1/7cxWnhhCe7cempnAAzs1Oe1cLc
         wR0NC9HeOqx8kzIVDpx+uDHkgC7b4xzbuPpxQVPgdH9h7Jj3FDT2sZiksIUX/qJVs/xG
         G04InsNWJ9i7FDiKqBz+ZseQRAFL/1eglYZaoJElflvhTx9/WH42MbQi/z3NGBEJlvgD
         Iq3wZVs/zwyjeDfP5bJ8h6J4Ywn+CSmUkMDNRnI/w+4sjKR9LYtNKhGVvSvY+vOkEs+c
         DqEJoIyPay0a3la6FMX5Q2uHGolTYmhnq+WbgN32jTbKTNwp0GkuFysuLhY/PzauqpMX
         DIgQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774321080; x=1774925880; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M354F8P0LheCjQFeoIcJbRMyTMMbZnLsLJRoIG4JM+M=;
        b=WfydFu/3T+FwaXuCZkCar5Hv6v4y+2Da7owj1SWhxsh03ph7hDak0RQgYS6zZI4kDQ
         r39+Bh5aqxLQVJoaq1P+/W8nTtwZxv4sXS3t0gNcmRlWpVCNGZuyQGW/UcQRfizWMbYo
         G1sXj93ns7CzbRZVdKxFXL8TaCIjeEQRIKHMF4OGwhMhxHzqSeA90COWYgbACgpLpcSH
         V0tVQVCDnVBP07XijKCUGG+dL2NqKROQvybfaL3nB3bpCWyMfEJWhCs39z/apR/VvEoK
         brnW7EoG/RyvlMu6C7KLNnQ5gVB7TZtif9oyn7K0xdhci2WpKg/yJKzfYqUckOaXVa1z
         lsaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774321080; x=1774925880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M354F8P0LheCjQFeoIcJbRMyTMMbZnLsLJRoIG4JM+M=;
        b=jeUvtl66STx+jRSRenIUVWzkg+hBMD3BNrlBHmJgh0lqCX5YW0iFYElkyo/KeUZdxw
         j96Rm5YPpUUhUQeRLHi6Ywm9NSP6PiD3vS6SbyuHnTPJxDdjQTqwBI9bO3AOwtyhfJO3
         D75kEFT32UfmtggbD/g+5zMKg9AAnWl2ohl9MiZAP1JzfPXREcG171Xv+Dx+cBOYOff/
         INSk5UcWfMPTlMq7q9IgfBZyTuk9NjtjHitQpY3vumJ7FWB9VXABzAlV9n4sbwDdKPCz
         Wzd2LlSUq6NrVR0ZChnermmEatf5rT5ipFZvIPvVmfHMa8OUqf0GX8JyYalCxX0i7ZS4
         Jivw==
X-Forwarded-Encrypted: i=1; AJvYcCUqv2dpnnJ/EJ+2OsP1bHFi1WlNYzr9Lw/N67LGDzyIvr53V7liGqzGg5d6exZz2qVQFoPUWRTcTHA/CQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOvQL45belzmy9ZoZ+5NXIyKBMRk5Gml7LNsV+tKLbfitDo21p
	s2nKGypKfYVTJsgbg3r1z9oEuW+b0hYWvlvBQAzxGE8NY/4snhFzHZP+FKrBrvFwg/Y+7s7F6wq
	heEDGia7k9Dr9iWTxqfY4jqLSwJ7T1cM=
X-Gm-Gg: ATEYQzwA5IqtfNtm9zh/S4G00Aoy5zAsTkdj5svPKXAly66VJo281JJ8igtzcDupruL
	hs5/nB4Ewf4wq/4jZxP0TCOI0ZhVPJrVCsV+2PBchNzkNd+WY3rDO+0NIMR6s9jyOosN80WzKEx
	VN2qEC+ewPIlir0tThnKD3qMZkOGdPQc45KMYHUJPZlgDdqFVDkk5an4UH6TAvXRaO+oVS2yUgU
	J20yxyacrT5uwJAtIRFbI9m4dlT3YoMlx6BXWUEciJG/kPK6cK7GOssKqwD6gK1jfFcctUb1Mgm
	9UuhtLWGLES+r9XQZ5Lk+1xeoXsbUf7QaaYTS+N7NqXQEDB1Y/fG17M=
X-Received: by 2002:a17:906:5985:b0:b98:5b2:77fe with SMTP id
 a640c23a62f3a-b982f21d401mr646008066b.3.1774321079541; Mon, 23 Mar 2026
 19:57:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260314123741.1439792-1-gality369@gmail.com> <20260314123741.1439792-4-gality369@gmail.com>
 <20260323175212.GO5735@twin.jikos.cz>
In-Reply-To: <20260323175212.GO5735@twin.jikos.cz>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Tue, 24 Mar 2026 10:57:47 +0800
X-Gm-Features: AQROBzDqHeoQAJF92QQMjXBUGsYCyI0RiNd6XWdGUkALGK-Tg7nug0L3JVYKWlw
Message-ID: <CAOmEq9WK-uA=mGcoeHOy_11acWgzrqfj5fXfSmzQY-E=nUTWmQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] btrfs: fix check_chunk_block_group_mappings() to
 actually iterate all chunks
To: dsterba@suse.cz
Cc: dsterba@suse.com, clm@fb.com, idryomov@gmail.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 1:52=E2=80=AFAM David Sterba <dsterba@suse.cz> wrot=
e:
> This is called during mount indirectly from open_ctree() and this is
> single threaded (partially), so the lock may not be needed. It would be
> needed if there's eg. caching thread possibly accessing the same
> structures, I haven't looked closely.
>
> > +     for (node =3D rb_first_cached(&fs_info->mapping_tree); node;
> > +          node =3D rb_next(node)) {
> >               struct btrfs_chunk_map *map;
> >               struct btrfs_block_group *bg;
> >
> > -             /*
> > -              * btrfs_find_chunk_map() will return the first chunk map
> > -              * intersecting the range, so setting @length to 1 is eno=
ugh to
> > -              * get the first chunk.
> > -              */
> > -             map =3D btrfs_find_chunk_map(fs_info, start, 1);
> > -             if (!map)
> > -                     break;
> > -
> > +             map =3D rb_entry(node, struct btrfs_chunk_map, rb_node);
> >               bg =3D btrfs_lookup_block_group(fs_info, map->start);
>
> What concerns me is this lookup. Previously the references avoided
> taking the big lock. The time the lock is held may add up significanly
> for all block groups but as said before it might not be necessary due to
> the mount context.

Thanks for the suggestion, I=E2=80=99ll take a closer look at the locking h=
ere.
If the lock turns out to be unnecessary in this context, I=E2=80=99ll drop =
it
and include the change in v3.

Thanks,
ZhengYuan Huang

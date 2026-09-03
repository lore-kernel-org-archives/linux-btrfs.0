Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF483F58F5
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788417735; cv=pass; b=YuWWcW2U8ITxQckBKYLDDsorA7PVDp9UkMoobhf7v6e4Gds46JUKNvajVpgW0u6JN8meTZ7wwqdQvAeUrivDV3UfET0gc9NWvqp64vemolg0MTflTebKlK9pe2WQOn0G4RoE5HGg9SqbZ9UB5NHal3u1kQLaYJmmKhqLqNjHL6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788417735; c=relaxed/simple;
	bh=lSN9DCChFA6DayRL8sMHWIHXXI+CEjHXAXVy1PgIcFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DcVjgtvLOKwd6L5t9TCsmrY0xj/Y5KljVtqAa+QTz6xjHbyzs0ferPmBdeIvaOtZ5vjD3amG/YVAqSjkgo4sRRyEucacCKXV0o8Uw4ntXeFaZ8lQZnw07c9LfaF/zFMBvYEsbGaSKkqaLW2XtWK3Y1j6svf97NpJoFq5InMZpv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XK071OJP; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XK071OJP"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48431648f33so419215f8f.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Sep 2026 23:42:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788417723; cv=none;
        d=google.com; s=arc-20260327;
        b=q8qP645thQRjtEUV6UjCWJRqk1e4eY9k4QS0/suR2bINDJTUygbmfJ479K29BY48Ku
         Tf4UxtQFFbeuiRM75GirF7F17p/eQGGT0atS2jBpd3+Lt+pzucTmvQUAUrM6F7A9ZNzF
         SaMGiXQh6f/mVm+Bk+9blITArH3ydjRfhSE671V24roKKgMBvzB6e1izKb+Ldm/XYqWn
         6nJDk5CQn3XpYO9K1qzSUHD/rO5sj5ey8ITzx+ISkemSaFNWXxyRrz1g7ez6/+eY290J
         p/p9v28t2KI/7y3485RFf8bf2vDPmoM0+bqU6ecia1ToCj3vuJrCk8SSbR3/oyTtoN2h
         iRUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uZUB6wYVZBAtgUBstmC68loIx9lctfrU/baEzEgmg7Y=;
        fh=9EJq8ABJ1gVXvuJIcBxEHnoIgXPVCVBX0wn+1t/iWqg=;
        b=tCpa4+YL2ioNdJmTSwd19oK5Rrafogcf57dnjP1p8g13/BVPsPfGQ6gkkvoUQ0RXzm
         aqwLacN9oy7A7ot7qL68BMOyvY4lkAAfkIEXCwOzhl70j/lBhLIVt+vx4k0ZZ0pDvXva
         V3aExZKxCPZui9z/y2/Tsvwe+5k7OL7i/fX9xhl6pu4/srTdAX6ocGaU6Tf/6Mr/9KkE
         WSNeeJeWSfrm92ZprJCwaQvqh8WYYHcNBv3EXQk7+GMFNvJuFrcNp7ATFCpGkUsakQie
         BTD8RL2/3D/VHk6dO43eoioWiFa7M0I4oFyW7YMv9L9KYl8TsiqU23weD/NE8/yP80/q
         z1XA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788417723; x=1789022523; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uZUB6wYVZBAtgUBstmC68loIx9lctfrU/baEzEgmg7Y=;
        b=XK071OJPUrrtgbin42/Ou/qMA48uDqKVIACShU/7s8UXLNOWoJbLAZ6riSuFciQR7K
         4bgEohqxDjefY/+c2qh4swBucvMu4sepfLxwC7r7EIyJsDQtn8Bn1W2MAV5zJkSI7Kam
         6nmKFq41qtK2/TiIaqXV6W6r2tPSRZZZXuWXMiereHOZgcGO7BLARAodpO3mBmAZWYTU
         uiVkfoIPH/XopjxzDZAuEzm7W9Pp6FIvTgdfwN9NDceGV8SsweUDeLlQzC7oNED7gdI5
         rUgYG3M2ypET9Ucw25hkIbuOXzQMmGhZNfUQzawioA7VzJGUp9l0SGx9wltrQcqa48DW
         /wlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788417723; x=1789022523;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uZUB6wYVZBAtgUBstmC68loIx9lctfrU/baEzEgmg7Y=;
        b=fD/CRw+WGyCyxDeQZIC+S2OCU74rn/XT4MBD7Ewwjb90fcNP/A0nCmX7/jkynSCCi2
         jau5SaR1cOGBN7sq7c3EFGliFU92QKUe7S1EPlQZObAob3yDDjFdhjbWhQb0xypjbMaw
         CtTfabEIJ4PfnFKPmGVM3rONkdOyPaX1KXdVg6r7ZNCjQEbz9GGssLj5y1etrPWg43IO
         TxudG2EJTvHJaPAiC1ZqPU47A66SFtGWSzjaNK8Jq+EIHEO15FeRROWeaWal+u55WS8u
         kNL0xHgOcSZthxPHNzoRVwN0mzw32t8GiP0GzsD+JvhbOlALn/xnWdFalKnf7nvLhiDQ
         JfvQ==
X-Forwarded-Encrypted: i=1; AKwUvBwRc8xHTcgBn4ZrOVdEgj8lX8ADkqRvrp+CNAm/KK2bKWRT7mUKg/nbuHC0e7nI0na5arjbcAGyrNkyZg==@vger.kernel.org
X-Gm-Message-State: AFuF++nycVrildPSHKxQ8A5kSuKz1pU2ul6jhCNy6FDcoYYK+xD8PXr5
	2jdbxiso2aNQSgpIOr/Hr9/DgAcYTGiqtd9FrPYHLsK2Ut9e7IGZLB6GPSnt2Ywl9uURrOgWmBr
	lWo/v6EI6mNiB5RC67OS1og57rc/LpeU+ibhTsaqCvQ==
X-Gm-Gg: AYBFou0+jB04aXCRGv826i3TWg+V/l3ekec+8I4MKVbxSnIMX+WU6OZQNzz1VpK+SZK
	T93cIiIJCIBiu2Pp2jfc64hejhCtxa2jWC/PpYBVtimvUK1xFS5GhMgIJLqO8Kd06Sl22GWh7HT
	fwYHViyU8RnC9CFGyeAAOxp/3ni4DubaJ+kbJO4cBZEo4n2JxpEvmOhDvfrYIujKWLW76wRqIZF
	4dq031F/9AIJnxhNTIG3ey0Oy3rxMSyZrnasZClKjhKNloSBdAcs9bmaZ49+vYbc9s1VRMWaIQp
	QXyu6Wx8gKR7sEPQHj4/1ZgZpa0MJlJ6z7TdUHlJoSphqdzT5GiGjhYBBrC2BdsdH929LzStn92
	3rMQvyfLDe2c39imaEpZIi3+RIhp6n8bBlyyjH++dvA==
X-Received: by 2002:a5d:5f08:0:b0:484:410d:c9fe with SMTP id
 ffacd0b85a97d-48582438e6bmr1968122f8f.11.1788417723160; Wed, 02 Sep 2026
 23:42:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903062317.3928665-1-neelx@suse.com> <20260903062317.3928665-4-neelx@suse.com>
 <a9179480-4f99-407d-b381-5c97a1e85a2d@suse.com>
In-Reply-To: <a9179480-4f99-407d-b381-5c97a1e85a2d@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 3 Sep 2026 08:41:52 +0200
X-Gm-Features: AcwNN1Wt0wO7i1klrQ3rnYjIPw7u1pzqx77dpuCO57Km4vvM2geVwIMsZ8iYoZ4
Message-ID: <CAPjX3FfnE+X-6r58eMGF17VP+oJ3c2bRvcc67EKrZvGmU52Dvg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] btrfs: promote async checksumming out of EXPERIMENTAL
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Sept 2026 at 08:34, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/9/3 15:53, Daniel Vacek =E5=86=99=E9=81=93:
> > There was no issue with this feature since it's introduction in
> > dd57c78aec398 ("btrfs: introduce btrfs_bio::async_csum").
> > No need for hiding it.
> >
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
>
> Oh, I was doing this already, and it turns out that we have a lot of
> things to cleanup:
>
> ---
>   fs/btrfs/bio.c       | 136 +------------------------------------------
>   fs/btrfs/disk-io.c   |  20 +------
>   fs/btrfs/file-item.c |   6 +-
>   fs/btrfs/file-item.h |   2 +-
>   fs/btrfs/fs.h        |  10 ----
>   fs/btrfs/super.c     |   1 -
>   6 files changed, 4 insertions(+), 171 deletions(-)
>
> The main missing part is the should_async_write() now always return
> false (you missed that EXPERIMENTAL flag there).
>
> Then it means the whole async submission part is no longer required,
> resulting the above code removal.

Ah, ok. Then drop this one.

--nX

> Thanks,
> Qu
>
>
> > ---
> >
> > v2: Introduced this change.
> > ---
> >   fs/btrfs/bio.c | 4 ----
> >   1 file changed, 4 deletions(-)
> >
> > diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> > index 771b7d598aee..db426ee6e587 100644
> > --- a/fs/btrfs/bio.c
> > +++ b/fs/btrfs/bio.c
> > @@ -569,11 +569,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
> >   {
> >       if (bbio->bio.bi_opf & REQ_META)
> >               return btree_csum_one_bio(bbio);
> > -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> >       return btrfs_csum_one_bio(bbio, true);
> > -#else
> > -     return btrfs_csum_one_bio(bbio, false);
> > -#endif
> >   }
> >
> >   /*
>

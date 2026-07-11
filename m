Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DA21DED5B
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 22:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783808632; cv=none; b=hd9G1l2sqr7r+9YIc45LY8Rq5FheCItoLIN8ukaBMbMwEClC37fayK8dj4pzrI6qsxjvd+cXeX9NuaXXS+Su+ROF/iGLIur2z+SU4BuC0x4qN+YaEfvqR7cbz+B17C1kjpDySuGqRiHebSq7TYPThKLDetJmNictEHwDX7jJdt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783808632; c=relaxed/simple;
	bh=tes96vTe7hlnidlQ0gKOpy4qDww/ODfIT1aShvTrEqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nC7xo/ZUCS7fhQ4V7x36oNDkF26rrPIR8le3MKRK7UXRd79uDEkqz0aqHcCVH4V4PY36wMQzef+UNEagr0tY/XBRo72MrCAtkgZutj92ydn+3ZEWLbjor4zceq16npKMv+sZeY3TEKlu5hMnlblQiU10Q+ieSeIcbcsQ6oKe4YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e9f69eeb6cso1311821a34.1
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 15:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783808629; x=1784413429;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EVpr5T21CCx1Zl2kG6RORQEOUOP3r3jC95g556ounXU=;
        b=bbfMs5PtxUHb9+4eg5QVlDvgulaIj112jVvcODXD2nCNfuenakSuFP4ujjr1FF3zck
         xFVNIpQk3ldVBC+p2xgnqjw2kQgVj0d+FCdNZFGiV23tciN+5zzyHRjOw2Dqx4RtM8Bh
         JOsJBxlH9nYRsq102IJx1KcNwP6tXtddgZosDKQB8uIU22lWatgHJkZL4AZ+iH6O6jNg
         amLv+r9oJTZ3L+gSpfnSALDiCB63TqodO0gmSa6iZ1QaeUu2X+kspmS9M67CoYCiSlGy
         j/eMjOAPEu/3r09V3SyygeOLmoATMmCT9bVVsxx61Bpk+78eeeUwfZe05yvdCcR1wIB5
         LYXQ==
X-Forwarded-Encrypted: i=1; AHgh+RqDkzqtUFeN7KR5DcO/e6KwppTwQydq3lUnUa8eLTUy5/5Cj4hZm0pYcz/wOlID1ee5XOKtQrLplHGt/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YybVyx+FtmR3PnnjTP5p8Ro9DmtbOD2w2cl//ZZldn3lTO594o0
	IMWg5L5WADnHzWdhvWMmS3N1PlXBMlkGY2TCBCyH0HDcJe5ek/ZYPXUhpHEveg==
X-Gm-Gg: AfdE7cmfsEoqEOjU1nxqR1PIwl/6XduMtfCx9gWqJCkbCp+E3z+PinYcggpVWJiWhxj
	9z35Soc2CApwAC42xQz9yGREFpnBuf6Dtj1gLIcVudZ7dH83+JWv72SzzQXjmGmtFrWPvgg2jz7
	gy2/5Lagn1CsMYWLuWn0uQN2n+oh3Y3ZxGsI10CNMoBWQXPXCRRXariweHa8E2ODPP5UilfUaaN
	xzmUQYwLRvUMZhDUhwdP1pr1oCuij4dqOQN5Y7i2F6vmZhm9/U6y8XlrCDySWyPtprxirQVJ8I9
	UUUdHwsaK+cxzeY2gF5QXKL8Coa1ARKJ1Z32REJggP29V2HCwffPl27GSsP/LlOdvI1L3+42/8x
	6J6OOG/TpJIAQ9ecRQh+HjKnhUVpxrY6F5/DyHHPWuV5fxC8JENVRQMkSFOurIKnKSMg6iA4ZdE
	5vWNUsCLpQrxV6zWJiqor+L+ZNAaLaLiueC7m1ZKN+EdMY8rV5iAe0ZznJ4ZdL3yBj1ayW6cF4Q
	CzW26tG1IIMJdPiD5yY3kr+UrA89oLf3BtYJgYH/l8/8SBwz18bDXXKdkIPwpU=
X-Received: by 2002:a05:6870:c296:b0:451:3bc3:2944 with SMTP id 586e51a60fabf-451f0faf472mr2576835fac.7.1783808629441;
        Sat, 11 Jul 2026 15:23:49 -0700 (PDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com. [209.85.210.47])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-45191643994sm8655540fac.9.2026.07.11.15.23.48
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2026 15:23:49 -0700 (PDT)
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e9f69eeb6cso1311813a34.1
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 15:23:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+X9EgrhD8VtBkMQ9qRpU/lz4JS69nSCJtYRdymkzyfilJ0RtALyUNj9lwLnp3FOUf+3sj+5OlJiSmA4Q==@vger.kernel.org
X-Received: by 2002:a05:6830:6814:b0:7eb:cc5f:a6df with SMTP id
 46e09a7af769-7ec097c7090mr2928517a34.18.1783808628786; Sat, 11 Jul 2026
 15:23:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707142736.2330146-1-neelx@suse.com>
In-Reply-To: <20260707142736.2330146-1-neelx@suse.com>
From: Neal Gompa <neal@gompa.dev>
Date: Sat, 11 Jul 2026 18:23:12 -0400
X-Gmail-Original-Message-ID: <CAEg-Je8ZqV8Jm64kNPBc80xKrBb2KB4EFobKR3yFUL9moZdN8w@mail.gmail.com>
X-Gm-Features: AVVi8CfR3PeMaJTeWSlo9zUp2JvungwA_UpiA5kgfOaZbQhIb6w8K5_rdloldzc
Message-ID: <CAEg-Je8ZqV8Jm64kNPBc80xKrBb2KB4EFobKR3yFUL9moZdN8w@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] btrfs-progs: fscrypt updates
To: Daniel Vacek <neelx@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 7, 2026 at 11:00=E2=80=AFAM Daniel Vacek <neelx@suse.com> wrote=
:
>
> This series is a rebase of an older set of fscrypt related changes from
> Sweet Tea Dorminy and Josef Bacik found here:
> https://github.com/josefbacik/btrfs-progs/tree/fscrypt
>
> It passed all my tests. Hopefully nothing blows. Enjoy testing.
>
> v3:
>  * dropped first patch and improved inline extent length checking
>  * correctly squashed the context key definitions into "btrfs-progs: add
>    inode encryption contexts"
>  * inline extents also show the encryption field now in tree dump
>
> v2: https://lore.kernel.org/linux-btrfs/20260624165144.556908-1-neelx@sus=
e.com/
>  * works with v7 of the kernel fscrypt series
>  * the on-disk format changed and parts of the series had to be reworked
>    - particularly the encryption context is now stored as dedicated item
>      and not glued onto extent data item
>  * also parses the ENCRYPT inode item flag
>
> Daniel Vacek (1):
>   btrfs-progs: recognize ENCRYPT inode item flag
>
> Sweet Tea Dorminy (6):
>   btrfs-progs: add new FEATURE_INCOMPAT_ENCRYPT flag
>   btrfs-progs: start tracking extent encryption context info
>   btrfs-progs: add inode encryption contexts
>   btrfs-progs: print encryptin type field of file extents
>   btrfs-progs: handle fscrypt context items
>   btrfs-progs: check: update inline extent length checking
>
>  check/main.c                    | 34 ++++++++++++++++++---------------
>  kernel-shared/ctree.h           |  1 +
>  kernel-shared/print-tree.c      | 28 +++++++++++++++++++++++++--
>  kernel-shared/tree-checker.c    | 17 ++++++++++-------
>  kernel-shared/uapi/btrfs.h      |  1 +
>  kernel-shared/uapi/btrfs_tree.h | 11 +++++++++++
>  libbtrfsutil/btrfs.h            |  1 +
>  7 files changed, 69 insertions(+), 24 deletions(-)
>

These look reasonable to me too.

Reviewed-by: Neal Gompa <neal@gompa.dev>


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!

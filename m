Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCEA23741
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 06:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776406681; cv=pass; b=S6sGOP+y+EysGKYNX7JCXnjH/e3wmWydZVp/ATzKO5D6b/A/oTGp5DQTN9GS9px9205USaJaCXXb4GCFd2eoheRqOgN0eNu1xrL4udv3gv6e3Cq0zTcNqAoEQSX2u0LVw4Fk3rDAnBtzreLUKRBRAyIPYHxCV28emLhMyzLKnqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776406681; c=relaxed/simple;
	bh=CftPVaHbY/sLZyg7fdjKAg/Q4VVFXC/L3LipqZPWB7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vBO4qaI28SxMy9k0kgqIHWDNPYOJWH5l2sWt2hDu021+2PEbVq6W3l/L3Pdst4/tsezq6CPe2VXuamucoQEkYhf8yrReLHSe+MYtjIz1feQH988Ape3hoILWtQGOrCtoxPpcdDonqX+VEs9+TdidCjRRwmGenDXQUGPA2h77qQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Pj+e+9rO; arc=pass smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Pj+e+9rO"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so1688715e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 23:17:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776406678; cv=none;
        d=google.com; s=arc-20240605;
        b=j/Ai2asfyKnREvn35XMM0vj3+3jlnI6QhJ5xVGuIMp8CyB/eXwdqiGTH3FVupK26V0
         Am5PRBZKzYSXtXa5NqJBVPv6GVVpkCvzbBplbWvLmyLM1F5+bP6tvChHpJFDXiufWNwP
         tR2gLvcu2LwXzgTYqTD0Yc7KM3X3QR7B+78E4EfoJssVvAQ9AQJHWJf9cJMcgGmPvdyx
         0JF3MIz5ZT7x/QF5BmtGro0dwAVH2Ut3Ue0YM9OVzoiWPqVvn+ROQKwJ2jSaMT/kWmV1
         U1Fdw081SWuwLGH39ePctmsPXo0fkGp2E1POY/Qz6rz+yUJQOb0Ky8IM72nS4eRoTpP1
         i1qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YKMEI62h4xeSA4wc4eiWLcZ98YwqwCz1YZcyfyucBNw=;
        fh=y52Td+ZyYrJYp/O4y7M1pGatTfonr8Zus2sGconZkr8=;
        b=aMWTk+8Q/qqpWmRmU4u21EZk0jYqUhyKO6SMK5AVh+UtFcC9uw6SHfpSimWKdR28Qw
         7lW7UJtMgPqTx878qsIL9vUM6k1mWTilcKdw1CaCIVwpRlA+0z1mx5w7sepHB/MNP9lV
         5SrgssqM05+GN3IbS0JMuGh+9Y/DMptft345iA9Vae+dWXVgUxP5KLrrXXGbEUgIQrgR
         XkUw8BDONT7o3n3OtqqCFKWLiVzhymQkc8BVspH3QofqxMyFD0oEYcVrjZNGYR0dCKmt
         zRlP4aZAX0TcWelVChGMINpLXiKfVp1sK2Bi651eim7Hbka7AgWmrhsAj7h+hbmJWmqm
         06JA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776406678; x=1777011478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKMEI62h4xeSA4wc4eiWLcZ98YwqwCz1YZcyfyucBNw=;
        b=Pj+e+9rOGAOsIvl6Lpgw/XMNd0V1JM9H9ggsyuz7i4FaFZnWHAsk/ET9R7IPTwyR1z
         BGgNc4AdSYXSks55nxUJl5xujTnOtC+cZLNlxVQcRg5VV3IU991UcoLd7eO68mD+9qEj
         LZlx1Tz/uWwzc6y+X2+GfwFQkgLdm94YkMxU+a9MiZg8sYY393ODlmgZMATXriSi0D3x
         cl4S3l0rzjuuBSWLFmeBmzHQ5VGXFWWePJZvlbru/0cncC8XDf2Wot0QeKwpq3FNrwGu
         1M+JTuhEpNwzgPkHBjwP9WOfPDRuBY4EXP4YVXKQqjbmATnNaH3b118STCVW63aipeXH
         wUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776406678; x=1777011478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YKMEI62h4xeSA4wc4eiWLcZ98YwqwCz1YZcyfyucBNw=;
        b=kF4Q4ZHtjA/LfN78H29n+0wl9DP/o7+rQU2aW3IS5SnHvVaJKBT+kFWTDm1ksxhbOU
         /G38czU4imNfOzkvvUwqXrTaG/f4F7qkIW6eKOAPiOz/ajesStqE7mj9FP/kq5KqexDV
         9ugTtLe7pMPWuN5aVSY4qENj8oLDzS8aXWtDEaI6k1ZUPAkpv9/RQnnhWawsh9YO/R5A
         TUs48psUadE+a/oFXbyso1ykB4H/K+KK61Aq73ZPeYVyz5plFk4bdqzu8xZSK+pWqgEU
         mBjJ9AO/h4Pkkr7PrpeopWwpFEFAusL/1LatHtY1ypLi3Cl4NXAoPZ87dVI7aQjO+Jzi
         UPVg==
X-Forwarded-Encrypted: i=1; AFNElJ97vw1TF4Z7OoRwK2g6+lfJTT9K9HEoczlkxZCNe9TxYIZ0vhC7b+LD2JcaqlMfbF6AlHvGLn0F34tgLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwW4EkbJNH5wU6YrHnSEr5Y1MerXVvwnQepgEeGaVK6dHuR0XN2
	wtCgUXliEuXcYjyBMLVnohLgHx26LSDPTwiNc8CApRHd/Bo+2MUeNhk347eoJeC7T3ZDamMRAGn
	8/NtvIaB54P+4LNXyRUmPlfPjb24kOAs4aTM4Y/Zq2w==
X-Gm-Gg: AeBDieuAFStSpgS4+tvxuqGPfb46HM4VtHcp+Nv5eKa8D0O2pvejCwZscnXVm6X1Hbm
	KYJKv71unZMChdSppJBbbKN1hqiZvnjDC1XJaMH0/IeQRYDNcyQxI25HssDkHXwnYPX8/Uh3BLm
	WH8FAVJRiPCzng4f9pFGRx+jyVcC7q5wEVluf+9WKCSilviTZdcbejXnPU5zNnUXLR5Y3PH/B3C
	zAO9yEzCJ++HsDonlxfOI/RGCrZxtUOwUY1Ziik3FKpUjeFn9l+hpF8O4Ui80/Fe7t6ZmfCaLFu
	ceBEW+Ok4iKn4lhjLtFwIQc8roggp2iiwaUDtQG7G0XCk9j3kyxMd/lQnphNncm9VbcfXo9uckC
	3HgJxG+3NZaTt+UU=
X-Received: by 2002:a05:600c:8207:b0:485:3193:6ddb with SMTP id
 5b1f17b1804b1-488fb73cf74mr20471855e9.3.1776406678000; Thu, 16 Apr 2026
 23:17:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260221205606.GA23260@quark>
 <CAPjX3Fet5M2C=1TDNRhrqmanvJ2=aFdtQXfXK7MuxiOkz2rNUw@mail.gmail.com>
 <CAEg-Je80=M9nS=Dmj3FiGfXTEP_fDYytAv0ouN_iu+GzRrHp+A@mail.gmail.com>
 <CAPjX3Ff0=OOWcPHWam0WEGUY-xx860NHQt=igfZ9102-Zj1nOw@mail.gmail.com>
 <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com>
 <CAPjX3Fep5ZYLuSUY+zhewtcBqW84a+qYfLcc-20soDfMjvkecA@mail.gmail.com> <CAEg-Je8ZFJ0MWobrgNpns1-ovh37FeyuvmaR3QSarF_sg87iVg@mail.gmail.com>
In-Reply-To: <CAEg-Je8ZFJ0MWobrgNpns1-ovh37FeyuvmaR3QSarF_sg87iVg@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 17 Apr 2026 08:17:47 +0200
X-Gm-Features: AQROBzCA29DldQaGFY1g3w9X-DRSmkbfRlRBH1HuXznzsTGLXoDZj0AOkLhu9Ak
Message-ID: <CAPjX3Ffen=QZvJLdmudBg8LsTnuTOsq1QvXF7eWJtK0Sfr8xnQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/43] btrfs: add fscrypt support
To: Neal Gompa <neal@gompa.dev>
Cc: Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Apr 2026 at 16:35, Neal Gompa <neal@gompa.dev> wrote:
> On Wed, Apr 15, 2026 at 6:21=E2=80=AFAM Daniel Vacek <neelx@suse.com> wro=
te:
> > On Wed, 15 Apr 2026 at 07:30, Neal Gompa <neal@gompa.dev> wrote:
> > > On Sat, Feb 28, 2026 at 2:57=E2=80=AFAM Daniel Vacek <neelx@suse.com>=
 wrote:
> > > > On Fri, 27 Feb 2026 at 23:26, Neal Gompa <ngompa13@gmail.com> wrote=
:
> > > > > On Fri, Feb 27, 2026 at 10:55=E2=80=AFAM Daniel Vacek <neelx@suse=
.com> wrote:
> > > > > > On Sat, 21 Feb 2026 at 21:56, Eric Biggers <ebiggers@kernel.org=
> wrote:
> > > > > > > On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> > > > > > > > Hello,
> > > > > > > >
> > > > > > > > These are the remaining parts from former series [1] from O=
mar, Sweet Tea
> > > > > > > > and Josef.  Some bits of it were split into the separate se=
t [2] before.
> > > > > > > >
> > > > > > > > Notably, at this stage encryption is not supported with RAI=
D5/6 setup
> > > > > > > > and send is also isabled for now.
> > > > > > >
> > > > > > > Where does this series apply to?  There's no base-commit or g=
it tree,
> > > > > > > and it doesn't apply to mainline or btrfs/for-next.
> > > > > >
> > > > > > Hi Eric,
> > > > > >
> > > > > > My apologies, I did not explicitly mention the base. I'll do it=
 next time.
> > > > > > This was based on for-next @20260127 (commit 80dbfe6512d9c).
> > > > > > Since then, some changes occurred that will require additional
> > > > > > touches. No wonder it does not apply anymore.
> > > > > >
> > > > >
> > > > > When you make your next revision, can you also provide a tag or b=
ranch
> > > > > that I can use to grab the patches for testing? It would be easie=
r for
> > > > > me than trying to yoink them down from the emails with how many o=
f
> > > > > them there are...
> > > >
> > > > Sure
> > > >
> > >
> > > Ping to ask about the refreshed patch set. With 7.0 out the door, it'=
d
> > > be nice to have an updated set with feedback addressed...
> >
> > Hi Neal,
> >
> > I wanted to post a new iteration last week but I hit some new issues
> > that I'm trying to address now.
> > The WIP is here if you want to have a peek:
> >
> > https://github.com/dvacek/linux-btrfs/tree/fscrypt
> >
> > Note, I'll be force-updating it later so don't take even the v7 tag
> > for granted at this point.
> >
>
> Cool. I've got some travel and stuff going on, so I'll probably only
> get to take another crack at this in a couple of weeks. Do you think
> by then you'll have a finalized v7?

Yeah, it's on track. I expect to have it ready in 1-2 weeks (famous last wo=
rds).

--nX

> --
> =E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=
=EF=BC=81/ Always, there's only one truth!

Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB31831E82A
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776350130; cv=none; b=uUG4zbdQMzzrWlGhsLxXaCzGDEMXmz9KBj6juQXNn0WTBTln6AbVdXZmuV1OJvoylO7WuO5SFZYq/DzxTk4lzffEGibSqqiRRGmc7W3akAZ+HywHhkNI7eVuExmDx7KTUC8euI8zm9Kjz1NSMMx5aYzvM2E7DvE2fOl5wetx4dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776350130; c=relaxed/simple;
	bh=K5gvEiYv3jZzW25PsjZwADfdThiRHyl5G6a/VOIXzvs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gvf2WFIttmYNKGX9BWX0zY5/XUE9j1WoHJob7luGLyQGjYO1dR5tFjNafz0dbPQEiMzqvpHeLvfKVneTTKCIMat7rUl0LGjpD93C30qU9fznDHq8ENTzslWWaUP5mYnPrkDC28ZnB2mi+BxuU1lmN/mpC7Yf3CloSwDcZj/P56o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-470145d7df5so4781962b6e.0
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 07:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776350127; x=1776954927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AI1FEazLMBfRkY6zv90212rOaiThKdBsiK5ZQ2oBKoA=;
        b=C2WywuUM7/57ITpj0HqM3A6DUTrUC1fDFKp7JuByT/8yJuyKBB7G+0yf/Rrfm5HtF4
         /c0K/m6BFAWcsntel1+w94NGE8ocbyFCAF/m3tk4Pikennm18aTO9roMA/VMOqLWufGs
         dufX56IXr1EMED+6OGQBkCDQOIBJ3t1IPWEfG435OZfMsBGU2W2FYtQL1H/Hty42jvzk
         7qcMAvoKyY19prwBZSG1J5xTBGR25SoLYhlGCSe+NJ/ZK431Zq5gu+kfWzDg8Mh6YMX0
         SFaNRp3VVlfyOGZvocd1/UUrUopVWRa8WOghyKJAKNYv6mZ2iePfc8DYybvGthm9ZzMh
         XctA==
X-Forwarded-Encrypted: i=1; AFNElJ9112qySl4OND2+99wQJJHM/beIflyp9SnSlBPDGAomGFZFq+RI9MWblMBJKzUgPrBJ097vp39JDdCV2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwdDaZYmhwC//oFgdRm2Ly20qyPQ2IeRS77Ac7FO3VMb1LbCC4f
	1UJgn/w2oSJrBW/WaVSw29qoRLT2MvviBIGeMLtWOCcuCzW5u/WsTXs5PUTC/g==
X-Gm-Gg: AeBDieu2ijKXfIzyYza9o6JuinhU3IxK73ev0dZFkDqj7FVHfThWDhJ6X1Mjj3yM9WX
	v/uaOjh2AAWekpQ75Oyg/UUtgBhij1jTOGuOTqo2nJwj7bhonP+ytUEopOd/GfYb/REu7ipNAqX
	a649E4qBFEXJax2vj7c2u9JnrvS1itL9Cmb0Lx/6pCQvLuhfOBEYMX3LwbllqMi673jWBI1PfoH
	LkShOJwIlFkvBk2GT6Vlzvvl6E8h27uhAyuQepo25pDykAKkGzT+uBXY/EksZvk7HccWJRjWZ6Y
	zwimZMZ998RcZuVtDvqjYDMCUZt6ZphQmKxNAIC9sfOqecwfoBksdHBnMW8ikDWGGuVha7MPS+W
	GUPpdv9TNS0Q34qTb0I5WlWvIoD10AT1SvjXs3jFlx9V5V9YDAcFMjYIYou9+79hqXVtI8SIrTX
	fFqkziITKN1B8us14shnrKVWtkvB8HlO7r6ZY8ADuGFSRlVR7PcEDCh2eZd73kXzhIuLAwQcdb2
	3oGxpftOLgweky98PYvmtXJU3aX/fN3Hi+T2PKk9IDsyFWvIZF+iKJxV6XEMPUpomxi1O7pcA==
X-Received: by 2002:a05:6808:c1b5:b0:467:2f84:b0c6 with SMTP id 5614622812f47-4789ca3aaa0mr14037552b6e.8.1776350127260;
        Thu, 16 Apr 2026 07:35:27 -0700 (PDT)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com. [209.85.210.44])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47997f931desm15662b6e.13.2026.04.16.07.35.27
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 07:35:27 -0700 (PDT)
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7dbcb467f2bso7252702a34.3
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 07:35:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ81IjxJQrBrgOWnEsNrGW4ZrONBe26JA9JzClDboKf64imaIaQQCCsY7+MMgQgqfNhODj14yne+KkxFPg==@vger.kernel.org
X-Received: by 2002:a05:6830:3984:b0:7d7:ef0a:1ceb with SMTP id
 46e09a7af769-7dc27e2f0c5mr20103991a34.9.1776350126827; Thu, 16 Apr 2026
 07:35:26 -0700 (PDT)
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
 <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com> <CAPjX3Fep5ZYLuSUY+zhewtcBqW84a+qYfLcc-20soDfMjvkecA@mail.gmail.com>
In-Reply-To: <CAPjX3Fep5ZYLuSUY+zhewtcBqW84a+qYfLcc-20soDfMjvkecA@mail.gmail.com>
From: Neal Gompa <neal@gompa.dev>
Date: Thu, 16 Apr 2026 10:34:49 -0400
X-Gmail-Original-Message-ID: <CAEg-Je8ZFJ0MWobrgNpns1-ovh37FeyuvmaR3QSarF_sg87iVg@mail.gmail.com>
X-Gm-Features: AQROBzAbu52l_aX8sNV_57C_OXX36_Cyf8egj2w81DfudRRt3HPopShq5pbvZPE
Message-ID: <CAEg-Je8ZFJ0MWobrgNpns1-ovh37FeyuvmaR3QSarF_sg87iVg@mail.gmail.com>
Subject: Re: [PATCH v6 00/43] btrfs: add fscrypt support
To: Daniel Vacek <neelx@suse.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 6:21=E2=80=AFAM Daniel Vacek <neelx@suse.com> wrote=
:
>
> On Wed, 15 Apr 2026 at 07:30, Neal Gompa <neal@gompa.dev> wrote:
> > On Sat, Feb 28, 2026 at 2:57=E2=80=AFAM Daniel Vacek <neelx@suse.com> w=
rote:
> > > On Fri, 27 Feb 2026 at 23:26, Neal Gompa <ngompa13@gmail.com> wrote:
> > > > On Fri, Feb 27, 2026 at 10:55=E2=80=AFAM Daniel Vacek <neelx@suse.c=
om> wrote:
> > > > > On Sat, 21 Feb 2026 at 21:56, Eric Biggers <ebiggers@kernel.org> =
wrote:
> > > > > > On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> > > > > > > Hello,
> > > > > > >
> > > > > > > These are the remaining parts from former series [1] from Oma=
r, Sweet Tea
> > > > > > > and Josef.  Some bits of it were split into the separate set =
[2] before.
> > > > > > >
> > > > > > > Notably, at this stage encryption is not supported with RAID5=
/6 setup
> > > > > > > and send is also isabled for now.
> > > > > >
> > > > > > Where does this series apply to?  There's no base-commit or git=
 tree,
> > > > > > and it doesn't apply to mainline or btrfs/for-next.
> > > > >
> > > > > Hi Eric,
> > > > >
> > > > > My apologies, I did not explicitly mention the base. I'll do it n=
ext time.
> > > > > This was based on for-next @20260127 (commit 80dbfe6512d9c).
> > > > > Since then, some changes occurred that will require additional
> > > > > touches. No wonder it does not apply anymore.
> > > > >
> > > >
> > > > When you make your next revision, can you also provide a tag or bra=
nch
> > > > that I can use to grab the patches for testing? It would be easier =
for
> > > > me than trying to yoink them down from the emails with how many of
> > > > them there are...
> > >
> > > Sure
> > >
> >
> > Ping to ask about the refreshed patch set. With 7.0 out the door, it'd
> > be nice to have an updated set with feedback addressed...
>
> Hi Neal,
>
> I wanted to post a new iteration last week but I hit some new issues
> that I'm trying to address now.
> The WIP is here if you want to have a peek:
>
> https://github.com/dvacek/linux-btrfs/tree/fscrypt
>
> Note, I'll be force-updating it later so don't take even the v7 tag
> for granted at this point.
>

Cool. I've got some travel and stuff going on, so I'll probably only
get to take another crack at this in a couple of weeks. Do you think
by then you'll have a finalized v7?


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!

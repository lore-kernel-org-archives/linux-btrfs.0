Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F040337BB5
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 10:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776248500; cv=pass; b=oWqbEefFZrKZ/qdhjfH/WSes6UW2wkcnrgQ8Fz4KKpcMzblPQGccV2HrCNiBoNHziV38NqoeHyUnrlL9g178OEL7tINvn8P8E3xpuLFYuhkA1VWRD1mQ3ZtljKCGTMkL2I1ziUUearnmTzhuaYQgYyVVg0oZyev7qLFYM+ikz6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776248500; c=relaxed/simple;
	bh=Mp45n7gf0bWphbcLLRl8cG/twkgXRBKxmEorex//enk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BCrXKzkVdQZLKbWCjBQg8ZqjbnIGeyRJWfNBIDTtj9MMbW23e0c9NZDQELz1HMj8F4tAEnPXRSs2jPQUNYNQ8suaDWl1W0OCaAAcu+Mstan2KJ7FGsaMHEjpoy1cifOrG3rV7iUBbwvAJF9w+qq3xyS2723e+WVXgTWAaGajRJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JHVfTE2d; arc=pass smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JHVfTE2d"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43cfd96354aso4011909f8f.1
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 03:21:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776248498; cv=none;
        d=google.com; s=arc-20240605;
        b=Zd2bRiGpNHCDZLkZroi30Ep5PSBADxTWuhr/bfjvrp9vEmmMXYHsBe4MJXvPs4aB4T
         +NlnjBd3btCih8K+zD7hsj8f2Wvibye1hR+fwvZvb1hxlQVskvGZYkde4PSBIMpW+k5j
         oIFd/je9VbdexIf/rNIme15qKXTFxPW0kUEn7E0JYUoiHJ44szk8KsxiQL5Mys5EQpOn
         LJZlImgn3zBp6Y7SnBimhsLqJlHTPBZlJcedR8DaOUAY5A72WXluG/fL7gJbJ37FZPVj
         /rpFIwE40qtbliNsvGK7M/fnV5D8IkluhL9iOY4VqptCwFuRCyDyBQ9T4HPGaYvGl9NG
         KV/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4jJcnoVEJ7leDnc7X0jMMrtOneFaKOo08VlNndQ70BY=;
        fh=UtltkcTzXOxpTutqWq9ec1rActaWo/SaY8h5lgroc2Y=;
        b=HGAyVeyNuaQEVQANXjptTRNyITXd1JI6YESG/cx2qoRKaj9yKDZUQScLYTwQV/63gn
         Rai/tvzNI/asCkJ2RB8T7ooE21SdIC0C97qUQBcsAWiVbAIwGT2MFcPbpJUTs8JjjCyd
         jdv68f0G5u33p0TqFAmTP0o6xT+geTuS97KPKIAxdTapKSnOeOcudZ6fUwr3ELToisSq
         yfVcgxEEGAErqleGBoza0JxNHPq/AX10WbNA5k4sIiSVj5sQuUMPLJWQJSLTlTY8tzoz
         RXJIZF5w3Jc1SRzk9ofYt+/o3W7hFJ5zGBErgVAOtV8SGA0Ljo9sUsC3bZDjdrfVCta2
         XOUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776248498; x=1776853298; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4jJcnoVEJ7leDnc7X0jMMrtOneFaKOo08VlNndQ70BY=;
        b=JHVfTE2dXAhTkYAwprQpbt42op74y45gg7jM8KiRePoLE7Ov2U72wArhD41imnii1H
         NzTNXCFcSWbmkgW9FLaw/MKB6cy1QNrBBSi6WDHUQVoFNtv4P62iYMYuk93htmsrcd+x
         JcQy9raiOlbyY/9vGP8iovVI9E70dlG/jAHlbs7+uu+qY8gbtFgiRnaKuxW+FxrPKDhb
         O5LJ3zy9rTw+UL4IqnCKTFvuNfYfrq3zWOS+COqYkyCPNVYsJZffbvm3Y2t16+PsasEE
         657rpRFRP1azuUN1EH+d/XWA7vX3c8ijyZU1Z34xk2yRCz0Z/cX4YyNeuqT07FPiN8M6
         LLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776248498; x=1776853298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4jJcnoVEJ7leDnc7X0jMMrtOneFaKOo08VlNndQ70BY=;
        b=mTtkV56vrt6ErGKeDoGFYxPtpy6TjqJlF/n9gmE2bESDUFIWTT8j++MPIm8hnplaMf
         e7yEQYl2ISGmiUIJzVlMwT7k52YS9OsH7U3vUPmrLuNLpDFJm2jAL1ewJZVawmv6mOwV
         CokhzBl1DKjOSla9g8fnKMzMPLhckQOCnUxTwirGENusqxH++e7kXne5lTr0rqBEP3mL
         JmEmznFm2+tVrpyrXO/UIEt3agSQlAkpoR17Bm8JKPQ5bRBdsE+U1aaWYCzrL3rF2WtE
         8lvPjYeuWyySzfGS+KIePDLG0prXpJFrIXC/G4aoqTddLeHE4Y61oePXM9wzNZ1Yu5L0
         7Tzw==
X-Forwarded-Encrypted: i=1; AFNElJ8C/kXaN3KBir18KjdDbVQkn9j4XzLYmy6CdvdbJ4Fp3LH30AUABm3yuny6BOgxDtsF5trOJk7LxhbMiw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo/kDuHM3YJgVg1Wp0vHHC9szwTUUGbhVFbVrxB64TL5Dj8Agc
	JrN47EX9UL9HozQMCfymBooDkk0uYgNb7ksXrgYZLi2dhAq3NiB0vSYeso6D1VMzi6ZBoYFvesv
	D4A649RFQQ9WEU9V5sEYUiqIZKs3SNNRhHpbKQ2tD0g==
X-Gm-Gg: AeBDievD/XvxeQEW57I3nhM7OJD04OZZoM7jAFx4977PYJ22Kwi9LlH2bZe66PdEJq+
	fnSmuVnpiYB6DogsT4ow35wmY0Dc8aBi7mnSr4PF7DGprxeAEb5v94F+xD9qOrtv/sfr8WwjWoh
	a8lV7glVPwhZGSHH/IRRHmhGh5HhgGhpO0C00j0CSUcd+4AXqySiCtj15SIWZ6afwxyhzZpgoWF
	OEcJM88p+p01vvNtVZqE9O603iZltbutmx3+eShyMjz47yLNMZ/VkZPo9WSWLZa+NGKe5iTxMxP
	N1HfFweJVwykSb0SjfJa4ER58q2gKBlfXvjYuknYidEREwtSiq+nXDrDvy7j3Yn02phzjKGDucY
	uLZRiz99NTPtZIcE=
X-Received: by 2002:a05:6000:4203:b0:43d:9bb5:bd97 with SMTP id
 ffacd0b85a97d-43d9bb5bfa7mr10883975f8f.8.1776248497809; Wed, 15 Apr 2026
 03:21:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260221205606.GA23260@quark>
 <CAPjX3Fet5M2C=1TDNRhrqmanvJ2=aFdtQXfXK7MuxiOkz2rNUw@mail.gmail.com>
 <CAEg-Je80=M9nS=Dmj3FiGfXTEP_fDYytAv0ouN_iu+GzRrHp+A@mail.gmail.com>
 <CAPjX3Ff0=OOWcPHWam0WEGUY-xx860NHQt=igfZ9102-Zj1nOw@mail.gmail.com> <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com>
In-Reply-To: <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 15 Apr 2026 12:21:26 +0200
X-Gm-Features: AQROBzBSgMMSXj8EtJPvx4T66kG_rnjPScVsioJe9OwbOT5kODIuZAteSeQn6x4
Message-ID: <CAPjX3Fep5ZYLuSUY+zhewtcBqW84a+qYfLcc-20soDfMjvkecA@mail.gmail.com>
Subject: Re: [PATCH v6 00/43] btrfs: add fscrypt support
To: Neal Gompa <neal@gompa.dev>
Cc: Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Apr 2026 at 07:30, Neal Gompa <neal@gompa.dev> wrote:
> On Sat, Feb 28, 2026 at 2:57=E2=80=AFAM Daniel Vacek <neelx@suse.com> wro=
te:
> > On Fri, 27 Feb 2026 at 23:26, Neal Gompa <ngompa13@gmail.com> wrote:
> > > On Fri, Feb 27, 2026 at 10:55=E2=80=AFAM Daniel Vacek <neelx@suse.com=
> wrote:
> > > > On Sat, 21 Feb 2026 at 21:56, Eric Biggers <ebiggers@kernel.org> wr=
ote:
> > > > > On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> > > > > > Hello,
> > > > > >
> > > > > > These are the remaining parts from former series [1] from Omar,=
 Sweet Tea
> > > > > > and Josef.  Some bits of it were split into the separate set [2=
] before.
> > > > > >
> > > > > > Notably, at this stage encryption is not supported with RAID5/6=
 setup
> > > > > > and send is also isabled for now.
> > > > >
> > > > > Where does this series apply to?  There's no base-commit or git t=
ree,
> > > > > and it doesn't apply to mainline or btrfs/for-next.
> > > >
> > > > Hi Eric,
> > > >
> > > > My apologies, I did not explicitly mention the base. I'll do it nex=
t time.
> > > > This was based on for-next @20260127 (commit 80dbfe6512d9c).
> > > > Since then, some changes occurred that will require additional
> > > > touches. No wonder it does not apply anymore.
> > > >
> > >
> > > When you make your next revision, can you also provide a tag or branc=
h
> > > that I can use to grab the patches for testing? It would be easier fo=
r
> > > me than trying to yoink them down from the emails with how many of
> > > them there are...
> >
> > Sure
> >
>
> Ping to ask about the refreshed patch set. With 7.0 out the door, it'd
> be nice to have an updated set with feedback addressed...

Hi Neal,

I wanted to post a new iteration last week but I hit some new issues
that I'm trying to address now.
The WIP is here if you want to have a peek:

https://github.com/dvacek/linux-btrfs/tree/fscrypt

Note, I'll be force-updating it later so don't take even the v7 tag
for granted at this point.

--nX

> --
> =E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=
=EF=BC=81/ Always, there's only one truth!

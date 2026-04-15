Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6594418AFE
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 05:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776231056; cv=none; b=trx7e9UjUHWDG+6KBreED04ePgN2YV5OOss2ph2XqI7ktWacwrJ6UJRp2bUFKTH8Pj8SW4zkfPC5bzvFjndkRih7DBHKaJmMXDh0kAj60eqE4SaOmqPfU9UfcXbELjqGhpxKYvZe2gXcQjTrUdyUBnktOS888H6B2MiRatre998=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776231056; c=relaxed/simple;
	bh=yTnQ5CAqd/UhKMcqDiDVIchriTG9e9wvpYUEVj06UmI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GbZl5Cu8h8Eyd4V+oAsBCiKUXJplRQTexoAckC3N2FvAk04rZ0IEIz9gdjsAPnXmARusfheSKzrFauakId4IZ0A5V+gdFpcvwFjuhlXFwaPpzG1UQcqI6AdP5lMFJm+MSPPVdaySrWv5oT8vMGjQxqGbblw0KLVtiojUkrKIQ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-40f387a688dso4500350fac.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 22:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776231053; x=1776835853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y9GVkYuXTJNpmm1CRCAA50QlNbF7wx2z6REKbWX7K/s=;
        b=IfGvz18NE0y2xEZiJ5d6v76ujM1XTC6u3RRWfC7EIuSyCzH0eASXppq2upzj3p2IUK
         /Lfz1Jesr5FKeQGFBkpCp4goZZ0bhKefSu7WlOCHJM8yUYzoz+YdNz9i8G5Ydo1GS7pY
         tIfpGgwNq2kntD7SnuIf+08xPUferGHCDmcVHWx0UFBj9OBM+uGyHb5svGbhLNYG1lSy
         ThKFeh5fBYXJU9zMhCx3hLMI6al2n6gJu7JxLWkhKSKOsC3KX6V/KNSET8ffN87tQYAQ
         uyTEpouOmGB6Yl2WNe056cgMlclgvdovXCri/iOOCeRZud5S6i2dmeye81P+VJS+uvYD
         dNDQ==
X-Forwarded-Encrypted: i=1; AFNElJ8P8TDHWmI6NvDG14YNI+nP3uRC9ftJeDUzndt/n2PryIljKcDECzZk2Mm2S0iFdFV3ALEz+694+R5U+g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3txxuUNcqic1dx7+7h/31rMoqqSTGCZb6Veii1blStv+kTLn3
	2Les/binMZMfG4/+bnQgy4bYVaTHDjuTcwIbyWe77eh+FSHEPT0mt9TsVhdfHpTV
X-Gm-Gg: AeBDietXODyhfHEFrqHrwcKMc9ZhtDyfcuOQ+JzQce4XrlFarW6ar0QA1se5JJvM2u8
	1zSF6gKYvnNYep7I55U++y5pjmMH07aCVFgwQ8VuqoYB6qmFCssWD2BW3AzeSUPiKuwoImo7qnu
	zt4KJK5fbCzTkrRFLiWSU0s3FmUCr7P/7iLQTo1uomAiMrauMxCg6MHggxgZk12krsvmBVN3XGk
	9IUnbd6XgGPqiRjMjoIczIyATk8Ni6ocfUlwbcqE5F8nfPcz8UcxkbtMZVCGpVuQqsjL+WjRw/6
	asIFcS5wnHghoC5Hs2VQaqsAjCkaW+cyFteryN43Xrg538v9giJ0wo2YHRSL2N30prkk6IA3Mu/
	H6ZkXHIen49a/mu1hEDiAw98vipVfDpkV7JBeOMTf8YxulStw3ZuIzh5PmYr1SDHmfy5Ai0hyv7
	tHIvfFXWoQV1kJmjsDx7Up8H1W2ZpyG8XgPeid8+uSeaPKntGIA4rKL1hGe4M+FKL2K/hT3pDaA
	0i1i4fQeyLPy/LjCMjvXUbbOwkvuyFuLAwfo6RRVB+V1MyEH/ehkfSGSyu7RaMG0zxD10aVHA==
X-Received: by 2002:a05:6820:8504:b0:67b:f1c8:edd8 with SMTP id 006d021491bc7-68be8fd26f0mr7711069eaf.54.1776231053568;
        Tue, 14 Apr 2026 22:30:53 -0700 (PDT)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com. [209.85.210.50])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6932b3745afsm446390eaf.4.2026.04.14.22.30.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 22:30:53 -0700 (PDT)
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7dbccf6a23dso6125979a34.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 22:30:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/tqLVEsmNXTs913o+b4YboEjoQvQg9tOFKipBhM2zv1PkAl5+d53GxY19voLeRHoUzvOAMLa6vtIlwXg==@vger.kernel.org
X-Received: by 2002:a05:6830:438a:b0:7d7:ef4a:5ba0 with SMTP id
 46e09a7af769-7dc27e5fb9cmr12397641a34.12.1776231052630; Tue, 14 Apr 2026
 22:30:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260221205606.GA23260@quark>
 <CAPjX3Fet5M2C=1TDNRhrqmanvJ2=aFdtQXfXK7MuxiOkz2rNUw@mail.gmail.com>
 <CAEg-Je80=M9nS=Dmj3FiGfXTEP_fDYytAv0ouN_iu+GzRrHp+A@mail.gmail.com> <CAPjX3Ff0=OOWcPHWam0WEGUY-xx860NHQt=igfZ9102-Zj1nOw@mail.gmail.com>
In-Reply-To: <CAPjX3Ff0=OOWcPHWam0WEGUY-xx860NHQt=igfZ9102-Zj1nOw@mail.gmail.com>
From: Neal Gompa <neal@gompa.dev>
Date: Wed, 15 Apr 2026 01:30:15 -0400
X-Gmail-Original-Message-ID: <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com>
X-Gm-Features: AQROBzC34OjCDF6LKBnu6dATulz6eZKfdg2cuV20SScBXwf_3JWh73-Zk-aV9jM
Message-ID: <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com>
Subject: Re: [PATCH v6 00/43] btrfs: add fscrypt support
To: Daniel Vacek <neelx@suse.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 28, 2026 at 2:57=E2=80=AFAM Daniel Vacek <neelx@suse.com> wrote=
:
>
> On Fri, 27 Feb 2026 at 23:26, Neal Gompa <ngompa13@gmail.com> wrote:
> > On Fri, Feb 27, 2026 at 10:55=E2=80=AFAM Daniel Vacek <neelx@suse.com> =
wrote:
> > > On Sat, 21 Feb 2026 at 21:56, Eric Biggers <ebiggers@kernel.org> wrot=
e:
> > > > On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> > > > > Hello,
> > > > >
> > > > > These are the remaining parts from former series [1] from Omar, S=
weet Tea
> > > > > and Josef.  Some bits of it were split into the separate set [2] =
before.
> > > > >
> > > > > Notably, at this stage encryption is not supported with RAID5/6 s=
etup
> > > > > and send is also isabled for now.
> > > >
> > > > Where does this series apply to?  There's no base-commit or git tre=
e,
> > > > and it doesn't apply to mainline or btrfs/for-next.
> > >
> > > Hi Eric,
> > >
> > > My apologies, I did not explicitly mention the base. I'll do it next =
time.
> > > This was based on for-next @20260127 (commit 80dbfe6512d9c).
> > > Since then, some changes occurred that will require additional
> > > touches. No wonder it does not apply anymore.
> > >
> >
> > When you make your next revision, can you also provide a tag or branch
> > that I can use to grab the patches for testing? It would be easier for
> > me than trying to yoink them down from the emails with how many of
> > them there are...
>
> Sure
>

Ping to ask about the refreshed patch set. With 7.0 out the door, it'd
be nice to have an updated set with feedback addressed...



--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!

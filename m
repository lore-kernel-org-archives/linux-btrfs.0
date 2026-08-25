Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F346440625
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 12:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787661898; cv=none; b=LiqSVGbTK0KhdKEmltfEWxhBbpHgcJc4NApiuIcNVFBfRvxJQ8eBR5DTUaypSAYldEXVVSagZby/EUvzeZBEn4eRumrxGkrvG7aiIPY9mZc3Y890J9aFYvRHML1ga+iZO8xl8jbjWIl0cguPRaQF/uNCgtVsAKnh399U1fwXspU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787661898; c=relaxed/simple;
	bh=c78AQx2D0kBj9i4SB4XDP70TIa3W1tftR15NvoWfc+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NTAZlIZJYh827mC38tm8DiRfYfs3ipcMIy4FlIoc+0h3sdo9Ko7X0FrbJ39b8WUuoZuVaCPD2kSk6OGAyawh/MlTBILpN1PCSCLIPivYjklCwV4rThBFcRtye1SYXYJ8k3hO49HTpWO0fXkLe4yZg50YxDExvOQIQInZE0D4x3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsUz/P0u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsUz/P0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546461F00AC4
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 12:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787661894;
	bh=c78AQx2D0kBj9i4SB4XDP70TIa3W1tftR15NvoWfc+w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XsUz/P0uL+z7OhD77Zk4wqzNd5INsa1dGZzSLz3TLJWBUmZfAUTYi+xYP4tQEuxHD
	 Lc+iJWIFmKms9vsZ4AbxYqtmZFtmxR2Cm6owoNCgKwce08ogfXC/Hkkab5czR43OQh
	 QYhygxC70w1i6wSK5d8Mvb3YomzG+trhbKI4MTwpXYdrQaJ/nE2Xc1aIcjgxfT9tCS
	 S23gZ+HhdBYgc/pvaXqA4/4IM2pW5f4Fkp+g3pamZ8qRvh91cx0ui4IN0tF9LJx9EJ
	 9YC7pjHd5g5Xs6qRIfOfu8oeI2gdPvYZ8g3QxHFLtXdjoUHSVsG9/sIyhXp1rv7Kie
	 iB7rtQBDTnoHg==
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-966eabad303so912039241.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 05:44:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RotdY5ciVEmsjXQRFKn4EEK611fqlJ428BUoYtttKz3jcAf0XBNOUFGM0Hsvjt3zSGiiiIXi4snRNgbmg==@vger.kernel.org
X-Gm-Message-State: AFuF++kpypl023V3KrIVPWpxp9X+XJDjLIAzP6scRvqK2pr8r+ZaaZjQ
	4JXwm9lu22ySkG+WwIiJiLzbkByogzxOsgX/GtXnS0LBkiD5qfJ1WcpmQNCBoFTaFBO7AtYYmqM
	pyvbHc6q4h08YGKzVttWptbe2ElPB34A=
X-Received: by 2002:a05:6102:b03:b0:778:5369:763d with SMTP id
 ada2fe7eead31-77a62325a68mr10591736137.1.1787661893478; Tue, 25 Aug 2026
 05:44:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824-b4-btrfs-em-shrinker-v2-1-a6fc80447e70@debian.org>
 <CAL3q7H4OC_UqJCEo-o=uNSwZsCPJPuw8062_Mv+5NPaVqPJfsQ@mail.gmail.com> <ao1NIwsVWLkceGoJ@gmail.com>
In-Reply-To: <ao1NIwsVWLkceGoJ@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 25 Aug 2026 13:44:16 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7fYFUHwWcebAmOv=jG9AeC_n4zkfppCn1U9f9JuOYC-Q@mail.gmail.com>
X-Gm-Features: AcwNN1V5HMNaEN5EzQAyvR74XAWix9t263SwQneIMHBbkdgPMk2zajvzHPaSrLw
Message-ID: <CAL3q7H7fYFUHwWcebAmOv=jG9AeC_n4zkfppCn1U9f9JuOYC-Q@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: skip the extent map tree lock for inodes
 without extent maps
To: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, fdmanana@suse.com, boris@bur.io, 
	wqu@suse.com, layton@kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 9:10=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> Hello Filipe,
>
> On Mon, Aug 24, 2026 at 09:14:10PM +0100, Filipe Manana wrote:
> > Reviewed-by: Filipe Manana <fdmanana@suse.com>
>
> Thanks for the review and feedback.
>
> > The current subject:
> >
> > "btrfs: skip the extent map tree lock for inodes without extent maps"
> >
> > It is a bit too generic, giving no clue that it concerns the shrinker.
> > If you agree, I'll change it to:
> >
> > "btrfs: skip extent tree lock in the shrinker for inodes without extent=
 maps"
>
> Please do, your suggestion makes more sense than the current one.
>
> Just to be clear, I won't be respinning this patch: you'll update the
> subject while merging it.

Correct.

>
> Thanks,
> --breno

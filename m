Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A998238F624
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 22:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774994475; cv=pass; b=EwBEtUXmlD+mOotjs4Cm6HXROvsPDhEgolORj/VhS/a/mO4xAoP6+1gdUPxdOGWH88++QibRCt/cMBPhVHNJkDEw1m1mkKDnOH6RCRclurYbDOmmi2zaN4/Bhik+15NdxUu8AYaSCGSinNMO/EupShAYC5vHaiVW9dR7pyf2KrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774994475; c=relaxed/simple;
	bh=+B2qLKmOvJwDALMye5tBcWhncoVj3y71+ZPHDc5lfsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CNTDokp5KjxdCb221a8yBK62W5Xw2KPtCR2EpGRVFmberHfz/5PVEvE4iANnlhfvK85NkHxFIMDu2QnJK9Fe1V0HU89ZCDC27uVhgfbxnzxCVmr0i1lYxkROI5TEfwR4WnolXtzzhVaYc9uSPmtO9GaEMnLI5Lch8pWQUxislCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com; spf=pass smtp.mailfrom=vietors.com; dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b=HtzFhRfS; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vietors.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b="HtzFhRfS"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-79b73b31d36so1996117b3.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 15:01:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774994472; cv=none;
        d=google.com; s=arc-20240605;
        b=Tnj62tqyhupCXXbye8p0PKqDd2/GY3poTAFEbib5gakrBgnJ/wWOAny6T6uarbtcRZ
         bKzM2lOATAVs0LQjfl6CyyMxuyKJd17q2sFWo+jZ19cJRNk7xh5nrVVyqeGL1zQAXqgu
         H1dkYZu+6WBd0hjhuRcbCY7/y/hzqzaC3AlAOv00/4yuhrCBYzBLhtQmEXWFsqkFBhmi
         2RpdiYrMn7h+XpS6MHBmYHkO+Rngz4mVT/ZumLRJWRwMB+1gbgrSZHDys0JPWhx3u4DV
         +hvz9TSb1FeJwPyINruarqWBTXQtX5dfl2Uj359ZepDQf7rYxf0R3OapZnufsStBqOCZ
         CgCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v5q7CPHGqN6tWPkekBKy+dJpz8G9j4VFge6DOCZw504=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=etqctXf9y8yo1YIpsyP0D25ZPUABHcBRLzJNjfhWH+gSrMuG6EU0hj+JflQlIdVVtZ
         Ow+Mi/I02fYmULSOP9QZvpmB2n7xFc+AD9IRI+06Uxi7q/nqJdC4greoOdd5G0yKnFR3
         dmmq654M3LwfpJTyzg6hLeJOOxkNunvab9fA3bvVHqbaR0JcrO7iulQFFs6qZKH8eQTJ
         8/f/4TvcebRBIN5XrDxw8qjasyKEV93pK8WVyFYt2YeReThJDt1l2fZ/3pM8YhDTtWUa
         YrVdT5yXpo196zQbFw9rop8djiQrnV0U7JVOwS3CMrgY+fW2YebCvjl2xf/xmqa2tL/X
         TwuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vietors.com; s=google; t=1774994472; x=1775599272; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5q7CPHGqN6tWPkekBKy+dJpz8G9j4VFge6DOCZw504=;
        b=HtzFhRfSNp6xcTofJd5fTGzKNZpVq6C0Duhj4yaFs82t5jsUWLkIV4xnaGvvLOSsvs
         NVYAnkh9USixXnzzuVJGwTmP58cuwzw7guznMetaSllNuSs9t8tKPF3GhJhI8YvmLflt
         JdBc79392LFODMfRXrS51F8/D4ByjsxxphtunyANbVFd5/5WNdVEvQ0dVhWIcGaXQNZm
         qYJ67376MiF8iMv5PRL3YihmgiqVLPrSTs7YZxHHQu7XaaDOxMvL12hF3nyvFkJFBk5z
         0LiR+dZplCk/ZHp/b3EcnZYTN3Vtf1tjDTePsFA6NaXBJDyIwTfLBJdlz5ETZ1QAABDx
         WClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774994472; x=1775599272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v5q7CPHGqN6tWPkekBKy+dJpz8G9j4VFge6DOCZw504=;
        b=AiAPHzBQxpM9sNqLktjQ23APdDuB0OPBZxf/lAboI9lRRBeolVNmSgELbFWhmZbeT1
         fcSp0JB/xtDNTnCLco5NyE9NMIpNOHEvf+1X4ij+qVW73gPseaIKVhVD8gTkGGIWTieP
         ukLFuSR9jOk+aWXiklJfafs/2QMkE32jEIeOAKyhn+kFMB/gGe8l3WNvMI4KuaC/JKbG
         Tj2FH7By7rNOguC7v4QhdeFj1Upo6mucLTdpFpFDxapXmI5N9gszLcqj3DUFw+OnrIOJ
         j6D91eZv1QbYc/XxDwJ67V8kKPWmHhMCYyf1Qg0QhhK4mbE886aYkDtMiMnueAoLanZu
         SJ0g==
X-Gm-Message-State: AOJu0Yw4EeR/WMet5rXdPTph8nxI+C9YnBz1ZgDeTF1e/LB8voJ426ES
	P37Zu5nr3YU480mdFubAhJ6E32vkY61i9bNGaEEmhpvIVs/SGatc3HwvJ5LsVKvW3EIqwhDjqOD
	PulNbFKuqIgKDH3cVeJfKKf62pajSzV4mpsRGgqbNtg==
X-Gm-Gg: ATEYQzweDf0QC5lTvbYT0DGLN7lF7aZ++Ca4nflf+fqEBAdr2lu/nWqGDyuBlPJGu1w
	24sO6IjAI6YxUMunQ2ctyKXNDxSItnBrAN+R8W8uakyysk9rbz87WBSKlSSYexehDbc6XnV9Yuw
	vSdAUYfZExKPm6cbi3PHVBb4S7g8llfHH5QMda5danXw99VWB2Xu9Kjs1bLixde/4G0Ak3NVvud
	x9WNjYg6McEskGRSCol9f68aALwyGom+40wcTQ48tBRjWy3LuFjRGhshthq9x7pge2hkBpUET1M
	LWnrueuj6DkYe6ItqCOW8c95wSO7ZMKQkRXAJB1cHNNNmDqq
X-Received: by 2002:a05:690c:7304:b0:7a0:62b2:27cb with SMTP id
 00721157ae682-7a212d17a1cmr8809057b3.8.1774994472605; Tue, 31 Mar 2026
 15:01:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com>
 <2aa4a94b-1f10-4b17-a78a-2a58efb56522@suse.com> <CAF1bhLWJuHjf8e-4o9y-hhFqadpQ=13P-PZSJLem5Q_A2T-CTw@mail.gmail.com>
 <d470a043-72c0-4124-800c-385c19007b9e@suse.com> <CAF1bhLVahaWzAk3xXLdDSgacHjnMZLutbcP05zuxfTc3JuK-4Q@mail.gmail.com>
 <4f99d0c6-42a8-4d23-8cc0-48ff64cc8f4b@suse.com>
In-Reply-To: <4f99d0c6-42a8-4d23-8cc0-48ff64cc8f4b@suse.com>
From: =?UTF-8?Q?Jaron_Vi=C3=ABtor?= <jaron@vietors.com>
Date: Wed, 1 Apr 2026 00:01:01 +0200
X-Gm-Features: AQROBzAjt7uQ3YGjthy1om3HwPBag1bBv1J7iOPIU-uwglPyDp7ANnZgVXMhRv8
Message-ID: <CAF1bhLWnf2CLnZ=BbBVS1je8a7LYacbKDAaLYNgFzY+Z1=L2=Q@mail.gmail.com>
Subject: Re: Problem mounting 4-drive RAID1 fs after replace was interrupted
 by kernel crash
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2026 at 11:58=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/4/1 08:24, Jaron Vi=C3=ABtor =E5=86=99=E9=81=93:
> > On Tue, Mar 31, 2026 at 11:31=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote=
:
> >>
> >>
> >>
> >> =E5=9C=A8 2026/4/1 07:53, Jaron Vi=C3=ABtor =E5=86=99=E9=81=93:
> >>> On Tue, Mar 31, 2026 at 11:14=E2=80=AFPM Qu Wenruo <wqu@suse.com> wro=
te:
> >> [...]
> >>>>
> >>>> Kernel version please.
> >>>>
> >>>> And with all devices (including the new and failing disks), and "btr=
fs
> >>>> dev scan", the mount still fails with the same message?
> >>>>
> >>>> If so, mount with "degraded" mount option, and try to cancel the
> >>>> replacement, then try again.
> >>>
> >>> Thanks for your reply!
> >>> This is on kernel 6.19.10, the problem (and start of the replace
> >>> operation) was originally started on kernel 6.18.2 - I updated in
> >>> hopes that would fix things, but it made no difference.
> >>> Yes, with all drives the mount fails with the same message. Attemptin=
g
> >>> to mount degraded (or ro,degraded) also gives the exact same message
> >>> as well, so I have no way to cancel the replacement (that I know of).
> >>
> >> Then please provide the following dump, just use any device is fine
> >> (maybe except the replace target/source device):
> >>
> >>    # btrfs ins dump-tree -t root <device>
> >>
> >> Then the following dump for each device, including the target and sour=
ce
> >> device:
> >>
> >>    # btrfs ins dump-super -f <device>
> >>
> >
> > I've uploaded the dumps here:
> > https://transfer.ddvtech.com/obowqfcDsl/dumps.tar.gz
> > /dev/sdh is the failing drive, /dev/sdk is the replacement drive.
>
> My bad, I forgot to ask for dump-tree of dev tree:
>
> # btrfs ins dump-tree -t dev <device>
>
> Again it's fine to dump it from any good device.

No worries! Here it is: https://transfer.ddvtech.com/pY3LV9yw1L/dump_tree.t=
xt

>
> Thanks,
> Qu
> >
> >> I still remember I handled a similar bug before, which seems to be a
> >> bitflip in the devid.
> >>
> >> And just in case, please also run a memtest to rule out any hardware
> >> memory problems.
> >> You won't believe how frequent such problems are observed, especially =
if
> >> your NUC is running DDR4 memory.
> >
> > Ok, I'll run a memtest overnight just in case.
> > Though I should note this system had been running for several months
> > with no observed problems, so it's -probably- not bad memory.
> >
> >>
> >> Thanks,
> >> Qu
> >>
> >>>
> >>> Kind regards,
> >>> Jaron
> >>>
> >>>>
> >>>> Thanks,
> >>>> Q
>

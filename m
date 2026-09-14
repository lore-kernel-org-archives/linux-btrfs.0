Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5B148094C
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 17:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789408034; cv=none; b=s5G+HboArf1hPN+haPbggswTalkzIYLzpN5DV1CdmJaP9p5mgibVF53O/FrXLfZnu3KtVF9b3AMZzraPSjeupDzcLYUAQF1Iru254HunVEgjtyZGcbtwy9k2H4U1yoMpwe81Nkaf0gvqg6s1ClFOBdvDEpob4W7A40E28RC2D8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789408034; c=relaxed/simple;
	bh=6VptuWPIH0SbbCFVZjoznBYoVQMKivIBeccyTAlqiVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XcsYPSMOhlr7p8Wf2wbERSHepyF/ysc3l37OJD2Dv4CWK78xhnAVBY9pVqv04SaI66OwvlpYYdi6T47H6XFJmCbFwOG1Mno98S58r/z+L+/6zDoau1bhdPPjHnjP4ycaGaxsH2U0gdm0C2yQQYmMwQK44joueheYwUVYM1+72LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lM//XXZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lM//XXZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C471F000FF
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 17:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789408033;
	bh=do+nDCE9pA8JWyYAddqXSko/FI17BOT1dB81Qi5dgXs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lM//XXZNyeNqkNF9VV8qlWJRuVLBKdzPCMfbHwbzXJqtox/oL+SVV2n+O9JHLbk6K
	 k3qbkBts3JgjiB10Tlg8b4/XD2XtG13yem0DH+O91+P+jHhITM1on+cpBkoMPTjTYJ
	 4bagQzvVIpvalgScb4FYYPYSxMSI9lIrSia6u/vmEwqj1MkivkbEMGTV2PqZ2yXa/c
	 C8wyIxNsGI8Rj4rjakbv/k9SnnZ0fXxPly0YJzcaf4KUVTJEoP6Bt2CCw7rI02TkDh
	 wgFHfzc+o0eHExW8f83e71l5Aehy4M2oydBe9Oa2SgDvNfYI3pp1jug+wogg4bXrQl
	 DNJydnDpIbz7A==
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5c675e64ffcso71343e0c.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 10:47:13 -0700 (PDT)
X-Gm-Message-State: AFuF++nwUTPSRcHzF3e8JuimAV+xT3eRk2kNw9epOd7r7me6uGk6ASJ/
	gqgTpEZW6zwi1nQJwyESP9tJbY9YWKESh6bw8xCpZDpWs0J7/+ffeAKNVzTupQGV16eJJYRr8s5
	r8bfMwA7Op1/NBWF+UrePRuMhl0DmYYA=
X-Received: by 2002:a05:6102:8506:10b0:78c:d14d:8389 with SMTP id
 ada2fe7eead31-79d28cf2f87mr194151137.18.1789408032267; Mon, 14 Sep 2026
 10:47:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c97652a5-ac6b-4de6-aa23-3cdebc01d00b@gmail.com>
In-Reply-To: <c97652a5-ac6b-4de6-aa23-3cdebc01d00b@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 14 Sep 2026 18:46:36 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5dn+NFK+At8+C76r=u==AC_ZivnrvyezwOoWLfjjq9PQ@mail.gmail.com>
X-Gm-Features: AcwNN1W7zb9g21HBgp3VIMXbL6ThxFPtzFvCWB4OSJaNK_Tn89T2Hsmt0ynqtyA
Message-ID: <CAL3q7H5dn+NFK+At8+C76r=u==AC_ZivnrvyezwOoWLfjjq9PQ@mail.gmail.com>
Subject: Re: Inline data is compressed unconditinally even when results in
 increased size
To: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 5:53=E2=80=AFPM Hanabishi
<i.r.e.c.c.a.k.u.n+kernel.org@gmail.com> wrote:
>
> Hello.
>
> I noticed that a btrfs volume with compression enabled (e.g. 'compress=3D=
zstd') seems to compress inline data unconditionally, even in situations wh=
en compression is ineffective and only leads to increase in size.
>
> It is easily reproducible on small files:
>
> # echo 'a file with test content' > test.txt
> # sync
> # compsize test.txt
> Processed 1 file, 0 regular extents (0 refs), 1 inline.
> Type       Perc     Disk Usage   Uncompressed Referenced
> TOTAL      172%       43B          25B          25B
> zstd       172%       43B          25B          25B
>
> Same file when no compression enabled:
>
> Processed 1 file, 0 regular extents (0 refs), 1 inline.
> Type       Perc     Disk Usage   Uncompressed Referenced
> TOTAL      100%       25B          25B          25B
> none       100%       25B          25B          25B
>
> It's not a big deal on practice, but shouldn't it detect that the file is=
 uncompressible and fall back to no compression?
> Also, if I remember correctly, it wasn't the case a couple of kernel rele=
ases back.

It's a recent regression, independent of the compression algorithm used.
Fix here:

https://lore.kernel.org/linux-btrfs/721d8fd2c73095d06cbdbfa714a6dfac9c48895=
3.1789407346.git.fdmanana@suse.com/

Thanks.

>
>

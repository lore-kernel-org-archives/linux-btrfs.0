Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.214.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793183013;
	b=fQXc7tkaiZBf238LFrJLf4dA5GuIdnFdqgoh8WDDozMnKUDCfYNHhVMdZoLfO67nBm4X
	 +m55rP6xAxZcVkDhEaFU+EqorFacK187FUsgKO/IC17OJN9DVjHpt67DacFVOSXrpwOE4
	 YOiNujtoUVOFw3Th38SMFYw2KmEly5wTrwK6DI73KTCvmuH2u5oV5a49IVkaZISbtDv4p
	 jn3zadMLm7h90pvfTHQ3o/UAJwAnCx7FWTtx4YTnn6k5uf6WTo+4mypLSDH78buAJb8vn
	 4fuzRMdvTumvV0lDihn0FCnwCcH6B5tuU2z1F/PGfsBE+Zo7ZEcKVQ4EeZhzffwEvYQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793183013;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=h7H5p3/8MmY2hRf2o1iZplE7/tq7UTMN+hAVuumZtQQ=;
	b=D/Ji6Y2x1m4I/OeaIUE1dENKuC71Fv0jm+saLV58sjLcLIRXWNHtsf2J4H58D8geznd5
	 Z4bOLZGJDVzQ1rJ15LZiktQeaXCUUcAkoaUnA4p+RMtIRow1enh2Om3QjEBKPXeyqI8+e
	 cd39t0CF7vIP08KPGl23xQTKiHT3eod+nAYnDIsj2pJrCwEvn4KwoVDUgd9/PEpXJX1/F
	 V3LU5UqfiY8srUB5Hp2Mq3jXVimuP6+2Cx+i0UEtePanpgsdyVyNtBEO68LyxKw6MVEL2
	 NKoq0J/9r8CpWZSituNE8yigYdEMn7FfXQAyNx4pVcimkvvX3I9cdLaupaIU0nObyVg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oXrx7cNs;
	arc=fail smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E766E606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 10:23:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E766E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oXrx7cNs
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ea0efd636dso6385215ad.0
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 03:23:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793183012; cv=none;
        d=google.com; s=arc-20260327;
        b=UN9Pw/VbiUPkjT2g+3cDDdMlWFw16QkfjZyPPFtuYsERf//xUvQvEmXa5i/ifAed+T
         bDZm3mTolHvG3IBAsGIWPNqS6LF/sZLr6Walqd/jNdQVRJHy46xhEkxEzfNOWvtexAOl
         CiCLk7Pdqa+TA+MFPUR8JDAE2/oxIWgHB4Alx8jQi6kApQI3wVkJrW2eO4/TlyLHx/wn
         Uf/6Mz+VJmX0EgllmjetjdzHv70RHXr2/crVvgV5UUDiXJgHUJLueuq45VBaRVy2/Elb
         spChdHilJi5N2nrf+m3zK3MwUjvCTPAYGi901c6JGelvXPqenK8VgV9f+KeJYZg9us4H
         tmeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h7H5p3/8MmY2hRf2o1iZplE7/tq7UTMN+hAVuumZtQQ=;
        fh=xeZTQdWvPnF59lvhQDCsrlFBZxy3u4YZjJInPA+PfYY=;
        b=AqbHQkp3rVnnDFNE7xppXQlCMQJ/z5d2ZXsmubLHnjmJwjvLcm9+Nb8MURqo4CxDLE
         kIqVA4ocoS9RCuSh7WLYQq44a+2WvKgY0dHevG45oSJhO951kmDzZOKNGa+rbxUFgBKi
         0+C90SwK3wKEViK5T4QLnfHEdunvXQO/dEN2+V4fLuRWaqycctHIZJ0VyOAseGhUD+O2
         /bResR+gemZXDg2KFOl33e1fDJhRKdKJyegI+piHKi3OL2jcxxDitZUxQWRFmDmpAL4e
         JI2/NSR6Bw/2WegAMbf+dCFbRS8G5oDPo2Ia0b0PbL5wk1MR+RRJm4XqMpskdcsu9Rze
         HAoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793183012; x=1793787812; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h7H5p3/8MmY2hRf2o1iZplE7/tq7UTMN+hAVuumZtQQ=;
        b=oXrx7cNsisFgzIbJAbxRsjycjR5P/FTNIwQcCoFXpEm8b5OuGsX1ZAeYcfy10xRWrA
         /IAdNzehwadoWFQ0ARxy6GH0VNgIMsMaeBzyjN6YfwViBH/OX5a8uBnb7C/6hPNiVTAj
         RiHflQbveoBiXlairYL4JdXjOew6ZDuJ7Ck/cFqNtLF8WJLG2tzxeTfqmQ5jRejXW4DB
         NsLSkFEJDfAXwwacbCW8VhzPraBIR/WembaCMhqhf/lzLSreGUCC128Y+T+nWXhyY6Jp
         WSdkpBSdiE1LsKoP0SW7l2j0ujp4qzT+meKsOxzgXUkSIlKg0OKt1Nf5wnawAGkPXOIh
         uixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793183012; x=1793787812;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h7H5p3/8MmY2hRf2o1iZplE7/tq7UTMN+hAVuumZtQQ=;
        b=FZT6/RqDxUqmDubHg1aEwrPW3PyJUjkcpnkfaK5vznhDKSyigixvRcRbz1CaMvK2cI
         6bMYnNSXZMlczUUmUZbCbT0roJj3FPOSdjpn7sk/7fBqrJqAjqv+V8efWrmEYjpIjXDy
         dH4zQG1+UJo3pvnAGE0Vhgi8Esc7kVe1QXIJGc0WbjhqhoBVuzyJbN8a7DPdS4wHwQBZ
         DCQmTT9QZ0kHJRWWNM6dyJVEBAzUS0Pjj0c74kkgo9Itp3hj8mspyITDuwZTkFAARDQ0
         YiVZnH7BLR32eCyWa8/vHHvgk2X1nvyNrZyTHTzxEoFzNwi32YJC2aGEvIaMKTQPZMmc
         hDWA==
X-Forwarded-Encrypted: i=1; AKwUvBwHWw5Oc+Ez5oRY9ZEan5hvpE586yuqeiX3Fh2XkdyLxWOlXDBQfMY/GIf2DfoE/+jsB7RA19zsCl3prQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYK+naEyV5xILsR3wHdT1FawZ5lmMJvFcHnTRC3m8/cbYBi28evW
	fhTcnfkERxU97Q1eUufbPaeSMq5LeojdrHpDND+JECxehoakRM5ZvGtILud1ZY4hddE5qJE1oa5
	u5S9BV+xoqcvMsRPENNb4NYeJLLLzTG8=
X-Gm-Gg: AYBFou1UUAc7M3cgNqzotNwZ1vcpuEVl4aTRt65L4f9edbo7DoMD9gWuaHuJjzrYcJH
	Vu5UvlPWKhmIb0BVloMIvc8n5PbIAWXVLDTCA3HSpW0u0Lh7ztnkxy14v5oZsSb+FcQPH/ruMYX
	X1dKYD9L6forhkuN2fLTUj/ne1KoZPT3oD9LjmtFjZwRPN26sqOO8dXsk/wcWR5XpoIMutT3yP2
	nwD9Ex/N+KoN1qT2ZbeNpDTpOeShKd+CxpI1SdlBu7twmsKqHjxls6Rmih7uL/CEEI8S1zaN7fN
	cGJIZLKN7nIKxdvheQbu7OBR9NAf3EDWPzrMy/iprPa1UF8jg4bt4U1xhAKdMAhJjy7TORj68xx
	GKylGsiV43slFWg1Y5YyCVis3q72jStqtXEE=
X-Received: by 2002:a17:902:da86:b0:2e9:5b4e:b8a7 with SMTP id
 d9443c01a7336-2eb005d279cmr16426375ad.51.1793183012215; Wed, 28 Oct 2026
 03:23:32 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me>
 <CAO0HQ0UE5BtevPHHfV9mQo5HoqzxzDDjAkj9e=pD_0AaXmSYFQ@mail.gmail.com>
 <65fd2260-78e1-4521-9df1-b042788ae7bc@suse.com> <CAO0HQ0W3rALzPX59mVONjDtK1otyS8bo6_hGG6og3qwyLepmnA@mail.gmail.com>
 <84d8eb19-4264-49a5-b9b0-733c4e971433@suse.com>
In-Reply-To: <84d8eb19-4264-49a5-b9b0-733c4e971433@suse.com>
From: Luca Stefani <luca.stefani.ge1@gmail.com>
Date: Wed, 28 Oct 2026 11:23:20 +0100
X-Gm-Features: AclHuK-TMMY98rKDlXfL_veOnxxf99WHKRVy94H0MfYOd5RXWKEpFis_Hy3-fi0
Message-ID: <CAO0HQ0VTd-5Pu_4MmNfcOCjd4G20K4L2=qtkOBfAjYaOj0ZD0g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: do not leak -ERESTARTSYS from FITRIM to userspace
To: Qu Wenruo <wqu@suse.com>
Cc: zhiwei.liang@zliang.me, David Sterba <dsterba@suse.com>, 
	Chris Mason <mason@kernel.org>, Filipe Manana <fdmanana@suse.com>, Robbie Ko <robbieko@synology.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Oct 2026 at 10:42, Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/10/28 19:50, Luca Stefani =E5=86=99=E9=81=93:
> > On Wed, 28 Oct 2026 at 09:57, Qu Wenruo <wqu@suse.com> wrote:
> [...]
> >>> I don't know what the intention of btrfs: handle user interrupt
> >>> properly in btrfs_trim_fs()
> >>> was, maybe we should just swallow the ERESTARTSYS case in those scena=
rios.
> >>
> >> I agree on that btrfs is the exception, we should follow ext4/xfs, not
> >> rely on some tricky signal handling behavior for suspension.
> > When I updated btrfs_trim_interrupted I used the same "checks" as
> > seen in ext4 so at least on that part it's identical.
> >
> > What differs is our error handling: we set/handle -ERESTARTSYS, ext4 do=
es not.
> > ext4_try_to_trim_range only ever succeeds by returning the count of
> > trimmed bytes
> > even if it checks for trim interruptions.
> >
> > I think if we remove ret =3D -ERESTARTSYS; from the
> > btrfs_trim_interrupted branches
> > we'd align the behavior (plus reverting the previous change as that's
> > now useless)
>
> I think that's would work for most call sites, but there are some call
> sites that we may want to know if it's interrupted.
>
> E.g. btrfs_issue_discard() is very deep inside all trim calls, if we
> drop the return value without any other extra way to notify the caller,
> it will incorrectly return 0, which is definitely not a good idea.
>
> A safer solution would be keep the existing ERESTARTSYS, but change it
> to return 0 for now.
That would work, I think.
But that would only solve the userspace problem, as checking for
freezing(current) might be wrong in those points, which was pointed
out in this change.
Maybe the "old" btrfs_trim_interrupted users should go back to
fatal_signal_pending(current) only while the free discarding phase
keep it.

This looks similar to what some places in ext4 do, but I'm no expert.
>
> But if you have a better solution and can completely remove ERESTARTSYS,
> I can't be more happier.
I wish I could help, but as long as it's a targeted change I'd be
happy to help, but I don't know enough about the fs :)
>
> Thanks,
> Qu

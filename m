Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275E143C071
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 21:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992236; cv=pass; b=o1nM98yyWmlwzDkIzH/gP1uwYDftUlMndY3qviMk2d4I4RMjPiClIV5XwHxw/wMO0rsCErlxGAJEtHSyWv7voCP5lhiXQuyROHdHBeUBWditgXnaO94qy+pZmD0PG35qCzA8D3rbTDEnIFbskqMJSUZYi2VZ3aP7jcDh4lRLZLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992236; c=relaxed/simple;
	bh=HubY0zWmhVmRyXjwkLXKs1E7jvVKlomDEwn2ivXUybc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cMTue/XkP4MP/BTOvV7Y2AuXdwJp0748tijDdIzFSu2M78Yes0WgRqcgMc8EPxkBnKEGHkM2cMqgGwbV50RgXhi4cAkMNHf5MPgAWRJZ/PCvG5bLuxN4Yicl3hvGpyW+JdVJuli2L/41mfWpVHX//hAzJ24ORRAB2/DgGoyyVpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com; spf=pass smtp.mailfrom=vietors.com; dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b=ZZdtx8zP; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vietors.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b="ZZdtx8zP"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-79c28eb73d3so1281797b3.3
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 14:23:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774992234; cv=none;
        d=google.com; s=arc-20240605;
        b=NMneAMxcOI1NvVtk/kQzmkutX/ebnV5WxMzFuYK5kuk302kcd/lpZq6zLU2x8CTcOy
         IB7mc3OXEyYAWha0StLHXG5l7HIrW5CIn2EccLbmEO6cEBEyPiwgTb2tD/tbxI9cXNHM
         XCCJZQLbT+w9oe7H4JuXA4H5g+T519ZmmshLDdbGXuyNogy+Cx/gUFk4W/uhblIlU7I3
         fmC5I6zmAtnxLUqznwVoQOqYIX+2n+vzBP8F1egR8PfCU2jK5Oo8djGh15YUWu+EfLLl
         jPjjpmEKKMzMpmVlQC7LnN9khAVCAnHVClAzeFimHo9J3McO4abKcA91BwXTXFIx36Yj
         tDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HubY0zWmhVmRyXjwkLXKs1E7jvVKlomDEwn2ivXUybc=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=c7Ep/C8XHijlGwOM5fxgDU+r/u21MWPzh6kMZ6z/0+EWxwqoLe40OY9BB+INEiApdX
         Av7PClbDtph5cN+kMWl/wuqNSsmaPWusxn6ftvUQfwuVFvfCH2qyaFupfNLRcbxilg7M
         gLcy0bYpbRQo+R9RXUSOOf/8POaxvyZc8OsQxH8K4TKiHYqvZEfQinSt4nlDl1K8Hzvc
         ufgc6XDDERHXoIlpoSZsn8JcK7gcJJExn61PGSMHziPaf6ezBY5DtC5qinLvTONu68YB
         8KJoyfKQ7IVHRPFyEbai1Z+30hT0r2dbeHXSI76dZ4HYbJ6OacfKt+2ZX6TuhvElwdKJ
         X1cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vietors.com; s=google; t=1774992234; x=1775597034; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HubY0zWmhVmRyXjwkLXKs1E7jvVKlomDEwn2ivXUybc=;
        b=ZZdtx8zPKQjF8McETWGmf11ZrNow3d2hQpcceCXfYw31B30kDnqATQZox26Wv+m4v6
         t5wyFyQXGeZIn4MszKMlaSYo7MaGYsFRpl2AlYd7sPFp3M2Nt1pxZQ+eTXxiJfUhqe9Y
         iWgGQBGmOwPaT6o6AQvbtJ4N/3fH4P80nrBFneP1ITMBRJCaEwWdp3bmiiiCwaFb0icZ
         1ipgVBQzgnuxbwPEVcAiQjacoPp9NQHQvyjUlde2OG58Awgx/pbI6UnKrZHVRyFcOLpW
         KakA/pJ+6U31s+QjAjQkzW3t/YQ/3KvWy8yClQoz0+p48tCEFBIm/7nARIyYZUBCpY4x
         SFAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774992234; x=1775597034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HubY0zWmhVmRyXjwkLXKs1E7jvVKlomDEwn2ivXUybc=;
        b=fbwKNFca4E/ystpuuBFr++BxJ8XczLLSNMnfc/QJ0QDC3tyrhUyUaEvwsLYLF/eLCb
         Fez7BGQUFaytpbETEYeo8ALzhLqTr9lgJF73LcxQDFPe5FJ+BbUqB0XkbrJg+kocO3mA
         iAV1652GrGP8+l4gzoZRLGLRrJrd4zr6vaph0Ktqy87cCV2R35yowrIlopOOWbPH3GKE
         lnIXjxYZFkliG92gFEWXyGdO+e3Tq3Zib+MeCrL2eB9odzW9vFirg6sKC1YGwB/AJM4Y
         dliviXi8dSPrKxIbjwbBSZdd9+PBYiS4g1tR09QpPyPl55/XjrhmLcdm2UI9AhTdZX7c
         20pA==
X-Gm-Message-State: AOJu0YywAapb7nYlPdLcbiF1hORExRjWQk0/5bVzGydFRqYCrxPa8SSe
	XpbXNxvqKu/quK6K6hzelt0m9fOextMgz81Bmwg8n0C7yMaqjID2F/zAu5rrLkL2T5rb64DPUzs
	ezBdS9R7uuxJUFZbXwLCS32xD3VevFdI4hfnAc35aWQ==
X-Gm-Gg: ATEYQzz0zSDyWsnClcMix+AdnobE0ZBezzIi2PxpDU81NLj6+MzX6zDomusjpRW9w4F
	r/9jF4gF7c+fW03SaQkJaYuPVidzGVAQ3t2PInZPgaP0gt0oyKzJhXWg/7itEVOVLsc9jrPJQzx
	aQh4XTz7ASXev7KdCH7N+VavnB6qdY7lXrrIfIs1lqiqef2vm0dYev9dAzekOTf1aoMH5a5Bp6+
	al6AyX52/CDgyp/GYQaVWephhGr5gFH8j05t1Z6dF4/ZFFHPYjUaz3Zzf6QyvksheQWg4aBsirj
	YpIZBW/G9lSx+MgIcUjlBYqYB5MFBrJwCnRWhQ==
X-Received: by 2002:a05:690e:d0f:b0:64a:f23b:e2f5 with SMTP id
 956f58d0204a3-6502fe69095mr710168d50.3.1774992234098; Tue, 31 Mar 2026
 14:23:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com>
 <2aa4a94b-1f10-4b17-a78a-2a58efb56522@suse.com>
In-Reply-To: <2aa4a94b-1f10-4b17-a78a-2a58efb56522@suse.com>
From: =?UTF-8?Q?Jaron_Vi=C3=ABtor?= <jaron@vietors.com>
Date: Tue, 31 Mar 2026 23:23:43 +0200
X-Gm-Features: AQROBzDnfdP5zpOtJ1I1pYJxEqeI4jAWM0BTUDPP1hhkiYPi_3TRr6LfISBq6k4
Message-ID: <CAF1bhLWJuHjf8e-4o9y-hhFqadpQ=13P-PZSJLem5Q_A2T-CTw@mail.gmail.com>
Subject: Re: Problem mounting 4-drive RAID1 fs after replace was interrupted
 by kernel crash
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2026 at 11:14=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/4/1 07:09, Jaron Vi=C3=ABtor =E5=86=99=E9=81=93:
> > Hello,
> >
> > I have a machine with a 4-drive RAID1 btrfs filesystem attached to it
> > over a USB3-to-SATA bridge. They are not connected directly over SATA
> > because it's an Intel NUC, so USB3 is pretty much the only sensible
> > option.
> > A few days ago, one of the drives started failing so I connected a
> > second USB-TO-SATA bridge (the first one could only hold 4 drives),
> > inserted a new drive into the new bridge, and ran:
> >
> > btrfs replace start -r 7 /dev/sdk1 /media
> >
> > Devid 7 was the failing drive, and sdk1 is the new (larger) replacement=
.
> > This all went fine so far, and the replace was happily chugging along
> > for several hours.
> > Unfortunately, at around 7.1% done a kernel crash happened (I believe
> > it was unrelated to the replace operation, but can't be sure -
> > unfortunately I didn't save the errors it printed) and I had to reboot
> > the machine.
> >
> > After the reboot, attempting to mount the filesystem gives these messag=
es:
> >
> > BTRFS info (device sdk1): first mount of filesystem
> > d18c93f8-d80a-4aa7-adc5-86d457ddde20
> > BTRFS info (device sdk1): using crc32c (crc32c-lib) checksum algorithm
> > BTRFS error (device sdk1): devid 0 path /dev/sdk1 is registered but
> > not found in chunk tree
> > BTRFS error (device sdk1): remove the above devices or use 'btrfs
> > device scan --forget <dev>' to unregister them before mount
> > BTRFS error (device sdk1): open_ctree failed: -117
> >
> > Either running that command and/or unplugging the new replacement
> > drive, instead gives me these (either action results in the same
> > messages):
>
> Kernel version please.
>
> And with all devices (including the new and failing disks), and "btrfs
> dev scan", the mount still fails with the same message?
>
> If so, mount with "degraded" mount option, and try to cancel the
> replacement, then try again.

Thanks for your reply!
This is on kernel 6.19.10, the problem (and start of the replace
operation) was originally started on kernel 6.18.2 - I updated in
hopes that would fix things, but it made no difference.
Yes, with all drives the mount fails with the same message. Attempting
to mount degraded (or ro,degraded) also gives the exact same message
as well, so I have no way to cancel the replacement (that I know of).

Kind regards,
Jaron

>
> Thanks,
> Qu
>
> >
> > BTRFS info (device sdg1): first mount of filesystem
> > d18c93f8-d80a-4aa7-adc5-86d457ddde20
> > BTRFS info (device sdg1): using crc32c (crc32c-lib) checksum algorithm
> > BTRFS info (device sdg1): bdev /dev/sdg1 errs: wr 0, rd 16, flush 0,
> > corrupt 1054, gen 0
> > BTRFS info (device sdg1): bdev /dev/sdh1 errs: wr 0, rd 0, flush 0,
> > corrupt 379, gen 0
> > BTRFS info (device sdg1): bdev /dev/sdi1 errs: wr 0, rd 0, flush 0,
> > corrupt 1652, gen 0
> > BTRFS info (device sdg1): bdev /dev/sdj1 errs: wr 0, rd 0, flush 0,
> > corrupt 1522, gen 0
> > BTRFS warning (device sdg1): cannot mount because device replace
> > operation is ongoing and
> > BTRFS warning (device sdg1): tgtdev (devid 0) is missing, need to run
> > 'btrfs dev scan'?
> > BTRFS error (device sdg1): failed to init dev_replace: -5
> > BTRFS error (device sdg1): open_ctree failed: -5
> >
> > So... it seems to be stuck thinking the new drive both should -and-
> > shouldn't be there. Huh.
> >
> > I already asked for help with this issue in the IRC channel, but the
> > friendly folks there told me after some debugging that this was a
> > problem for the mailing list. So... here I am!
> > I do have access to other machines I could potentially connect the
> > drives directly to... but I'm not inclined to think the USB-to-SATA
> > bridge(s) is/are the problem here. (Unless somebody here says
> > otherwise, of course.)
> >
> > Thanks in advance for any help you may be able to provide!
> >
> > Kind regards,
> > Jaron Vi=C3=ABtor
> >
>

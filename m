Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793783290;
	b=Hfj6FpWmKQRRopln1wpqMm1dGV1ZqAT4VIRPmAtYh5uzf29gHGhVrMLEekNKbKnS24vN
	 +RPaq0aJecZ6ADbxGttX+aErwF0O6COipMX+OfffKxPGflSdMqYdFrK/xVwOq3m5o+9E1
	 e7jzjWVSzJk2VPi2AURw67ZYRxz+gRK3U6ZA/zPjEPs+kzag+yX44R7KSySfVNUSyIQ0Q
	 Ewknrgw+DF/Xb8m87JFLER07+KS7kB6qcJFBkaPHkP15fOM33AgaePZ8xxVZ2OPmCxvhM
	 4NZfLvJudNYwQivz2Dd3UvT9RQoaG4d3qr6CHYbkVgou7sDXJBhfhfMiz+ISsfKAXJA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793783290;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=EPQ3ZIfRI81vN242R/I1oPQkqhuSo1NcBpSuKfnwE+4=;
	b=Xo3Bm5Jup6hE0ztkvef7WgJNGCvK4sN5J2chDeZLAuUYXP5485FElsSxw1HsmPM27n3q
	 1gNrropQKIegP+CKPV84yRzgSY4yLOnC+BluYI7YLy0KZlqA82FV0ptkcainqedTHDwne
	 HVyoHv0CJ00KbwUO+jzA8mSf8iWHIuL4W4F1OdLtcpIAcidAOdewjjUIP3o13qn6WRqyR
	 mzCeEo8Rtxu6Twi9cFAXqztwobPj0jwe9yiEASVXZpgKOi/tul9UQyTppAK9aY+Qsim35
	 +2ESvZiNp+JB4y0ZR4vbFswk9+Eyv6VO/tPOQwM1fDjx9i2a0opwPNrLQA28LxIIzbw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=MmCmTAmT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91076606A326
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 09:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91076606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=MmCmTAmT
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so3586025e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 01:08:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793783288; cv=none;
        d=google.com; s=arc-20260327;
        b=bhPagpAMcpJ+UoEXcSSsiGpgfpeNfvgq3sF4Wzy4JBMfINxM5QAoKAcKuAnIxTp9D8
         C63giR3q7zqCMK3sHUbN3TyDPQTsFLvXg5SL2cTHfFXN2TxKytpGOBLmz5y3k1XmDC6N
         V58zRRqvpY44a8uyCPYmavbkCtrjizm93SHwXYVDf6G7z5olmx6hWAHPGL8960Op2zjE
         /L/wcNVe36MtHsw9NpgX0oO8zHpXsLMiyk2McGfr+bT30UFCcJdA9+PvW5PoeSN/suLT
         tqDCQ2rnTacoyh39E9igEK0ari/Y+jYhOS47bmv6Jzjrhc/DMlVeTtYYpimDdXpHe5KX
         w2Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EPQ3ZIfRI81vN242R/I1oPQkqhuSo1NcBpSuKfnwE+4=;
        fh=XgbjpJubtNRJNFEQaRWPA82DrRqLWLGQ7aM0D+dcqn0=;
        b=iDw0fWs+6uXcoddooMCvhjtzjYvSubbVHCI4dcFjkesAfu+Oa3Tuv9K/S9Zri7Ubd8
         yFipZA/g11E4eQ/nnOQF45SxcnySbkwrO1RqvKjOWp+KOJDF5d/kYepLJ/j0Ixrd6xtM
         4aRguZ7RZ975Acn5McTeJTScthHdvV4QTfBl833iONpqtDThtXackZADurei1vbj83oi
         XDm5VGnXdtQZLzoUETmO0+mfY26Wkju2uvWd4L0jTrbVE1Qz2hyJSMvKPhCguVwuAHjN
         sN2ffb302cD5MU1kCN2veSB0PKSlva8/msyw2OOGjoYSdy159qap4LZVasnM6N33yIdX
         2+qg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793783288; x=1794388088; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EPQ3ZIfRI81vN242R/I1oPQkqhuSo1NcBpSuKfnwE+4=;
        b=MmCmTAmTQTh+IPhEB+0U6OqhlOBmWphbkeHGJcygkm4pAeN3UkGmwoDIe1PavlHRKI
         ad5oFgq3AJry3YMLVwBOw5agH5KfvBG+vNbwIzx55BFMFFXUJQwBnZB4IiGIaMiZnNtw
         ui22WJEslIlgo3DQUxmtLEGRAlPNvhd1ASYAdQqfrd5lCcn/PdZ0WcvPOdN9+2G0nONk
         qzfG8wwGMaSr5KzlTzLcyEQICKYlJtx7fdx9BBRCQgvR/OXu/GjfeKl4cjxRhARtExEf
         ux49L0ER0DvRqTwgB3BueDzXaubhIRBf3JLzZqTK9GvezZpaa6S1dhaZU2vUVI88vI5M
         cBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793783288; x=1794388088;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EPQ3ZIfRI81vN242R/I1oPQkqhuSo1NcBpSuKfnwE+4=;
        b=sOSDnaxhKEK6XTGavCI8wnjyCOrsB1BvX8fY7C4OQFWGNdAdRWUzrjCfJAbnUzzBkY
         xYxpi5/eXikX1pIX0oqb/n1FmM5f/w0Y0slRJ9NY8v+iHshn/xx8umzHVnm+XgfAz3uS
         nWpbKzYqGzNJrErh4mY2Txdxy/5X8xCAQb0TjFOa9HkwVlUS0gm6GF7mlZvgGH0mRFfy
         0FjdpFMeJ7Jnw7HZhqXD7ffhiPmx6kpoApIDnXDtf3bLWfEhJx8uN7M/hYPdtIBfMCSg
         +NzYpgzmL5Aqs02XbKZ+jlyypjQkKLcI0KqnALXd9+iv6A28rYX3KrM6vl0ggjB6oQ9J
         tCDw==
X-Forwarded-Encrypted: i=1; AKwUvBypDVzX8T/yh9E5Xfnp/MtD7azwX0es25QBhUoRGavWtJc899lDrKthIHe6rU/KftJrbZQeukgqkDS/Gg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/bjff8HBCI0lYHInddkNfhfVy1ryEKi6NYiOX+54+84kWNTxYt
	ZpUAjVqi1mxnCFRuifcDiHfAZ7G2EZJbk5xrizzxeXhFHsnqsw/8Gv3TJKB2f0XytbKEAftywl0
	eSx23axBV5cenJ92r7OYzgwUVfXgwyOAaYSwcrYOhKvBjNRydHA4KNuOw4w==
X-Gm-Gg: AYBFou0BqKvEnkCKbszC4/MVZVwA78wYUpmOHWkHZU3f9QCL8UAJjlmeYD/qfYhGC0W
	V4fdu3P+cul7aR4NycKlEyWZMXN2/UyZRt9670u5nyE1d1KlvDXT4trpTviITKBIDGMAqqesUUY
	iedOK1Kx7ym6YA6IrfrbDfmXGwT3y9DGOeyJhIVedboz/DYEUjD0DOzJxXQIQY1NUgW73IMgd8p
	yGB9yI+HQhNb7Qz4CHKGwMKi64D8VScPQY3j4tA0YeMQbWh6jpztToC0Ds+gFPhDxJBUGvPgWBP
	wM99z8X2qdVrON1TQKbvNyNE+9MXdLfVkN4/yE/oN3A9d83KRQFu4hyHNik7ldgcJxmE1UM512q
	rmML9sIPTDIyT6y4cbbwiCR4b1qIgRN/1WSGVIayXu8bjgshfDXK36xtHZ3diYS5bOZRw3fMcb0
	aesuaJBV29Vn6HVn0a6KefX67CH1EpxpWKdA==
X-Received: by 2002:a05:600c:3b0e:b0:4a7:7d22:c50c with SMTP id
 5b1f17b1804b1-4ac150b2243mr386203905e9.2.1793783287991; Wed, 04 Nov 2026
 01:08:07 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <fa0ffb25-3c1d-46ce-8cc6-bdc1e2d86c2c@app.fastmail.com>
 <5843fbc8-95e6-4703-92db-5cd1df13ae9d@suse.com> <CAPjX3FesndAq7zHfkz8O3_tTkh_ttx_g1SOhhKa9sZ4gOsXZ8Q@mail.gmail.com>
 <ae7552e1-14ee-42be-90fe-b8bdddad1fc1@gmx.com>
In-Reply-To: <ae7552e1-14ee-42be-90fe-b8bdddad1fc1@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 4 Nov 2026 10:07:57 +0100
X-Gm-Features: AclHuK8FflEkxYC5HZCAh684rJnid2g2Pz3ezN5tA88SMXhlFBCgZXCBVZ35RXk
Message-ID: <CAPjX3Fc7N0WrgGA7SCFtwrzK0-AkDUAxT23M8s3sX8Q9_D3uAA@mail.gmail.com>
Subject: Re: bitflip in extent tree questions
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, Chris Murphy <lists@colorremedies.com>, 
	Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Nov 2026 at 09:03, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> =E5=9C=A8 2026/11/4 18:21, Daniel Vacek =E5=86=99=E9=81=93:
> > On Tue, 3 Nov 2026 at 21:42, Qu Wenruo <wqu@suse.com> wrote:
> >>
> >>
> >> =E5=9C=A8 2026/11/4 03:38, Chris Murphy =E5=86=99=E9=81=93:
> >>> User reports transient Btrfs corruption.
> >> [...]
> >>>
> >>> The questions:
> >>>
> >>> 1. In 3/8 checking extents, do the 1st and 3rd lines tell us that the=
 metadata profile is DUP?
> >>
> >> Nope, it's just how the extent item cross-check works.
> >>   From the backref item in the extent tree, and from the file extent i=
n
> >> the fs tree.
> >>
> >>> 2. Why does the kernel not report a checksum mismatch? What does this=
 tell us about the nature of the bitflip?
> >>
> >> Bitflip happened in the RAM hardware. Btrfs calculate the csum when
> >> committing, so it has no way to know if the RAM is reliable or not.
> >>
> >>> 3. Is this almost certainly logic board memory induced or is it possi=
ble it's a drive cache induced? Seems the lack of a checksum error tells us=
 the checksum was computed after the bitflip? Therefore not drive DRAM?
> >>
> >> I believe it's the system DRAM.
> >
> > I've also seen system crashes where a bitflip happened in CPU
> > registers. DRAM may still be reliable but CPU failing.
>
> That's damn cool!
>
> And that also explains a few cases where obvious bitflip is observed but
> memtest returned clean.
>
> BTW, how did you debug such situation? Regular core dump?

Yup, vmcores from customers. And examining the data in memory you
could see the correct value. Just the reg was off by 1 bit flip.
Sometimes I even got multiple dumps where I could confirm it was
always the same CPU core failing (matching the logical CPU or it's HT
sibling).

--nX

> Thanks,
> Qu
>
> >
> > --nX
> >
> >> A memtest is always recommended for DDR4.
> >> DDR5 has some extra checks, although not as good as full ECC, it shoul=
d
> >> still reduce the chance.
> >>
> >>   > 4. Is it safe to run --repair?
> >>
> >> Yes. I believe so.
> >>
> >>>
> >>> What else?
> >>>
> >>> Thanks!
> >>>
> >>> --
> >>> Chris Murphy
> >>
> >>
> >
>

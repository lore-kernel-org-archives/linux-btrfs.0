Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795447127;
	b=Gq8DwNsr29Y29CJ9pWnj6GHSN2gVLOlchR8wS2c+TPDsEHNltP6bLzSv2LA2JuUPn9CR
	 K+jUxaq1sb+YPnENFNQECIzDr4EeNhml5zZdmSYCfRNvnFZ2ybwCpCmyrkCyapNwhs9dL
	 svvC2dT2MfvYLkDpWRlPGw6roTmnu5wASsbUGAo/8thCrDhHitvQT1w196w32Rqd1HLYl
	 rxTczNgyBVBk4NBwsjv/iZjQBbRNol98v8dGYX+SXBF2vdhQQ5sFBc2ZuokpiH/H3CQuK
	 8f2ak/GKq/H5HQfX8F5a7g+WPcrNiAxUJlVj2pE5rXbWPi+qI2OIoyAuQH4G6YxrRRA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447127;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
	b=TcyEFSyzp3mqd60J3Iop5D8jIFCRduUxRIpnGdWZ0reTseezdEp15/3KdmBYApAI07bG
	 0q8E5eFq8a0Ak9wpsVerYE3vIV3oC4ZEo+BQHOkZSNeAiDl9+C4Hrt17ZXzYhoiql+MFN
	 ogGz/O9S4EFsdEHVWLhr1AXux9/U6RPDTAsm8l3dK32TAuEKYPiQxyovx0/0KLcPi3kH2
	 n53DaXo1+K8Hbaj8d8qTwhmne0M0QuQoYNJgwahM1vzAk/4xyi+ejB5NiOg8wNvJIR7Sj
	 cRpMUAaR3BD+V6zOktXIYP5G9d5fNtzvTuhHSxWT8mSANlX4FpHvrybr5HWwqVoAoOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tnOVRIK8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B488C606A321
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 15:18:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B488C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tnOVRIK8
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b87a92c17eso4778632a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 07:18:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795447125; cv=none;
        d=google.com; s=arc-20260327;
        b=WxzAkLuNQ6Wg5cVa6w9L+VAspMtHKWyfKNyTcplv0/3MckbPbXcqjgk+l31yxpwWMV
         0PFRILoTteLggPQMFOIQvUbu6klVTRzVnUUIJNWqJcRHbXCDLOzhen+tUPkXCHHDW2is
         TDx2yPHt/1x8jE9AvrFn2WNW6cCpy6dSqRyp5f8lf522NcK7qilvGebOkQpPwvxpV+Fn
         xFiIQ3XqAXA1RZflfMCOgx4Ju93SfdBjZAT1Cx31PXFPS7TZYNWdEmYhD8BPB4B93XW1
         m8nSkuY/D7v/sQUnARF98GV7CmMhnw5hKeQBOhPRUz2AGfS+bw76n/cN2m6Bm5wWLL2t
         7r0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
        fh=DgPmyDUKgFVfrRKf7hPPnFeGnrLM9k/fcRX/S6udwDc=;
        b=gFkVc/33dHHBe9VJmtmbC0FS3+tf7Ft3LJuHA16iH2QgxqrTEO/5fMJs02vcOLFQNM
         f4Cz5pUCfDgTOfvKXbazbs2So/0cVub6xWtWgAls5IVluicz0GYMZwpwNScBecEiRHFQ
         TcQsVhIApJjXwm8QzrBUlQc4NwBGNLC5lvuQhf6Sdl3azj0Rm0YQcoa14Or6qKw1dcCX
         CDhwBGDgHSWB6d9YEqNcUcxpY4N4LpnQwlNIiVSBeygoYWFd6sZsiyQAd7haMdfi8pRk
         GDZerV8WhFkzOwsmLts2XXPVhitXRTIYG+NjLtIIQtR6D/oxOj4YEHWY5lnlBfhDA9s7
         zQsg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795447125; x=1796051925; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
        b=tnOVRIK872Am/h1zBxtrm624YwtnAaM1ODFpUf4BIJQhjvNzDIVKPp0Tc0+kuNgK+T
         P6zbEiDvzhGQMmXVnvEgssD5Os9Kxz71/UfuvuNfnMWhsGjmbEY+8raprIJ9X6wrs9+P
         t+n4QGoPL0En++2BIFCjCTfGW7tcR93V3ClOyWg2gSS8rvl/rQevnj+NbA2pmKoegUTq
         wAOmepamNX26KktT8XanGPaaDNNp/wDvhl8maLDsDH89HC5UHE/TdVVYvF0O7DiHJyEN
         CZVx9d478DNjHDgR4foo1kre37sD3glA5umfoInRNznQIrbXZtcPjA2+5t6yJceHDFpe
         Nzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795447125; x=1796051925;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
        b=oN4OPouqWxyAwqK2q5i71H4OKkyqSY81CJOYE59roZkehd/olRrD7B9F+uOmXviyvm
         Bdt8jYFu0js2IN7WP7yn5VyW5lzR+btln/y6JtdFPQlJ+5M/ABqGjQ+LQhBRXI26j5+7
         5ga3Bs/j9uAiLeBInZIRUx6Jr40cun9dt3K+dfEaACAvPVuOawAKvROxbkLd4G910k2f
         2sxqKsJYOVSE/QO3VG4W5KVBlLoJyAU/RUYWdJdkITDZQQZEpGfcMOXLDVN9ubvRKF9U
         JgSLTPaSw/tPTfwHELJPWAEcW+mczrHNpEMHaaLNUJ5gh9ec74ZtL/OG6tTpK9BPFtE0
         2oTg==
X-Forwarded-Encrypted: i=1; AL+hErGaY8claXYPzwuf1QGQi4MfmrciMKQaz7cU9Q6+UVkf8rkyk0FhIsUSRgtKAjtuTyl2j4PNsGgKW6qh9g==@vger.kernel.org
X-Gm-Message-State: APuU4Z/17gMhCpdiWQ6lDBqIH0VG5qsvQH5t1bwYmR4A5g/94ETNSl2d
	MWyM8738QdpOOTzRGv2XlnEuurmnUq3pcwLdXHKxZ9ffIWSzzbAdID1MjnU7MNzN5G6RNhK4a3h
	smNZmVROvwj7KBmBicm0tww468e7IxwQ=
X-Gm-Gg: AZFdTZeqD7mobUCDUDbDDpAqSZh3zl1hore7p6BhCYVFjAgzS9KRGjms+DGndcIP2O2
	fKHscSONPtl3w6vY3YVKTUKNLWKTab/fdwSmnqOMsITCLT24TFVoPGoqNUVB4YYVWYZ8B//2I3v
	NHtGseXwXQDmCi7vgr5JA48erpBnxswlnkwVcSSA90I1CX4VENAnvwtCiEykAXWdCvkBxLw3wZ5
	/WtrwlTzL+U8QxcyFq1Ezl8jHU5hFfSJHYdlDvGwOFSxqlsA6L3xGEarb+seseKU7QDpLPgN1Je
	gVnbeYYqrEZJIhDrrnOQsoJfzqucIMp9pPfo+se/4HBnkVhvi5dSQNuWsC4wdc6LF1ZG2CzUiEB
	3CuNxBRcCldD4VRuSoezM3acdJJDDzRRetH1Sc1LKciO7tnckORwlzCgU5a6tx7on0+LoHFA=
X-Received: by 2002:a05:6402:23d0:b0:6b1:b97b:744 with SMTP id
 4fb4d7f45d1cf-6ba37ec18e4mr7070716a12.32.1795447124603; Mon, 23 Nov 2026
 07:18:44 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-4-koray.fra@gmail.com>
 <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com>
 <DN2N0BY83OY2.1OV3ZAZFSWCDG@gmail.com> <CAOQ4uxg9O-R_SUPAZ75ESGB99-4Z4EEUKGMkCF2f-sXkGPq1GA@mail.gmail.com>
 <DN2NVGUNO0GA.89JAB2PVI0LA@gmail.com> <CAOQ4uxjuAN0FdxGr_-OccO5qnUuLF5oxOq7L_545tG3+36EKFw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjuAN0FdxGr_-OccO5qnUuLF5oxOq7L_545tG3+36EKFw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 16:18:32 +0100
X-Gm-Features: Aa3M54oObGzmT9EyX7FArFQpCHBYwqipULgBnYau0_-PZcRo8HGalO_VEERbt3I
Message-ID: <CAOQ4uxgyKcB8GjE5_S9fgMv9oC_dKKaypDWEf-eXEkFeo5e89g@mail.gmail.com>
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 3:55=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Mon, Nov 23, 2026 at 3:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
> >
> > On Mon Nov 23, 2026 at 3:14 PM CET, Amir Goldstein wrote:
> > > On Mon, Nov 23, 2026 at 2:50=E2=80=AFPM koraynilay <koray.fra@gmail.c=
om> wrote:
> > >>
> > >> On Mon Nov 23, 2026 at 2:00 PM CET, Amir Goldstein wrote:
> > >> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmai=
l.com> wrote:
> > >> >>
> > [...]
> > >> > Rule:
> > >> >
> > >> > You cannot add a flag to common without carefully auditing all
> > >> > filesystems that support the legacy flag.
> > >>
> > >> Yeah, sashiko pointed out a problem in f2fs, and I could reproduce i=
t in
> > >> testing, where adding COMPR to COMMON makes f2fs crash, it also need=
s
> > >> NOCOMP in COMMON.
> > >>
> > >
> > > I don't think this is correct, or at least not enough.
> > > My agent said that this breaks or changes things on  f2fs/ext4/ubifs
> > > I didn't bother to check if all of them are true - I doubt it
> > > bottom line - need careful audit and good testing.
> >
> > Yes, definitely.
> >
> > >
> > >> > FS_XFLAG_ENCRYPT can go into common but must also
> > >> > go to FS_XFLAG_RDONLY_MASK because it's read-only for
> > >> > all existing fs.
> > >> >
> > >> > COMPR is rw for some fs and ro for others.
> > >> > As with CASEFOLD, you cannot make it COMMON before
> > >> > converting all casefold fs to new API so that each can say
> > >> > whether it wants RO or RW.
> > >>
> > >> How's CASEFOLD currently handled? in the v2 I'm drafting, I added
> > >> fileattr_mask_to_legacy() and fileattr_legacy_to_mask(), which conve=
rt
> > >> between the old format (filtering by FS_XFLAGS_MASK) and the new mas=
k
> > >> format.
> > >>
> > >
> > > Good question.
> > > Need to check this.
> >
> > Can you do that? If not, I'll check tonight, no problem.
> >
>
> CASEFOLD is set in FS_XFLAG_RDONLY_MASK and NOT set
> in COMMON
>
> Therefore, doing set with the old xflags API for the common flags always
> preserves the old CASEFOLD.
>
> This is kind of ugly and works but its hard to see the design there
> so hopefully all the new helpers and masks will sort this and make it
> more explicit.
>
> IOW, ENCRYPT can use the VERITY RDONLY and COMMON
> precedent because it is read-only across all fs (via this API).
>
> COMPR (for the purpose of ntfs patch) can follow the precedent
> of CASEFOLD of RDONLY and ~COMMON, which somehow works.
>
> Note that for fs that were converted to the xflags_mask API,
> COMMON should be irrelevant.
>
> COMMON is only used in SET to do GET and preserve the ~COMMON
> bits of the "other" API flavor.
>
> With the xflags_mask API, unless we adopt the "verify" feature
> there needs to be no internal GET with user SET and then COMMON
> is not used at all relevant at all for those fs (e.g. ntfs) only the
> _fill_ converters are important.
>

The statement above came out too strong

The internal GET is still needed for the permission checks (immutable, etc)=
,
and for converted fs COMMON still matters for the legacy ioctls, but it is
not used when the new xflags_masks API is used.

I would love it if we could get rid of the internal GET, by moving the
IMMUTABLE|APPEND checks to the fs fileattr_prep_ helpers.
But this can wait, you should not be distracted by this now.


Thanks,
Amir.

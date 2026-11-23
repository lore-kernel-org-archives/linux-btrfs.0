Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795456741;
	b=Pxb0AOScZj+0sA8Hqx7pr1KYsz3wgniD4fwHdtkgUvJDn24c7jjsC+mD7lhF2UEC5DDc
	 HYZC8JBjPUmzI0ykBGajuBKzgiD95diXOS5lBAH5R16Do2j85CCAsiKs4moqBEpB4Rwk2
	 JJ+YFm3VUV51Mg0SBMpe/aF3UV5GoZZCdehlg+l1jUL0698hCYD44zvUxPBYUhEKpsY9H
	 VIHMz2Pny7lBZhJ0tnVyKJOhbbjHwiCYdnGtpovcw43ksWIplfGabDdtbfRI9zsxsnB26
	 JEMNRCcL55oRncnMZltcg3rzzoIVmAt4DDfEsxxngRPAv/6jwM4XW02pJrRtvEciq3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795456741;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:X-Mailer:
	 References:In-Reply-To;
	bh=MluqPmwvuVO/ECMu3QHES2ezbhuwl2JDe9bOaf165Uo=;
	b=DHi5PR0CiEnHUl89jPzOZIdWacKZWkR6NE/QLALZdZSLOzAbt8yqVT6hF+4v/IpzMuD3
	 aqb62LtG/WLrXx4wAmpvTye8cNIyd0Mlw2XQuz+TXTOZ0lMagja6xMkZOGLoWlcjPhNLj
	 iucebAblGNk30wFa8T2ZLPB4hNu5n+1mb6imzdOGOwTROweuaDtkgqakgNtqRA/e6x9HW
	 in38bUqMmd3yKXc3ZN8gg2W+028nTmd9VsYVaafmKVqGqlacwijI8YIzDo2ygtLCWpmPh
	 G8/tS/BUfezj7IU+kDH+KbwRU0W4MS8mPdfp8fY0QVpDuTJduDVJ6MHeGJxb0CZLyKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LaUWsf80;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2185D606A32E
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 17:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2185D606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LaUWsf80
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so35077045e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 09:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795456739; x=1796061539; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MluqPmwvuVO/ECMu3QHES2ezbhuwl2JDe9bOaf165Uo=;
        b=LaUWsf80jU5NPHzr1T3OKDObLFeFS+0XFBRQvkot+h4cuG/Xi/qPHEDAPWEbJdMP18
         4Ey1dly9U/TamziZGQLSDLTBcCJWD66P6Dxa2LRv5D5KKkyV+Blv/vsXZi8wJZPEcYPk
         pgDFiYoJ6I7RskRWTWyD4xBd8Q8GgG7opveoSilfGjGRtkpdUTDl5K6wCMKusgHqbiMz
         SXG/8cPp4uw4N+xb4gPleov+yOCYshiGRkgHHjxU73Zr4xDv0DBDjDaM/10jjrOTBUaf
         QJfC/jyHrhmUXk+KOusHpxr3gifL49WAAlixY2u6llhPTrqRx2XQnJKxzMBQ2uLOLjLE
         qkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795456739; x=1796061539;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MluqPmwvuVO/ECMu3QHES2ezbhuwl2JDe9bOaf165Uo=;
        b=lJ+0+oefmT/rSYPuzJTqucI3wGmswIUjeIuEaKMY9GVixJCf9DdT+LJA0f/CM1x9tZ
         hlV+ukIpXxhG/NX8UokuG6IFi7wrppS+OmtlNRlk4+9aR68iwlrf24BVpSKtewPJgae/
         kAgMpZI4ZE046x6oqw1KcH3oiOAqj5fvB0r/BiiB0KuXwHkzY8DFC+EWRmzGG0L+JDBE
         rvj/DgXG9X6fbKvIaXZA/b6qorLFU0xsjOEg1axtExkyVyyj4z2lFwwyLXq9JyQoU4wn
         ibAVWWvu7Ha8dNIL1HL3DZMn6qfrauKZ+f0b5W++XJMwIZW6qBq5ng/2wV3/QW79dgqS
         bjcA==
X-Forwarded-Encrypted: i=1; AL+hErFYoUqkWIhBsUx0svju1ZQ3fF0bJxowaZ+pRpQshGs8ZTQDMDSNUCiyl+yS3bCbFXFrB15UPJ1B3/ryMg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/Run9+BHwbqHG7morAOVTgNR/3N/fpuu1NCb80PNTyaYjvYOAC
	uOI9m9IHKs9M9UKWyY+0gEGTD6we0l9d1tSjYVqm+h09oZ5RYOa7hHT4
X-Gm-Gg: AZFdTZcg5hMVFpG7bsYlAu+qUY8DXUO/BJvd5zfbZxhz94TuZyus/SiRBjvcyA4eQby
	VojkxR4AZmYAbMBVCmPwdTRRLbnfb5ioVOy6TwYLynQNkM9NmXPng0wGj1QI5fxUr7J/RwXsqjW
	2Fevh4ZIFw36dgW6A5DDQcHyL0JHWHUT3l3lMjSVBXxfhfZOoK9TMg1qTJE/Uorb8lpUpanWQQV
	ntTm5P7ROXYIfvaz/M6r7fdkZeTYrcKhfRgu5DGSR+yVSfIYkJcsK0Ot7Abtf1zW7ZFwW1e6nA7
	hDDa1a0gMJzboydj4bN5NrnNIDyC4LcLOjKIAGMVCE5iS82/EjeSs4sbGv5okHkNh3EKi0xd6+3
	KnM9T1X5ZvtHcDrBh9qgRG4nwfubcNII8z3cmtpaWaNFJRMgBSnH4wkqDOgDHG++eEfLC9Pph5v
	QyYUAI4qwcZj3ZIO1WfgUvjOmmtmYYJFhUHL9JvHnamn8022pSNXrEyOWowdYKMfvhWq4j90lBp
	RO5Dg2kW8JC7fuoetfoth7qrkg6XdQPf9SuK/fVvNr3oUF4jGvkklLC9A8pJN+zgm6gsL0x0Qh2
	JRJ9g5syybCt7siaihMNrIbfXA==
X-Received: by 2002:a05:600c:4f4a:b0:4bb:6752:8413 with SMTP id 5b1f17b1804b1-4bb8880015bmr286272305e9.8.1795456738947;
        Mon, 23 Nov 2026 09:58:58 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb90655f5asm200592505e9.1.2026.11.23.09.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 09:58:57 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=3dcf8e0a5e9edc0fcf06426a56395e3537d991acfb90470930d0b8ec71c6;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 18:58:54 +0100
Message-Id: <DN2SAKX1A29W.R1HHAXESXKS1@gmail.com>
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>, "Darrick J . Wong"
 <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add f*_xflags_{rw,ro}_mask flags to the fileattr
 API
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>
 <DN2NFOEO4XGN.1PEF1SWOF7YCQ@gmail.com>
 <CAOQ4uxirKKi=uwyiFWev_5h-LBTLjHgw-FHJ9T2X+JUNSEpf=w@mail.gmail.com>
In-Reply-To: <CAOQ4uxirKKi=uwyiFWev_5h-LBTLjHgw-FHJ9T2X+JUNSEpf=w@mail.gmail.com>

--3dcf8e0a5e9edc0fcf06426a56395e3537d991acfb90470930d0b8ec71c6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 4:42 PM CET, Amir Goldstein wrote:
> On Mon, Nov 23, 2026 at 3:10=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> On Mon Nov 23, 2026 at 2:35 PM CET, Amir Goldstein wrote:
>> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.co=
m> wrote:
>> >>
>> >> This is a follow up patch series stemmed from [1] and [2], splitting =
the
>> >> _mask change for the fileattr API into its own separate patch.
>> >>
>> >> The first patch is a preparatory patch so that the code in the patch
>> >> after can be formatted better.
>> >>
>> >> The second patch is the actual implementation, which introduces:
>> >> - fa_xflags_{rw,ro}_mask fields to struct file_attr
>> >> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct fil=
e_kattr
>> >>
>> >> These masks have the following semantics:
>> >> - rw_mask:
>> >>   * for filesystems: advertise which xflags they support changing
>> >>   * for userspace: specify which xflags it wants to modify
>> >> - ro_mask:
>> >>   * for filesystems: advertise which xflags they support only reading
>> >>   * for userspace: ignored
>> >
>> > Nice!
>> > I think this API description is very clear and coherent
>>
>> Nice.
>>
>> >
>> >>
>> >> (ro_mask for userspace was also proposed as a "verification mask"[3] =
but
>> >> I left out that semantic to keep this patch series more contained, an=
d
>> >> can be added later if needed.)
>> >
>> > Not so easily added later.
>> > We cannot change the meaning from ignore to verify without any opt-in
>> > later, but we could use the combination of
>> > rw_mask |=3D X
>> > ro_mask |=3D X
>> >
>> > to "verify" (set it as long as it is already set)
>>
>> Isn't this just "preserving"?
>>
>
> I donno I am confused let's keep this side discussion for another time.

I agree lmao.

>> > all we need to do now is make sure that the API returns -EINVAL
>> > for rw_mask & ro_mask on set.
>>
>> Yes, the current (v2) code does
>>
>> if (fa->has_masks && (rw_user_mask & ~old_ma->fsx_xflags_rw_mask))
>>         return -EOPNOTSUPP;
>>
>
> This is not the check I was talking about
> Use should not pass via the new API a flag on both ro_mask and rw_mask
> This one is definitely EINVAL and not EOPNOTSUPP.
> It is a basic contradiction of the API definition

Hmm, IMO ro_mask on set should just be ignored, so userspace can do a
get, change rw_mask and then do a set without having to zero out
ro_mask.

> it is not a specific flag that can be supported on this fs and not on the=
 other.
>
>> at the start of set_prepare(), I think that is enough, since we assume
>> the filesystems return the masks such that rw_mask & ro_mask =3D=3D 0.
>>
>
> It needs to be in the vfs before calling the filesystem at all.
> It is a UAPI definition.
>
>> >>
>> >> This allows userspace to not have to do a RMW cycle when using the
>> >> file_[gs]etattr() syscalls, avoiding possible race conditions and
>> >> simplifying their usage.
>> >>
>> >> Patch 2/3 also introduces the missing FS_XFLAG_PROJID flag so that
>> >> programs like chattr can leverage the new mask API.
>> >> FS_XFLAG_PROJID is kept out of the legacy FS_XFLAG_MASK and so it's
>> >> defined as part of a new FS_FILE_ATTR_XFLAGS_MASK group of xflags tha=
t
>> >> will be used moving forward for any new xflag (like the one proposed =
in [2]).
>> >>
>> >> Patch 3/3 converts fs/ntfs to this new API, to show how it can benefi=
t
>> >> filesystem drivers too.
>> >>
>> >> The series has been tested across NTFS, ext4 (with project quotas), X=
FS
>> >> (project quotas and extent size hints), and Btrfs.
>> >>
>> >
>> > Judging from the number of bugs reported by Sashiko and by my agent
>> > on the COMMON flags change,
>> > I think this needs test coverage for the old APIs, especially with old=
 binaries
>> > chattt/xfs_io that do the get/set cycle and re-built binaries with new=
 headers
>> > both tested against old and new kernel.
>> > Sorry, but the UAPI issues are fragile...
>>
>> Yeah, I thought about adding some tests to xfstests yesteday after I
>> made my agent test the sashiko issues in my test vm, but I don't want to
>> make it generate them and submit them with minimal oversight.
>>
>> It could still be worth to make it generate them to just test locally,
>> then clean them up and submit them after the vfs design/code is
>> finalized.
>>
>
> I think that selftest will be easier to check these backward compact
> issues with a C program that can use its own re-definitions of the struct=
.
> Then you can post it as part of the series which is much preferred for
> visibility of the test coverage in the context of review.

Ah right, I could copy src/file_attr.c from xfstests and modify that,
since it defines the structs and XFLAGS in the .c itself.

>> > This is one of the changes that would have been very hard to audit wit=
hout
>> > the LLM agents. Hopefully with the agents it is doable, but need to gu=
ide
>> > them how to review/test for regressions.
>>
>> Yeah, the amount of edge cases it catches in my code is very high, I
>> manually wrote the main vfs code in this patch series, but I took at
>> least the same amount of time to fix *some* (considering the amount
>> sashiko still reported anyway) of the bugs the robot pointed out.
>>
>
> My 2c: prompt the robot how can I make this easier for human reviewers
> to verify - keeps it away from being too creative.

I usually just ask it why it changed "all that code" and it's usually
enough, if I can't review it manually it's probably not that correct.

Thanks,
koraynilay

> Thanks,
> Amir.



--3dcf8e0a5e9edc0fcf06426a56395e3537d991acfb90470930d0b8ec71c6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawR+3gAKCRDmj22qf5IG
XP+1AP43BRF64QEMtEZ533xQB/KRczImKn5mbaKWll5fbt6qZAD+OrjJY0OBmpMe
mmkvC62iSdxE0n0dXcWsl70+M0KBlw4=
=xoVq
-----END PGP SIGNATURE-----

--3dcf8e0a5e9edc0fcf06426a56395e3537d991acfb90470930d0b8ec71c6--

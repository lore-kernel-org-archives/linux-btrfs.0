Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793536359;
	b=UhBwPeIXxmjHhqayoqb0x4OEmLfXJUpefz5HWm56p2ilsGPtdF5UQtyEDtqOYNPTg/UN
	 ZiF5D7WvFNdS1dkNr6P5I08mdUsSnjCErbKan+sNaxQh1ii+F7jivKThwXAlIhpLooZWt
	 /15APLW0pvs0zoq2yEmxI9WuRruuCQTuCykqYf6jMyyJTs3KEKzxZkTaEiwLcPZV/Uukj
	 WrNXSM2Mk4U2Aibs9lu2O7nAad0+/3I1hCEiky09syKmc+9WY+kp33GPxC8SLbjaDyCtD
	 9kswXowwALfFiX3MHa/AyRuTbtxuAZ8dgadkB5XKxdeShMwM7QpRmzMxpo5zV2FtRnQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793536359;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Q/agyZjyVt8cATb1twFRPt2O+9K+O5UwpIt4X+3S/kM=;
	b=VK8BMWAsfn+JwxPZ4iYN+0NbPc+/9xb3AHY7ISnKctAag+CRvWPxjiW5LMPl1M000jBL
	 CZ76RLptJSIVUEHWhd8XEe8GihVBUuE4FNM+5ipV7ovaCLdJMzmrGOOw+ITTp4ldpzEYu
	 y9BsfSOdlLmQHK5YfxrCIKYMt2KC2rzFYHdrR7a7kVoR+cRaD0WI4/lrxX9Gl0n5gLawr
	 aa2lArmxAYEL/vkdfKdKYRf56vaRtvN0KZBbBUwXt7QClklNOQDgCH2400v8LQ2UeFG4q
	 yxIQU1FAi/i4FaM0UnuFqhIKL8u/X92swBWPvdIOYYZYNiFzGjpSH8zR4zfS2z1FPAw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="pdZF3nq/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24895606A324
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 12:32:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24895606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pdZF3nq/
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1a2af4c8d00so2077928c88.0
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 04:32:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793536358; cv=none;
        d=google.com; s=arc-20260327;
        b=oNyF7BgYNmfVv2Jj53wAWQjsIRXTgRjGYt65MekiYSkIEHnMGY7KBJX/1ucKVjjw5Y
         vvDRgScRO8uAC147UDRnmHMN8t6B+lQl3uZpd9psPthJ9RIXQaaBoU3xQ5BIPK9JG7mO
         Px5mZReVvNi1HHo4q1F5pqobe/WWmXAu1XhajzAcRPTzzQsdIBmrnx2KxSRAlKRdVbef
         sW0HhuLUieRsTAWOKhALMkUVexNIUqAmN5XCuEuPbXAq1eypOgLXpfIHnsyGlrWYIHyO
         8BZtMCelWADkUDRlO32R1C0qfRw17y9jWNVgInFlZslu15wJPRfSWhymm7U/wwBuwiGH
         MEgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q/agyZjyVt8cATb1twFRPt2O+9K+O5UwpIt4X+3S/kM=;
        fh=8E38F0Jce9j9h4DMGrxlPspsOuC6qDLDqGrGgkaHbAU=;
        b=GHVnMy/FnfiO/wKZ488rNmPwICDuRDEehBsFSPidBWvKTMDTVHibbRfXIF3gGqRsyO
         pmjHOnXNaDRKFs58MTyOJJjfztWluJmojNhX25YWfRp5jiRdqqtk7m45c91/at4/1Tjh
         RYtUxWTh9zG/y/t396lfvaz60hyliZCneNoAuv+SKdmeiAd6VEVGv6aLpCNnaTh4qljW
         923yJaxgsT5O944nRqgXIp612RvJDCJPm1KQtW+ncRuVkGUeGWUolgXNuQ2M4k3Z0UmL
         ZvS6m09zjhG8C+AV0vYx99qgzXpq9UJsNLEgWhehJ4kLxidjDabKLpMg1z3rdYrd/UGk
         LeAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793536358; x=1794141158; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q/agyZjyVt8cATb1twFRPt2O+9K+O5UwpIt4X+3S/kM=;
        b=pdZF3nq/KO96MOb8XI+AYju9yFWjx9p1XImccXYwbQPLwU+aKZyGZuEx5CvpavW/SI
         xMJAR16aLZvWFMg2NtG9RJr0k04M7omM9WkK3/ytC+NJbd7Z8WKUVbl2SAln6ih5GO/n
         Gpiv4M58f3qJeCXd5fC0UEDbPZKUHfdu6Dqh1cPc/N/caApjYk64AzZZLwqXld32+fGP
         0jJgphJ1JoK2E/U7zov8Qg4K5xMdkHOskmKHEIZgm2LOUr4JQObPNhtWc1w2LSndxolv
         tBOTRQ0OjtNhQ3t3dafewcznwSCMAUgWb/l2wB5njz4fDU7USHomNyn7UrYo2jFbMOTq
         ZeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793536358; x=1794141158;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q/agyZjyVt8cATb1twFRPt2O+9K+O5UwpIt4X+3S/kM=;
        b=IMfTkzAHw3fSFH9wC/oXchLfnNY91+voDhWz21LVVTbmd8c2wFZH28PbBwzzn65itk
         YqOdQ36OV4niOJ2KEWrG45Qvs1omx05Jhr3MbGfPokDL0z6qM40/vOHG+vD39PrgHUwY
         r76lIJnIvonMP1KOeXyj+OQdph25UNGap+LiBjFZXIX16zsDe3Pvamm1yJW/SDYLRfHa
         mhYh9+gzqfxt5DQZJw/cqk2+fqqUN2VfUcC3o4kEZr1CwTd52aqaw5TzzeYSPPNA0rFH
         5bihEUDRg5WyjelF5bZeRACQfQr3ew34nY3R527Q2YD9K+OAdrGLQerXF4dxMITwnnaD
         9cyA==
X-Forwarded-Encrypted: i=1; AKwUvBwHndZ8pYaFvBZ5vFa0F7I50efsb2xmpIxP5pRsA2IhmaaCnvcyy6t4m3CEr7VwIAR8Ob7usIgosfUJjg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKTYsX9/O/9BGBpmKhlFPvWd4hOIYexe+R0F2hlfOt/VeftjNZ7
	iIVLMUcuxAmYYpW4jvlJ4JN4tROWAASiSYtH5ta+8FF2FGBYEUWRJZVK/4f9i+EbybZ3ccmVtcs
	yvC6syG1SfYhZZxmthTSnNxHgK2duI9E=
X-Gm-Gg: AYBFou2MMl+rNTPhKhotyYygIQG2fzb/RVpPFL52nnoPx9X2M8gaKJHtqaYh4i4w4TG
	7N6SxYqSy9+m4Ub2ey8aVe+JU2zpI/n1/lngkGe0b9fDRmSEJ8o9xHpb0aYLEi90/aep7gNYmCt
	TxdiTq09KdDHEdUq8U46eWft+8VDBWEIvn5UpleK05zH7bJJoaB5hkpAcaMAS4r2bGe9ioOCXAP
	CilAQ+P5yW9SBghOJT2h9lGULgaPVyjt9ZX4ll7VKojSacyGubGaNTSZQp4EsaTwoyEidmmP+P9
	WLIXrBE06saSHcsOIhOp+Z4R73M2sebOg5HJ+igzrysvmwtnjjeQleYYOLfz9WnxCTy7N4v3rxh
	Z5VW2vVqFrc8XRrl8Ox7UNFAGOf5QGCj0KaRe6yqAgomYdUm/Kx9PY/VfjZBN4pVgW/wypZfnTm
	RqbfrA4Qoh9mYh
X-Received: by 2002:a05:7022:1e13:b0:18d:ac5a:89ef with SMTP id
 a92af1059eb24-1ac5c17ab77mr9307258c88.31.1793536358037; Sun, 01 Nov 2026
 04:32:38 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAKu0nJUGwnmuuT6fBz0phH=1Nyi6BguH2PHvs9+hDnrc_X0zWw@mail.gmail.com>
 <o5sj6bswd6arkusrxj5w5ww3jwk5hz7ktzxvdik72h7c4uen5i@fnwkmk6hvuf5>
 <CAKu0nJWyt8OGYkYBdnUnWo3rT-FwKEwoTmsCe71vC4cfUcbE0Q@mail.gmail.com> <CAKu0nJX68hxKU=G+bNq5HaUF9yPPy2bS3ifo0O=qwcW1m010Lg@mail.gmail.com>
In-Reply-To: <CAKu0nJX68hxKU=G+bNq5HaUF9yPPy2bS3ifo0O=qwcW1m010Lg@mail.gmail.com>
From: Saleh Mammadof <salehmammadof@gmail.com>
Date: Sun, 1 Nov 2026 16:32:26 +0400
X-Gm-Features: AclHuK9CavhZo800DQzAzQO10otkNnV4JuvBZBEz5Zjm5Ys5TMPHW6k2u81iZSw
Message-ID: <CAKu0nJUB=K0Er_H7k7eDcLJzT_mrwfcyJJ3ikG7i+WXV9kv0xA@mail.gmail.com>
Subject: Re: filemap_invalidate_inode() - losing -EBUSY from invalidate_inode_pages2_range?
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, hch@lst.de, dhowells@redhat.com, 
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

Thanks, Honza, and thanks for looping in the btrfs people.

To summarize: filemap_invalidate_inode() ignores the return value of
invalidate_inode_pages2_range() and returns only what
filemap_check_errors() finds on the mapping (AS_EIO/AS_ENOSPC). So
-EBUSY, and errors coming from folio_launder(), are dropped, and the
caller sees 0 even if a folio was left in the page cache.

I was not able to test this thoroughly, so please treat what follows as
a limited check only. On a debug kernel (btrfs on a loop device,
FICLONERANGE into a destination with cached pages) I forced -EBUSY from
invalidate_inode_pages2_range(), and filemap_invalidate_inode() returned
0 and the ioctl reported success. That only shows the error is dropped;
it does not show that -EBUSY can happen in practice. I also made a few
quick attempts to hit -EBUSY naturally on btrfs (dirty pages, splice,
dirty data outside the cloned range) and did not see it, but those
tests were small and may well be flawed, so I can=E2=80=99t say how reachab=
le
it is.

The callers differ:

btrfs reflink (fs/btrfs/reflink.c): the comment above the call says
btrfs_wait_ordered_range() is there so that the invalidation does not
fail, because a dirty folio would make btrfs_release_folio() return
false and the invalidation return -EBUSY, and that such a failure
can=E2=80=99t be ignored. The caller then checks ret < 0, so it seems to
expect -EBUSY to be returned.
netfs direct write and cifs appear to check the return value; afs
ignores it.

Question for the maintainers: would you want filemap_invalidate_inode()
to return the invalidation error (with -EIO/-ENOSPC from
filemap_check_errors() keeping precedence), or is the current behaviour
acceptable for your callers? If propagating it is what you=E2=80=99d want, =
I=E2=80=99m
happy to send a patch.

Thanks,
Saleh


On Wed, Oct 28, 2026 at 12:52=E2=80=AFAM Saleh Mammadof <salehmammadof@gmai=
l.com> wrote:
>
> Hi all,
>
> Thanks, Honza, and thanks for looping in the btrfs people.
>
> To summarize: filemap_invalidate_inode() ignores the return value of inva=
lidate_inode_pages2_range() and returns only what filemap_check_errors() fi=
nds on the mapping (AS_EIO/AS_ENOSPC). So -EBUSY, and errors from folio_lau=
nder(), are dropped, and the caller sees 0 even if a folio was left in the =
page cache.
>
> I did only a limited check of the effect. On a debug kernel (btrfs on a l=
oop device, FICLONERANGE into a destination with cached pages) I forced -EB=
USY from invalidate_inode_pages2_range(), and filemap_invalidate_inode() re=
turned 0 and the ioctl reported success. I also made a few quick attempts t=
o hit -EBUSY naturally on btrfs (dirty pages, splice, dirty data outside th=
e cloned range) and did not see it, but those tests were small and may well=
 be flawed, so I can=E2=80=99t say how reachable it is in practice.
>
> The callers differ:
>
> btrfs reflink (fs/btrfs/reflink.c): the comment above the call says btrfs=
_wait_ordered_range() is there so the invalidation does not fail, because a=
 dirty folio would make btrfs_release_folio() return false and the invalida=
tion return -EBUSY, and that such a failure can=E2=80=99t be ignored. The c=
aller then checks ret < 0, so it seems to expect -EBUSY to be returned.
> netfs direct write and cifs appear to check the return value; afs ignores=
 it.
>
> Question for the maintainers: would you want filemap_invalidate_inode() t=
o return the invalidation error (with -EIO/-ENOSPC from filemap_check_error=
s() keeping precedence), or is the current behaviour acceptable for your ca=
llers? If propagating it is what you=E2=80=99d want, I=E2=80=99m happy to s=
end a patch.
>
> Thanks,
> Saleh
>
>
> On Wed, Oct 28, 2026 at 12:51=E2=80=AFAM Saleh Mammadof <salehmammadof@gm=
ail.com> wrote:
>>
>> Thanks Jan, makes sense. I'll wait to hear what the btrfs folks think th=
e expected behavior should be.
>>
>> On Mon, Oct 26, 2026 at 5:34=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>>>
>>> Hi!
>>>
>>> On Sun 25-10-26 02:27:13, Saleh Mammadof wrote:
>>> > Been going through mm/filemap.c lately and something caught my eye in
>>> > filemap_invalidate_inode(). It calls filemap_fdatawrite_range() (or
>>> > the wbc variant) and then invalidate_inode_pages2_range(), but doesn'=
t
>>> > seem to check either return value directly - just falls through to
>>> > filemap_check_errors() at the end.
>>> >
>>> > The thing is, invalidate_inode_pages2_range() can return -EBUSY if a
>>> > folio won't evict (release_folio failing, launder_folio erroring out,
>>> > folio going dirty again mid-invalidation, etc), and filemap_check_err=
ors()
>>> > only looks at AS_ENOSPC/AS_EIO on the mapping. So that -EBUSY just...
>>> > disappears?
>>>
>>> Yes. Whether it matters or not depends on the caller I guess so you sho=
uld
>>> discuss with the users of filemap_invalidate_inode() what they'd like t=
he
>>> function to do. Adding btrfs people into the loop.
>>>
>>>                                                                 Honza
>>>
>>> > If I'm reading this right it could matter for callers that actually
>>> > branch on the return value - btrfs reflink bails out on a negative
>>> > return when clearing the destination cache, cifs sets
>>> > CIFS_INO_INVALID_MAPPING again on failure, that kind of thing. If the=
y
>>> > get back 0 when a folio was actually left behind, they'd think the
>>> > invalidation fully succeeded.
>>> >
>>> > Could be I'm missing some other path that catches this, genuinely not
>>> > sure. Haven't tried to reproduce it, just going off reading the code.
>>> > Let me know if I'm off base here.
>>> >
>>> > Saleh
>>> --
>>> Jan Kara <jack@suse.com>
>>> SUSE Labs, CR

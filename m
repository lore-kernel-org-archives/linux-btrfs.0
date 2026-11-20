Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795185854;
	b=VCNTRrwgRqUs/vvOjKqiUjdzmyPc1oefNc3lF5uLIihEPA+lIOOYUf9t/snxXinh/1Jc
	 ufJfonONt1yQWRX8MR0Jy1XZ152xUMqp3G3GlwVJ7TQxBOucu7/xo3VblLrhN4jxv2fr7
	 y3pA3X/kL03QmUs2YWW8xbbof9uBfn8M2LOc05ZFGdFicABWz32JvTfaBD5R5xBPLzUlC
	 XdMvjdFfkJpZhQPHQRPKUjH5sGUG9nvggE6NXjXxxCBZs0OIscbLprElMjf7wfDO8MW3/
	 /dqrWYwC+cYgYYydobXmMl6k1cn7c5LXshzUF8+oJ7XTibxYo+TrdoqdicXNOJhcoEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185854;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
	b=MJw67aQsRMkME5+Cuf0sRw4qOSLEvuRAnltpflu0qiEu6myxBkSxbUFEWyNmIwtIgkvk
	 OOxTr4c2ctaYcW7B77GwWU12KP4S9BsXWmRFCo61G25bzGf/4QADiIyh5vh3ObcPfbt0P
	 EzCq0088KW0pBDN6h1UBEyBXQ7EGYArNrJZ2lKFJ9BQQCKOW+N+ELchNbNqKaJkOmHSaC
	 kbV7RuECk8VTimmmM9eufW3A4kaZX6UkEofYaqf7LNHMq/yexEsjmVYupsi+x7a4/S4bs
	 RXvGkRqAVqgn64uo87Y/UU3K4rYjQcOKQqoMaD+IGwNG8Zcf5kQY9x37skgcdeNEbtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UCx2E0Sw;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8DD606A32A
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 14:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD8DD606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UCx2E0Sw
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so604841f8f.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 06:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795185852; x=1795790652; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
        b=UCx2E0SwKcK/oqyYNLOz686VusYmii+3mMDSe2hm1s34x/9j7y81gtRcvRwLvYBz3L
         8OWonxeJ7ONGBIAdCYN28kX+LRG6+zE1qzjaKqtJdHF3MJBPWqGI5u3OnZMZ4nUYhE9m
         PEaUWEoqsvQP3IAgHgg36VjHmqvLstmO20zMnptGeWfnBQnfV8Xwbcf2i+5+HPE/je1g
         UffyYR0okyEW/XxdVXBfUQ2+CTA3+deWuJyIBQP4+m3bQJNmt6Az6/sbA917Q6G5mzbK
         Rj5vUQAl8Up+44D/OFiKqlCYJFj+9wTD4uBgXkGE6VmgSc/N2pGJihXdIl+6jSPw+Tjd
         ggNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185852; x=1795790652;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
        b=me2j+UTDtHJVlO0fZkh+5x2FEhUgaw/Orpk9OsBnnad1X75ukPS4hdozz6O/GkbjdY
         s8boMHB78hqw63z/mnutNsnnKPgHzbREUTX/+Di2TUTMG08UDjX8dmyYL5TikCcGQfmv
         oEPLGdFj17k1v5RiYInkOzEO8RBiGrVWa+aH21Zp3o0xbu8sTf4S2IzVyfeYRsVl7yVu
         oMwplY8sT475q7ROozUOVuLvktLoR3OSPLXEez3/gog2qE+GeQb6FSZ81A/xZfU+SoxA
         Dr6zlkDttEuuChNAryOMiJgYq95aHhG/3L58gcHqsKPthqpOFqYqQLw9Bjutuv2743GF
         VabQ==
X-Forwarded-Encrypted: i=1; AL+hErHj9sQJZG1Ih0oTCaLKILoup87rzAmlsS3JvAKrq+jGvGuekNNUo7tZnogsG3WIBO6hQ/LgySFKB6zXhQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z94kAunPP3h69hTZ2rD8XDOWGRM9XoGdp8tZqv6i/vraLb9N43y
	2SK8dmhvso/o8S1BdCHx7e8E56FP15BASnV1aBhgA2DFwuUu2q8P7bZD
X-Gm-Gg: AZFdTZfvZVS8NNIdv+phTii1lScumTMwyuorPfhqqnFeRQvl/Ebs/C/wneMOx2d6g83
	A/GGKH1dZPmTPV9XHsnXH+02upk64GhXFmeltPWVgyEqpHb5Bgg5voPcso6DkmLI+8UvjaohpDN
	VTxxy7l8Da2rjyI33inv5rCKrFNKqAZAMn5P7d8tn89HDM4o5BZx+BvsZmems4ecGvowtjieOHU
	NnvaNtnRTyjXb2JLWaUzPyIBKYVjDK9xU3f8Jvza8k+ahyDdTCf2J5Wi3fXp/wXvV1RNAYrZxG+
	ZeS/eePZFjF+BofCD0vkCV2GiMUr5ruPyzO/8mkENBdCrF2M6ZfwndGxw8LQN+A5AhsknyO75tp
	uLlxocRxdGoeGDBANyPe82I3FKoMJpjd4+ZMKNRW70cKSOZG/Ea7NLAbYMTYcQhhg8bAsF62M2D
	39pjNmuW3+rm9/YbXuwlKgJDhUiwynYV32fmzT3wEImpTj5SW11BpwptSo4k+xxS2ciHUTh13UO
	rvrcRSm+lV3yR8WOvDYk6b/AnVDygakxf9ivkTHM9KEA0706gaKmjsUSzLQFOSEanJJ9X13XQKA
	4RYYin707L68hHxGM0kyDIw6vyw81Lw91LIydI9QauPBq/XZ
X-Received: by 2002:adf:e014:0:20b0:491:8462:20cc with SMTP id ffacd0b85a97d-4abb400c0cbmr5198457f8f.37.1795185852061;
        Fri, 20 Nov 2026 06:44:12 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf62f7sm6426849f8f.13.2026.11.20.06.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 06:44:11 -0800 (PST)
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
 boundary=8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 20 Nov 2026 15:44:07 +0100
Message-Id: <DN049T7Y67NZ.10CIWW8DE6PP5@gmail.com>
Cc: "Lauri Gates" <lauri.gates@gmail.com>, "Dave Chinner" <dgc@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>, "Christoph Hellwig"
 <hch@infradead.org>, <linux-xfs@vger.kernel.org>, "Carlos Maiolino"
 <cem@kernel.org>, "Christian Brauner" <christian@brauner.io>, "Darrick J.
 Wong" <djwong@kernel.org>, <linux-api@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
 <ocfs2-devel@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-cifs@vger.kernel.org>, "Theodore Tso" <tytso@mit.edu>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <av4Hn9u80fs8iHZ6@dread>
 <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
 <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
 <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com>
 <CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com>
 <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
 <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>

--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 20, 2026 at 3:35 PM CET, Amir Goldstein wrote:
> On Fri, Nov 20, 2026 at 3:12=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>> > With non-zero xflags_mask, internal contact masks
>> > can be used for -EINVAL not for silent ignoring.
>>
>> What do you mean by "internal contact masks"?
>>
>
> I mean that users do file_setattr() with a bunch of flags
> some of them are just ignored randomly without any any way
> for user to know about it, because this logic is some internal kernel con=
stant,
> which cannot and should not be documented in the API.

Ah ok.

Thanks,
koraynilay

> Thanks,
> Amir.



--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawBctwAKCRA0bnTtJTDo
OG67AP99DCLnFsLMHCsRAeUitR3pAiNRglGbALKnTbw7U718dAD/Rbb718IIJvnz
/T8g9StMlY2VrgWntvlMz+RabJ8OUgY=
=dJIP
-----END PGP SIGNATURE-----

--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd--

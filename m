Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795781098;
	b=L67NdsB2GxZfg3Fg2/i/rVz3puJSji2Gm1/D8mHXiEfxrZL2uzncQ963GY5ZOHYioMuT
	 2GQ2stzhnvL7NPVEyDW0ltY/hestAylq+uuLp5phzFkNCY63jNtl1HxiywdPz02d4c/ji
	 +/jEv7YocoEWFcp6WDMw0IB83uLh0Nazn4RIn+uOCuxWa+5HtSPU2IkSmPChfC2m6NVGb
	 8ppCTeG51x2PGT7wCe4KriFsIXhiYEQ5PIZjv6pORXxJTTFAKIlxAe/eFnd8+q1okG2Ol
	 97qnZ52A78/6duqogK6ExdymbC2MINAHEhVao3Nhcm4ObuWLFuDh/fsjPyZfi52dqMw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795781098;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
	b=i7UGLmiaE6ruDijVNzYD8t/jSsWvCXkGxvAWit7/Q7/eouZ7ygOzjtMyZn9q+UFa12R/
	 wV7eJIU38E53OnGULPRe3iT3+bYevxpm/NgD0HQZGP498agrcZlR7u0kZIot6QNr+8bJv
	 QB4SEeo0OnrA54eDsiK49UVZVheR9b8Vwo3Z6n4s9rsWHHX4ac6LrSRNUMMbB7u7rAomw
	 yCKeQOvkVRcSamBeTL/9SKKFMAQDMvf5ZDaYE20vWHG48C1dLzlt3HWwEZiRezB11i13z
	 MwVj98WAEj/RIfi6m9ZfdUXVEw8d7fq8qX+iTxpA0qhhXFyigtZ6JyxUCDsaMaySzcg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="a/faIOem";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF86606A31E
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 12:04:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BF86606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a/faIOem
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b8a52db5f9so9787035a12.3
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 04:04:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795781096; cv=none;
        d=google.com; s=arc-20260327;
        b=Z8s6TrJeMJSju8yzcyFPc98iOV14vlAWsTLucQKvjEbalRM6j39Yh9dSwNWIzytDdE
         hKdaQJ6gWzNbkoQ5pGmtQWkVLqTeaKfPba2kSuWzuaVmTLW/UTFd6RuwnQvdMp6NQEoc
         jKq6GpMAL+/xs/Mc++mfTUtIM9Kyme606snfRwLSJec5p/vSOmn9DYq8bL19U+K+IS3T
         CI8/g5GVjGv+E3fHA2wfyuai/mkowRPHOSk8Xtog5pzaqk+vIcM/GtGrrfA4nwMTujic
         XXYtMLoFF1lW7dZ3OQhUGQNGw+4tUTbKXo2keqvi6PAR7wqlNtDjNkh0mXHeUAOUqfG1
         XVnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
        fh=9NiGWmI3zoLZw89+2QUBAHJN0Rdwr8L/ArJ1sEvW3Sc=;
        b=roDV2zVZEdbbh0xe8JDNUFN1W0GYHBp2uJCl0zb/jx0gmZis0LtzA3eom6v9BpvxCD
         igQS/vK4PsF8B/rLyj340iGImfjGTwdHXZIHTzKuRJDNuomPoKngJN3S5mGRYfBjA1+l
         8ZxDMeqt08sPzCQKZ2N1d2y901QtNG8ONafrvFm9Re9ZA0m4uq4+4u67CxjwLD4kQUSc
         2iOY9jRr6eRSNAF0blS2u9JjnFreLA83pgg4WGhxUHJi0Iyyy7BTSWDCr+EB2OelYE2A
         BKd+ME7qJ6stY4Pl9BQq+WMYplG/ePkxZai0s3oUuWjCVL4AmEKa6rdWMCmHCKTROnkd
         FRAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795781096; x=1796385896; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
        b=a/faIOemKG9XP9oN9nHZ0RXKAJGUuULcrj5tlG5oW/VxoETGk/czdvSllhhNf3cLZ9
         QZfgoKUPAO+lxAeT39SzbkiTrobrvkwTRilpOiRfynBTw3Dq4mQQOsaPpO2q3L/eNCw6
         75tG8Way+N5Y7kNdc374kxwLxPpgXrf4M3aS8Tkoc7ZPyjzg6Rzr+n+Pscq1n8ZXh53X
         8gOnoWD+dlS10yDPmY1W05uiGKpWUmd1Zb6pGB8AYpx6o/RFlMqxj59WZhRkFmmQMlzf
         d6R5FFbL3Np6vQDGcBL5tFUkX4TUGEgF/3bqMPd6LQvhH05HX1jyMVN8C3RNkqypH2BI
         RiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795781096; x=1796385896;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
        b=fQMUaJzR1kuNLU7stzdUeY1wwYpeWgVClcY5oB+lURuT45uoyKkb/gAKRNSyqtlluX
         sID/Iv4S/QVSo9+82YeL11pXhTKVlNmOeS7RuA1SSvpDYiFfBL0v3TeXdrQ3m7dSvSQv
         jJ1W+fVKN99Q1kG8LfxUArExiqKyEASHdLa6F39+2eTd4h47SJvCfgAEv9Ac7aPYQHn2
         u3PmeHe92ycNFopD2vhPzynHG8CprJayrpYOFJVh77oSIhC4IEWSIvfH/vJQAK8O+bve
         nEj07oXzp/x2PZV3hWw01nVSc28HQ/vCuEsZL8h+fxppq8zYegl5DaD0llqsx4/PYpc0
         406Q==
X-Forwarded-Encrypted: i=1; AL+hErE5Oug9v08KfizS41MtQ5hWZ9AQwYGc3MJfNzjltZCOqBv1TXuBU413svVVa3SaAK5TGCCXOy1aUaAO7g==@vger.kernel.org
X-Gm-Message-State: APuU4Z9OEx06ZFPhlmie51x+XHgoSykc5R56Ksoh1gR9eOqQeep1OUMK
	sU7Bj9l5vXobbf8tJUmsuY071qK6NJxE1meUpTSFHmlWQWEwz0+I72Q3rWIeiEolcFk1ng8uDuw
	rY/UYZ06pybedtGe/ooy7R2t4z6ioGeI=
X-Gm-Gg: AZFdTZfnpVynwBSNpJZ3Ffwqoa9uPSpv5wEP1pg9Ed1qAismgt1aNCrsFXx6DGdBYI9
	IssFLCbjvpD30fV5yX9Nm++Atj/v3euNB7qbCsvKPQA2cbr7+jcBps4hSnCIPy7EFr0DldINTfJ
	jCJREV3sKAn8BwO1+QaLTya8tcZZGbgeZHK9NxgMNDiG91pMmNqw1fPCUul63HPFlv6ECXml4ch
	Qclfiul7c7P+GeD0iVznO/qba6j+BuILGVqOyrMOLYdhN1MnXxEEd+uKViCyVecCxg2o0ZzhvZ3
	0RgQ7NEQMVgXrv+dd3ELO9VhUyb3MNYWlmZCVG1LkhMQ5WOCtu+3WJm4ocOkBHPk2PHCyzQJUoy
	qRBpd0WPUDVeDCnTfsXHLBdUPeQbXVJLlBzDDdgYxTFH0gEQZGeEs3TQ=
X-Received: by 2002:a05:6402:320f:b0:6b4:59d0:7294 with SMTP id
 4fb4d7f45d1cf-6ba37e9ec85mr20367582a12.31.1795781096175; Fri, 27 Nov 2026
 04:04:56 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126163114.403846-1-koray.fra@gmail.com> <20261126163114.403846-5-koray.fra@gmail.com>
In-Reply-To: <20261126163114.403846-5-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 13:04:44 +0100
X-Gm-Features: Aa3M54qEfB_iTiJNZjGRc3XRinkgqc1ntuigIkhA7BS94_VSwwZ4uoMmp26Q3TQ
Message-ID: <CAOQ4uxgJjy3TaORBkMOdef-JvzX2uA5K2sbMDEcLqmpkedsESw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	Alexander Aring <alex.aring@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
> modern xflags (FS_XFLAG_*) fileattr API with masks.
>

This is where the commit ends doing what its subject is saying.

> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT to be used in this API
> upgrade.
>
> Following the FS_XFLAG_VERITY example, put FS_XFLAG_ENCRYPT in
> FS_XFLAG_RDONLY_MASK and in FS_XFLAG_COMMON, since it's read-only for
> all filesystems.
>
> Following the FS_XFLAG_CASEFOLD example, put FS_XFLAG_COMPR in
> FS_XFLAG_RDONLY_MASK but not in FS_XFLAG_COMMON, since it's read-write
> for some filesystems and read-only for others, to avoid breaking
> existing filesystems.
>
> Also update vfs fileattr_fill_* helpers to include these two flags as
> well.

All of those non trivial bits deserve a patch of their own.

Not only are they independent vfs changes, but they also have
implications outside
of ntfs which need to be spelled out.

With current patches, I think this change now advertizes COMPR|ENCRYPT
in fxs_xflags for all filesystems that have them set even with the old VER0=
 API.
That may be ok, but it needs to be spelled out.

Do we also allow to set COMPR via VER0 API? Do we want to?
These are questions to be asked on a standalone patch.

Thanks,
Amir.

Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795440928;
	b=JtxgmuiGGoQ1CBaGPC+mIusnYFjygnaad6JnUUzILhOc7ZRu7Qek6l0X39ybCx8MTClg
	 qtmZ2aYH78zxBARbl/06HDoRECuPMaQkZVyrMddx3NCIBjPl99OlI5NOwLArnWy1p8fzA
	 zjt5208YmAKMx4JRbLGEdSWzx9/7EKOp7V6QkDY+xRMjM9nLUSVAFkz2IS+syKtLUZQrT
	 vbA+GRWLEOS4Jm2FPkyrOy+iZbdGYLMMTRza5tX4PFBACtkocrBWh5i+zVZgyPDalk4RN
	 v2Qs/487L2Kj6wR5u4vx8sqGAc9l9t7twanWYWV5TPVamKJixZIabK7VpLcaKdHo8ow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795440928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=wA48BtGM3vO5100Jfaf4088EYVNimRYHtUBWITFpY8A=;
	b=tb6v27rEX0xPLBaICOcpgI9gszu6ARarPstsjKOpXz7Ia+A9DknTfIOxKuHZPdZgi3oH
	 pekkMOd0izlSLbvhZKANTzsHkwSWwdoCzTLjvy/KRe4K0aJtB7r0bhE2WqXh9IKOAJGWQ
	 UcySSnY5YcUKQO/E7tHyodZ8IgBdHoTBiUkjm7dabH9oQq8zSMWp9+COaBAFV9EkW17U3
	 7v4cWPhKDq7cd9v306+eQ4nWt8ZKcGTJsp2zNFIKJDVnUD+6l8q9P8iSiOUm1vIYO6cLQ
	 K2MpkkWKid7owgHt1wPFmcOnma8TadB1BsrNAq9uISfLdwNvBUxwkcllgWZGDeG/aHg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CUalyFmo;
	arc=fail smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6D9606A327
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 13:35:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A6D9606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CUalyFmo
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b88bc47e23so4022181a12.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 05:35:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795440927; cv=none;
        d=google.com; s=arc-20260327;
        b=OkOr8tYFO6h484dAGtdpxdgAuoRH5gxmiRHQoIr8o3z5G78xlavutOCX7Y9GruQj20
         BM4EQd2iQScxp/abUG3Llc8wazcDrzwgX/0c7LE7n98PcTeETHa0bRhDGLKOtC0+echo
         pULEFp0+Qpz6i7fBQYiADXpdwMSzBd2AqimhKKGDO3MaMW3c3rDPw7K0UTOc8kU3pRN4
         HF1M7yvjbIPbI+XcC19L9/BPsEIG1C714SEYwUhrQcXfMXs2QORdvzeI20qIcnNeDVqO
         8atXidNmR3+i83J36CbACAoZhmPFot51/35Bf26z1sRkGAbNV7nkQJ0UM8vWAKpM+Ope
         Sqvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wA48BtGM3vO5100Jfaf4088EYVNimRYHtUBWITFpY8A=;
        fh=ACiaqP+QuG5i9YL/1GYTS/2ElcpEud3KZhjgH45rF3Q=;
        b=SjAAdwYWbMO43ILIx9eCaS4tnUup1gLOsbroD6OrOODTNwd7X9u2wc6L+1GWwwrDD1
         QHZUCxcJ8DRjOFzxT2M4H9HOnekLCrCN5BdbSQv5feEw4LO9HKTNsihIBmrMJOorE1OK
         gMN4FExBGI8EUk6pBIRmaDr04r2dBkEL8bB1k6ZjpemSdQt3OXCK+NRMfC5jtjujQ5hz
         xC94SfoDVIyNJoWuJiYkQSmCWflwQwBtB5I5sA0p85FWcxbZqPJgnDM/e50zlJhFjddw
         suQn5WhPQ+koWAcVvD+Z9TO3YKFoYAoWD3+gDAVNJ7YdmGhdKAWjyrF+aSaAMVdO3quh
         i1cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795440927; x=1796045727; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wA48BtGM3vO5100Jfaf4088EYVNimRYHtUBWITFpY8A=;
        b=CUalyFmoReb/83xqvr2Uap9kVXJPiulZAZ9BuYFqHt3BZvwosq+NJSvwCx7EXaJ61q
         0UImgM/pK6aJnaecMJUvuPZ2cI7g4pQe50qM9Pea8hpjQVdlAcsrhBAjR5pkLoL6krP6
         nRENxUXoYZaxAwVNugh+MZ7YZxx2ccbHZqMsfjTLAWxmMDno9W5bQVXg6ZykzS6zofee
         MuNz4LKoADJSq/Wy8NqZgyRU3Eg71INdz3RDm6YrbcXLD3QD36tPN1Wy8wpv41odHg+C
         B4L+HLWFbiG+tetJRVhqx1bMgUVGiUgvZsZjbnHTLfWPYdIp22KPI7gyBEnpYFSEFiNv
         Y33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795440927; x=1796045727;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wA48BtGM3vO5100Jfaf4088EYVNimRYHtUBWITFpY8A=;
        b=rTqZv9U9FioGZM83BIzIQpYB6N0Gt4+vSGm3wS8oxhPg8CeqlleKAZrvsACRS80cir
         yyA1qfLlJOV3pJ9F9KoIpEbiLg3jGj0Z9LccwvtaBgtcM/KVDsH0Hx1eWd+RGv2pnVfX
         6RQ+uIF7a6cmW2bNDl/SEz8ltIUG/IBbg+pTUfzksNtYmtyVSi9oSphBCusKlg7KUUu9
         fI6JCIhA/tOPfZ368xs1vsl7w2XjZpuHjSYAg2yWTr9TRdGi8c73bcUugwPhVCZ06zxb
         6yO59YvhwSDGIJkiRexy07y5PeDlD65riQ8SAKzytp6iFDwjRUot+Y2owhuRYTmTB90Q
         lRuw==
X-Forwarded-Encrypted: i=1; AL+hErH6i6lGChiazDN54Jp7t+mS44T2AAo7dkUQN7XRrSL374IoBpmnXvaQ42MWADWXNamrjhrycfPU7LN3nA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/7II52x4mh1FzcCV/9AlkUVszB7FMFrHicoykw9H2dOGpOD5L9
	M8cPw7YXiPhzJ507myeraKEImOOrn0QD0wVoxYA401Rf2NwH5r5mpqFMcd/hwM4FOHQw0Hntk7i
	1+Vji9Eb/M7ltSR8287OJJ7wfCyg9TQk=
X-Gm-Gg: AZFdTZd5wps+8txzjrpPNFkq0mm8IdExxDBXbNrewuf/QerKyvOl7ZQXI3cOVsa/h+g
	s3EV/t2+6dtSTLZe8udv9jf58Wu3iz85cVcq3cbgr2XQVRkeYNd2Q/jJ9/fsjAlp/DVfowNvEX/
	jR1KSGtl513/tUlTZatG+2Ss+EM3yps9T7gIJXgo70sL2Botb4RA5qagYtjLUagj17Dogh12FcT
	JteIJkigbOd4JKlc8nR521IJKIanSdzCAfFLE8ZogzMTcdYzFTEzv6h1dDcMyFqdM6JNnK4hRgp
	9G3qYZ9CXHIFeEUKmS7/JGXZcnh8UHs2DYWvpyhLEzt1DhBR3ipqWj1WuDfLXbY5NkkCQJfAV0a
	jVckb+KvtlrYyvXI9sTDWKywd+dR2ZfEQOcopGBUqCMthIXUX6E4JCrtvHs9Nnbbs0OUFuQ==
X-Received: by 2002:a05:6402:1ed4:b0:6ba:7e42:d88b with SMTP id
 4fb4d7f45d1cf-6ba7e42da5dmr4190054a12.12.1795440926543; Mon, 23 Nov 2026
 05:35:26 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com>
In-Reply-To: <20261122000856.536902-1-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 14:35:15 +0100
X-Gm-Features: Aa3M54oltothA2ZyBgLZ2dfkBmCeGTagh_PAD6Wp2_FkqMP-qy6jOW6gmvjqNlE
Message-ID: <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add f*_xflags_{rw,ro}_mask flags to the fileattr API
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

On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> This is a follow up patch series stemmed from [1] and [2], splitting the
> _mask change for the fileattr API into its own separate patch.
>
> The first patch is a preparatory patch so that the code in the patch
> after can be formatted better.
>
> The second patch is the actual implementation, which introduces:
> - fa_xflags_{rw,ro}_mask fields to struct file_attr
> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file_ka=
ttr
>
> These masks have the following semantics:
> - rw_mask:
>   * for filesystems: advertise which xflags they support changing
>   * for userspace: specify which xflags it wants to modify
> - ro_mask:
>   * for filesystems: advertise which xflags they support only reading
>   * for userspace: ignored

Nice!
I think this API description is very clear and coherent

>
> (ro_mask for userspace was also proposed as a "verification mask"[3] but
> I left out that semantic to keep this patch series more contained, and
> can be added later if needed.)

Not so easily added later.
We cannot change the meaning from ignore to verify without any opt-in
later, but we could use the combination of
rw_mask |=3D X
ro_mask |=3D X

to "verify" (set it as long as it is already set)
all we need to do now is make sure that the API returns -EINVAL
for rw_mask & ro_mask on set.

>
> This allows userspace to not have to do a RMW cycle when using the
> file_[gs]etattr() syscalls, avoiding possible race conditions and
> simplifying their usage.
>
> Patch 2/3 also introduces the missing FS_XFLAG_PROJID flag so that
> programs like chattr can leverage the new mask API.
> FS_XFLAG_PROJID is kept out of the legacy FS_XFLAG_MASK and so it's
> defined as part of a new FS_FILE_ATTR_XFLAGS_MASK group of xflags that
> will be used moving forward for any new xflag (like the one proposed in [=
2]).
>
> Patch 3/3 converts fs/ntfs to this new API, to show how it can benefit
> filesystem drivers too.
>
> The series has been tested across NTFS, ext4 (with project quotas), XFS
> (project quotas and extent size hints), and Btrfs.
>

Judging from the number of bugs reported by Sashiko and by my agent
on the COMMON flags change,
I think this needs test coverage for the old APIs, especially with old bina=
ries
chattt/xfs_io that do the get/set cycle and re-built binaries with new head=
ers
both tested against old and new kernel.
Sorry, but the UAPI issues are fragile...

This is one of the changes that would have been very hard to audit without
the LLM agents. Hopefully with the agents it is doable, but need to guide
them how to review/test for regressions.

Thanks,
Amir.

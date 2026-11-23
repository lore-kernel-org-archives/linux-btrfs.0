Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443035;
	b=voYubdH2NYURVLn444Pz5lKLTKbAw4SmfTGqtbm0t1vzgx0IaxTh740Wu5Vupwia1mm9
	 R5ZlCV8egdDXIm1mxxq2pUq+OaUVhSuipnpCCTowf0khO16vSeUBNfGDQfYcw/uQp8ikT
	 BUWRdoM0QMAFdXq+i9y+IGUA+00uxxEu1w5bDnIGhCvW92tyjeQDrU7lrgN5/KJdpapxb
	 LVM7Cwl2MpDgVJ34BKL4mSuS2F3vRicGjt+Rr5l2tsCpfgY53cpJwQ0vgdO3lQn8HoykR
	 osil5L8ZpQmSvxeJKsuwPwkA2P+uJyqfVCUhLW9X48Upr2yCiTh+U//OhaSc4vFeolQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443035;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:X-Mailer:
	 References:In-Reply-To;
	bh=CuMgRbNwzbHcnBEprb4vp2b0/t/8wHp/89cdVf+1khg=;
	b=i54gnVeWCaQvSimJHufAruL/w4p34AK+UcZoQbQ6zg+xFQzfZ5Im/pfAomq1Hma43b9M
	 jAsVSnUIo1kUehpM/eMk4fzvORmEsM6U/686wUDqLxy2fvD3vO4zDSNeO7WCtSfGJ7xvO
	 DSsDW/V84W8MHIIXS7s0t0wz4czcvWNkgVMO5AMOP++7ZBJXUyeLEkIwLfclTF3y4zgK0
	 EzqINVjcWq9onYMDsF20U/PdWLxG1VPF27qKciIaUW/geDXxR3TiA9WPOlmrLV811Fq5Q
	 FjQRgr3mKZe9A7/zhct3bxc6BSzBBqtw8wFJSUdBenh+EeoF5P/jLkSjE41HPtb2aVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pO+zyumf;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D9E606A32A
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 14:10:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11D9E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pO+zyumf
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb77a462c6so32793945e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 06:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443033; x=1796047833; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CuMgRbNwzbHcnBEprb4vp2b0/t/8wHp/89cdVf+1khg=;
        b=pO+zyumfN2hTCRi3iq5NLc4z3g1haVYIkxKoEw23KhrnoeCnmxoW4xCWvhExvnIJt/
         4gbKTdRC2pDBC5Hp1QDu+A0sp15J8QbF1uz26Txh9nn6GACU+5b0eGJf77ZBrYD4ljq+
         VVV3TAosIjsC5zJn8eKmTnnWhVsW6mimroaCxKkcPnOjrIMaRqjQxmZWMMEEHiUMLpCa
         5p6UsfMRL3fW14IdkB9Z+Y3d2oWg/54ukp4uCq+iKOIANK3taEUvY5lWq/haJ8zprVcU
         w6wYX1Nw8spA/Ix8oPfGxJSdQ1mRWnJ2ch5ULR24WELgRzxBIqSkStDAjP/XrMzlFrUI
         DGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443033; x=1796047833;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CuMgRbNwzbHcnBEprb4vp2b0/t/8wHp/89cdVf+1khg=;
        b=f8YpVmWuhCNoX7vbFpeVXkg1bs+A5Qt9xtq5uMasLN3SLhrfV3Ld7PflWel78KhxMh
         1K3KzxSWdWZxy0DLx2XAKyQe22LqJZMG0KQvraCwGToBvTNJoEtU+0123R/4eiwlnCAC
         IaU/D1bP5//Yp9w/atCsMCn4CDYR77Uswm+G43rHN+w7v5j/+ZWt38xJvbKbQaaKTVjc
         GeQJP3j5gFPBgNQ7kCaI8KIdK8WJoYKPWfrnMekmIS0XaF5RqRktSeaAhZ1y18uzSAZS
         vGVflIiV8XbuWq+qMb8hJi0P/Cl2MmiCFHTufGtv7ga+PQQR3MzUKgsaZdg9g3vWN4Fd
         PlIg==
X-Forwarded-Encrypted: i=1; AL+hErG+JM6vGS0saWopZTvsDzHcPLZ/9tPWPSxvyPufmG1HLmZndtRFoEHms7aZ27xY49u6LX7mcdC7NoTgwA==@vger.kernel.org
X-Gm-Message-State: APuU4Z8od2/D44NAXKhzznpQk0SkWnMU4ok2x7WgQKWShsjjgqUW1CFb
	TGNTTqV6O9tFK/KaYrJ/OUn1Wf7FZiiAvIqeIwGQXEMsTxzN6UjbtYmW
X-Gm-Gg: AZFdTZcPwo8rFJL7Ge0howTvxINpoaDEKa0tZTt4CLjU62OpXiQp8nUtT1Bdsz22LMA
	EHODrkeCpua3SM6P/HFnMMQm62oERjyWM51jqr9fsFboMhCv8G/KbjmNbFcx1H+BVO0BBeJFj5+
	dpgi3irOW62+1ZmlVKF9Lr4gV5l4XSSus2SnNSQAi4FyUwqDybgmNdU07KAId3Ck4Puviz0jSvj
	bEOoFsEIgmyJOqy1xWDz2X7tRJFsL9+q5sJrinmwPkzb+sS6qtG6bGIJ+E9/wpQERdK2E0/bafE
	O3mhEW/cbX2XqlGJ8v0hhz+XYYsop/5IuX5UT5yDsx3BXDb+QqN9XluX/QHDqkg9qkJjyshPyfp
	sXDW/j18iub/Vziy2mUslome+iEKpC/wBSy8Psk9qUIKWdbLiZPY/brp5ZjVhOUMxYf4yomNh1m
	qc5L8+I4RcVMdLM949ULxj8CdTXkPuYjgh113W3i7AgTylBk0UIbkWqVrpwB8hVOMOSNq3bKWKO
	pxiFdzlo3BRqfM5xxyXG0ZBXB89tAGIDkIkeYoolLNMxKZobu2c1O/3XcS8+Nc6+Re15+Yzc8CZ
	jgX7Ekark/GCOdJrly0BdY0dMQU=
X-Received: by 2002:a05:600c:828e:b0:4a2:526b:d40f with SMTP id 5b1f17b1804b1-4bb88785898mr250028695e9.0.1795443033146;
        Mon, 23 Nov 2026 06:10:33 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906817ccsm170559065e9.5.2026.11.23.06.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 06:10:32 -0800 (PST)
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
 boundary=b1a345f2b4a5254b3632da7c1e235601a7730bbbbe126372d6b8eae348d4;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 15:10:28 +0100
Message-Id: <DN2NFOEO4XGN.1PEF1SWOF7YCQ@gmail.com>
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
From: "koraynilay" <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>

--b1a345f2b4a5254b3632da7c1e235601a7730bbbbe126372d6b8eae348d4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 2:35 PM CET, Amir Goldstein wrote:
> On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> This is a follow up patch series stemmed from [1] and [2], splitting the
>> _mask change for the fileattr API into its own separate patch.
>>
>> The first patch is a preparatory patch so that the code in the patch
>> after can be formatted better.
>>
>> The second patch is the actual implementation, which introduces:
>> - fa_xflags_{rw,ro}_mask fields to struct file_attr
>> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file_k=
attr
>>
>> These masks have the following semantics:
>> - rw_mask:
>>   * for filesystems: advertise which xflags they support changing
>>   * for userspace: specify which xflags it wants to modify
>> - ro_mask:
>>   * for filesystems: advertise which xflags they support only reading
>>   * for userspace: ignored
>
> Nice!
> I think this API description is very clear and coherent

Nice.

>
>>
>> (ro_mask for userspace was also proposed as a "verification mask"[3] but
>> I left out that semantic to keep this patch series more contained, and
>> can be added later if needed.)
>
> Not so easily added later.
> We cannot change the meaning from ignore to verify without any opt-in
> later, but we could use the combination of
> rw_mask |=3D X
> ro_mask |=3D X
>
> to "verify" (set it as long as it is already set)

Isn't this just "preserving"?

> all we need to do now is make sure that the API returns -EINVAL
> for rw_mask & ro_mask on set.

Yes, the current (v2) code does

if (fa->has_masks && (rw_user_mask & ~old_ma->fsx_xflags_rw_mask))
	return -EOPNOTSUPP;

at the start of set_prepare(), I think that is enough, since we assume
the filesystems return the masks such that rw_mask & ro_mask =3D=3D 0.

>>
>> This allows userspace to not have to do a RMW cycle when using the
>> file_[gs]etattr() syscalls, avoiding possible race conditions and
>> simplifying their usage.
>>
>> Patch 2/3 also introduces the missing FS_XFLAG_PROJID flag so that
>> programs like chattr can leverage the new mask API.
>> FS_XFLAG_PROJID is kept out of the legacy FS_XFLAG_MASK and so it's
>> defined as part of a new FS_FILE_ATTR_XFLAGS_MASK group of xflags that
>> will be used moving forward for any new xflag (like the one proposed in =
[2]).
>>
>> Patch 3/3 converts fs/ntfs to this new API, to show how it can benefit
>> filesystem drivers too.
>>
>> The series has been tested across NTFS, ext4 (with project quotas), XFS
>> (project quotas and extent size hints), and Btrfs.
>>
>
> Judging from the number of bugs reported by Sashiko and by my agent
> on the COMMON flags change,
> I think this needs test coverage for the old APIs, especially with old bi=
naries
> chattt/xfs_io that do the get/set cycle and re-built binaries with new he=
aders
> both tested against old and new kernel.
> Sorry, but the UAPI issues are fragile...

Yeah, I thought about adding some tests to xfstests yesteday after I
made my agent test the sashiko issues in my test vm, but I don't want to
make it generate them and submit them with minimal oversight.

It could still be worth to make it generate them to just test locally,
then clean them up and submit them after the vfs design/code is
finalized.

> This is one of the changes that would have been very hard to audit withou=
t
> the LLM agents. Hopefully with the agents it is doable, but need to guide
> them how to review/test for regressions.

Yeah, the amount of edge cases it catches in my code is very high, I
manually wrote the main vfs code in this patch series, but I took at
least the same amount of time to fix *some* (considering the amount
sashiko still reported anyway) of the bugs the robot pointed out.

Thanks,
koraynilay

> Thanks,
> Amir.

--b1a345f2b4a5254b3632da7c1e235601a7730bbbbe126372d6b8eae348d4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawRJVAAKCRDmj22qf5IG
XPMqAQDKSRELLXXkJM1eWJs/2jAv9K7PNaXrJgEdc9WUuhVlqwEA+UC/ffcMo2z2
JMu/9eWe5JddaVS+uSeZePo0JhjpBAg=
=ToHp
-----END PGP SIGNATURE-----

--b1a345f2b4a5254b3632da7c1e235601a7730bbbbe126372d6b8eae348d4--

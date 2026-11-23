Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795474038;
	b=rEzAmHVKlvQZmcMP+599gH73oRzK1j7ldFaRecP/bLj/IEqMlz68zfJmqkK5PJi0V+Gh
	 b149UFDmBTiwE/ZHVGINimmRxUUfdisZ/pa2deFrZH7mLho/pGqKGpTcJKKzlqVjPd/Jx
	 ck4Jnng4rJtktU2S2VTJ8T5UYpurMk0CtUrrCKgZS9tY87v+Fngm7X8rMeM3zto2C7tRt
	 BQ3j8IvQDLLHC5D5pGaG9UOo66T4TxqTXs7Cqx6jX0Mc2X1BjgWqxVwqcR4uvS97XD7WZ
	 unEiJF+yjWifMI+sPGdHx7SvuXRhWQdNzdg8C1gweyWP62q+Tfz3XlwURxveJAqYlJw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795474038;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
	b=tMe+f6jb/Ekm4pvVSLiWNYlWPBQfE4vbOTuMIwcA6iP+0avIlaShhYxJ9PgXcooavq5n
	 uAGUa6Yirz0k3hUhGmBi28wQMnplxcN6w+13i/cA536EPzBH6qlbpiKtbU63S3w+JjEYV
	 XIRGd3otW7RJu6rbCJJadkuU1BzyywtifGytIqm5ZslDFBeAQYV6E7Ugd4O0IPOeBxpUF
	 jgLEMIMRUGkE15KbUZjfv8fhxFbt0BCffGVMWPlgfzMV31yKAvzZy1jaBSADH+YSPlBIQ
	 AVty1akMViDN2i5QQKUno3CMVVP0GzuCaJZKE0daTwPYMdzATug2/POD5FriL00Vfng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e9TlTdXc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080B4606A32C
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 22:47:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 080B4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e9TlTdXc
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b87a240de3so4727303a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 14:47:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795474036; cv=none;
        d=google.com; s=arc-20260327;
        b=Soa6CvzBnj/wGdigLtLnWbtOLHh1PsXSXkvvRIluMia8l3Y0+xINTw60VbqLVPc7/E
         EqhMvr/DAVLozksUg1cK+zyQC4Dh1fIqDFV13vhVIU3kDUbd1/mCybHO7T8TaUKNI3kt
         f7jLU+QsWLrjppEU7eFWnAkame+y3CYDVY7Dm7DVJfL+nzYnLlsch8N+BRWHWPRF16aQ
         7IxqdQ2+9ezP5W67bSzr5sea32Mth7LZii1kDJdiOqWrYUr06yuTBXuf0pMrhIWSGveD
         raYsZyxYyE5SrbFgWQKSTj6Cho4pBbTJlCNBcNebAzbUwaFkNpkbekX6xkbkpSNBkWF/
         hLWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
        fh=RsqMNTOfsPejOUgR+DlS91jfu19/h8jNirNzolXCjCU=;
        b=j4Mj5WjU9QvUkHhKw8+74aniuA3VgjglFPTph+ciwZ4Aft+ujMs3Fl9SslWNd8j+qj
         5QvciBch0wK3c/tvVTJNOvakI9Z6v/BQEqt24kBsUx7tNuvhAhA8xWc23RsbQOTSntDt
         juqfK8+VUJWGvilIzw/5PsAVgOfUZNKKO+MnM74v6U45pN0vSbLw6ZMrfaVjq7aYHhk9
         Vn/O5v/rLB7OTCpr4EqFGISbjrAM9It5xmTpF1uqpUdzipwHMno5O8mmzHulcupCgVHu
         1qpCLCQmWtLyfxS93rE+Ypzz5ZpCskvJw8xlOlgwSvMupJLHSu2MzFvhLEhjx6h0biIz
         PHRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795474036; x=1796078836; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
        b=e9TlTdXc+gatXcuCFKKb7aj/RyvKZZs3Fc22DsvCbrqYMGGtwci3FfIjibOfYQ/CZW
         9N8fj6eIrKNnVRdbxmnkFIx1GgLKrWEmFGL9vOQOEa0GR8Bc8q6jIgpflc/R1WmaKkIq
         a1L/XNzQgQR2OfVdP5ZWakzu06AC21i4FBAOG3jwYP8Lhy9AUkzJO9T8iBSrC7rM4aSU
         +QCy52SpD8tCCzGsrVoCDffQdo0iiSxV39ldqNaCG7VxnqiWEDVWhmyRn5+Uk0DxMQhg
         +jgf5l52Pyk6Ega5GmFX/ULCv5YHSq3eiAljutksNIdRm4c/i9EcMfRht5xGucVDbs5/
         qj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795474036; x=1796078836;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
        b=AO/Lm1ImDVvcamnAo9YEnXjCPeHS3MvXsz/1cYZcd2yk1+07u5ghXgYGQdbuBroO+K
         ukyH/ifbeWn7wcmyCAAlWrJj5QdCLWmwbRb4B2KlKpzI3fG+hgSSQ8p7RTE8XBL3JugJ
         QjHu1VXIwCQx6GouY7TsAGKu8843JKpDrrUi6Wja6/354kAfMZZN7pqjFnaVUTgnw1YA
         KCbj/L8gW48rcjdS2sozY484cvHWMJrViwRwV0Ux89UtwxUpCnCkjApO0/pso5lsJMPW
         Zzftp5KoEkCimQmaAOaIWw27AYspMWrWbKwap4EOaKgYr93/Zfut3nI99P9dkEwK3xJm
         RI8w==
X-Forwarded-Encrypted: i=1; AL+hErGW5wdHJR6thLQbaChv8WQS+ys5CWv5t6T59tHbxvZAb4fxSOvzaqorb7fEvDbnj+5ZON6fHeJy93ztCg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/rrrGP6yhUR/aayfXc6hovWN7eSOUjyDM2Q5GHiTDLiIYUk7Q9
	U+trgfrVtdXcifXZ7DzwpqeMliM5JFv/KP51chG1ZofrFX/VcXRm/dkTdFUi9zGqvjiv6gZZpmR
	uIzcplFdXe+P4DyZI0SZ4IbQ68+hXkGc=
X-Gm-Gg: AZFdTZfzqv2UfT+vKo7UDcG3udrMKBTT77LOk26Bnz3xgO5wyyN5GltRuhVfJog5pxE
	h/UA4ai11te/e2XZ2i2oCSOyYUhv5hQnNFZLqZa3ugZ9RmRV6XtSH1Gtc/0GSlYoKuvqJdv8zyb
	PUncExlh0YP0FjCX+TkeVvg1E9xnnYK8AIQ1krCFOOesPF2Pq8BHKJaoMFJEII0QWiPf6R1WxHs
	zCwNLYfN3wjQACqF4KmGhy2bCk/YzyqdApDZMAcEjngS21U6ce5mvmtWOYre6LPEr4Uwz1Onl2l
	hDl9l/AkERBVqSBuWfqO3iVvXcL5i2vtzv9T8Yz81r59cRlsQMGxh5fVlkddpGQXt5E0KJl0hnq
	ZS0jLWXWp9SNKgYOIYqJtsUnqIsMWiKAXBVwfFcR+jBe2Lp0r6USYu3JVtYxJBxnVAOb9TA==
X-Received: by 2002:aa7:c710:0:b0:6b8:e848:d004 with SMTP id
 4fb4d7f45d1cf-6ba37e8dec5mr6855932a12.29.1795474036043; Mon, 23 Nov 2026
 14:47:16 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>
 <DN2X3RC5JUFQ.2LNGLQOUX4ZPF@gmail.com>
In-Reply-To: <DN2X3RC5JUFQ.2LNGLQOUX4ZPF@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 23:47:04 +0100
X-Gm-Features: Aa3M54pZr_aGN97hdgjJEJclpmHDWTbmXWMujrk4s8rCr1BMot2r_DEgpbuT4T0
Message-ID: <CAOQ4uxhsv_1EEqAZ3Ebp5Uy8Q6nvEnE3EAomJjjQO86nTcW0cg@mail.gmail.com>
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

On Mon, Nov 23, 2026 at 10:45=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Mon Nov 23, 2026 at 2:35 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> This is a follow up patch series stemmed from [1] and [2], splitting t=
he
> >> _mask change for the fileattr API into its own separate patch.
> >>
> >> The first patch is a preparatory patch so that the code in the patch
> >> after can be formatted better.
> >>
> >> The second patch is the actual implementation, which introduces:
> >> - fa_xflags_{rw,ro}_mask fields to struct file_attr
> >> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file=
_kattr
> >>
> >> These masks have the following semantics:
> >> - rw_mask:
> >>   * for filesystems: advertise which xflags they support changing
> >>   * for userspace: specify which xflags it wants to modify
> >> - ro_mask:
> >>   * for filesystems: advertise which xflags they support only reading
> >>   * for userspace: ignored
> >
> > Nice!
> > I think this API description is very clear and coherent
>
> By the way, should I use this description in the commit message (and

You could use that as a short TLDR intro

> integrate it with missing information before/after the bullet points),
> or should I keep the current one?
>
> (current one:)
> > This lets filesystems advertise their support for specific xflags, like
> > statx.stx_attributes_mask does, and userspace can specify only which
> > xflags it wants to change without needing a RMW cycle:
> > - on GET: each filesystem that wants to support this new API fills the
> >   masks according to its supported and read-only xflags, then:
> >   * for boolean xflags: it fills fsx_xflags with the current on-disk va=
lue
> >   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
> >     xflag value in the struct field;
> > - on SET: userspace fills the rw_mask with the bits of the xflags it
> >   wants to change, then:
> >   * for boolean xflags: it provides the xflag value as a bit in fa_xfla=
gs
> >   * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
> >     provides the value in the struct field; if the xflag bit is set to =
0
> >     instead, this informs the kernel to unset/clear that value.

You can keep it also but tbh UAPI documentation is more useful in
comments and in Documentation than in commit messages.

Thanks,
Amir.

Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F513B3C19
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 05:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785217491; cv=pass; b=Hu32ytfIjH54YWCPxywGZRu9jHPOz0RnvPIrNnJf94ph9aFEVPHxdjG3dVecsbWHsheuIPUSw3Ey+Qn3rOxButKLG4JbPzMiTkiEyvCsKFhbjtwCUyJD7EbyFgnQVD39Ahn4w0Tsy+JYh3ld5nDnNP6VsrWU3nogwnJk/htxhOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785217491; c=relaxed/simple;
	bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CioXhClISyEelhB9BMOhMoDr/cHaEnVqI2MAqMlhGUsXaIRVZSrLFsKSC3X0KWwfdGF5XRgIxTJ3ygZM02h9n3lyuBLdSvnimSPEKKiqm3K56Ny1BgfUYmrURlVzfpHuR4CV4UoiSj5Bo6PUvs+mlOQIc5wvgP7L1lGfQPoj4sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fBjaNva3; arc=pass smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fBjaNva3"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49557167508so32614135e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 22:44:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785217488; cv=none;
        d=google.com; s=arc-20260327;
        b=aUATgAcGXYeUORlYVRtb1g/f+u6YfpgUgXZ5DlV0ayPRWLkxOD0RAxve8wrq47UJ5F
         nuf4xrYHcIWLyF5TeZ4UHtIZe5Ak0rzPNAZ4PgbrLm6CX+tuqMkmE2HqERAfIx2P9vBa
         /p0878LlT2YuQaDNDnN/s3fIX/QxSpOh8dfptyV0lIo000eUDTcDRMPlUbWm/EzsNtbP
         iL/ftArAu8J/LbTEXY8DbRXxeeFG1j3UaeSPqrH7vyZxJcDRzaT1F7c6QLmNP8yvfUOp
         IFBJ9Bs3wj9Tu5sbKQiZZuMIXftIPG6mmxMcslpHnPFzw07rpqjEsUlrBXT6qinjHsii
         M+PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
        fh=4yYSofb/eTQ/GfgZ06O0upUPb16VD28ptrkoVGAI2QQ=;
        b=UdO2hvoENP5nBpwWTtXw0GXNIheSTEsjDMkwgNu1mgrSN3GKqnm72v9cf7oFOej08P
         9MXdx3s/QEqev6UmDkU/zURBrOVUYzkmEnJOS1ncOQTR5xxwgWysfRlhT04HnCrMqPWh
         KWLn58AUDXqFGC/DR82MsK1ZVyLV8UurTvjFH7+77+gLUI9xn35gAOMFv/OtsTOW7PH+
         w9szE9espNv6qlpdH+EkLv9Wm8wKESnWh9PZ0Rv1AKhSMU5eEXe7zo4n6eVyauOW3vnT
         LzcLFWfcrCZPgCVE4tr4ZaGAqiAXXLg4QJzmVZClS+ACMlxgbMAP83fC10EILtS8b52v
         ZfCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785217488; x=1785822288; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
        b=fBjaNva39tUoIh3WdRtYTNHX6lXws0r73HuX15d2GPSulNVAVJug2chPtRkCxBctrT
         77fgXWVjRq4svwy/4Iy/mHq2Mf7BuTmIUSZgxS+pqU2tddt6Cz1jc+ba+k++HVdERP2u
         YTlyXEcjikO/XsTWJ+Ib7KoTgYlhV9JyoykvLCA+vLYLlDNa66LY8AA6t63oh39o+Lrm
         wDW/eKsE/q4VyshhT2rSJtcOjGvHaxZDnMcjzV0nygT/7ef6EezQbO67EtJgUo6U/DEU
         l2XoUeUA9dAonr3rbYVmbYUzoHKkN9KcrZ6/3wHbCjbDETMdv9MpHyAbC8TRmJQ3hoe9
         bWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785217488; x=1785822288;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
        b=l7eObMOjkJf8lCDcm7Bt+MOKYav8LVmlQldLN9lYGb0X1+x+7I56/lJVFfXskXpBB6
         KQswiVHsQITPbaf5Fqw7ShZTeqZGcRgF9TA3jAnysuvLI+V/vwMsqkXAE0TWU2x4t8gb
         JEr59TAaDxnD+CSAa3QH76a4thuIQ3AUxfpdSaeKncD0luL7P+bWWAgmd2AKMxycGxYF
         +TeNQrEMqnie8ytrOiAF65hSz7NaVJmBi2HyXGKe5HiL8toE144iOZ/YqvcJw9kNml5L
         LjRbT3t9s07BlgmY86NRq+NXVz2At2VDG+7cyRBZCBrG/LQlm9t/puCWsDVfZdOUgqIw
         wNPg==
X-Forwarded-Encrypted: i=1; AHgh+Rrac6aoxvZMG3wyugroIui4uHBhJUTbFwpyLYlJyA+/wi6Nu5oH59j8tC9agsAaPhQsx4vnNCTR70r2Vw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfJnSvQik1NcG/5RrWpQapSTSzCEIUVyrgMZOIWgSbEmwr0BiX
	r5Hz4TyGGR4hdmnNgYPOmwH4K2nhpfR6T4zWySFlyeL8SGPQDTGDYOUTrzyq77fu1LuVzZCPWfX
	Lz8Z3f23te1hfyK66hv1NWFVHFVUxuS7UF5U3o0REFA==
X-Gm-Gg: AR+sD13ixmzWVFcFxIcudfn3q0hA7hJHvt+BIoUVA86PngmCThtT62dgRU2se1WVNHc
	VJgxc2f+0sHbtr88uRY9toa3xJYxXW/4jjUPj/FcVohtYzIcFB37pIgpeBMBg7CVQuD3pFPoGdo
	KeUXshsdx2tPs/01xxiX6bPDKagyMXkaNSr+r2nWvDftuXyu+pTHimZPBhQbrfZK27qmKGPCcZW
	HfVlw6vnIQIF/Afz4AOWeRdR1VRQREG72AX+Rv4iudJ2ivm3KBkggPnwZhFuLIAVuIX4X2xL3/8
	5ENXEBA8xLQh3lw6ZXMVH+mw4V9So3OQwSCAwCHlojqHp3pHbP3a3IDlV+0=
X-Received: by 2002:a05:600c:a012:b0:496:c18c:f9a2 with SMTP id
 5b1f17b1804b1-496c6586ad0mr8148725e9.34.1785217488357; Mon, 27 Jul 2026
 22:44:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724133328.1837318-1-neelx@suse.com> <amgfuk12imPN2XJe@infradead.org>
In-Reply-To: <amgfuk12imPN2XJe@infradead.org>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 28 Jul 2026 07:44:37 +0200
X-Gm-Features: AUfX_mweqQ4DC10RBxGq9-w14Z5dbzAU5cW-2aUZfLxC0EG3IWa7sp-qvz-yJvY
Message-ID: <CAPjX3Fd1KPswrsNe=BeDpkDwi8CmL9HNKcPScMsgGN16MDyVEQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] fstests: introduce fscrypt support for btrfs
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, djwong@kernel.org, 
	David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Jul 2026 at 05:19, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jul 24, 2026 at 03:33:16PM +0200, Daniel Vacek wrote:
> > This is a rebase and cleanup of older patches [0] from Sweet Tea and Josef
> > fixed to work with the recent kernel and btrfs-progs changes.
>
> I'm not sure if you post this just for reference or what the intent here
> is, especially with a cover letter like this that doesn't have much
> information.
>
> Before we doing anything for the btrfs-specific fscrypt changes in
> xfstests, those changes should be accepted upstream first.
>
> Maybe some thing like splitting tests might make sense without that,
> but then it should be posted separately.

Hi Christoph. Thanks for looking into this.

Yeah, I could have been more verbose, perhaps also using an RFC tag. I
wanted to get feedback and a review from a wider audience to see if
this is a viable direction. This is currently the base for my btrfs
fscrypt development testing.
Especially for upstream fscrypt changes, when sending those patches I
was asked about tests support. I understand to keep fstests OOT as
long as the kernel part is in development. But at the same time I'd
like to make fstests complement the kernel part and ensure they are
ready and available for everyone throughout the process. Kinda to
"bundle" them all the next iteration.

Would you suggest otherwise?

--nX

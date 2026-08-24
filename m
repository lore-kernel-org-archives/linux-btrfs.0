Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB4938423B
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 19:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787599998; cv=pass; b=T6Hry5HpJ6J29w43JYYj5deK0xHf/OCl2GLRJbHlORH3HwvBhdLbFQauXvq9a6YQaPLFBgMdUUwy0C24e4FPald46KnD05Ukn994zuN+JX4R2NgnBDLvY3rXbr7IVsJ8Kqzdr7bXsj5Q5DT50KDw1YEpXG/Jn1vqQ1KsqvJxRfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787599998; c=relaxed/simple;
	bh=6nzgFXxKsg+JnpSIQP0/wxVzDkLsa2CzNa+jLf/mGAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EgkWmaYUnLs2EOjdDogpXXgXYXehYBI1w7wX2BOX9J7qe1MmQbawJKb2ZVxusD1O+7oyVC6p4Ls0/pdbLHYzqmfY/WbYQWRJFmFrk3c7+u5TyTl5HvW3P+ScNuTrbwp65Y/NnIjx4s0oMQWI0V60m1ZE0z/YI9LKUq1yC62z+8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=rWbvmCWm; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="rWbvmCWm"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-52cd38ddcdfso22513741cf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 12:33:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787599996; cv=none;
        d=google.com; s=arc-20260327;
        b=Efoe3AVtWRIaPyK5GrRAlGFuf7hIRs/Vyhdh/5s8QAoPg7wBU4DBm3GaRYNFUkxn1G
         2G/uXuNpeSpaCni8gQavH/r15zn1QvDzfZ6oHItOPKb0TExTAiXJcGelVKG1CosyShd4
         QQ4SNvR1pKZYJUy4TmUgFNnWA5UhCKGjcWLqS485Ea743vuadTPkRdP5b8urBr5781Yx
         OJSy0B/aaQUAHyylCmHYCL3SDDCKhKuxe0tO65bD3UIzyAGVpQBrQ5lEc7ScLYzxfrE+
         1nrV29Jj2KESxseZqBvvSRLv4VC2Bi7EYMC9kgVEFrs3zU2D8Qe+INSZssD8jGtt8x1q
         8Ebg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DK1kq+UORspwzlcL44O0F5OA7o6ZQNGRnMf+1R0tFOc=;
        fh=L3JNJ2cPrKbYXp0dKpaUHMOuxF3GmtP/VrtEZQH0zzw=;
        b=IU9JEb0RqNToKOZMUzXM7QCkPpMHwYnMXeSpZOpwyNLBoNfbIKtLkL0xd/3O06fn5Y
         v2TLm8QGJ7YKdiPSxsyexPgY6jprtf/lV8/xCJgI1NXQ/lPzJq/4+PnL/0TIjZ9ybUIb
         iJhRnHxBUtsO9WYozfyUJa5AMMOCA6ZufiVAdZQmpyemkHfw/A2dYX/Y46546dTySDjx
         x9oZa516I3Ql6zr74c3VB75sBt14jCKEydGhVaA6oXDwjyOZWl/E1nrwrJW00D0WfcxH
         Czz2P8N5ciFkJKVoV0wz8D386SuBSsqgfQiJJJH0MHJYSl7PQ3lwLpvRNi3f1VWOFsIq
         uNpA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787599996; x=1788204796; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DK1kq+UORspwzlcL44O0F5OA7o6ZQNGRnMf+1R0tFOc=;
        b=rWbvmCWmjcCMV6cmRGcdr3+XqqhuMWDGjRX1T5jRxsvlEvHcuEqtIU8Ara72ZK/KBC
         Fo3btCJeMyC+8K71XbO+ycgkyzflH+/WAU7RjJ+jWdNq4ZIUVDtoY46nzEbAYFajZokv
         WbFxgJPYPnzHMK5AKBCgIKfsa0iEZf2co5VII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787599996; x=1788204796;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DK1kq+UORspwzlcL44O0F5OA7o6ZQNGRnMf+1R0tFOc=;
        b=B7I7Dx3kM98aI7gIogJefBsd36Ni5Lim/Ylfv8tE3eUiqy4PTpmzlaCIxrV8JLYnty
         PWQ0J77xmyJVyeRv16F2AUfR4bb4popdBgswfi/rxtb/hg/FNzaSzKTGI1D7E6mK9NLA
         FjXsKam+MHZEQ7geR/InTR0NUKobxgzIjNchPVAxtb32qSzUDyxdniFKrr/Gr1LbFCGw
         a0+ysxrA89UpBJAVK4cvQ+KGMxuCZ9uLvYOo5o5pZVbp3N67w6UJb4vt6AY72kDf6ZHO
         fCbQeroccM9CTiG5Qq4DgzPc4P0LBG5YHZPCOMi9TkTETUx/QiMjycrD1mHELoY7eQMn
         vFnA==
X-Forwarded-Encrypted: i=1; AHgh+RpYB6h0BqrwhcDpZln3QNqDZumGtPSrORhDMz8FcG8pE5l8mCnFWB/osbnaPYm+Ca4tOV9m9S4gsEjyNg==@vger.kernel.org
X-Gm-Message-State: AFuF++mn4qabQWnfgGnwOQDIvSj3tiQObVv+sZyUvwJzKR5LoBhoXCmU
	aFqoyn8JkwYdGPrgGc00A0wkijpBp05y0Y89+oF7cZXc3SApiew2KeGUR7PGWWLaSkfSrHVh0Ab
	Tja1mAVw2NyIer0jrp+hQMPegjvV2bShtcZW0SNybxm4D9womDS3WOSY=
X-Gm-Gg: AR+sD12Tcs6KTiQfEJVPySz60oH4YFhSNMhoxAZRjLATuvle/i67N0tYnhymXlBXWeV
	RabXr8b7STo6KQ7xnPutU8nnLXmEmUlVniTiymt+dCfsly2Ovf9tHhWe+2RXOPKrK7u1m5zvpZJ
	4pchQUHf5qQcq6O4bTssROhb8OrubAqmpCOnnxpvL6h3T5hFSY31cl31iHbjlei+gc5fs8Utm+i
	zHJ1H2OI3WKziSnxqAJ0ed+bsSWd3CUHJzha7BZ6jDd2YIIMqZx9Kd0MgEMGkA7atyvjxCxDQuO
	XPC8MOoJrzan6VlPxS1lsHlWv3S0s1vctCifRUhUKybdMpFCMqy4x23fNXolAtfPDJMK0GSORTy
	CXqI=
X-Received: by 2002:a05:622a:411b:b0:517:78c7:d93a with SMTP id
 d75a77b69052e-52df57324bamr286714031cf.16.1787599995881; Mon, 24 Aug 2026
 12:33:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820193343.3852967-1-willy@infradead.org> <20260820193343.3852967-3-willy@infradead.org>
 <CAJfpegvP3i8ZJc2T=+f4rAhZ4E1QcT5+jC6mQPLxtB-yoK9Brw@mail.gmail.com>
 <aoxHOSC9kTPbKeNq@casper.infradead.org> <CAJfpegv3Ak+qNLb=fTSCSz7-taQ3Ui-Hkmqgn4PaGPe=CR4cbQ@mail.gmail.com>
 <aoyKxvdQdeJQfPHj@casper.infradead.org>
In-Reply-To: <aoyKxvdQdeJQfPHj@casper.infradead.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Aug 2026 21:33:03 +0200
X-Gm-Features: AcwNN1WHKWPg-gulrL_ybc1YuKIIGquGv3tDzpc2zs94XwMFk4U-dS3q1iLbtfs
Message-ID: <CAJfpegtgenUaudDcvecJuV2_WkkVw=gdcB0Eqg=UFKPMZP1uKQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] fuse: Use filemap_invalidate_pages()
To: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Aug 2026 at 20:17, Matthew Wilcox <willy@infradead.org> wrote:

> Before:
>
> fuse_open()
>         invalidate_inode_pages2()
>                 folio_lock()
>                 folio_unmap_invalidate()
>                         folio_launder()
>                 folio_unlock()
>
> After:
>
> fuse_open()
>         filemap_invalidate_pages()
>                 filemap_write_and_wait_range()
>                 invalidate_inode_pages2_range()
>                         folio_lock()
>                         folio_unmap_invalidate()
>                                 folio_test_dirty()
>                         folio_unlock()
>
> so what's the serialisation that the filesystem can perform in the first
> case that it can't perform in the second case?

In the second case filemap_write_and_wait_range() won't write protect
or unmap the page, so it may become dirty after the writeback.

That can't happen in the first case, since the page is written and
unmapped while under page lock.

> or alternatively, what's the serialisation that would be useful by
> adding a lock/unlock of the invalidate_lock inside
> filemap_invalidate_pages()?

Nothing.

What would prevent this if we'd have writeback + unmap + writeback.

Thanks,
Miklos

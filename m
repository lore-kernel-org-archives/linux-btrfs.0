Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C84E3F0749
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 09:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787562361; cv=pass; b=oF81ctK7NHGkrAdNRVmtMAykC7rh9w6VtlxmW9p7KtqJBTz3oDJgYsMwiOZRkySyYmyXHyl+3V80Pmzc90MJY3g5FdSJ0V+mh0FXJj61Af/XeS/oO66G6/1W90XKUf47k0hvcmwOuXLdm5PaS+/Yn4sV1H/s8wDFE5GYJymWj6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787562361; c=relaxed/simple;
	bh=k1VcahloVqTMd2bS2EdontwtzK2WJK0zze95i6TSOFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oyMY+YdgcRbCz2I/YjcIfgCzkaeWZTEVYAlQCACFnsmMTLUILIs3juiJA+Rf/UsEdhkXtx5x5B04hR2yDSAQVcUOOSO0BvBiIRRaotc8kh6mA0oIHxtgF4E0hlenYLE1o8JfQt5oa7F5WtxhmZ9lCgfm2OwthRzthHR0KjNjbrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Md3V02RB; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Md3V02RB"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e99ef0902so155638385a.2
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 02:05:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787562358; cv=none;
        d=google.com; s=arc-20260327;
        b=StB0hObrOLeUA+yodCzTMReG8Bo4dCP21PTP7sPeyI7HprhKr2nA4HytR35mnOOCW9
         Wn/+6O8nOBc3ucKmU9fUcSsGONXyJWWLJZU5yBN/0sKO/HNtZbAbeGPCrMpNtTaVSEEn
         HRJ9QTqlGD3+lBWW4qo1xbNiYmNR9ECLfAmadrMQZ1+WJBO1GldRx1m8D9eicqIiwIh5
         4+oUvSw1Y+iTvRRhMs8F+IgevS275gEQG/2HHpo+g/xKS5/WScU5hJ2TbOPf0jCbsx78
         DbvJ4/ublSiC7tWkvAne1XmYDIYUFuPjStc6PQ/REj79mRpIEPlERDpCdIs7qkqhrigp
         bCNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xjSchm007/sw+2JfMjG96f8T6RE12rgCCudebYixRu4=;
        fh=JQ7+MAEZSssY+/TbNyxhoL4FyuwuNKJxs90VPwevA8A=;
        b=ACPoq/jNdJ+RGqrQ0BSxex0CrdmiymLP5aPUnLOrFBxx1dLX3ELPTe8lVlj6At/7g1
         UUSJQBMosHPT9pk92QSnJeCTzl30aJXpMs/RID6VPvDbJZ/NbyOLITaxpZBtxVVXjfkD
         HX525wR8ZZsk2Lg4ECr2KKEDhXWEcYkly7XUi4TSGCexrl+eQph+IRWDiYiIJjaUnKoE
         t/jUaSJARmYvJcl9F4KNdfwqROxkqtwx83way1A5P7+GwUlbZjtf1QYWU6e3APadw5wS
         ctlGdy+A0NOwMrZHoS3tfvCHzOVARqEE/4XQhdRLtm6JDISjA/IrCwfuoJVv+rUItVf9
         6xTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787562358; x=1788167158; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xjSchm007/sw+2JfMjG96f8T6RE12rgCCudebYixRu4=;
        b=Md3V02RBMrXT7++lZjkapZopD8qkdAFSHpNsSv6QmBIPKOdzQWCNN6AR4kmpFvkadv
         0WjoUBO4KWY/LQLlyBAjyM8JJ34zje3REjajNVZ3Gow34PJ4FI1D/qOFI4wkzef/51KP
         WjSj07LC1JS0zXh2vxVUSAXHu2k8KyBR3WWNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787562358; x=1788167158;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xjSchm007/sw+2JfMjG96f8T6RE12rgCCudebYixRu4=;
        b=W7gawr9xyEUeKoj5toJZRyJcBN5V25TVqq7DpjbuZBJeAJT1tBWOX8Uek6LN3gC7ME
         YCPINv0pCqKVXedWGtqB0PJSnm+2U8kpn/rbvG2L5a2jSBdsWnjHQmfhZqm8vM1I6xQA
         eGsW+YAYJEJ9Uy2AfPOT5OTKVG6yqrV+5uqhzsQP7GGKtbkZLsKm/p7qvd4YzfsKdBEN
         VhiPSzhZoB0zoufW49UOAN+kSG3wck/AWoqAVt1Brn6o68nY+aMSyjrmniz9wHx1xwvf
         wUo2EqeiuvNNrGAkBU1wVbjNCHskhuLsKVtLXa/wKchDUDX5xksYL/CiAihskeGkFREx
         876g==
X-Forwarded-Encrypted: i=1; AHgh+Rqw5Yit2GsgM8iIGXjHaYqvw0NxTCcTAebHqjDviFHfjGs01hcHU9u583PXmdbNHU1QFKly1hYZxDAqOw==@vger.kernel.org
X-Gm-Message-State: AFuF++msrS8HYMsXgNfy6K532B6dxVznrjtVYCe0CByACpLnhofbA3OH
	esCbOn86gi7ldfOL/HMmA0At5gmikvl4S4zXCwRrOXDbersRRQMM7vSBHmRh8JDAvU9KBbZ2KT1
	MhLf/nvBl3hGVDBtV2g4sQG1in3H7UPA+1gVg6OR1hDB7IhpuBc5Fr5c=
X-Gm-Gg: AR+sD12nuhqJEGF299BN10SeuGkCaSEoTS60rMFXCxVZlftqiMVKWlsadWTBOrYi+el
	Q/NyioPvpOOJFpF1JGR6oml9XuoKD9zQa5SPRyeJD2OwTrW1rbtIjWEmi3Chl5KmQY7rm65f3LS
	nJSelG7szaZA7iJxfkRDs7g1/meCO3+oic6uvgp8ndaFbiLyZkTE7MzxySSKOtxewI9dyXG93Na
	jlNc2VxWZhSA8lpuKyIz1TY5m+7X/ZC0WPIvzXEtzot9OoaFxAgmQLn4SuLqvC1ESXzUXAkL5v0
	xLRDLEbs6urNNU9+JIfrd0grxULjQobGqQJZP8xOHdZPawNn0j1aKtHvI12Ko5u+htr3qmtSp+2
	VlNU=
X-Received: by 2002:a05:620a:a2c6:10b0:92e:bbd0:260c with SMTP id
 af79cd13be357-9373957655amr1668397485a.36.1787562358062; Mon, 24 Aug 2026
 02:05:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820193343.3852967-1-willy@infradead.org> <20260820193343.3852967-3-willy@infradead.org>
In-Reply-To: <20260820193343.3852967-3-willy@infradead.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Aug 2026 11:05:46 +0200
X-Gm-Features: AcwNN1VnwXUZIDZ1PfaZZEyLrhKwB3yAlvrDYfoxcRnFp4RHIk-2JE_xMlB98T0
Message-ID: <CAJfpegvP3i8ZJc2T=+f4rAhZ4E1QcT5+jC6mQPLxtB-yoK9Brw@mail.gmail.com>
Subject: Re: [PATCH 2/7] fuse: Use filemap_invalidate_pages()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Aug 2026 at 21:34, Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> FUSE relies on invalidate_inode_pages2() / invalidate_inode_pages2_range()
> doing writeback by calling fuse_launder_folio().  While this works, it
> is inefficient as each page is written back and waited for individually.
> Far better to call filemap_invalidate_pages() which will do a bulk write
> first, then remove the page cache.

filemap_invalidate_page() suggests to use invalidate_lock to prevent
races with pages coming back.  I'm not sure that without it the
behavior is identical.

Maybe add a variant that takes that lock?

Thanks,
Miklos

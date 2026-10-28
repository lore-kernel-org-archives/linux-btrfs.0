Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793225388;
	b=y/kZhB4eoWUR1j4wjuSLz6Aric9cFAb0Gc7EpOd1XTSs/SNBFbQt2e5P9UWrln4FiGPp
	 354l3LDU6EP4YfIsda/KXnQHlhEQMrdr9MZ4XfskRmfGiyJrHiwpyM4J/ZtXb92UhPO4A
	 othiVAtL6QlGr72Ya+XOvmsTOfO6IJkbV/nLqS8JLHtFyJQ6exbvtz0mtdJSqcsbE90V/
	 ixXLow+OwLFL+CVeB3wkiQmNiVT2B4MxuCfgZ2sjAwaMOnBpWpXtF1VcF8H7YYf2Zc7lJ
	 Nji29geGKgyZFwFKah+VY4Ayp6ANqKmVNd4twTbHszrFM74nAXRrY8+A/vgTrh3m87Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225388;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=Co4JEYHfDMKeUF5o6b32P6qXHFB65senXJ+UX06lo8FXinnd2StsJ4ZU1JZhUdwdJkd0
	 t8EtOQvjGeB3AXaFtqiAo2wwvlKLiZyI0ZU7yVqTx9UNSKfAlcWfgoO8y/o+IsVpjCzyd
	 g7gEuGYHruyBjYNpXmCheu18lx5JV2rNyolTdCupufwWbQRhEB8hT66M6zd45XyXXsO5U
	 nKeHXDX/eqmqjVV3oGMK7nILpvfbwHMtX73tluOEfdhfom2BT+AfuJE+2MxfVW+fTG0bg
	 mG9m9gG08fjIFhBv1OmEh8o+w9btXU8EPkqavmoONO8I78c5DOnDl9cjgv7QHD1fdVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZPz9gBSh;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dMvVeWef;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D32606A32F
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 22:09:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6D32606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZPz9gBSh;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dMvVeWef
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793225386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=ZPz9gBSh/yBDILl4Wre1GwBJEJXRNCKDy8H1++h5ea/mHhewpVcmtz4SCdXdBmonsKpZe1
	QK1fPZIYqd8QAOBgp8EV/s4fRwGOPz1p9Kchisl5RmbGzn4ytpw5/9xqYRXzNr/WdCGxH6
	pq4S89wJjHyakIP5ukEWtbeAwDoljB0=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-ypmTcVu6Pd-kBQWyC8uBAg-1; Wed, 28 Oct 2026 18:09:43 -0400
X-MC-Unique: ypmTcVu6Pd-kBQWyC8uBAg-1
X-Mimecast-MFC-AGG-ID: ypmTcVu6Pd-kBQWyC8uBAg_1793225383
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-6795a39e53fso247618d50.0
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 15:09:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793225383; cv=none;
        d=google.com; s=arc-20260327;
        b=FMxXOfBO7J9XeSkaIMlEMQiAcdF2zX5enjH4XSSdkEtNKEE8KoVggEnPwGgPJvEhmy
         8LKFs4/LQwdGqOQCaYI4quDqNrQdTrP/xlghFN8QYBydAdbaMb16vkJ3asF7zd92bZDv
         30FVe7c/EMd+6x8ERV2gU0X5lFuDKAyR4/Gi1fwLRcxQHmXAZKmN7b8iZ9JTxD1zXlY9
         HUfnY1zy1Ej4OKBvmvJZ6R2Y4htxw8/ueWLNot7BBXdq2B3P9AQw//G7SYih+tqOSS+P
         TtzhXG7ZXokRPWb5urfLtshvNSPuRnBsAsPlpAp8WgS8k4lfLqcCew6XeBDDlL3CllxN
         R77Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        fh=VYuv5Ezub9a7Uydt6h6tU2OdSNMYEWzL8dmeTeqvAhU=;
        b=ZtSL5Tr0HU4bFYUId7DEbzuTQf2LlHAwR02tmk//WdQlDVRAXDzdXXKP6e6uW8cZ+V
         QeMJoU3smeh7sZQIPenSvT9fGuWTrroF8alGxllrMgNuqYrWBRJ4JN+FuPEF+S4yaxT2
         avXUyXRfYzm7QrEYeVpWv7I6aeGWgfJcCBiTr/OZtV6mAEe34M+P2msyMO23NWweCiJ2
         sZESQpOYs1K25q65eOZ4D1aDwJFCvilD+3715e47w/7QTZLviIhTnJ7cibcjRhxmJ/Fp
         GvqysAriT/K3npl5IP31FDlAEjb4xedI+M7cXPZXL06QpGYw+jbZDk4Bv3k1Pl3q83Iv
         WipA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793225383; x=1793830183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        b=dMvVeWefC8P+UdQKNVCTRzDnhWHngZQGob2rSgzwsZSnRN8SAHr7CL96OPYJXufFq7
         zSTFFPllhPr/w76wrseeWsykFIT3XNeylizZvRvScikFw2Vx8ZBVf5aKYuJSSTUPuuch
         XBaTxNgE5Gyy25Odb94BXqgaNMMlvyhAsHvl+cohQ1ckCaDBDm4+NkPEdFeD/j45D4SX
         9JdubWa1Rkola0sqbNiDrUuR0ynjj8Js5euvpFf83x/dOZOzpzImQtYe9Q9exxMiq/qr
         mXS/pEC6VjG6Gc4ktJQ1wDheP9WEZsIfL+MfkoZBHHuqMX4NfKOOS6gRPfYVsrX4HqWa
         L7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225383; x=1793830183;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        b=sapdQufc4aJrY8+s3m2/l/n735TQuUqumEFQB1uoFDfHSnUyj+ldoErb5fZJUjpnnx
         0pwMk6Qq29vmNXvOa8GxBYmJTR9vEzXVRjvCEE1NKt3ZUDxw9AuP8z+dZUg3LzoCpYZj
         G9Anh3nYZhIvvFxhbza+PV/TAJ2z9ARSWmKo6vuinKWzusFm9bzjMe8NE58csd0K2Ref
         ijiVeTXMcAgtnAOHdBs5WqJmaFnVy5bC1uB5YqrFe3+JLfB0t0QnJFKzX9NgDOUIauk0
         XLNvEji3CLY2uYVnIaiycWYeWeFxC2iMoNNRWIktQGSiD04o8mtvqqvpTogBo0IrfbqB
         BpRA==
X-Forwarded-Encrypted: i=1; AKwUvBwTXWhEQ9wPrdk8F7y1oILY71p+MEB9EBpCNbGIqa8ZDm79lOzAODY4VR6+7mKyiF/e0cxBqrZFXsz3wA==@vger.kernel.org
X-Gm-Message-State: AFq9FYL0U41FkhD3lwzigmFGKFd7lCn5lYfP6+esLbI2czUdF+uDSd4/
	LRJmlS1XFvrJ1DDXC0YPeemUEqsR3D81t+aSlVbGGOu+Q3ia5rqMr/KLkjGLC0aj32F+e4L1SgN
	ELg8DoNfrrOAnQb5rQlb8BAHkprFYYevU0dPLwx0CGEB0E9qyTe6hOBXeggKLsZWLmFqTP5Uhq/
	Y2lqD5bB8wi0USkbL/apUpaMEuDRKpZBxsUwMdMH4=
X-Gm-Gg: AYBFou33XsMnUbgOuPeKfL0QZs+9H2sP6iCuPaIjgxGYywcCV4Bux2CH7eC3UXWgQHK
	Y6DlvRov7WzvNw7g+vmcD4ppudvK2ejYDtzscyDjirKU/ttGjUVyFwjXif3p1K2vf1s4WDbpsKH
	roqVuTc3syY9iKku7W9+XYi8yBd7oJQqqzJEySenZOmUR26PBWXPAKD4O2Hge8p3kHzx2KA1uCs
	wpAopu2SccPDdxnhmVTlHADUV7deEDWRZZ/eBc0ZeF7eA==
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id 956f58d0204a3-67a8d0047a5mr704866d50.8.1793225382836;
        Wed, 28 Oct 2026 15:09:42 -0700 (PDT)
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id
 956f58d0204a3-67a8d0047a5mr704846d50.8.1793225382297; Wed, 28 Oct 2026
 15:09:42 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org>
 <CAHc6FU6z4kX5R3Og8m0dYOHsjFcw+4Btvfe87AGPxy_EWs0E7A@mail.gmail.com> <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
In-Reply-To: <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 28 Oct 2026 23:09:31 +0100
X-Gm-Features: AclHuK9MzobLdiG2EG9M5KT_ibZzYxdrTghiXff6ZlesOE7YSK8Ag_RtXekxyZI
Message-ID: <CAHc6FU6VSAWQ4RJTO_eLnpqN5qvrShbJeT+ADwiA6ohpq8dO4Q@mail.gmail.com>
Subject: Re: [PATCH RFC 21/28] gfs2: don't set SB_RDONLY on withdraw
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 5:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Fri, Oct 16, 2026 at 02:01:00AM +0200, Andreas Gruenbacher wrote:
> > According to commit d564053f0746 ("GFS2: Clean up freeze code"), the
> > idea of the freeze sysfs file was to make it behave like the FIFREEZE
> > / FITHAW ioctls. This isn't what the code is doing at all.
>
> That's a pre-existing and separate from this series. freeze_store() calls
> freeze_super() and thaw_super() directly with FREEZE_HOLDER_USERSPACE and=
 never
> goes through gfs2_freeze_super() and gfs2_thaw_super(). So it never takes=
 the
> freeze glock. I don't think that's for this series to fix.

I mainly wanted to point out that this behavior isn't intentional.

Thanks,
Andreas


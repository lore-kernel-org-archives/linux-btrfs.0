Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076C844C651
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428267; cv=pass; b=nfJYE6fzzWw4hpa2D7O6Gs99y/mNJ5nGwb9QCPW28APSCF7EodYTvEfyC6zdzyIWJnuhYNHE1jbHuuY3Lriv59/2gNSnEAQasQZ7A/LlUQg4sZfD3bTnbX5tZIojBijwvtMIgJlSAseyl6FMEpPAm1tNRr7vu+xbu7FLwph+KMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428267; c=relaxed/simple;
	bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pjUKAFxKyQff/YqcllRibFAwd2WEYDxHDgauwOWWgH3eiY/tBIc2UICZ2BzEBAPIi/UhzyglUCVFcP2wG/pZHpreo3cCqXYiTOnwC2MMUmpNIRY10U7qc5sUB2eGw8qlz0rTDztEz9BUPZUvZ3UzSdaEQy0D9aOZZiznEXTNMxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=MqCUIO9y; arc=pass smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="MqCUIO9y"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-451ef88519aso7734fac.1
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 09:17:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785428264; cv=none;
        d=google.com; s=arc-20260327;
        b=YZh5rw1QCbbb6Zhj/HZk7VupGIh4tcAYsQKwaUvaBM49LumP3FAeBxB3IR8G2DYl3C
         JTclu79hP1NqT9qBI5bzIDmggnM6nqfTSUhnN0IkOpxe0mrxMdxtbSbL4vwi0A62B51S
         xXAULyo1jqXyMai1eoHSHmqtFfYuCQQ3DBV64GzpixPBSj80l2TgaWW7xzgkA8j0RuxE
         g6z9yjH6Cns9mNfJ/xWzFCjedrv3Z14C4JjgWJUtIRnnZHYy24bfo1xL8mqSSCBcMR0n
         AI7uJXdmQLajIbxRKSjHDy7mHlvBDI6/bV+SB6lFx1AgvPd7SLAEAsTDdz6worLAqbdy
         V+CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
        fh=ZUApdceZN7owct9GzHiuxVa7gEGt76+nN5ZbLXrEucU=;
        b=DPSkWgxHpjmP1YKm1hY2MaPHeRSLhOVXk+MB3eMRizJZd5dL7VJCQPy+pJRWak2tYe
         EWaKDJQqocqgZQcnU3/KAm/BIn9UKt5cIujbAJmV70KP4cXAZx5elJ8U5njit20T4iED
         0P17/sqQ68R4i2bhA942t8p+d+FIKDyZFcKZ2VVQwsq+m09ZDLNr+yX6/dKu7Kjg3ZDn
         XqTUxgAj71j6uH82MM1iE97LFXlRJ7rQYaU1Y1tUv2SP+J1LgxNjbzo4y4Vo6ziyHjlS
         NUH7QWVCjr/wmtFcP248Oamv7sS7EilHQftxcUqwuZn/pYyqe+YjKARGMaCVZ9m8xg8r
         EcUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1785428264; x=1786033064; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
        b=MqCUIO9yyYJwHrMDdiejiNqcDHA+nR86bfqK9iKWYUvi4dsxosqLK1HYtjLP+5hW70
         k5P3caMtPDuMcCd+Q73b4jXiKqkWofjW7ZGye0Gp8XbL+MuQteuqTWNusN4S1MOtLD4h
         f043KR8DclrbfQVIx1LIlJafF4mkqxY53CJGgcgKSlzzpPwATxfWrBB812Z2bO/xO5EC
         elYoFSb15ifUMJi3Yt6rGgvVTnyac4gvXe8Q5aNLZI3twpMmhH335Lq9BUPv5Oxu/My9
         v6K4aHa0gm3jyf/WIJFeYkP3hvhEKOXplgljdRIOV2CPW6euwywntOV8pDIXxSVXpgaz
         L+fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428264; x=1786033064;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
        b=O34KwNCkGYOFuQMnmIcvwy3AWz3aq4rPtUihje1ZZ1PDUnFtxEy500Yjhh8yxu/j4p
         4i+D/6Yqf5TehbRFinKpnCFxa+BYb298OYjFXlLVPEgtPxIMQdMFwgZwiynm9vKSHXKl
         D4QCmD4lziQnZr8JhNwTjOjN6Jv/7Ve/0roZkDKLt1h/p9czuSqiiXPW1UrxWzW3+pVk
         i/KTT1/ldG2y4u2hXqG53TbtR3dLOHZzFmgoc1QKZq+u94K3UUSIUuD9OdTpgZ0mTbdC
         ZyD7TUN0sTG448Qheoy+S7DxjvoP0pbblGRKTC8HCKQ6C+T2Bk27FILJVbxp7RjboagN
         08lw==
X-Forwarded-Encrypted: i=1; AHgh+Rp9a2p4Sxvu/IlsQkDYiK9rgE7H18Bcwer5nkRRHMIpZFRJDWgBaQ75UwAbjddUBGbEGE4dSSe6uQuHNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxD5w+dw99ySmoIIlcKal8mxGk4ti4c1mq4tEccr1R4KErG8LP9
	5Xoy1ivHYMT7Bn3//V3Nk0HZ2VDZe2C7DFELE8ShKfFwvQWZkIrda1KBAFA1vhcQDsuqLqRZdcQ
	QyF19XmkK9IE5DKPk7kWFMXVSuOPgmrt/cFAE5bs8MQ==
X-Gm-Gg: AR+sD13TQVayAf55oHOKNEmA681i+wMYzm0dn8jDvbHu0d1GtdZ/GgHtDXgcrphIXRZ
	5yZYgElJqw0TyDf6+a0zxDq6GnLQE5VCZPLpxOrxAoKUNTEug1varvblW/PSUQyMGzg00x97Gra
	OL8L5kYx7syKw4tWyTkZ3GRwQzHvTYBsFdBdnobzjEfE06BRnJiKfFJbIr8dRpXa+Dwq3wDHPJN
	qyGWw2qWvHs4fy+xXLrHZOdCudbtBWrBEJDQE/kZiJoN8PkCYZus3+nXrbEcSJDOUKwDm9N1afY
	RQgbRkwsPe2r2GDP0BzO3D6NC9oxTLB7C4hIzH2fGh0A
X-Received: by 2002:a05:6870:610c:b0:448:8595:1e8b with SMTP id
 586e51a60fabf-458dd203cc6mr828125fac.4.1785428263717; Thu, 30 Jul 2026
 09:17:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785274111.git.asml.silence@gmail.com> <19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
 <CADUfDZpwF0jp2e=+c3w_NjWPbnQ858bkSD731M6+x27jzgcJiw@mail.gmail.com>
 <CGME20260730104131epcas5p4b52720519486f7ac774c317923a79c81@epcas5p4.samsung.com>
 <de4ec386-42ba-41c3-bcbe-1fe8b2f71ba9@gmail.com> <09134617-6d9e-4963-9319-1855e88a4df9@samsung.com>
In-Reply-To: <09134617-6d9e-4963-9319-1855e88a4df9@samsung.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 30 Jul 2026 09:17:31 -0700
X-Gm-Features: AUfX_mzVuCLkHKoQjKU1BgpL-X0Ty4OF1wEt1trnCKGouEKw-m3DZTMxHTHiuQw
Message-ID: <CADUfDZoVUHMWK0KBnznB73o6Vg+iQBBzJE2NmF1Tf22Zvh4=Yw@mail.gmail.com>
Subject: Re: [PATCH v4 08/14] nvme-pci: implement dma_token backed requests
To: "Anuj Gupta/Anuj Gupta" <anuj20.g@samsung.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, David Sterba <dsterba@suse.com>, 
	Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 4:36=E2=80=AFAM Anuj Gupta/Anuj Gupta
<anuj20.g@samsung.com> wrote:
>
> On 7/30/2026 4:11 PM, Pavel Begunkov wrote:
> >>
> >> I wonder if it's possible to perform the PRP list page allocations and
> >> initialization in nvme_dma_buf_io_map() instead of the I/O path. The
> >> NVMe dma_pools are per-NUMA-node linked lists protected by spinlocks,
> >> making them significant CPU hotspots. If the dmabuf registration set
> >> up a contiguous DMA-coherent list of PRP entries for the pages of the
> >> registered buffer, any command using the dmabuf and requiring at most
> >> 1 PRP list page (i.e. length <=3D 2 MB) could just set its PRP list
> >> pointer to an offset into the dmabuf's PRP list.
> >
> > Possible to an extent, predecessor patches tried that, I left it for
> > later to keep the series simpler. I guess chaining won't work in
> > general case.
> > I mentioned this to Kanchan, Anuj and Nitesh before, they were up to
> > playing with nvme optimisations in general, and since sgl from Anuj
> > is ready, maybe they already have a prototype somewhere for that.
> >
>
> Right, I have prototyped the PRP list optimisation before. I will send
> it once the initial version of this series lands, to avoid adding new
> review churn while the rest of the series is pretty settled.

Sure, landing it subsequently makes sense. Glad to hear it's already
in the works.

Thanks,
Caleb

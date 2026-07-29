Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F81D469838
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785344013; cv=pass; b=rnv/iHEmZdD3EB85SHwIt2OMDBTXJzWD8bWHLnx10EkApgKpnli3oNgt5yN9HBPkHWldIe6g/6A20AoyGkNMBJPdg8wEz9cLOjr0G9euxCop/BcBU4FSqKbk5E9pcRjRFBJkzBcBxeYujo0SgC7P2cVtZx9nElWYIf7zbOG8BE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785344013; c=relaxed/simple;
	bh=/YYV8EJ3uAY8vVlHWLu4xPFSaaoxJidP5IaWXw3aYyM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qPK/ede2tgN+1tuX+5oa+I7nF5UvTSn7RtKGSLv80gx5Cw+klC8wmgOF8LRmGyKU6xkkgCAOBBvpCH0Fjy41rixy3k10JSnjfSLGv7alu2240KN7gJy+Y4BBY+KXj2Q1tgXukB+JeoE/3PnQCx1pR/4g0MtPF5qL9WsNSgO5sjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bZnLVGTN; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bZnLVGTN"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-698bf053053so1739960a12.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 09:53:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785344010; cv=none;
        d=google.com; s=arc-20260327;
        b=KllOv6kpwrq6ZCaTMyveZC8rpZHACQivU2lL2yPR0AiaBSIFFZ4t8JI7XNic+CkGsP
         Li1be+QQ578IIPx3T+5cz1Z8XUrwX7nhRE/tmJanLlBJyZLY51yRs2g2JKLCwJ2xDnL9
         OO2bD92kExvzZi1n6AhqOeHOX/TAXyLGiCiHD65ynQHzutfVO7RbWJiNl3yOk68/M/G0
         AhNPmtF1/03sfICrSc2KMQd2xDAieyL0Lk0fFVNgNnSl4gNg1xATc4bAiAjUt15UCsBu
         UE3/tvROPR1PfPyyN3Tlp/nj9p8uDvOlZGv9a4CazVvj2uckhaT9UONjgdnDr99jDMrK
         6tAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iRO7Ed4PohyaBZ/SmZ+npcgI12Qnh1MLhDgk3TF8jow=;
        fh=CZDOo5itetZ9UooXvhIYPRZ+UvwphkmnIiFkIxPa3Sg=;
        b=XRshgSdcLOQtw5FTpAA9Z7UANPqKn1E0d7AU+DvP4khnootAF8jlwGLIlSga1a5rVO
         pu2G7oQSy6i1o4GwGPjlqq5HXfBcCUEl40rm/3sIt6mQl7/QMPKGRfoVkHAIUfrlJA1U
         Y9gtiQissyXC+hudM0h3DTs/zgC9I9bkpX05afTJZW8LOd0bxcY/XY3ie6CiGJZ79X5h
         XAxUyWDXGsYrk3y3C1xCFZxiJI1fXRwAnH6gqKpG3ULFgcU/W7w5EqzVLPjq0YcKjQqm
         1nc7Vfz9C70NE0YfTeNSKTYx+O+30CPhKedXRHdfDxnSs+MWRLNcwKXC5AfUjZIFXTDV
         YO2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785344010; x=1785948810; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iRO7Ed4PohyaBZ/SmZ+npcgI12Qnh1MLhDgk3TF8jow=;
        b=bZnLVGTN71+6rOGUEDOF2KKfsBoVzgPc+6KjOtUaxwoQVgAQmK+bgtKyqFpFZyFtJq
         nJFEqB8j7YlMnW8bUNEzJRfJdekDJcM3xXyXgWJfL8WDAjIA3f+W8yZPcnNdDQX6YYPs
         zt8TRyVY0NOcpOxJVRgxQ3PtjdnE21ULXhmra/XwVXzB7WWEeWKmgccKwMgl8IfnmX9e
         NcmoVChs0wbWpUsGydeoisKkkxMd3DGcCAK/J5JcBvgO1tu0OLStdS8VZccIfwTe6wFB
         My0l1BLssPp/A1RJ4FF3WmwVQ3SdB6FnYUo9UJmt9ZOwzK9HEYfhV0xxZNVb2TFtv0WA
         WvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785344010; x=1785948810;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iRO7Ed4PohyaBZ/SmZ+npcgI12Qnh1MLhDgk3TF8jow=;
        b=pEDIYYzyNt94WAJ57FggpsfP1NvRXHBpYrZOamwwEfWasuyg1PNsn/fRjmJC6OqQyl
         Qpe8B/OBCbJ2iyiWCjOiRLoDH2F9oxvF4xKF8lCE05xW5W6By58GbYrtE5UfQCvx+dLH
         5ikOd14Ms+2+ntePaS4XeO293+R/eJbPtQk2rGNbXLJHVCozxX8UBJkPgZ1P7KuybUnd
         Kim4q2Q/wESGMVelvV1Z89YF4wKm/ZUcBjnRuVwCEfh7EsSmF1dkK4R3TwPxasHn58qo
         Ea9Tp4M6l6XNHkOEnvoMvRjCcMiZ7bSqtv7nGqizjHAco6z3XJ+ptPNmoZ5NAKj9bW1E
         /GBg==
X-Forwarded-Encrypted: i=1; AHgh+Rosr8HWWz4XH5Z/wizPofcLoEN9kCKldewd/tPCvTfWXcDFF+ixijMkVtvTkPRCOezELXNCzS/Pvw4s8w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7yDdP+kffUBkrSGz7AGiIxuTlwQoUvVAJSPpGxq7YSYSafdro
	qPJOQoo0f/g7cP/k/+ydThPOTqTEXSSMon4swVJMItgDCK/yVLVFGqSpei0gaBAeB3UcKeMXCza
	709SWHivpmv37JWxmBtw4Uh8lbhF7Jw==
X-Gm-Gg: AR+sD12Ie3tqpE3drN20gqO176Nqi3RF+GluNT2TOKu30kODlZqPc2uPuGRqSkbzPs0
	GuJtrNl7BZo8fZm2g2pKI2ydy4JiiSSEoG+o6qk930ZXnwPaX8NI10Lewa7X6B9SMhhj56AYgIb
	0RjpY+SHEMz15cLhSTUBJkma0v++afI5eg/jvKcGeyd+CFiTeXGb2+ukw8KhptsAEukWaSvxRrN
	RUBXzLv2X0+woe9jkDtybO8u1fXu4jwNp9j5aLDbJoXs56kZPryi1Rd+YgQaK4MkDDch6oinVye
	lCNrzs5IxwmcmtHA/IaHnQBPixWf5DRYRjj63pF+4rrzszeY+IM1iY//t0UbeMuGv/AB12Zf0SF
	lgeT27oQsMl/C0P2Ryw==
X-Received: by 2002:a05:6402:5018:b0:698:ae69:3992 with SMTP id
 4fb4d7f45d1cf-6a0349ec697mr4404066a12.16.1785344009469; Wed, 29 Jul 2026
 09:53:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785274111.git.asml.silence@gmail.com> <CGME20260728213020epcas5p1721e72ba5544abf0b61482da005120d9@epcas5p1.samsung.com>
 <26dcd0ae5c87a3ada5710b14b6894ef343cec6fe.1785274111.git.asml.silence@gmail.com>
 <583fdfb2-5368-467f-a388-6d388859c995@samsung.com> <0df2f832-e8a8-4fdd-a5b6-e08657c2891f@gmail.com>
In-Reply-To: <0df2f832-e8a8-4fdd-a5b6-e08657c2891f@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 29 Jul 2026 22:22:50 +0530
X-Gm-Features: AUfX_mw2n1ETd8ASN5Vcu4oMSqcqp6oKyV0zFdoD8l7zvxibNrqO80gPOx-5lV8
Message-ID: <CACzX3Atj+hJmF+Au1Yw5KMk--EHy_J=7Yof1aQNkUV0hCrdVEA@mail.gmail.com>
Subject: Re: [PATCH v4 14/14] io_uring/rsrc: add dmabuf backed registered buffers
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: "Anuj Gupta/Anuj Gupta" <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
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

On Wed, Jul 29, 2026 at 7:37=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
> >> +static int io_import_dmabuf(struct io_kiocb *req,
> >> +                       int ddir, struct iov_iter *iter,
> >> +                       struct io_mapped_ubuf *imu,
> >> +                       size_t len, size_t offset,
> >> +                       unsigned issue_flags)
> >> +{
> >> +    struct io_regbuf_dma *db =3D imu->priv;
> >> +    struct dma_buf_io_map *map;
> >> +
> >> +    if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
> >> +            return -EOPNOTSUPP;
> >> +    if (!len)
> >> +            return -EFAULT;
> >> +    if (req->file !=3D db->target_file)
> >> +            return -EBADF;
> >> +
> >> +    if (req->flags & REQ_F_DROP_DMABUF) {
> >> +            map =3D req->dmabuf_map;
> >> +            goto init_iter;
> >> +    }
> >
> > O_DIRECT is checked only during registration; we should recheck
> > (file->f_flags & O_DIRECT) per request.
>
> Nobody should be able to clear O_DIRECT, unless I missed something?
> And fwiw, io_uring wouldn't be the right place to do it.
>

fcntl(fd, F_SETFL, flags & ~O_DIRECT) on an already registered, already
open fd succeeds. The consequence is that subsequent I/Os switch to
buffered I/O and cause silent data loss. Something on this path needs
to reject this combination.

> --
> Pavel Begunkov
>
>

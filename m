Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9672409277
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Aug 2026 13:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763303; cv=pass; b=YLSAn7rZ6FcHl88lnxsM8rchEaLzf3DLll+oS2m8SGdZkXpgKcMp8AHj8LzXESYJo/j5ldgfjMLLdy2idb3ruhDHDUfximmPfWgdahwbxMm5/xGiSonvHcS23dNmQ8GwF7j8zdpkNzcQlNyqupedo8p/H6t3vRddjOU7hurG6eA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763303; c=relaxed/simple;
	bh=Pgl5mTcqFOqWGOQn2TZduStirxwuSm2pRwIjZSucJwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hlgh5VyIKDr5S7i1WTuZHAhKYf0y1/xzvkRuzPT6JbajBWz5d2dy4wATyacZAgEG3ZAGscI1Hrz2uL/PNDxv7hbFylhOA0qHsQ3aqQRBTfM4Kt60o2D36E0Mg/LojN+89K3ECFj1oJJyhxFSV5ZUzS+ZzUhM8QCFWgJtt8JgVK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dvxRm/Zc; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dvxRm/Zc"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-69f2c67650aso5274522a12.2
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2026 06:21:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785763289; cv=none;
        d=google.com; s=arc-20260327;
        b=haHddLOzkCUeHcicROhmc53PS3ceuWJZiXB1Wmy1AsHX1Z6OqtZUOcAQcPKyabkySo
         YMRHabPACuQC1oI8iCTpQTrxozHa2CJwWy/lWRquZyg8bzZdrEJLEKdvF4wAIx1MNOHx
         0ZgGLE6Xh1eIURgN3rgHqhOjvqhj5NrzQve3e/ves/qD4RG/XSGxUGluKfKY4PgzrDwe
         6vHkUTqkWfyE8KhttDwvZAJxALQAv4BGSTbt2Nkwx1yTNmy0q87WHyB7q66BdpqP5OyG
         iLyZX17qa1gD2fa1FjsmQJ0+Zqh0IR6cHxN6T6nT8Cy+RGgrdvBM2KItgTsoGyBvhYjs
         rjsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y/+lXFVTL8yRFLlIHwc83PXR9zbnjKq/x3zTQK5cH9A=;
        fh=sJQ+QF5nDb7/Py7On7H9P3I+iPKtF+7e6zYdntFD048=;
        b=Yw7cAW3uCDQVUmT+OcnZZYRKUfXlk4LoG/kDm30NHaqEjn9TtncFupCZXy5kpuGLax
         DBTeKp/8rrH/ZtwmulVKTRtCkBftGwpvn6B51ptEhqzAXJWw3NXrtr4Zovu8UtdyU4Dt
         kCvp5UmiyZRInvGOb3EqOzk/oFnFRK3aIW3e1hMQwiXVMfUOOPqmUND6QYgHFxSkPsmq
         Tu1pp4sWGfXPfc3GRFPsKb16KHqhCfZdcZ0R2Nk0Jc9JJ4ymRGIQJdkbF37yi/aOV0Ur
         KREq3xLsjU4m9KtAaG2Fs0BKtoaIpa1OyaJuuO6idN/bDJoujHHhPJ67L0dYIdGEV+yg
         MW8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785763289; x=1786368089; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y/+lXFVTL8yRFLlIHwc83PXR9zbnjKq/x3zTQK5cH9A=;
        b=dvxRm/ZcGYR2VElqHNvrbIbP9OvHsQkpvLJObV5wRx/fXOfUt29OLPtE+JvxWK2AOQ
         3VhaxWdK9wr8VU9F7OpdHh93UyXYln1zJIFeKxpY8byuq8uH5aOk6evZeGjO9IkqTptd
         6pqSXC4iIsTM5Q5hI3ihgFCpFYQmHAIH17jBmK2nWesFrnXCN+cLlB30cVLoPE7iBxPq
         YNZUhtvw1JycZThdfbfdyNVwsIyNlqZahx8PqEto4vhXRgRne7m4fkHUxVzQMxB0N/A0
         77oJ0UDkdALZBQIED3QKAmbqVImouGpGGwdcCJe4RsLDjGD4I5xyy4Jr8+HbjvOIgaqa
         GxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785763289; x=1786368089;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y/+lXFVTL8yRFLlIHwc83PXR9zbnjKq/x3zTQK5cH9A=;
        b=aHN9eD4x1des6oEA8/jbHLqytGoRDx30RyWiHmNEf4XhyxFkLCRQ3J7UTtcx/1iLqg
         loZyxr3GM+9KZh3iWmfQ/2PWjn9h7kG3aqnMoqamB/S2WZI1/1+AesDIQWQAG5F1OUhA
         mdzGp3obg4dTd2qnw9JJnOmWRjs2D3+KANY9IPtUd5E5IxhiRj8m6I6euRyK39NELxl3
         yAmnjM7Sx2/fvIiDWugepQ2YSQWZevbz9p4xAKUS3RklqLueAw4r7WtJFAIpXeFqAqa3
         23pDOJ3PMRJibZN3DbyVQo8Uh/jif6ncSyJU2L0taOcqbCh9CkKu0gDyeoYglHrDzDq0
         3PPA==
X-Forwarded-Encrypted: i=1; AHgh+RoiyxUKjX93j0TiIS6QP80B90OgyZeulSXph15sg0MvJD8tqdfjUeaJoog+DbIFnGUQ3ZoL/HjB38Em1g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+ZY9bIkbcP4xvq+VqpsR4NnPTs7GUgRdThBB+2ArzjYCZnyfL
	pBD4vYVMuX1aWUVCMwaNGdIHI7I0cqJ9es0SbGQmMLauJgHVgallFtmjV1n2SwvddCHnDo0iNh/
	Arxgr9Ahis4oP9tfS54pdHrFkW30lOQ==
X-Gm-Gg: AR+sD13yhDOl8jNrJz7B+WlIA0SzTS8BMP5Ohb+WtUmWclnzpAghkM7MwWR936dq+uh
	w7RSd2lYeNPqiecOI28FbPxWok8A2tspHuY2UEfnp8J+SQ2qV4hwUkfHeRII6MgRTSs1wxen2NH
	rN0AuyMvjjlgKS7+3nkPrLtIr1etw/OCWMaG0ETAsrR8kKnglDUGPHfARvZUecQ1a1yiAuBYLbA
	DGBV8CO9ZB2YXybl1UPT8y4Gu3E3MMcrWFcG+c6GJzPUkts3QILxrgezAc2spUnMp6zlq/4Hbos
	0HODkU6r/zsRn+3kzxq46OLpi+U1BUPRjQpJSH45vFC47P9SQNPUTfV6iXr8a8NLQyG+4n7LUzY
	iTGVSJv9tk416szM=
X-Received: by 2002:a05:6402:21d9:b0:69c:794d:4862 with SMTP id
 4fb4d7f45d1cf-6a0a7c614f9mr7875783a12.7.1785763288576; Mon, 03 Aug 2026
 06:21:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785596451.git.asml.silence@gmail.com> <c1ab6c0db3853b339a89aee0b1a9c5ac0c48b79e.1785596451.git.asml.silence@gmail.com>
In-Reply-To: <c1ab6c0db3853b339a89aee0b1a9c5ac0c48b79e.1785596451.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 3 Aug 2026 18:50:50 +0530
X-Gm-Features: AUfX_mwnLWCAPfRurFp37qU73Xc2KDpD6en6Q3cA2kgelroMq6uNFVC_YKEZqSE
Message-ID: <CACzX3AvwBF32_ODomei3XHSZ=KtRaWLN-_Tfkwv7sV3Ssc3wmw@mail.gmail.com>
Subject: Re: [PATCH v5 02/16] iov_iter: add iterator type for dmabuf maps
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>, 
	William Power <william.power@intel.com>, Phil Cayton <phil.cayton@intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, 
	nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 1, 2026 at 9:19=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
> @@ -841,7 +857,7 @@ static unsigned long iov_iter_alignment_bvec(const st=
ruct iov_iter *i)
>
>  unsigned long iov_iter_alignment(const struct iov_iter *i)
>  {
> -       if (likely(iter_is_ubuf(i))) {
> +       if (likely(iter_is_ubuf(i)) || iov_iter_is_dmabuf_map(i)) {
>                 size_t size =3D i->count;
>                 if (size)
>                         return ((unsigned long)i->ubuf + i->iov_offset) |=
 size;

dmabuf_map shares the same union slot as ubuf, so this reads the map
pointer as a user address. gap_alignment() below already returns 0
correctly for dmabuf - this should too. Checked the rest of this patch
(advance/revert/restore) - none of them dereference the union pointer
for dmabuf, so it's isolated to this one spot. Doesn't affect the
current series, nothing reaches this with a dmabuf iter yet.

> @@ -872,7 +888,7 @@ unsigned long iov_iter_gap_alignment(const struct iov=
_iter *i)
>         size_t size =3D i->count;
>         unsigned k;
>
> -       if (iter_is_ubuf(i))
> +       if (iter_is_ubuf(i) || iov_iter_is_dmabuf_map(i))
>                 return 0;

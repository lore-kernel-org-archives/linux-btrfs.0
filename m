Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203FE4A33FE
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 13:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332628; cv=none; b=H5UDfxRg9TU49YBmDZwwfNzNLKU6P6S8df08vQ9VU9t2CGiI4PEOFOK1yuKs74h17g7asFhWeuJYxgveBOsJNKc9YWrsqr6hlk7geVHryyu0LOn351bEl1ibspBDCm/2hLlkrvHb18eKVzM/RYX28j81OAfcovYohk1lWHGaUxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332628; c=relaxed/simple;
	bh=eaGzEIkYl8mhH9FJsA+z0QYzoh5FgifdmAGDyRbtefg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S/6yhgEp6lhO++AA2brU0Z5cSzUvW5+q+XP3WJdLKanuItvlLo+4oree+LEz0VemN9GDx++RSN70JLmfBVtLdce/Xnx0272qypooV5rJtYLbNsx/pCQq1kSfpf2R+2c/3ZiW+x4LGmBVjd78dowCTJWboXRo8kqdLXY5J2mSa1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkB6Ju3s; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkB6Ju3s"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a051b73866so1226257a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 06:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785332624; x=1785937424; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GoC91kED98vuJAvVTLdEFxjWPhyWXTYJuu42/1RW6zQ=;
        b=NkB6Ju3sR6t/04LfYOcf1isKoRwj6gashzuQqgP16ZraPJFZ3CxthU7KB7CaDi06Uc
         OV+KK3R27aibqPqauHrjVAclLEu3h2W3M44GUXpElW0GFsm5UFqCvsfPDqjBxpg63uYZ
         DdC1vsuHvRFktDtlx5Sf6xPt4LJGvH2d7JI+99RmcX293mY8nN15zRfHQqPW5HCj5xe6
         TRTuhPfI7+U7ybhMZvkcH543PUnWZXFT+26Zq1ln1U5nH7Qu6C2M8bLp6sUsjkHprbXN
         ddgRUBujvrsDPmIv7uI7IdmFAg1DBQzp7jOr+ymhaWRkv2OB1OeAiGWdRf93WHwGf6te
         Qsng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785332624; x=1785937424;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GoC91kED98vuJAvVTLdEFxjWPhyWXTYJuu42/1RW6zQ=;
        b=KRg1ecF9BSWdFbVsybxMI8jOP//DkhYo9R5l326ezeUBxjSWeBeM1MYWYmJwNDi4v4
         lhZncODpihwVdxbzWfH2EMzPUVSoky1rwKGps2zV83OAjjz4KILtaut9gjnfCKnfqM9r
         mMTl8EeRI/1NyZQZbmaxPXKzsnYImBgsMYTbdDKlZWjle/Peu1ntxPzJLs2aZRhJ03AU
         YZgdypgiTs+Pl6ptAcrFxVIDuZaFU6XhWP4pVYv8+4fQuyvqfMkBvRXHIKWuhGd5507d
         9jEMuXIiP082DW1GicPzg/0gukOiOc1uJozFPBH3w96Fjuj/jwpUGKXbe/PaCngiC73F
         7jww==
X-Forwarded-Encrypted: i=1; AHgh+RpBA76LdXTO0pxub7Zq710k5KMfNP5eQThvuzSDO4jIEHojhaBeOMo7fbaCzqkNwf45ck2gbhvzHKxCzg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7234wCzXMBjbijy3++IB77nZqfcue8sxFtIhca+izAMAO5wQt
	QPqVOkc1KNcnTJ8orJQLVoQo8iMPqJfM2RwGK5CmuP+df5tpV7A/TrfC
X-Gm-Gg: AR+sD13MyBzLW2913NYbcTytuZ3A+aGpTvAUpJQuGptzEkO6N7jj8mw/iimw3F3tH7f
	DvsqHEkCic1LieNICZZWvH5HNBcSwyq3/ltHf/HKZzDwypjLCi0h6mo/8xgLvi6Zza1+ImcuSoT
	SFxKyILsAHcE4Dlvxp2/iuEtggXdYKbIUyrpWoV9A7pIuK3cls76u0JHVEhBbn4koVZRkbJjEVZ
	R7ZA2cpjPXgFJiPR9c7MgtzB7Tbo4549dkthdth/1LvOwAT09ZY4iVozzMy+YeWFDNBJPkDVfHC
	ubXmu9xTXgus6MwxkfI0uQw0P77bV3pKt/HdtA/m4ka8T/3A9PTFklwJJtOkPhS144CO6fFVvVJ
	M43W7FGCM8obGSlT9XnWOVxsWg/28bLFBKbSJpjjpn4PeCwhU9XgdAOgOb5T2KuTAJT59Og97XL
	hGOSV6bgUYOBZkHzGCU5w3L3bfCn9l8S7uv66dM/MqyI8k06Kw+FyymyUPeB8qsl9mQopOdhx6a
	Cwk5/IT0cZq2+I2801Jj1c7FTB+VPe72USE5EFGBmqOrN4YiNDvPLuZRYtNSaMQCYUFjWR/fURV
	BQHGqA9c54ck3F7SVHk=
X-Received: by 2002:a05:6402:24c8:b0:697:ecb4:b86c with SMTP id 4fb4d7f45d1cf-6a034a0b240mr2761963a12.2.1785332624180;
        Wed, 29 Jul 2026 06:43:44 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a050c49fb5sm868560a12.14.2026.07.29.06.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 06:43:43 -0700 (PDT)
Message-ID: <0df2f832-e8a8-4fdd-a5b6-e08657c2891f@gmail.com>
Date: Wed, 29 Jul 2026 14:43:34 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/14] io_uring/rsrc: add dmabuf backed registered
 buffers
To: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe
 <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785274111.git.asml.silence@gmail.com>
 <CGME20260728213020epcas5p1721e72ba5544abf0b61482da005120d9@epcas5p1.samsung.com>
 <26dcd0ae5c87a3ada5710b14b6894ef343cec6fe.1785274111.git.asml.silence@gmail.com>
 <583fdfb2-5368-467f-a388-6d388859c995@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <583fdfb2-5368-467f-a388-6d388859c995@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 14:30, Anuj Gupta/Anuj Gupta wrote:
> On 7/29/2026 2:59 AM, Pavel Begunkov wrote:
>> +static struct io_rsrc_node *io_register_dmabuf(struct io_ring_ctx *ctx,
>> +						struct io_uring_regbuf_desc *desc)
>> +{
>> +	struct io_rsrc_node *node = NULL;
>> +	struct io_mapped_ubuf *imu = NULL;
>> +	struct io_regbuf_dma *regbuf = NULL;
>> +	struct file *target_file = NULL;
>> +	struct dma_buf *dmabuf = NULL;
>> +	int ret;
>> +
>> +	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
>> +		return ERR_PTR(-EOPNOTSUPP);
>> +	if (ctx->flags & IORING_SETUP_IOPOLL)
>> +		return ERR_PTR(-EOPNOTSUPP);
>> +	if (desc->uaddr || desc->size)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	ret = -ENOMEM;
>> +	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
>> +	if (!node)
>> +		return ERR_PTR(-ENOMEM);
>> +	imu = io_alloc_imu(ctx, 0);
>> +	if (!imu)
>> +		goto err;
>> +	regbuf = kzalloc(sizeof(*regbuf), GFP_KERNEL);
>> +	if (!regbuf)
>> +		goto err;
>> +
>> +	ret = -EBADF;
>> +	target_file = fget(desc->target_fd);
>> +	if (!target_file)
>> +		goto err;
>> +
>> +	dmabuf = dma_buf_get(desc->dmabuf_fd);
>> +	if (IS_ERR(dmabuf)) {
>> +		ret = PTR_ERR(dmabuf);
>> +		dmabuf = NULL;
>> +		goto err;
>> +	}
>> +	if (dmabuf->size > SZ_1G) {
>> +		ret = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	ret = dma_buf_io_ctx_create(target_file, &regbuf->ctx, dmabuf,
>> +				    DMA_BIDIRECTIONAL);
>> +	if (ret)
>> +		goto err;
>> +
>> +	regbuf->target_file = target_file;
>> +	imu->nr_bvecs = 1;
> 
> There is no bvec backing a dmabuf imu - should this be 0?

Doesn't really matter as it's not used. It's 1 to say that
it's just 1 contig segment, but I can just zero it to avoid
confusion.

> 
>> +	imu->ubuf = 0;
>> +	imu->len = dmabuf->size;
>> +	imu->folio_shift = 0;
>> +	imu->release = io_release_reg_dmabuf;
>> +	imu->priv = regbuf;
>> +	imu->flags = IO_REGBUF_F_DMABUF;
>> +	imu->dir = IO_IMU_DEST | IO_IMU_SOURCE;
>> +	refcount_set(&imu->refs, 1);
>> +	node->buf = imu;
>> +	dma_buf_put(dmabuf);
>> +	return node;
>> +err:
>> +	kfree(regbuf);
>> +	if (imu)
>> +		io_free_imu(ctx, imu);
>> +	if (node)
>> +		io_cache_free(&ctx->node_cache, node);
>> +	if (target_file)
>> +		fput(target_file);
>> +	if (dmabuf)
>> +		dma_buf_put(dmabuf);
>> +	return ERR_PTR(ret);
>> +}
>> +
>> +
> 
> nit: extra newline here
> 
>> +static int io_import_dmabuf(struct io_kiocb *req,
>> +			   int ddir, struct iov_iter *iter,
>> +			   struct io_mapped_ubuf *imu,
>> +			   size_t len, size_t offset,
>> +			   unsigned issue_flags)
>> +{
>> +	struct io_regbuf_dma *db = imu->priv;
>> +	struct dma_buf_io_map *map;
>> +
>> +	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
>> +		return -EOPNOTSUPP;
>> +	if (!len)
>> +		return -EFAULT;
>> +	if (req->file != db->target_file)
>> +		return -EBADF;
>> +
>> +	if (req->flags & REQ_F_DROP_DMABUF) {
>> +		map = req->dmabuf_map;
>> +		goto init_iter;
>> +	}
> 
> O_DIRECT is checked only during registration; we should recheck
> (file->f_flags & O_DIRECT) per request.

Nobody should be able to clear O_DIRECT, unless I missed something?
And fwiw, io_uring wouldn't be the right place to do it.

-- 
Pavel Begunkov


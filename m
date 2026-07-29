Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ABA44BCB4
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 10:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322195; cv=none; b=nNx/CDnie0aV4Ddy8jcMe0U3SNHxdDXu4B0hdneKtTc7vhwCPG8hFm9Sdr3UILLgKgy/hT9xLulFIwZ9nBEe4N93dF1O6AEDuoE8iizAluIGwUkfXJAGZ1sAYvLI3N1oJz6JgzEGlVYvCQoWAYJDE1Vm4Y2KjfxGAImxxXYVfpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322195; c=relaxed/simple;
	bh=iNi2nFSA8g81W+/HnLXlWmnLlyUILEZvQTRGox6oYII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Brfamh+w0vibd9GE/ia1nZLFJ6YSpWNjPPW1+WB4OU8cgDsKsj4cX2cX+hkZ3EVJ9X7NtKA+j8OPSs2dulNdyrMMHiHqWLP0Xqs+azkqn3+Y2P9m9xyMb0b28KiUR6mtLLONS8hG7BkGcCcfg/q3RhZd93BC7W5Rv+LNFglOi7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s6f7Plz8; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s6f7Plz8"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15b1da6b82so79999966b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 03:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785322187; x=1785926987; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3xVEH4RvIZup14rRYV4Zvxl83sd+HTGGj/jXhd9ySH0=;
        b=s6f7Plz8hCZXfh5yIrDR0xQ3OAAJW6lfJ2nNCx9b0/4iAG0GjMrmw0T2rVHZYMI3hC
         ogOq+pzXWmy0m4piruY/4MCQ6T5/GjyfZFStJ+gYah5OmM+m1d++9jRz/weyos5l098f
         FKfMfTpcSM/RQ4KFk7bZuZtsZrdsse0K1beCRAdbe3KejCBQse+RNHSN7A/poayBldUY
         qHhGuPV6sNvmWF3VcHF0EaKge4A0A3Ypobo1f3LEr7c7xqOluLhscdDkMdcrVLONA7yh
         GeN3q6i/ptpHpfZ3AghdpxRH9Iqg/z4mdXe7W5VY1LoT6bi8nFV5VNT3iV8ElLNkLJbG
         UoRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785322187; x=1785926987;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3xVEH4RvIZup14rRYV4Zvxl83sd+HTGGj/jXhd9ySH0=;
        b=gVvb+oK6xoiGzgmysySY0LAquvekLKZkK4kC1VCgG3au1Ng8QHbkUvbxJzrEiTOqKq
         6fQ23UwsiHntM9Selu8r1dGU9gIPcPO/qqpoG2iydmuhW4pcQ08TjeSD35JIrFZMTa3T
         2skNuuo2ojG1yKCIOLUFnI+u2YkNCCsz1vPUOlRbCc0n6VPyUuVjiU6hPfgaNB75uOkw
         pUl/8i4x6nmo//kXrzX3S5tt3JsUj0wfOkdaKVs5wgWSZuS4pEMtpyqb3RYXUk/tXxdx
         /3s0RWfWrQdBuBNKrQe/owQjFRH1y/WBLvBcHq80S9w9JY3L+M4VB+fBSLCMmcKVF23W
         6pqQ==
X-Forwarded-Encrypted: i=1; AHgh+RqGdjA7nbyLCV3cs42NjZXblqhcMbDZ60vzgDMnySNacpQ5Dfxkxn8tXbvz3B/wBqtFliybeJLv75rDng==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ3KQ//nvmMFFFB6zomRM0FqO6+cihsWGzN4pEFPCJhNoqwJGn
	/xUkHzOE6pAF287TF44biCuK6nmruuDSMieJz4HCbApDwB/9zKkzsSME
X-Gm-Gg: AR+sD12QO0FuKXSljCe+lX2SS2QJo1xDimpW2XZHZ/u28v/heH/3r1ImD8kLl0vCnTk
	ei4H1+fdM2RgtATWLtsL2T63moSl1+4VKXcx4FlX2Xva0cUoY6VkuMlavUSp5ysIr2xCz/MiLZH
	wo/85U3DsCGNO7k6SkyVNxoElWjic8G8qde0rFVtn13Pe2BdYBvxVRbAW1yjGAQAgnzDekv6DH5
	6CUKv4Xref59NoyfPiDcaTJaJoBVnc2gNqZruK6wLVwdgF03i/Z0ovaYDHDvD3K+QMs6iLNPOyP
	hBtA2snGVqu0Qb42GPFJSBRB1GDEGNC56NCmcjslZ4u0j5vnqYj8+p6fIvRwWOH2I+S6MkxVBcF
	GJlSNoDacma/5ciVJppDli6fpg+IDe96/rSvq4YN+ZgajRbIAoT/oXYjq+pLVOXi5q3WJtIwBMw
	Ww8PtgA1zE8f2NQMRUuoqyv2HQrrmLzwAxL6iY5wPR0hYKmTKVfJKD2rE/nRjsx2tj6ovj0sLB3
	bVef7dQWJ0dtbqXrU2N6NtMa1Zw3oTb08aeZ4jGx36/D8PuV98lc0R7vCmzH5wjMOZ4S1I8Wv/u
	ON3tqhhQ/cJopxfgaTGXap10ZFHF1w==
X-Received: by 2002:a17:906:fe47:b0:c15:bea2:d209 with SMTP id a640c23a62f3a-c1f7215dee1mr299738366b.4.1785322187169;
        Wed, 29 Jul 2026 03:49:47 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83d27f47sm97965566b.26.2026.07.29.03.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 03:49:46 -0700 (PDT)
Message-ID: <c81be43c-2fe3-4403-b8a9-dd19855eeb58@gmail.com>
Date: Wed, 29 Jul 2026 11:49:36 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/14] nvme-pci: implement dma_token backed requests
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785274111.git.asml.silence@gmail.com>
 <19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
 <20260729071048.GH9534@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729071048.GH9534@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 08:10, Christoph Hellwig wrote:
>> +static int nvme_init_dma_buf_io_ctx(struct block_device *bdev,
>> +				    struct dma_buf_io_ctx *ctx)
> 
> Please stick to two-tab indents for function declaration continuation
> for the nvme code to keep the code easy to maintain.
> 
>> +#if defined(CONFIG_DMA_SHARED_BUFFER)
> 
> This should be good old #ifdef.  Same in a few other places over
> the series.

Going to apply both for v5, thanks.

> Modulo these minor nits the patch looks good.

-- 
Pavel Begunkov


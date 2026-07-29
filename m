Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C1142467D
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 10:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321453; cv=none; b=srlQSGhyDD8lPfkh1WfjJUD2rOFnArgbRj2EVD/rWq3Pdyzmcgs7jzFTDt7GXILpiD2k5dXGCSk3HjT0oWcWul9hVvK9IuAjE77sGfwETE5dPJWAyXysdKMpRJICRd4Ny6YgrvTbZ0M1MkTW0E3hHxlLMr0nAvvK1kOOy1iTfDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321453; c=relaxed/simple;
	bh=KMDBHWwtyZpTu40an4MnGq08B+PKsj/C5jew5swtPtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jPtbFwG5JU6T3GwBqC2GKGuS7by4zZVu7QB5+HnhcRqrpDI2Ss/Hl+N7vaBMousDHpfOXvhXGvJzZ2Dt18nNst4IhkDT77sNjaDsVzVf3sKEt/N1CW8SDEhNkFkvqq6cyBQ9ZUHZ/zHg2hcvv29+kyIi8Df6/G/j9z80rsMDfoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UQuApLte; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQuApLte"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69f7fa1c548so1134865a12.2
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 03:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785321450; x=1785926250; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p8KbmJYcU1SAlCdU+OP1hBT5okmuW3fRl/0GYAxB+Rg=;
        b=UQuApLteJB9kKcT40XOCwRqmqtd9RC2KId41eJaievdgrQkAkYSBBD3tGi/u/fez2H
         wEj2YyP+qYvRZa4Xtb8VcOAWrjOaeRZICTY9aIFaKTVNuRWxM+CziTXGSrcKYbSYG6NZ
         y4dx/mcV4IB2wRg7eosVnKv9HjbGYw6trbjjsQXNwJ7ddaVp0aqZSyyvGyhhhzks7Aag
         9AB/FWkuXdmVgpfxoSsRPTW6Y25+o4N6kZa1DfBxZefcNyFwXULJk8t2as6huleg4iNM
         gL+plUqY3hdAwGxRONuYMqTwo7vM0we09dnFCaHO01nkbW4UsbTgf4dRtgYw1fJ3wLhF
         KgSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785321450; x=1785926250;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p8KbmJYcU1SAlCdU+OP1hBT5okmuW3fRl/0GYAxB+Rg=;
        b=CPPZ1EIXYfJP1eUfAbCp7Qq7B7xowx6fk0ARD9NA1MQm4781NljR2w1WzcY7CRLMJR
         i/3jf/CiOXTiPbPXX4NCWg4Nr/QIusW9l/ROLKOxlnJL17joqN22IhPgD0ucBkVwYtEy
         V3M/QeHF7HJSA4A+fiRHsPyK9mV8anieBPLms/3kO/56x4G8AIVRf4ww3+xdi7OZl1se
         TDtQ0DB5hGEcY9aak6uzoNi4qEbA1L7gT7VOG6vdWv6dKggCCPxxi6MBwTonYWhwdcbI
         mLjxCYHARE1k+rENyW6p6S7Np2Ajcmo4kr9ztnQidwqjjE+Inlsvydgocvh8sTyEpn0s
         i75A==
X-Forwarded-Encrypted: i=1; AHgh+RovjBS/gazOaBRAWX/6Qn7fTHKofPguyjUf8xrXWdvkDoNFddLXcdOMf44yWoKCB32tvX6TmYJ7VmO05Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQIP0aR5p9Jwm+m1f4T4Ayujr+5gjzR8ViRgokt2GANrJKPksC
	awHYIgNaHLDxxEkNdq8NMYP5dsIvAxNBXNy3SU8jw21EnkziWokT2PHm
X-Gm-Gg: AR+sD13TpVr4o5wXYTEZkPTI2hW4FiaS2cJOxiPSX/6EijHjaqMrBWnP+qGp3IYfhOQ
	vkPtDFGXHrO6tPe9rF/zqMFiNrT6jHFCYYn+tAIQtr6QO6fMSiD93xgnrcRtv1yWBHW/SJZ7plE
	o9iR5OrN1ammpyO+a4BXpILXQhvD8RMUUQiYho5laQPXI5HMTEBWF2RGaCIEeeti5NB7Lzi2hLM
	hnjWDN+f2XEhQRKoCgpc2p8HY8NJIiofDpK4eIFqcdHxLpWGelJtbhZwXDyQnV0f3YlXuJwPVvP
	RRTKCYBj/IB04L0qnab2JABYFg+eajZAG3yZFe1UZOfCiotmKOxf2zR+xD2EXDlbclKcoHO3uP7
	7q37vHDW38p4F/iWTgsRxsThDXCW/sMH0/8JGYJuxViTkeQzPB9Uu/7zPTtOo8lOUKBaa8V8lSG
	y+IH1TNEDWXytSi5gp+3cmJbW5WxShCnIPFs4+wpNriKb15qzcftRPI+f1YptpT3DD9HYshOHqY
	DcOfvxib5WpB9Su8v25+mNzOwD60e1mMrd1pAqN+3D/ljIMcBiTPxakeSVCMaS0DFBJ+IpIl/hz
	gRcnLQHKbNuB+h6YL0A=
X-Received: by 2002:a17:907:9617:b0:c1c:62b4:1ebf with SMTP id a640c23a62f3a-c1f721913ddmr365145166b.60.1785321449861;
        Wed, 29 Jul 2026 03:37:29 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f84026c47sm93918766b.63.2026.07.29.03.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 03:37:28 -0700 (PDT)
Message-ID: <340dd033-2a45-49e7-afd6-95dbbbf624da@gmail.com>
Date: Wed, 29 Jul 2026 11:37:19 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/14] dma-buf: introduce initial file I/O
 infrastructure
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
 <bc20381e8daf85ac58811c344325d8192cde9d1e.1785274111.git.asml.silence@gmail.com>
 <20260729065927.GA9534@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729065927.GA9534@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 07:59, Christoph Hellwig wrote:
> The method name feels a bit convoluted, but given all the
> previous discussions I don't care too strongly.  I'll leave
> the dma-buf side review to those who understand it.

I assume you mean this:

+	int (*init_dma_buf_io_ctx)(struct file *, struct dma_buf_io_ctx *);

I agree, and all dma_buf_io_[ctx,map] look clunky, but I don't
see what I can drop out of the name. Suggestions? Maybe I at least
should make the fs op sth like "register_dma_buf".

-- 
Pavel Begunkov


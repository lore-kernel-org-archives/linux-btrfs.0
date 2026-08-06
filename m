Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2733C40A93F
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 12:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018899; cv=none; b=WJqlYM9F9iRgGXOQs4epq+uQutfR6QA+kOyRIIPXU/xewAJ0GYAnejyZb3ew/KUFiF3PL526im6zT7u6a+xm2wODgUHIdyWFSm77K3bRE/BIs5WkaENB/ekw02FI5f6qWB+8zshsBieSpR8IYUjOyhNZRxtguUABLuSd50MM/mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018899; c=relaxed/simple;
	bh=TTiHlStxZcKVKrwqcuDMLj38rBSP7TpoZoQlRZGLyrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZCP+h5G751szhRTwHZzpvyRSKO35GpSs0TluZPViUN3A5Ps47ptFjLtnqYR+A0C+NJeK7LkkcYWe6U+d88S0ukrn/hxvyV4Pgf0v6Ig7Unxt0mxx30mQxluOYhBWGVlliLwNn8caic0vsQILIJvdARsZinCyZSdbQEKQ18wFrcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XJn+DDkP; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XJn+DDkP"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47fe377a217so1424796f8f.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Aug 2026 05:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786018896; x=1786623696; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DfDlnjwEjqQiBft6//i9aWDA7+Wxp9IrqsB/3Fhaw40=;
        b=XJn+DDkPJjP/V2NYxQMNMiUSztdxL5BX3WbOePcGIWTdGsldovqU+YfLJCrgljR9wi
         Y7Zz1/sSG7RzzLYA2LPhGo+cnU6cJb9RbZpDL23FjZFb+K4qZGkYxZJToxsT0UUNh/da
         4gSd5ws2QvWA2bITT/VCjrmjCHJzcr07+p8KF1EhyRnckQU+Fjc8duNsPqwMsXZLrnJw
         8XeSVdu3KCL8RgMkdeKpLnPdI6TcVjzcqv11BdjCHvpdXY4YJW9NTiepW9CXB4dA8Ml1
         3OATNWEVAQ3M8+khX9YopaUgISPtmr84CTmTp5pvcKP+jJCJPvR7s8sU9HZX6DBjg+gs
         W/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018896; x=1786623696;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DfDlnjwEjqQiBft6//i9aWDA7+Wxp9IrqsB/3Fhaw40=;
        b=Wze+lMtmVL1T7QNKsDulwpKD6EbIjPtXYomi9VPNhVSsq5UZ+12mepoRXfxZlUDeTc
         yxETeZ7SH6O8XIDlCbjPIA6r8zAuUq96yWPtusMD6NAW/D2aJDYH62JPXZq9PYfh9oGL
         BWdO56TGJnEwsIP3Cb1uhvUo8qYx2wZip7FEQankEDiVxOPfV/NjMr7B0fNdVFns8ZmI
         zlY+UaTt00vw70mTZ3LdVOLSgtXiWwz6E5FcL6lrOBLavYVooBeQyi0hYyybc4DLa2on
         VAdz26dQ1tbw7HrlBpP9sBT3FzkU5x1GhpTjWIvIVtM+b9FBloNBAW9tJrC/6+EtrS2z
         v6pA==
X-Forwarded-Encrypted: i=1; AHgh+RpwiQHZMDicfcLaNuXZlFRdzch1SpQJ88LFi89zaO5tzeATXfHrfOIIPpjOXOf8jUMtS66l3W/MMivCOA==@vger.kernel.org
X-Gm-Message-State: AOJu0YysyvfoBMB7HSCxRckpI3K8Dvxreob0yZX+Oz/X3ou2g7tkx/f1
	bXXZYlY5hz3SnZ3KaKQxl2Jl+TvLWUIjiEIc/JYsNbBY+3S1afWJdS3j
X-Gm-Gg: AR+sD11SrTHrCq/YIfmQ6xEWf6EjRXs5avuFhfQBIU6a5b47y8r9UhTR88CwVXTrvcP
	cxV3Ki/fQi7Tno8hpc1oR56xt1s5TLne6tCsChiNSSSuLpmmSKgUh4GiKoru0ddzh+ibD3mKkas
	x7FaUTbSjRV++OWC1bZK4+9XHaCUhMXnF8RbHF9ez+5VjRIK+3ppVGE0ubvIiYrNhYjQuXCLM/B
	qUzOPVLf2lb6+lYKkvpsX5GnYcNUuDly8qo4gpgjkmgPo3NAvAdg72HOsMFT5OS1g4TOWOAOwgN
	Tg9whd7e1VwrdZrZkjtozF1LEH6Dwou1BbV0YKjzoBpm8zSTBDEqE/1nPoPc7weqHOdE+rsTkBM
	QTiaVf2e7hIxcOANjeLArngWfdGTW22x4paB9FXWWaN4SmZpamwN5KOOTVTRvEC8Ra5u32OYBlk
	fcn2Awg9d1N1M7cYOfa3mespEQqK8jRNEwwjYKbq6xLXLdDf75dP0VAFd4Rg3OKt2JwVgt5vyiV
	ati2ZlaVA0soHGBEBX5us23IBYQGBtjdzqvpdmXTb7Pi2f6EhCWGjcklL5YtwgoqnQZkr1pmZ76
	1hhlhaKi6gAyNYGfvyBaSL44rnEJiziDudrrkg==
X-Received: by 2002:a05:6000:290d:b0:47f:f42e:9715 with SMTP id ffacd0b85a97d-47ff42e974fmr10864047f8f.12.1786018896398;
        Thu, 06 Aug 2026 05:21:36 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b32492sm5927425f8f.35.2026.08.06.05.21.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 05:21:35 -0700 (PDT)
Message-ID: <f47ed617-5ee7-4259-9f5f-a6fd0f5aab24@gmail.com>
Date: Thu, 6 Aug 2026 13:21:38 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] block: rename bi_bvec_done
To: linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Hannes Reinecke <hare@kernel.org>,
 linux-doc@vger.kernel.org, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/6/26 13:19, Pavel Begunkov wrote:
> struct bvec_iter::bi_bvec_done is used an offset in the current bvec,
> let's rename it accordingly for better clarity. I also plan to use it
> for non-bvec based iteration in the future like dma-buf, so drop the
> "bvec" part.

I have this patch for the dma-buf patch set, but it's a very noisy
one, and I've got an impression that it'd be a good thing to do
regardless. Hence sending separately hoping it'd get into 7.3

-- 
Pavel Begunkov


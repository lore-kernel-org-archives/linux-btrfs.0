Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D544749DC
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 11:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324524; cv=none; b=ksbMqEC+G9c3VWtf2Th/sbEe0sxEC9qEdiZFBl+BpEHRgZI5GQ7t1QDtwjkxg+Kn76D9UjN8O9VbxPP91mMvkDGja2Nk8vDN5Bd2nvpV8SkMXZ5DnG52/UvuLLA5UMfjVIHl0EbRfqNqUpv8hwkZbeejGb6wfUOBH0uJxBg9CsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324524; c=relaxed/simple;
	bh=c8bXkSao9MJ4kDOqs6oXQ3HhNP8HUICfRxyNML/BlEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hnzOQVwAiPxX5vYiBYDRxjw6+Qqj37WJ7nW+W3M4v2xRMO+cJyuvzBb4+tBBaNrCJKc/KGEg/KBd2f0vwu0Q04+nhaSJ3Dpp0kCFpZYTsydR8tmNSdzKlQiKNXUafxLGFRtkObnwiww0Cuo29QB2x6orDoQndZ60hSuu+n0LzQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vkg4Roxn; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vkg4Roxn"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c1f758014b8so74786566b.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 04:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785324520; x=1785929320; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LDeRfN9blSLpZUyGDvy3JYR8gWm0jeyVXT2Ay7oVK6c=;
        b=Vkg4RoxnL7SMMdhAff6n/vIOD+Pc3C/D2bzK4+xOfQr5JJzbu2Nzj2OteytHhygSU2
         2qcOxRr0/unoHvtpi8ruamO7pvP0unzfVF4THkhrNVNBt6nFOzGNIYDPJ4CTyn30aDTx
         ArH3rJa2/Si5ZeDm3EDHg/8cbytqnImUoP6J5guGPJXGEvkKppTDiJaSYm72tJN4N6y8
         niAVdf9dPY5QCiHcVDYsVReWc0cxc5kw5zlKF2EcyZBHMw7FBIdLDuScoqXWL2thfpGq
         bP1JNt9kscBaNxWdYTTaQNDzBwA6z6f4BIecLNChO0Nth/vp8MRI8U88JbxmPS936owP
         giMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785324520; x=1785929320;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LDeRfN9blSLpZUyGDvy3JYR8gWm0jeyVXT2Ay7oVK6c=;
        b=gseqYJn5PK6zrfnPmKui6Q3R977pBr3XZSOqZxmo9QQ7JdjK3076g+f3F+f1crYCpb
         mPu5biA8uiadUV9mst7AjBUzy3UWsJL40SuksKPaN8Vy/WIaNqeC079gOoCNpR1tQ4mT
         Ydsr0IWW1vyJy487CdUpHTNRLhRnID2OrK8Aul9ayS9dVNj3Rpt+XIcPL0tk9/aRhHGz
         H+Sl1Mte0F9oaZn7JvrsOjE+G5kwOY+YW9BuMh2qA/moYLQSf47PIQwVz1BPuAid2Hi2
         43qtU198tfb9x4serPsWuQZXHm8djJPGsbWIAfauLTx7PT0khboWzs0EQmxTrFGcTK6I
         jJKw==
X-Forwarded-Encrypted: i=1; AHgh+RoeinTuvjHSVjBBd/br0V2pKV2d0DJ7qvQpPU9HcbOYAXtv8jGloURUh1UlWchmPtA1b+i22smSnUGq9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiYA2rFlYpykcUlu36hDvxFmpDZI5Kd/uiOJMu4EaPhpi4Z+L7
	RbdaAHQ1IpBfX2kACSDQXOpXR69wNxYSCI7bsdPuxfR3P/cLEbHTKRqC
X-Gm-Gg: AR+sD10VpeB2x+NhoDIlfhu6Qvn5UdH0Moylvoz0LS4m1OYEwHeS1X8/jfuZ0TIenDw
	YlokV1HtchIWhaqh/t51xuNSZZXw+Wf+FuwLteFGJQWNln757K5WPY0Kkrs9zd1ddWFwggcGJ5M
	ZRT9yk7Dl3LfzPcM34OIRIJZSgUnB58R+B7soFse8+O3juLnPNrS9lS6CaOFdGlDapgZ5n5Iehi
	klfmNQAu1PrQo4TtiUTDWrXozKRGqkUQy1WL8ztfMtobBPfsM1bMoQQdWspeRP4wOzjy021hprD
	EvkKRHGzb0BBMCtzuFCW9uu0FP3JUNxhrDv4RWnSF8PerPOzqhBhqVfzzgkV1OYXXc/asoIJb2a
	KYuWQdTRp6T/YGM/kOQ7m3FXuZGKCAvh0bPkSgKCQ1jNepmZbquoO95cMCjT7T4WQfyHDKZpd+/
	RILxrPsmYpc5JgX0TpXsuOBrjyFijNqiJOyJ84nmlThlqgzkQPeoD3CqX/zaojSj5fmlP7fj/UC
	MYGFpw2l4g1hcuKj9UeohG6A4d3Tsib5647TzvPlYz8N/HZcBQ1CsrZspB1YS9fI4y2S9StTHO5
	Dh6L
X-Received: by 2002:a17:907:842:b0:c16:5b3f:52e0 with SMTP id a640c23a62f3a-c1f72147104mr346195966b.38.1785324520387;
        Wed, 29 Jul 2026 04:28:40 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83cea5f8sm100629666b.24.2026.07.29.04.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 04:28:39 -0700 (PDT)
Message-ID: <872e7a5e-011e-4415-98dc-96c9066b0614@gmail.com>
Date: Wed, 29 Jul 2026 12:28:30 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/14] Add dmabuf read/write via io_uring
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
 <20260729065421.GA9468@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729065421.GA9468@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 07:54, Christoph Hellwig wrote:
> Might help to say this applies to Jens' for-next branch for those trying
> to apply the patches..

Ah yes, and there is a branch as well:
git: https://github.com/isilence/linux.git rw-dmabuf-v4
url: https://github.com/isilence/linux/tree/rw-dmabuf-v4

-- 
Pavel Begunkov


Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4AE3FADF6
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Aug 2026 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785863963; cv=none; b=XR12G5tfOqGrn2SmVGYlNCsKPDOgI+RCVmJTCrSRKzQCA0XJModlnCvq3g7k2nORYJkrrncxCXlnFpzM5GbuTFCwFh7CR01b4ZZkRwiTd0veiBqp5cvY7yiBzM25n7cxb27rtbOtq6qfZ6RYngcCcXibFADmdeldGWGFB1SkCVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785863963; c=relaxed/simple;
	bh=fiynAW9WpUzgt3N4BHN/WeqgVQsTYwv6Egh7edSdGZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bebPvdwOG6bBJmRQr6abdOhsuxvLAKVjDqPwbVWImxGCmdl64yl/rW6b52wM9SxUqcWAbrlxDRMioXNTGJ77dc/r1dcxODx4eGRdOYn0w9+JAOy6EHunZT7bMwxg4qhCW2SrNwdSY9D7Ew+ePcORz3bS4bYXyuJzBfvfvHV8ZoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gB9JzHh/; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gB9JzHh/"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f92e3c14bso54056f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2026 10:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785863949; x=1786468749; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kJpsobbV6cDtzB2hYIU7sj8yXmkuFvAex2Z4hVps0ns=;
        b=gB9JzHh/xNwbsxwl/HtsyKUVQn66uJpc4fGE3xWBbRBF8Bj789qpQkHuQYRZUI1uZH
         y1ATPiDHs+timfWEFxnQ8qOmZjfmmj3xYlVR86qIr174/WUoTBm8CWOktDfOtHh+vEqo
         FY7kiI/3/FOvVzA03rCNK2f7HteezMqmQ/yylnkzHyLH/U1gz6yngtU+KTnWdrdMlvY2
         +SSMhgpAcY3pILj1UPd1xvW/yHxQFHlVeFWGr+ikEeeL+JufTVT7HIo7ghRoQCOubnyt
         juvM34xc6zLxIMGU01B9wEc7AUyyF6GPpYwVIJ6J3IpHXum3mOowlhaN36AJ36Z1POyc
         EhVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785863949; x=1786468749;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kJpsobbV6cDtzB2hYIU7sj8yXmkuFvAex2Z4hVps0ns=;
        b=nlsKSEzM4xyaAZuDtm8D2ak9KdcIXIDLrBNBi63cjjzdL97/GsKcNpYPGk7VYNJKb9
         HxjTAWtPHvu98Ica/Q9kFYDL4AYhpigibk2hqaM4leliB4f7d6LR+sGPd3eMk+iBr+as
         JuWyEiRuqow+z2Jqx+vtqRhjIqnrinwLO2BEyD6c/hbgoCymzGnKqII2tIKyGNUT76pm
         DDuwPJDeCXsWDFkeQrlcxkFlcNQME40IHqI4Tqt2GeYlihxq0KGLC3iZZuyuTVotPpMr
         BtOXV/FWUtySu73j7/WBMcY3Fi34OI+wjFy2iHkf91knFsHbf1FPWPbmJq9pLwEdvn2P
         Sljg==
X-Forwarded-Encrypted: i=1; AHgh+Rp+zFI+iEj1fk3yXEuviL+KCM7ck2Ts5ZBr49LqjM22dSZjsi6f357MgVRHIm6weyWW5YeHt9dK1ixVIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YycV05kMh3CD5x75T1Pjgqw8VjuYqAPLoE6Fz8veORtM3trD5qg
	nOobjOPyilG37uCYs920DbTe5f+rYRFcYnd9LUY2mJA3b44MwRv0C+i9
X-Gm-Gg: AR+sD102fSWi7XVm5LqirTx0XDVt8qSLBp3kSkwCXfx+C9e+numY/EM4yd43SqJbMtF
	4d6k8tjlUOQyfFoiiGu8VciL1W0r+yTjlgISu+6+Fh75uuquRzIyXdQ2qDjWCh7nvTXqSN4GPFv
	9Ck4TutcpW/J9WfQUWq9cEX5RBuZU/YjscN/hqacm08MInThboykQkg4FlBwT9DLCvX3kTPntSP
	cwCTLo4Bo0Q4qbYKgCyp0esMImSR8BTCV2NjbgxR2AsP0aoNpht6pv+5Lkoe9EnXQwSLR8ETTO4
	3Y5yQSI+mHqXZNI4v2L2oBR0K/jterXxx20iGJsgvSfZO7su5nYSoTASUmKYGWr69TVNZstGSPm
	AVvXwehrVaUBVhHtfDX+WvmqzSMjlJxxH8ite9aI72QFAwm16ja0FPOSM6JVvwbZ7HLClkYdgDF
	eT7irJpWVXWEYhIs8y3vzaon0yzdbdKLKQCSnOGUuk9bmQMX1og7uXwjOIo6oKzApE1saWWG7bn
	RioDx718WV7+8Dpas+0M6/f/XcHh/2JVApgDOwshgJ10CGgAzEqzDc0zcZwTrWojEX9DEKOv0hC
	UVExJA/cV7q+vA+V1r20WH/suA3FqWbf4o/5Abo=
X-Received: by 2002:adf:fe49:0:b0:47f:941a:796d with SMTP id ffacd0b85a97d-47fec4fa3admr1381301f8f.12.1785863948785;
        Tue, 04 Aug 2026 10:19:08 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47febfda6afsm1357370f8f.3.2026.08.04.10.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 10:19:07 -0700 (PDT)
Message-ID: <38163009-770f-4596-abe2-249efc113f59@gmail.com>
Date: Tue, 4 Aug 2026 18:19:02 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/16] block: introduce dma map backed bio type
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
References: <cover.1785596451.git.asml.silence@gmail.com>
 <e26aefbcb383be7092dc76343ce745013e671334.1785596451.git.asml.silence@gmail.com>
 <20260804162440.GB12292@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260804162440.GB12292@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/26 17:24, Christoph Hellwig wrote:
> On Sat, Aug 01, 2026 at 04:46:19PM +0100, Pavel Begunkov wrote:
>> Premapped buffers don't require a generic bio_vec since these have
>> already been dma mapped. Repurpose the bi_io_vec space to strore dmabuf
>> maps as they are mutually exclusive.
>>
>> Suggested-by: Keith Busch <kbusch@kernel.org>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
...>>   
>> +static inline int bio_split_io_at_dmabuf(struct bio *bio,
>> +		const struct queue_limits *lim, unsigned *segs,
>> +		unsigned max_bytes, unsigned len_align_mask,
>> +		unsigned start_align_mask)
>> +{
>> +	unsigned bytes = min(bio->bi_iter.bi_size, max_bytes);
>> +	unsigned seg_shift = bio->bi_dmabuf_map->seg_shift;
>> +	unsigned offset = bio->bi_iter.bi_offset & ((1U << seg_shift) - 1);
>> +
>> +	if ((bio->bi_iter.bi_offset & start_align_mask) ||
>> +	    (bio->bi_iter.bi_size & len_align_mask))
>> +		return -EINVAL;
>> +
>> +	/* single contiguous range into the dma-buf */
>> +	*segs = 1;
>> +
>> +	bytes = min(bytes, ((unsigned)lim->max_segments << seg_shift) - offset);
> 
> I guess ->seg_shift is some sort of encoding of a max
> segment size?

I'll add a comment.

We rather need the minimum segment size, you can always split large
ones. I calculated it even stricter as the least common multiple
pow2 to avoid divs here.

If the device supports N segments and we know that each segment is
at least M bytes, then we should be able to issue IO of size N*M
of full segments. The line above truncates the bio size using
that + offset adjustments.

I guess it might be more straightforward to calculate the worst
case number of segments and then adjust the splitting size, but
since we don't return the number of segments it's more
computations. E.g.

seg_size = 1U << seg_shift;
nsegs = (bio->bi_iter.bi_size + offset + seg_size - 1) / seg_size;

if (nsegs > lim->max_segments) {
	nsegs = lim->max_segments; // unused after the block
	bytes = seg_size * nsegs - offset;
}

-- 
Pavel Begunkov


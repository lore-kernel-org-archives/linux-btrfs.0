Received: from va-2-49.ptr.blmpb.com (va-2-49.ptr.blmpb.com [209.127.231.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C077A26B2DA
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 01:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782784290; cv=none; b=RwSBCQfubJ0azS49FoNMpI2TKKyP31Gttg++sJKd0otQPzHCxhUKlTxybcogqvSLj0j4Zj01A22YYvYgRn90uTJgY8sXg7+eKuHbaxZArCsXPd42Z3tYcSs8jKAFg62FeKl2z/c7nrKSucC9FMd0EL6U80pKTQYLVmVYgS4edsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782784290; c=relaxed/simple;
	bh=v0Eg+2CpxUUtQzhF+u4Tp8m+PZbEldw36lEOMsF49v8=;
	h=Subject:Message-Id:Content-Type:From:Date:Mime-Version:References:
	 In-Reply-To:To:Cc; b=MX4Q6tbCR5au8ZPrVPQWykEE0ruX3fdsPjj8qxA8bmZRicMp9tVe9qoRCIXXrDFfggVmdQ+4Jwy85L91dLfyhnzIaYrTkupvqkDKeRaLY4NczuDoqLEY0mqqzl0nE9UMJ45xU8iEJqVlwpA4bkgagvrlnka4xGDHkBSbKVUGlj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=dG0Uxmhb; arc=none smtp.client-ip=209.127.231.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="dG0Uxmhb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782784276;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Yy6tIB1BiMmIIkBE/PNDUqkalBujV5V7JHXgMNn6eqQ=;
 b=dG0UxmhbLs08PNIs0hhIHtWj6YXL9UCFBHcqV9mnCQZR/g5p9eigHC1uP3VikeqOhO9OY7
 +to871B/rhuOz6qFJSFZ/vHjwhJyLBF32YhVwYYu4HwWNWRyBGiNo1RofqPzDwIjCHmLZA
 k8iW7bFHJV+pIjlpZdQrG8pyUNPkMUi//ATLuDI9zRmUsIM7lrvnVYcvEITiL+EGSvR0L6
 fqOiXo8UyAOx6N82SbKmQndfd4MX73EcNt53rxXFLV7py8LVdkUkrTApiKObihb+ZSyhyJ
 QWBZCv1ofFkAX93pCR6gQRDPJHwAiFadKOok9/Q2f1G/Egb4CH2jxeuheQ5deQ==
Subject: Re: [PATCH] btrfs: compression: allocate buckets with workspace
Message-Id: <d12006e8-538a-4890-b52d-43dc12704ec4@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.10.237] ([183.34.167.65]) by smtp.feishu.cn with ESMTPS; Tue, 30 Jun 2026 09:51:13 +0800
From: "Sun YangKai" <sunyangkai@fnnas.com>
Date: Tue, 30 Jun 2026 09:51:11 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260629002505.1552238-1-rosenp@gmail.com> <c6f9a5f5-0aaf-4f89-9e88-fb7eaf6aa3d2@gmail.com> <20260629230908.GB2398896@twin.jikos.cz>
In-Reply-To: <20260629230908.GB2398896@twin.jikos.cz>
To: <dsterba@suse.cz>
Cc: "Rosen Penev" <rosenp@gmail.com>, <linux-btrfs@vger.kernel.org>, 
	"Chris Mason" <clm@fb.com>, "David Sterba" <dsterba@suse.com>, 
	"open list" <linux-kernel@vger.kernel.org>, <sunk67188@gmail.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a432112+739a2e+vger.kernel.org+sunyangkai@fnnas.com>
User-Agent: Mozilla Thunderbird
X-Original-From: Sun YangKai <sunyangkai@fnnas.com>
Content-Language: en-US

On 2026/6/30 07:09, David Sterba wrote:
> On Mon, Jun 29, 2026 at 09:54:11AM +0800, Sun YangKai wrote:
>>> -	ws =3D kzalloc_obj(*ws);
>>> +	ws =3D kzalloc(struct_size(ws, bucket, BUCKET_SIZE * 2), GFP_KERNEL);
>>
>> It seems that size is fixed and known at compile time, and since we want
>> to inline the buckets in the struct, I think we can have something like
>> this to save one pointer:
>>
>> struct heuristic_ws {
>> 	...
>> 	struct bucket_item bucket[BUCKET_SIZE];
>> 	struct bucket_item bucket_b[BUCKET_SIZE];
>=20
> I like this idea, given that we know the size at compile time.
>=20
>> }
>>
>> However, each bucket array takes exactly 1024B memory. Currently we have
>> a 48B allocation for the struct it self, 2 * 1024B allocation for bucket
>> array, and 8192B allocation for sample. With these 2 arrays inlined, the
>> struct will need 32 + 2048B allocation if my calculation is correct,
>> which will goes into kmalloc-4k. Seems not good.
>=20
> SLUB merges same/similar sized structures for the named caches, I'm not
> sure if this also works for the generic slabs. We can add the kmem cache
> and so we can utilize the merging.

Oh, I've missed that. Then things seems good for me.

> The sharing can be seen in /sys/kernel/slab, "ls -l | grep <SIZE>". The
> size is rounded up to hw cacheline, so for the heuristic workspace it'll
> end up in size 2112. I see at least one existing named slab on my
> system, 'dmaengine-unmap-256'. This may not matter, but a named cache
> can fix the slack space in the 4k slab.

And I have

=E2=9D=AF sudo grep 2112 /proc/slabinfo
sighand_cache        593   1335   2112   15   8

on my system :)

Thanks,
Sun YangKai

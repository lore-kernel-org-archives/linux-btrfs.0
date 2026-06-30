Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02C935C19F
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782846012; cv=none; b=C/Zg5/aA86XetZXwm4G/iWDOlhfNd4k5DD8wVOYDOYr9cXJflYi5OkcM2wyFo41rOk/PhF10NEnVfx8O5o0AxcegRac34IXFfkCa8Qzlrk2G86djHu0f9QcSGmqcc/k/MVzZu6FaTXp0mF8qyiL8qv9ZkidLalx8rVp7shaPW+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782846012; c=relaxed/simple;
	bh=MRlVly6IwVEUfshQrSGanGM9XCu9NkTsRVEWk3QQIMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DERXY7HysmFadrAJupQ8XdfDkIqG/J21/svV5SbYjrJRwHsKFORMrBhAClgcdM/1TnT24TN4hxtdIZnKFQRtqdO7XXSbn6gqCvApPDCqvkJ+F6ETJTuutRH+MbOc7VP/niTUquX4KvDxaq8Ykjkn6cu4Ysp4c+vjPid/iea+tWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=niRcrtwt; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="niRcrtwt"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-69de16f5f79so2391029eaf.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 12:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782846009; x=1783450809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pcw0JrYae6holC107hwb8phuCW3lZ9aLQBkPPToEfOI=;
        b=niRcrtwt/hS8Lt34cEYNGldpCA8PrbnDzxh5h6pUvjltXa6Mh0UB8lS/PKjYayc8h8
         KNvklyySBpai1zAJwhKeDr7d0WgKn8Wf9A6E01zytFCMN9Qh5AVitsrlO2LZwtuy5VDl
         fBLmTeHOO71tTtL1yqdLFmWsGezzWFHnJlIAYUlqBq7fJYJ8mwrZdZYidRga9Zpi7N8J
         qFO/UZ9kQ3GfX1rhIVoJBR94cF7+qq4NZdh3c9SB7OXs97rE32KDbVR8alAFzy7o19c7
         M1PfhS11DjzqozR/Yj3mT1Not9M9dXxPprZAnXnEhJBAQKTUWdFBYNpVje2w8waOKwa7
         MTGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782846009; x=1783450809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pcw0JrYae6holC107hwb8phuCW3lZ9aLQBkPPToEfOI=;
        b=CbitE0qhhbLp+df4cTzGsTAWMdGxNhtQs6UNLq8Wlixy7V48tercGF9ri2jn4dYp40
         F9oTGUNc3T+RMPrAO0XMkh8S+XGVn6WvqAvGXJAI6U1OiQZAqUK49ozKFRay8zmtujPn
         6uJljoehp9cDMWFRhfvyGO2MZ60fkGZJ6r9GF3faeJIZG8HET5sWXU0R8/qlgRTuT0hA
         L35ZLMPN+4SMBwpoNotfahN1Hk+dV32tMYpq6tyEnjqpfM2Q1m6WZm/Byvmz6St8rZlu
         WyUifI30xYBjsNZCGheXSIPsr6gys9+nSNoq4c4A5xJkUysedgKa/Vc/+XCXtp+8bcxw
         7hRw==
X-Gm-Message-State: AOJu0Yz35MKZHPaQVqawM21XYYDGlbfpMRqIEvbWWCbkmemzg4VI92Hv
	sY0qN0Hz50RRxfUdVLoZpyGmqGC3HmXSYnONgePsBD0MSLO8egZAJmjKYE0DnF9JWKU=
X-Gm-Gg: AfdE7cn/t5MOcX2RV26rbmWUNTrMV2uSXZ/OIsEhD8INUjKKZJ2BlJ+LR1Fk6Fb840b
	GODKa6KGyaIuBBxw5Akj+0jmzuCEG0HKOE7iNulfHb7FmuhFsDr2IVfDvE2Ter7IkFn6GD00XKs
	b2kiYH/U6YPaHjCM09vlaUMVifmRjytd6+THBbldOIJMs9bB6QmAp+CGtAnQKq6qRkAU0k50Bvs
	NTLSkCt6EHO9SGgxJIi1oZhfX2TSLPM30McpRJCoqRTbLv9dDu+u/hPdnVl7B7NhpoTxdwUnuQN
	W8VkafJNgXuP8qNs2CQwHWz2UvpdYzKCxxDuNhek7zBcptkmSxfVZvrPRiAHC7DO0VXNy1kweYO
	147+SZRHZ1o/8lCd8igSuDiHHIhvhPptpNCDee+zsasPWAxgcc+lHXlX0iH+8MeIPOnXjur69re
	Px+nr7PYeoicPf29yuL51vYoiHdp5/Nuzy33Od+x5ZESZ5Tb2seE+GgFgvYOiR43NlR4ezsGQ=
X-Received: by 2002:a05:6820:4b06:b0:69e:57a1:8923 with SMTP id 006d021491bc7-6a18902e7e1mr3489458eaf.14.1782846008728;
        Tue, 30 Jun 2026 12:00:08 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a189173c55sm2896161eaf.3.2026.06.30.12.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 12:00:08 -0700 (PDT)
Message-ID: <8c8b9ace-dc84-46bf-8495-44bf2f2b0680@kernel.dk>
Date: Tue, 30 Jun 2026 13:00:06 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG REPORT] btrfs/io_uring: GPF in tctx_task_work_run after
 encoded read error completion
To: Yue Sun <samsun1006219@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260630091609.3414-1-samsun1006219@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260630091609.3414-1-samsun1006219@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/30/26 3:16 AM, Yue Sun wrote:
> Hello,
> 
> I can reproduce a general protection fault on current upstream master by using
> IORING_OP_URING_CMD with BTRFS_IOC_ENCODED_READ on a loop-backed btrfs image
> while fail_make_request injects read errors.
> 
> Summary
> -------
> 
> The crash happens while io_uring is running task_work for a btrfs encoded read
> completion:
> 
>   tctx_task_work_run()
>     mutex_lock(&ctx->uring_lock)
> 
> The faulting mutex address is poisoned:
> 
>   RDI: dead000000001129
>   KASAN: maybe wild-memory-access in range [0xdead000000001128-0xdead00000000112f]
> 
> The root cause might be a double-completion/use-after-free race in the
> btrfs io_uring encoded read error path.
> 
> The timing appears to be:
> 
>   # CPU0: userspace task issues IORING_OP_URING_CMD.
>   io_uring_enter()
>     btrfs_uring_cmd()
>       btrfs_uring_encoded_read()
>         ret = btrfs_encoded_read(...)
>         if (ret == -EIOCBQUEUED)
>           btrfs_uring_read_extent(..., cmd)
> 
>   btrfs_uring_read_extent()
>     priv->cmd = cmd
>     ret = btrfs_encoded_read_regular_fill_pages(..., priv)
> 
>   # In this helper, priv is struct btrfs_encoded_read_private.
>   # uring_ctx points to the caller's struct btrfs_uring_priv.
>   btrfs_encoded_read_regular_fill_pages(..., uring_ctx=priv)
>     refcount_set(&priv->pending_refs, 1)
>     priv->uring_ctx = uring_ctx
>     refcount_inc(&priv->pending_refs)
>     btrfs_submit_bbio(bbio, 0)
> 
>   # CPU1: the submitted bio fails quickly, before CPU0 drops its owner ref.
>   btrfs_encoded_read_endio()
>     WRITE_ONCE(priv->status, bbio->bio.bi_status)
>     refcount_dec_and_test(&priv->pending_refs)
>     # pending_refs goes 2 -> 1, so this context does not queue completion.
> 
>   # CPU0: btrfs_submit_bbio() has returned and the uring branch continues.
>   btrfs_encoded_read_regular_fill_pages(..., uring_ctx=priv)
>     if (refcount_dec_and_test(&priv->pending_refs)) {
>       ret = blk_status_to_errno(READ_ONCE(priv->status))
>       btrfs_uring_read_extent_endio(uring_ctx, ret)
>       kfree(priv)
>       return ret
>     }
> 
>   # Here priv is the caller's struct btrfs_uring_priv.
>   btrfs_uring_read_extent_endio(priv, err)
>     bc->priv = priv
>     io_uring_cmd_complete_in_task(priv->cmd, btrfs_uring_read_finished)
> 
>   # CPU0: task_work is queued, but the helper returns a normal error instead
>   # of -EIOCBQUEUED, so the caller takes the synchronous failure path.
>   btrfs_uring_read_extent()
>     if (ret && ret != -EIOCBQUEUED)
>       goto out_fail
>   out_fail:
>     btrfs_unlock_extent(...)
>     btrfs_inode_unlock(...)
>     kfree(priv)
>     __free_page(...)
>     kfree(pages)
>     return ret
> 
>   # Later, the same task waits for io_uring completions and runs task_work.
>   io_uring_enter()
>     io_cqring_wait()
>       io_run_task_work()
>         task_work_run()
>           tctx_task_work()
>             tctx_task_work_run()
>               req = container_of(node, struct io_kiocb, io_task_work.node)
>               ctx = req->ctx
>               mutex_lock(&ctx->uring_lock)
>               # Crash: req->ctx appears poisoned/stale before
>               # btrfs_uring_read_finished() is reached.

If the work is passed to task_work, then btrfs must return -EIOCBQUEUED.
Looks like a basic bug in btrfs, see below. Caveat - entirely
untested/compiled/whatever. On vacation, btrfs guys can figure this out.


diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 272598f6ae77..51c06618c733 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9460,7 +9460,6 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 			ret = blk_status_to_errno(READ_ONCE(priv->status));
 			btrfs_uring_read_extent_endio(uring_ctx, ret);
 			kfree(priv);
-			return ret;
 		}
 
 		return -EIOCBQUEUED;

-- 
Jens Axboe

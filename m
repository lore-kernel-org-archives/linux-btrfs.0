Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F358531ED93
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 18:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789409710; cv=none; b=pa+UbypZemT+lscIayovWSEsY0s+od/mRaDbWAylMVquEhwU3WJRyxHel9FBe2ByIewjDg/osMsNLIJLknTEMnBpHTigAzUagdy9w68sbCowNithrS4N3GtywTnTjKd+CehNmGXptxaNWAdmj4J1ToKC1nzoUdtOHd9FMcFH0us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789409710; c=relaxed/simple;
	bh=TRi0+IFgIQUxMa8UIobu0mkLI4kY7OwfFP6fV5o8ldI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Y2Bc5MW0s3B9fpbTd5AWmaB+4MLHUqAGLX3YiB2xbQLtzDEkI9MVugu+UXXXnH4X+atUAlENJ8oMUjfM9kjeGz5MBVzQis4MPD6RTSwYBauf6aZZeFAMx6Vqc166/VCAwjo+FdyrUkgq9aS4OdmK/Eb1K/+IhHQk6s1b98h8sd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N0uH3f60; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N0uH3f60"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa663c1so322173666b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 11:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789409707; x=1790014507; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1mpl9tczfnnSCRdLER584DnY3+33VsXgpV28T3HcjGY=;
        b=N0uH3f60QV8y07pyrMA3JG1D0De2zysEe9vHFyrU7/vtJpiUkt1qIQofZpcltYytCe
         etT/1dwJPoJH7o0aDUhAV20/U/jPIG5mND6kX/VpRfTOxFlFx4yHTwjkHrpoAd8SacCP
         d6XPRPlDyIMtJRMffQq32hzg1O6mb7hVYmdgXrHqIYvRBHh62i15ku1gB8076t5q22v4
         q4qf9ikBtdEomxB+uNUw7qDsPTJ8wDqjXQhYvFgHkVtMr0pUbqj+kaTf9ACMZdQ4Csp3
         Bq+4SA70D70LY4b2Ae/Xrs9Df6mRjWdvC0tOFDmVQd8hJ3w+4UCVBvgt/8fO36F5WVVX
         iKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789409707; x=1790014507;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1mpl9tczfnnSCRdLER584DnY3+33VsXgpV28T3HcjGY=;
        b=EWJX5o0WbRQVzi9Hi0A9J+/Lcbm7/b0DuZ+BxeesT4Xz7q0sxR1HC/0nW3Skqr9gKx
         l8JH3efCNeQFleKqHjdgdwgfdZ7BoHmhZacjNYY0lO6qhKvcNolln+OjkkmsgeH8IbhM
         6Y8QH8zHlqM2xCfxjM1E8SFX+pq0/i066oRGLX/TnNv9cYrWg3bfDXGSuQ1MOYW5eYsi
         w2NNoWcao32YOJpxtHQb+oJBxL9J140huc0/hV84GMKKB3RZpyYL3ejffpTommKDiyoi
         HxcgWVTtJKcjsNHDttTH0muEwE7W5GpgKy38p06FrCN2VVkTQ+wlQw1wxv6IaDu9TxMf
         nRnw==
X-Forwarded-Encrypted: i=1; AKwUvBwsQto1m3ukwL5ORT0i1aHqx6DGWMmTyf2mk5H2DrEUQfjWcjNj2Gq1Jd+P2x2S2V7enW3jnoYZxj79WQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kSVpMB5Ufme9WKVR094XFLcotSKQyeGKE8jWCC8RcMPzhMVZp9
	+YTWj9+E/kt6gGtHKRDq5ncF9UXKKNmDmWzEhGeA8nP2Zx9K6V2CgfhAZFg69CaB6iA=
X-Gm-Gg: AYBFou0SYj5a/hwm7FrYr+U5RHT/0MdrvI9iFh37SfHf2y36uSAfoWComOQaEZ1dBO+
	v5nU2MZzv7+CjAtHcUiqvPxjipbMrAKd2uFxdr/oyCivYIsOjj3x15NHfTrTZ9eMSftB93RXb0V
	Wjqty0OKCmtpBERGR8+EDaTqrF2AuN/rOkefbzQB8FeEhEo3eP86JAKCR8L/+vBBTS82rOIdhX8
	uhFxuI5lkUhDs7ppkaZez7oJpTLP2yTQQ4n5NvuM6nyuRyDGVxlIUdFt+gQUay8CKbnQfppn2PO
	Gb1A8itT5Odb9X2QAXptziGL7/ZM4YEb+Qgc3quEkE4g0iqjDSsNbQM1LIMpELKEU7w/TdcHVlE
	fgDqAkjF4oQvBWnlVPmWiGdiAN7IE62qby0tfNPQz2XMBUpORb+PKFuPnPwrUpj9GX/3CUlcG12
	8hQNxEOd6wAH2ppx6MpdibWg8V8/3qCb/9bHEwq3nLNElZEnbEeT95Yg+diOclvzjHJGNjWlfvE
	urpjr/pBTh+sPMyk8M=
X-Received: by 2002:a17:906:6a1c:b0:c26:2fae:afdd with SMTP id a640c23a62f3a-c29b870ebd4mr516114866b.22.1789409706910;
        Mon, 14 Sep 2026 11:15:06 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c296613c3ebsm461230366b.57.2026.09.14.11.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 11:15:06 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <2efcc9e0-e056-4f23-ac82-4b7c776582ea@gmail.com>
Date: Mon, 14 Sep 2026 18:15:05 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] btrfs: fix creation of compressed inline extents that
 don't save space
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <721d8fd2c73095d06cbdbfa714a6dfac9c488953.1789407346.git.fdmanana@suse.com>
Content-Language: en-US
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
In-Reply-To: <721d8fd2c73095d06cbdbfa714a6dfac9c488953.1789407346.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a85a7c561cf8..420d78b55bba 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2339,7 +2339,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
>   		} else if (inode->prop_compress) {
>   			compress_type = inode->prop_compress;
>   		}
> -		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
> +		cb = btrfs_compress_bio(inode, 0, i_size, compress_type, compress_level, 0);
>   		if (IS_ERR(cb)) {
>   			cb = NULL;
>   			/* Just fall back to non-compressed case. */

Yep, this works. 👍️


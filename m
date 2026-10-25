Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792942111;
	b=gWzbUcES4YUuNliOBiTDpeTOgR8SE/zR5OalMuzZ2/eDSfocdD/p5E1quKO+CTSjg2ea
	 Mul4fs6ktbBmlRZ0cRrYzLYQn1EuEnAH8jnHhKSvCBnZGXuc0+inZu/HdH3mxZ5BkhBRm
	 4b/FIgdPGPgYEolrN1RvS4be90IrOXWhi2uRhgwsz0o5BH9qR0m6DEOkXSuSOFnP7MiOa
	 d3PLNV43a0HXlZ3W3Vf6A/ljRChUiyK25SbxeiwOGRTVfjYgY74EMrAohPw5svE5zHctU
	 teu3sy56smE5AQ3TyewWhYmzkjokUFCwlZgysPBYZ7sULfBtUr4F6+V6L+TeLY/OJDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792942111;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=CaNBdB7iWC8I+pMSXF22JZ5nH4RtrrXSDHRDleoFFME=;
	b=tZYE/a+BzIaama7hlUFS5XTQ2Kxg6QCrl2Le7F6URwlUOfC+sQTRcwkE5nw3ka8wZeyb
	 s5CxNpZqBXZgMJjQL9ClVeT/5IP+fLN4x/2knG+J2FRx/vcEb9rwXLu3DP30H5pYkwM2v
	 a7x5M44cyXRWZ2tGUQFg4X9BhvbEDcaDWmhX5QozywGpzuxFh4rDVTorEeKSkV22oqrNj
	 cnS9zsQShr9kRQHzWl4mst95fbc7dZOZBYb8/rPBDOzOSfyZIPvOSQ2qrLwS0RiKbM0ff
	 unyYY61WX7YECwwibIINyfQlg10OP6k6Dsdn3XNiZhEc9BzL3D9bQup2LZuZYrqQvgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gIR1MhZP;
	arc=none smtp.remote-ip=74.125.82.51
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046C2606A31B
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 15:28:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 046C2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gIR1MhZP
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1438d9363fbso1706266c88.0
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792942110; x=1793546910; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CaNBdB7iWC8I+pMSXF22JZ5nH4RtrrXSDHRDleoFFME=;
        b=gIR1MhZPQ83M1k2coX/tRLmtNnfRRNGI1m/H7PcPvGPUs/FfFQDSkZablT/V2PLAY5
         j36hDCKII4wKFMoIH+1KgF/7k71x8HYCvqg7nBc5RUFt+uod+j3QCB0RwNuzSC8cydij
         GLmPUMXR1dOwbrOOza6H5oS2rZ8wu0qTfTkFIMy0qarpYA4wTLQFlSxPOaf7Vg+Rhd89
         qt0KREV8x0hlOuWVN+y/0W7ucyPvR4B60Y2Ml6MWHhXwDpizi6R5ZD3ARIzvfSbIMiSe
         81EqiAXb9SV84FCncazEGEFagpPG5pabk5kfpnhTczODzRhsad6v40jtv0SfC9dJKhY6
         E6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792942110; x=1793546910;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CaNBdB7iWC8I+pMSXF22JZ5nH4RtrrXSDHRDleoFFME=;
        b=Si0KgF3okOjkkNqHvumqGz6C4DzmF9FZHMrUc23QYoy1yM5tvmY/b+TrMm6vMLIxtl
         f4PaCnRx4a6BwOAFz7z8Jw1kPGjzCR30lo2zpZnSYnXD9HzJ4OqnblHoA/pUaQYb4OQh
         VAgGXD8kaZugI/Yt3iZ5dalWwPxwSgwKLPlkMv3mhoIS7UoqWjHMSMtuadm11fJ5N3OU
         SKZSmduTATxX3nPfe65kQqAWmtSC7sBO1P+Fb2XqumT3BUgaObNh0NCdyrZdOdy4WX01
         wkxhC+M9qfbdDWyZVisEbvS90nLCm8vrGiwzVwvSsdDJk7bdSuMteYITFC3pzixTv568
         ma0w==
X-Forwarded-Encrypted: i=1; AKwUvBy1Utw77kFGAnZxMwIu5wtpy/5QkyTku8dcKzAuUYjpB97X5BO1PXRmyhTSpfI+43PdH74gF4GOMJBZIQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJpuMN7EhNvoJU9OtPKe3oXDKlFywBKFQWp181qide04/Dwsou2
	KfllCE39PmJDQk+B+MkgWt4vkhhsFKcF5EzSOn9mvmC3FekGWWeokzAN
X-Gm-Gg: AYBFou0+Go2cVZ0n+E3VvxXIgiZoXU2/KB4/GBjraAqURCf4zPJ0NYvMfaGOzR5xubA
	11TX9VGGUAIdAeuVb2Nl1M5Upwm1zq4SaQFlA1B10qttxN+xP1qX/BiVdPDWlMWSdIaZqGRcuKf
	D3ECIFIyzBdU8F3/Hyl3AExm3MEsxZSqwjLXTtu9sP/1tjV3JXpWir3uOyIaTUdKnqbdsZLQkCb
	IKEVsOXN4tELRSTx4ZkQah1i/6zhWLioXklA0EwG+mN7gOBsOTAip+bfftnmdfTbXNnUwjdlFoc
	bgAXpT/V9DOl0UP3X1PiPpvIHzVnhXDy7aF9ucAzMwYIa3UudOCC7lmTuv8tyxdTXW0f+/KZhza
	ftSxbH2CNJJ55EynCQ97waobwvLJ89QlyaaOoa1+3SANQxQduiv+sOtp5R9yHMH+RBn7xSrKwTO
	WE3iEbtIsPG+tm2fnOp6jL2J1gRoVcRt+L/Ja/BGhn09vAnX7am/WXFtkDxnIZ4b5eIXpM7s76N
	Q2mX9A9SAeExPhSGq3udP6Bzmk8nmFDC7ciUT0hRDbNNlPUx1Z4cYdswVfWFOQNyJGLzCF1nirX
	/ta5bmJMHFd0Bp59mQEXSGlIfEsneQUgw6CDByvF0xn/wvDVclSH7ZNY4uE=
X-Received: by 2002:a05:701b:4213:10b0:19e:3464:ce40 with SMTP id a92af1059eb24-19e3464ceffmr2522187c88.1.1792942109756;
        Sun, 25 Oct 2026 08:28:29 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:97af:71ef:5d3:5a66:5bd7? ([2406:7400:56:97af:71ef:5d3:5a66:5bd7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm15314075c88.8.2026.10.25.08.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 08:28:29 -0700 (PDT)
Message-ID: <17693fe3-9b88-4efc-a8ad-3804fa675a7e@gmail.com>
Date: Sun, 25 Oct 2026 20:58:25 +0530
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] fstests: generic: add a test case to check fsverity
 reads
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 fstests@vger.kernel.org
Cc: ebiggers@kernel.org
References: <20261017090341.72079-1-wqu@suse.com>
Content-Language: en-US
From: Dhruva G <goledhruva@gmail.com>
In-Reply-To: <20261017090341.72079-1-wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17-10-2026 14:33, Qu Wenruo wrote:
> There is a bug report that with the recently enabled large folios
> support, fsverity enabled files on btrfs can trigger reproducible
> warnings about file corruption, but in the end no error is returned to
> user space.
> 
> It turns out to be a bug in the btrfs fsverity integration, where blocks
> not included in the read range are passed to be verified.
> 
> This is a long-standing bug where btrfs fsverity always assumed that one
> folio contains exactly one fs block, ignoring the fact that btrfs had
> block size < page size support before fsverity support was added.
> 
> Add a new regression test case for it. The workload is pretty simple:
> 
> - Create a 32M file
> 
> - Punch a 64K hole for every 128K
>   This will limit the read bio size to 64K, which is smaller than
>   a lot of large folios, and thus can trigger the btrfs bug.
> 
> - Enable fsverity digest and drop page cache
> 
> - Read that file and verify its content
> 
> - Verify there is no "FILE CORRUPTED!" warning
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog
> v4:
> - Also output the checksum for the file for content verification
> 
> - Update the comment to show the requirement more clearly
>   It requires the folio size larger than the fs block size.
> 
>   This means either a system with larger page size (e.g. 64K page sized
>   arm64 with 4K block size), or large folio support (which requires
>   transparent huge page).
> 
> - Minor comment updates
>   * Concentrate the mention of large folio to the triggering part
>   * Explain why fserror is not utilized for error detection
For this version too,

Reviewed-by: Dhruva Gole <goledhruva@gmail.com>
Tested-by: Dhruva Gole <goledhruva@gmail.com>

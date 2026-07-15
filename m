Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10523D522F
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 22:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784154887; cv=none; b=XrfYRTZ3PXAPM/AiGlimVZC3vCtAWBObe4lDa/hFRcBMLQ1GdiB0VbS8vD5bBdqi09ARl2Hb5cpgk0C/ZuS1mBVYtmmVJ58Md86e/SC5WySjkCNk72VlHT92cOE+lUC9hcpetAdEql1WipKG0aV2+olEA/F4R0WfxTGcgAeXA8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784154887; c=relaxed/simple;
	bh=IIKZNdA3ToABAV5rv4ZMI3BNGIEBhesy6+I5AdnAp2g=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cbwDgXSffWPQa0QmGukoAHgER2gPib5aDuub5Gnk7RPcQL304dBbrY/SDOKaFPA095yGPI+RZtg3IcFiWx531+txVYI1cJ6YCKcgeSnu+8IpBZOigp8kV2jYy4G7/UAck8XMd/xXdnJ7itL/z2qbJ1hY0tjlYzB/v0cNiTShKTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=jdcJa7Xd; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="jdcJa7Xd"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6a397a0e5d8so2694507eaf.3
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 15:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1784154881; x=1784759681; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ohQn2DG5ji2OSGvbMyf+yo50k/BurXM2ZXuuP4gtoXo=;
        b=jdcJa7Xd5ln9BgGwvoU2YzV1PFLUEzN9PjGtaQ3tFa2G/wdAuGMgDO9pR+BV9mro/Q
         4EFMryGH3hR2mzqKrdA4sDhgPXOsRvCrj8A2eZsiBf8YfK0YPz7oRzztQCfwBpW9ASGs
         u7zuEyfELSXUXWOxdkW7PZ09cLmfb8EAebkhsf0loQ6YxGGLnGswok0JOFmmeIk4UUzK
         jslgc8m8clL9uFfYSSPJYjIVPzpfxLTpSTv3pMPFgr3GwDrfblQEDcg6oQ5k5k/VExqF
         +LWmJk2pvITEUF8RzPrj0+u/TMELDXTYwoo8+h7lbQzt3D2mRUuCWBoZ4Hdyscaft1I0
         fu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784154881; x=1784759681;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ohQn2DG5ji2OSGvbMyf+yo50k/BurXM2ZXuuP4gtoXo=;
        b=qQPK1ezVC4otnYwdsHV2Xhq9AfmddlyDRC1xd/9qQgqzpiRjsCTQpYQ5/VnMmRewj6
         K3wF/b0VUCOfJszcSW3Y59F7z1JsEhDI5oy00qzTY/ly9dHg2LklkHOTE2bCW8NvdgmC
         it4TwnbfHSbz1gAl0H7MXpygu9nSUNHlNB62F8ipT4YeEB+w4G6Gjb8KWAmbT4MC7PrL
         AbJn/mzxyFKpuSp4S5tuAosgo/2gfVloDl0aTCMO56jl4bAK4zrXXFTovJCgIS0IYcZi
         INyNGyaVgig+dUAfR53pK5oeWLwX8xd3z0g9BYKSrfTvYz4x74NQDZd+23Jlpo1vhJtt
         mSuA==
X-Gm-Message-State: AOJu0Yzfcjl9LHDdPpiqpQC8RNSaOHsuE73Xv91ydgSJ8uKyRD3PHULb
	Ol86w5sNS/3N8EnvoSDGY2naSKqIxLUEtvgEKs2hBjkeShcep9X6QNOrwySJBwlvezg=
X-Gm-Gg: AfdE7clEiwKAVg3VinKVpgHoh6p0MnJU61RBQHzadWInZ9pRFrRUsWF7kyTsnUcYBog
	RmDuGGdxHD67dDsVyr/RLCksgJwJQ6/njX6YSIvwHxkBR3cIfccIEkw31W5xLVs0jWwjrrYAOKN
	vfFlhFWFZSDqMT/rPLdePZTJhVIPs7THkjIHFphKHzGemMWCpKatYV7WhIYsMMjz7ogmMZvLI3a
	l1GrH2R3CFJxk4OuP8eQzB9T1lW9f9fT9z+BoUSdnxIdoupmkYa6RKYVqDDdq21hiQEZaBnDOWt
	sNodgOlc3bVUjq7Pa/KJgZWvTHCxDUir4gBE7U5qrOiGPdv0FHwKlg7mozXP8xS0M8YIBt+19Dk
	7IGG+ulwg+b+qpmOf+PvZ4/8fMtM8ptw7ezJ2uxJnmuemFjqEtX9jxvA2hKRDwkSC8w8pHZWeZg
	bhb1W5OytneKSabmOKfm98w0fp0CI82kmJpDzf6CWlqEy3IwE60J0H0Ik=
X-Received: by 2002:a05:6820:80c5:b0:694:9ea7:7aa1 with SMTP id 006d021491bc7-6a3d9e70d85mr3125716eaf.5.1784154881501;
        Wed, 15 Jul 2026 15:34:41 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-45200b7b4c5sm14362722fac.10.2026.07.15.15.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 15:34:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 Qu Wenruo <wqu@suse.com>
In-Reply-To: <d10571445ee505d95ba6eaad7558fc1f556d2921.1784020005.git.wqu@suse.com>
References: <d10571445ee505d95ba6eaad7558fc1f556d2921.1784020005.git.wqu@suse.com>
Subject: Re: [PATCH] block: do not warn when doing greedy allocation in
 folio_alloc_greedy()
Message-Id: <178415488025.159585.4896334325664056033.b4-ty@b4>
Date: Wed, 15 Jul 2026 16:34:40 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Tue, 14 Jul 2026 18:37:39 +0930, Qu Wenruo wrote:
> [WARNING]
> During one of my local btrfs fstests runs, folio_alloc() inside
> folio_alloc_greedy() triggered an allocation failure report when trying
> to allocate an order-4 folio.
> 
> The kernel is from the latest development branch, which is utilizing
> the IOMAP_DIO_BOUNCE flag for direct writes when the inode requires
> checksum.
> 
> [...]

Applied, thanks!

[1/1] block: do not warn when doing greedy allocation in folio_alloc_greedy()
      commit: daff723f2d4c618d5f9186a990f47bf75878abeb

Best regards,
-- 
Jens Axboe




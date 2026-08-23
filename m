Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562F033C192
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Aug 2026 14:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787497070; cv=none; b=PngGp2bJmMg26KEdgsOBBqzxpbSdJHhk9s81iUpSCgEFLvf/cevnx12M9xbgLzO1v/XbPJvmmoV4NPncpMsvhOzUjyQ4FbSUh6X3H5IXNWGnGPSV0eiyW2s8eRUdoG/MwiOySNubv0UPqPLOeEz6X6SFUwiX4x55TJxtss600cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787497070; c=relaxed/simple;
	bh=kLWFNP8Mqs/xx1cxTSBiyQmyFIY2xjHPKB+TtK5UU2k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=h0bftrK6lfBe+N8Qla1pO+L6grSlN3WNFLLtnGx6aU3E6zGuzWuIwomI3WSYObL+uXtWaIURddcQLJp1q4OrRTZwVuDe98cd5DpCRzpJaIVTj71SljJsej7GTGdfKxmh7rMnrmbRr0an4n98ANIm4lWuJfxTlxyTU4ER6dY75SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=konsulko.com; spf=pass smtp.mailfrom=konsulko.com; dkim=pass (1024-bit key) header.d=konsulko.com header.i=@konsulko.com header.b=IxglbNe9; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=konsulko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=konsulko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=konsulko.com header.i=@konsulko.com header.b="IxglbNe9"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7eb4d532e65so1455763a34.0
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Aug 2026 07:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google; t=1787497067; x=1788101867; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=evTbu+qftbAcGgMGrVi0WtRDHLAvgW9ziE12M4rW89I=;
        b=IxglbNe9FW9fSjbCJn8EtTDEA07lP8utrbGBaUpRBuQSND8Xq6cJ8Sny7barpOFrwj
         KAYJ81ARKdUBBquSliVR8r9fD8pL/bmN1WloskK4ZxhD/2TYy4asO0Z6yw96YUEkzM65
         in2Gvv7YS9Cy7wkn+EFMo5RdXQK8gSUaBrD4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787497067; x=1788101867;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=evTbu+qftbAcGgMGrVi0WtRDHLAvgW9ziE12M4rW89I=;
        b=Wv2PBFEIwmMvyvxfsHAVLHtKg63qaL7OlG661CMfnTnhQAD63ePCkiJdNJN8XZLKwq
         15lGlBCdFyRuZ8o4v+kNarwBVzafwoEpb4zC3/cj9wAkkZQ+BBZ3TfOsqiwcJKKJhtUR
         L2XGsmNUxCkZ9FFCeyFym/9QI+hCKU0GY2m0LlTrV7uGiYCNtvKEwPGbyVCXhaT5cryL
         P8uRRJr9dn8hDVqFnZiUfUQ/AmMbuWvq3tACqDcGYZEx3U52HrvwweUE8KfJc1+iWy4e
         JVeRdfhrJIAXE2NG/0brbhNzfLZ6Qm34Eh0fDuuBMklOdFAQBSxOWH+GcYe3kyQXDPla
         RHPA==
X-Forwarded-Encrypted: i=1; AHgh+RodxkPqPLlQP4xzh7uUKVO3zIEdyCitnjNcYD909F7Z6fNxUP888irHDoTS1k9ceTg4ggVbgMW6IIGQfA==@vger.kernel.org
X-Gm-Message-State: AFuF++mZfRBYOBh0+Pmm3sp9iiH+NcQEhjiorkBBlPT1UN1SYPvt/4tl
	lsKwhYTMtT5UshfGecU9L+7FEBBXzQ64E19KQCaYAYyR4aNVLbQDcEkeGfVSxF1Qz6s=
X-Gm-Gg: AR+sD13HRnoTcW1WlectrcRUaxNkKls1J6HBIf35NWmHYyrG6XPbR9QculbgnuAaMcl
	lNxxCcDcssSNHhO5ClVBfzmZ4WfZw5v2wwb/ZtC5i6ETY7FvFRBdIphDAuey4stOUCurue+AHYR
	liQ0AXB01wJ+/RKTWGDcQLGu1PYKRcy4H+Am8ltt5LmxRbsb6bo33jEEzsyuq5UY+NWlhuRCVH6
	OUzaEnv8Olb6/qVyeHjeqPBcm8nk5pV/7DhcK02A95Bh//DKKY5vhGgXucXGpstNeCDPYigxemR
	FNkjmK41MzS6t++uErspMEXsRBlCT+eWqYM4gBYWsHbgAQtUagf03T0tIHhandIvl8KU8Kt0NQO
	SzYz/1nJnFRTZnqyDBqrfL6Fjf5M0JxCsU3jFcpIXtN0kywsWbR1djTijWgaIeYe4mBUZS4V/j/
	snrH65gaPclfgULDwg1MnexrfOlm8twtSlinj/cgtwtRA8g8aYsZqTqqYmxv1bz69qHFfx+T80I
	/r6ZLswfVWnThisMEpMCiefpSK1XTZeyumJjDfY6hKV6Q+MYhBPS35dknBa82RrGBjmjHQQ0qFc
	g7x5R6N3uM49zTkrGxA=
X-Received: by 2002:a05:6830:380f:b0:7e9:8867:cb23 with SMTP id 46e09a7af769-7f476556758mr14980828a34.16.1787497066755;
        Sun, 23 Aug 2026 07:57:46 -0700 (PDT)
Received: from [127.0.1.1] (fixed-189-203-100-56.totalplay.net. [189.203.100.56])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fc89283sm2028583a34.24.2026.08.23.07.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 07:57:46 -0700 (PDT)
From: Tom Rini <trini@konsulko.com>
To: kabel@kernel.org, Cole Munz <Munzzyy1@proton.me>
Cc: quwenruo.btrfs@gmx.com, sjg@chromium.org, linux-btrfs@vger.kernel.org, 
 u-boot@lists.u-boot-project.org
In-Reply-To: <f6ac2bbdb9b559041cb0c82efccf89ea7262cb43.1785545440.git.Munzzyy1@proton.me>
References: <9acf406b5e73fa83001e1951e883143e2afb8b2d.1785528314.git.Munzzyy1@proton.me>
 <f6ac2bbdb9b559041cb0c82efccf89ea7262cb43.1785545440.git.Munzzyy1@proton.me>
Subject: Re: [PATCH v2] fs: btrfs: fix zstd decompression of compressed
 inline extents
Message-Id: <178749706570.206448.5287903104249745566.b4-ty@konsulko.com>
Date: Sun, 23 Aug 2026 08:57:45 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Sat, 01 Aug 2026 00:55:20 +0000, Cole Munz wrote:

> The kernel compresses an inline extent as a whole block:
> run_delalloc_inline() calls btrfs_compress_bio(inode, 0, blocksize, ...),
> so the data is zero-filled past EOF and the resulting zstd frame declares
> a content size of one block. The extent item records the unaligned file
> size though - __cow_file_range_inline() passes i_size down to
> insert_inline_extent(), which stores it as ram_bytes.
> 
> [...]

Applied to u-boot/next, thanks!

[1/1] fs: btrfs: fix zstd decompression of compressed inline extents
      commit: 6f0719e4c420d9e3b1cbe92b2934e03f2f57e6fc
-- 
Tom



Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE5147CA83
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 11:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781690; cv=none; b=VCVkrFJWHCSPR6vLYy99HLVlzjcailEpw5koOe3AWVm75QnlVVHbZ9F6aeLPrmPFOBViTvIJmSSfpOueH/CIzz+1J9k10t3s+7oZecX/uWKJW1Ly5JvdvF3quApNlhsQGRlm0+OWhrgQxD+AXK/LoqeHiPbmLjISMM7HZyFaP5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781690; c=relaxed/simple;
	bh=TGbMSRctaX5jhPDgo8TGCoW6GnjLtJVIm7W+RZnDfS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqiAhAgDDROLTAbMWDZY2DcpYcQu6R5tzQqrazGAEBbRxkTappaKLkamY/HvrRCNEsRNawpY1HNkc9oeIkwGgk5Mx0q5yFWQtYMhlBaSrp5EhHBl1tQHNcYDpFB7cPB7pFRJ3OynKeGykLhLrRjH4OORjjFQ3VkEBNEsbzdRjE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qn2hFIXa; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qn2hFIXa"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2db18e5cb56so31195895ad.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 04:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788781688; x=1789386488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p29WlTfWVrQn534ptbrDbkRoo4ro4TG7QUYzDzPDAF0=;
        b=qn2hFIXa8bvISMYq3rd6wsDe0EojK2Lx2mgFCLxv74iT+jNHd25JwSOe+aZMk0bab4
         qWygx3wHjagV8KSJdYeS9VD+ncO0ZE6LbXacHXnmpZJV0bJMIpOeLbXzUuGyyCqmEK9M
         lTWpd911ttElKEezzQ/cNa0ao8i2U6TeVJ5Mt81vBolA05SMZf+SwxIqWlDq2s8+zq9t
         JCMnMesR+Xxmo5L1hNWBPWKT8pUpMMGNHd/YY8gWHnjn62Drf0Wwr7Tz8T9vOsdnCtkP
         0E4ItbQRH5/XnRflpVd1PecmfZg33a00H4xCULc8R2eZG6PfAAwqYEdNc9D9OqXNmExU
         VJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788781688; x=1789386488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p29WlTfWVrQn534ptbrDbkRoo4ro4TG7QUYzDzPDAF0=;
        b=pir+pMjITNj2Mo/abo2oUfqgdSGzqGSOlmdjhUIXlzNKt4EEfLmJDkPPt2pNYgPynU
         zfx10xN2+z+2W5SfNxSiNM0Y4WE9v21HT20OOw0bdTZ6XUJp8p+uaICg+b/jEq41fSSd
         GL+Kh3V2lf3SD0x1/PAbZdEth9YJ8h7dYNlL6oZ2U21CNFc3t/exK7GmxRvwaA3gAdS7
         DnpGcJM/epXjJ46RZW/LlFL8OszyaG5JczIH2V+1MlI0ZvEMT3/+Nc491M2vZCngYW1P
         LSUua5qWgUY3WRZXxHV4ADOJxu9NvUSVM7hyuPDGRVf56HjnhL3hGp1eetqdsyfcMS1c
         VVBw==
X-Forwarded-Encrypted: i=1; AKwUvBy3XeDAWlkHLF6r4bHF5QYyPellmARjRI9BM7RRo0WWMW4hy0WZsUns0yB//nz8NPGT/Pq3tdx4zwYSxQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lQ1Hefr+YQqaDHv5jdVq6rwFQfyJ5BL+PLFhaERXws2xdLLJLN
	nnvMNgtiNdh8/a7v4TD+/sh/de5OhKjCik6AldWz0h7I1qge9aYdIVqa
X-Gm-Gg: AYBFou3haZyldgSbHLvEqEd168USzJE/73rqY4/hXghEs15AGgRjVOT5D1AA2RrvLv8
	S86bn1Yadzg7vqWRynvi9xn23nvMOqPx6FJx5Y/hwRXODlVTTcRhnaYqZe7HEKzVlhQvSzkG/cX
	hLVWKLCEkyaAxdgpW7a1sXuRx/E7xihEJ3zEH/9W1njOuAi0SFnIuo/G3VO6n4pX7v8xzMZDN7k
	xv4dpeETRPyEUr6xcLj4SRFi/0w9a6/6omhJAVHDNnRINvtDWDrRbAbCbAjpkpYqH0zSufiLsAH
	T+uwHJY9ZS/lzCY5aoogx/9eU1ATz/GdpFXxEVQDQpgoeHkVI7ETzMKI987C+DS3sdfHJuOcojH
	9dO8LVjWkYSVBtqFIuHpMJ+lw8lf2YwH3ZalgntGBeS+u/NyEQqgM0u0Iy2G7aKi61DyDcF0Eyb
	7ZHxpK92q6F9/hSq6vmOVpJu3A7go0EvII84T/vjo83f9PrLpkLhelzVpag+YoHgG/zj1hZJaik
	0TsK58xs1GTDCc=
X-Received: by 2002:a17:903:2ca:b0:2d9:3850:2741 with SMTP id d9443c01a7336-2db12255f7bmr331441695ad.0.1788781688060;
        Mon, 07 Sep 2026 04:48:08 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339befe870sm30526079eec.30.2026.09.07.04.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 04:48:07 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Daniel Vacek <neelx@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: reflow comments left awkward by the typo fixes
Date: Mon,  7 Sep 2026 17:18:02 +0530
Message-ID: <20260907114802.16143-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907114153.39900-1-hemanth.selam@gmail.com>
References: <20260907114153.39900-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please drop this patch.

You had already answered the question it tries to address:

  "Reformatting whole lines makes the typos harder to spot, so it's fine
   to leave it like that and reformat at commit time eventually."

I sent it after reading Daniel's comments but before reading your reply
to them, so I reflowed the two comments you had just said not to reflow.
Entirely my fault, and easily avoided if I had read the whole thread
first.  Sorry for the noise.

The typo fixes already in for-next are unaffected.

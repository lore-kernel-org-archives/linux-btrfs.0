Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794804534;
	b=O5iEMWY8X9h61RedkyHvAI3Ju7bVViF1dvch+Ydg7sbhoPNZvPAUGkQ0WDDAw/DjbCxJ
	 eleEtSZQ96IWQndkODscg+ks1Y2+fuirm6rQY0IYzJgauzW6YLUtBRhDJOcFsZk8nY4Q3
	 yR8h7FMeLpp9yr3c7d6ciLreZFbiPoseFwK3UnAXvp5D7s2h3Tg9oYK6BYo++RWBNRfzA
	 aEfCACaexjRGhNpxdRqYS1CDwND6oWiWRnwlZ47gaA9yG/Q+NpTcVlqYM++0P5Y1Lp4H1
	 6AgDIzr1VryHOqxBThDqQLa01HjPR5tfCdnqlP7FVPiaxBM2e1J2nDAMdHdkI3MknBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794804534;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wmDJGpNor/i2EbBeChp/TshHxfvcgbfLGRN8N25C3l0=;
	b=tl11XB+ZfvQn8C+UpII4h2+rOMr51SRFw92upHm7nTfhSNXBzoWGZ+v7BtjCdyO0y9gn
	 05Sbp6H48amEJ8udXt83oV5DR56TCqcbKk8Bvc/UiO8Oi2M0DqCc+r6DUoZIpBQlrJg9F
	 5J3/f6m4M7f1NNQ2YEOK1m1qrhgj4LkAOWT4rR7T96iOZQhuHNtSEmvEPynQG7I8ewrbn
	 aXSFCpwsBfxF8Ps6qc7/5d49+IEDqvOgvP7khpHqN6yvVwYPmGJDcDMwgNINLFBJwnjvg
	 Rp6CYieovQV+tF43qT8uDh88040qrSIs7zUgxP4MX+c8/Uz1i6/zsbI5kXKHepd8bDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iQyiWSLl;
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C87E606A31C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 04:48:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C87E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iQyiWSLl
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1b3acec6677so4071219c88.1
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2026 20:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794804534; x=1795409334; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wmDJGpNor/i2EbBeChp/TshHxfvcgbfLGRN8N25C3l0=;
        b=iQyiWSLlKrHQPszF8YJwxf/l9hKbsn3bYs1NXdONMMU7xRwBtwBxfBt1UkM/rjlL0u
         a78zLsm14w7QycC8qDL2ruOTUYsjORz6q8qXaYOR8ksbOyXQQtMZabP0HkOIYqV1pXMC
         0RllMSl4PC0SHn+u8EBFnxn6aXLR4C3ddPCwPlGlsxYp8uqqFdJtKPT4hc3BWbwFyzaG
         EIBXL79mT/1z9kzC5NFVKPsHvf2TrhF+3ZgkjsfNJBS9JEP/LFTZj/EFMk6YvLtbuleX
         uF3m2nfx3sP4QZKOsGkYIbmlZtbWwcriDoolK9jbNB7xzw9n5XwpF3z6TNB8kVOvsgoR
         BD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794804534; x=1795409334;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wmDJGpNor/i2EbBeChp/TshHxfvcgbfLGRN8N25C3l0=;
        b=D1vaJGlx5H3LboeCJYDgv+GjcQJwSiqNJmigLHopkdQb7Eq4ai9MkErVtMm/zq8lM5
         fZJoV8e1JoutcxqEGRUP7eNT3jdSedJGtGOruXgxprL8uuM2+rYeQKjou7cuNXC2pGSf
         NJdauellpjDeFAGJnDtORfywYSaG9UaSHlPW8h7XV9v0AkV3XLvIsUVSWqF7LFCIGmNl
         rb5wUGEIhzEX+qaQKi/PbBsfwOPad5tvBvT3UwUkwMpxxIWYVpUI9gYLrGrIBgqrYxfC
         dSHyBZ1vDz+mSHZ+owGxVP9XOPG/5GrFMaRau2SHJYLBiRPQet44cFCA/gcmW98B2ush
         k27g==
X-Forwarded-Encrypted: i=1; AL+hErFLFimhDHeoO2mRhCG7QlnozkcQGszozjetoH5cqZYWj6tQiUqazQT5WTCUqGpotnxTQWu8H/oic3vQew==@vger.kernel.org
X-Gm-Message-State: APuU4Z81wVgvnALqmplb2ISeWCNc1iuZhfEyGSuvoxEOyxkBzFiVeyVU
	xkJhVLAZ+6e0P8JaILuODSxWh7R97UE00/K3D5LsUPGA62DtAl0b9M/o
X-Gm-Gg: AYBFou3OuDQBXajZHTNkM83fGcv6gr7y7+RV+rCO6mtzl8KKQt6yAgz+7deRJjHYRJq
	liXuZdzGMldxyrSubD13G6PI7L88UmcJkkvVYKg6ULD0uMDULm7o9cGVrpA48Nti5GQYZjZuDoJ
	yc8NloqrcjJrHRIxE7lqXt9F3sAFvgBYkBgE801hG/hb5Q3ZmWGLN461M1jbQRdx6YA+3BDF56v
	vgVeHIFiZ/JhjG97GIJiF86dkkM/pEjCnHi92e/aiVZxV0sP/UHns5ruQj1uWkgtvMveCFHRn7e
	wfWo9Qmb4GhPUwbQgkBDXRVQNgJUPPdVcxAMSLf08Rc0U04qODcce4SokzOIziFqRI0zxJtipbA
	rqKVXRBWCxzoMhx3KZ2QbsRam8RXT+zRCGlcyPJjc47OEBmH6tudIPVb065fPBpmvpjR3Ae/mWi
	2+cUlaGuF6Iy3HyiD9hDprfyU0cXgXKwAc3OVpE4xQevjPn3m3gAVQeMEXehOZekfWxBeRYlScw
	TqdPHlRrfvZuwuz3AOw5XzravzJG7wzfhJbaIQEA58edrPWV/ILhgyBdZTKsd65yQ4tZbexJ+la
	7orSMFUNdXLDrvDSGlU8cGnIlfSEyw4mfAkGLbF3+kNm9ZC7TiY7gqBtygUQb+rLvm7x
X-Received: by 2002:a05:7301:4d07:b0:375:87f5:ccee with SMTP id 5a478bee46e88-379684b56e7mr10407948eec.29.1794804533447;
        Sun, 15 Nov 2026 20:48:53 -0800 (PST)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bad6casm29442346eec.26.2026.11.15.20.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 20:48:52 -0800 (PST)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: reject file extents with oversized disk_num_bytes
Date: Sun, 15 Nov 2026 20:48:47 -0800
Message-Id: <20261116044847.285669-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261116044543.282187-1-teel4res@gmail.com>
References: <20261116044543.282187-1-teel4res@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Please drop this patch, it has a problem. Sorry for the noise.

Thanks,
Cheng Yongkang

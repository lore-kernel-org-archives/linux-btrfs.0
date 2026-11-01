Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517374;
	b=fqcNq8Os1y3o169jENQ7RT2l8PtWvcVNIyFczHdvnSP3Fp9Tjy9+Y+7cd+j3sLeGiCGn
	 eDdJZK4mwIRyaE8sGhPYd82oIHkayiFIfham3jd2cYjP8Zt/buYBxtObsc1QQoE8oenBK
	 WVOotq92o7AS1EUXviNgMOoVSCKlKD8/ibx5h2XM28JtTDQ3pQUjWKBtIiR3ED7UiLPpq
	 /ywwfwkyqI73AyBWvX9t8HL80osQsTMGfn7hfwG4cpue5gtJURoI99dQ5zWAwzvDp5OMx
	 0O7Z8gRrKERW+blOkWT2hEdYJWMxID/jjvd8HMxhlv2RqADzIxE2/HvnOv/kTNzLg5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517374;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xjWYg1n4YKzfxG8UfUkLCh9i6lhXerNEUBT8wvZMd9w=;
	b=iuOUhsiAn6WS6UGMLQAcYv+mMViVvBn2XbGpe3r1etxn61TgK0nslTkUcyIOl4eHmrtt
	 AB3qedAkNNiyoXIN/Z4ZgyayFPfeZkVthg7LUR7sz20/MWhA1ecRLkSdLwkXrfmK8HWCO
	 g6aqQT3lFeiuVkyrNSXbxWlHbo9wSpFsaiUfFgwNvVqyENk/tNZe6m9C/XXRp2ABaZrIB
	 bOyzQ8gH4ZK0nfCnORldvtTTyxr404h84JDVHT6x5wLrEp5UqLphfbPmShrxwjWpbz/8d
	 nOaVJCFmMSwiJ1f4JTD5htByht680btOpsCq0SGLzPSavRvoY2S0BlvZ5drraKPLtjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZOe5vS3I;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62555606A326
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 07:16:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62555606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZOe5vS3I
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-15ea896ddc8so3503923c88.0
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 00:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793517373; x=1794122173; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xjWYg1n4YKzfxG8UfUkLCh9i6lhXerNEUBT8wvZMd9w=;
        b=ZOe5vS3ISMdrhLgDpU/zp1i9KcXmr3D9SrI84jkP0vt/ytPubliSrLdOck/fcukufg
         2PUJKPhFtuKEukhICewninU3btU+c4JZS3aS9KP+RLkqCKyKi82tLpwwJsx//oCDXvh0
         ydib1+w9CvBDBpmHhsxjohRqCyZuJToLisyzIA8nlhTnccu8QvKSlSa9JuOx5s/HyLbT
         ycxtWq9WZXZJ8E62EQXgZqTnrbB1drTTqs8V3bdZIfHb0odBKFfqPCfKNtzgv/gQCYvE
         uGsHb/XGOswLssr1or5m4E/a/h9lDnDhg1Zv7X362kX1w2qcvXhOxskC1cFIGrXkZhQc
         F3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793517373; x=1794122173;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xjWYg1n4YKzfxG8UfUkLCh9i6lhXerNEUBT8wvZMd9w=;
        b=m+/v4/1JCvIjUioL1be4AyZ/jaxB4QFwO/+BAKmYh7tEqMeAZJlWizOWL93res6pVR
         WiixZwnCIll4Q9VyWnTBbxF+OkqZiTBXJoWgY4riW+gsuc9bDp/RmAZOO5XtX5/QWcYS
         pqflp13/Ml9vm/NcsOOQceJI1QcbzLieEdTJHQ7hVV2fzU/JTGZv9HWEg2pXEJXNwinX
         Jmz+v8ABJlx2VIKk29XnSzrJhpL8MnslCcEnPABf+Xtr+YFklS26UuxPVJSN0puLlfwS
         KwecAftAoIymfNoevHCEra3+Ob5zGY0CMObSJYnaj6xCXCWGXJVYvH1Pst0pwuTdLTJw
         PgBA==
X-Forwarded-Encrypted: i=1; AKwUvByjV9QIWWNbiw+TY6vS8fx7gA1foC9ehT0HM00NPfLLxfuXIfT7+TuSkLmKt+lX88ZvvT/NtzSVefnExg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLT+FK4QLOuCXhBYiDjWsr8QuYDsGLiZG1e9/OtdoDsJmC85MwL
	btT0bOW9tmpsjqloH8hDRpaWDbVZyRA383nU/TkTsW32Nq4dTn6ScZOUNFzm5amc
X-Gm-Gg: AYBFou0XRlehab6Dunukpxt2MVvdCjf1toFBDUpZiQD1kl2fduZE73jtaJjrHz6AaS+
	ZxZpGDfkw7NjsTGrKyLz8RT9IV+X08DnB9gey4tUKEovSJGbJeiNVYsoFXSgLR6544Zef0xvdpo
	adSk6WKMVLbyT+0vAbHKPxdJV/XMZMP3IvbDExWPZyn8yzmZtGZyUiykkr7liXO2WCCTR9HePEq
	6VqoagdU+GoSTl9Pc7Dpyg7h87Xzr63JI6lZb1mVURo6r1mof4+8ZX4GTtSHMeEOm/wKSX3VGN8
	bg218hMHyT6ZjKTF7fH4tb4mYnoqot/zKJ/stOslJXT8H+XZiZ/Kq01kodgNq5jdRuJYAtHzB/9
	CO8g/PkwsemuEuKWmDpu9PGf+3EyBTMvTlM6+XYyrlQNNCq2Jbi0bTBLDgKcZWP1/ZYIR8MJI3n
	EJr8GfTSkxXJxUgZZdc9AwpxQMgKPY9kEEFUHD3xczayq8LLII0qDgJqlQsjaXxIW4lBX0Hfy2c
	mtTsaLxlsw44983AmWJfrLxdpe+8PMy63qEuSjbQxBaZfFED04WOyPbxCjamRs58J2RID9mDvWx
	Zeabt4262WXMCd5YfKuBpqcQzUdQVFXpytc/c3t9OtbRZyUX4bC1N3AX8LdPaSsQpZcx
X-Received: by 2002:a05:701b:2401:b0:167:4198:2cb3 with SMTP id a92af1059eb24-1ac5ae38bb7mr10000684c88.18.1793517373179;
        Sun, 01 Nov 2026 00:16:13 -0700 (PDT)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1b0a628bsm23197930c88.22.2026.11.01.00.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 00:16:12 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: Cheng Yongkang <teel4res@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Filipe Manana <fdmanana@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: reject zero num_stripes in the system chunk array
Date: Sun,  1 Nov 2026 00:16:06 -0700
Message-Id: <20261101071606.1854874-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <d2ee0cc1-674e-4447-88da-d346122a43a4@suse.com>
References: <179328314071.648427.12527832319954042748@gmail.com> <6ad220fa-d6a0-4b4c-a313-a0cc052b8637@suse.com> <179334729054.2353588.12398743988940745859@gmail.com> <d2ee0cc1-674e-4447-88da-d346122a43a4@suse.com>
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

Hi Qu,

Thanks, I've sent v2 with your change:
https://lore.kernel.org/linux-btrfs/20261101071444.1853699-1-teel4res@gmail.com/

I also need to correct my earlier reply: with the assertion disabled,
the old expression gives 48 bytes for zero stripes, not 16, and
btrfs_check_chunk_valid() runs before the loop advances over the
chunk. So removing the assertion is enough, as you said. Sorry for the
confusion.

Thanks,
Cheng Yongkang

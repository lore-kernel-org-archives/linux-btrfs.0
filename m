Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794296137;
	b=JPGUqS+OtKZ4zCBKV2a/zlTRBP2khgcxY5xNVuAPYaTiKaSOM0GQ/+mlYxkUTn3knYNv
	 B5SBCITEk58rcKakyEGb2MHrhUHvUXBJDVPNyh5qvANhRA89/+Z17YHIV39NSes63iWk4
	 wq1rANoVwmZZf9PqtpEaBih9RMeSaOVcVQLp1SwAQnBF95+LCzRi9WcAkqgyYG4tD7j7D
	 uLtCylezTFBJf9DFbXrbdID1rlYU39ly9PEz1pAB9zUof6M1OW0jWl+2UcO0evqH6YS+N
	 yuMrk4B+JwmOP+aLF7I2AN879DFSNenX0sggEKvo0ABzUmJBCrRIzVx4ytXxOzO5e9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794296137;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References;
	bh=PHDIoEm9ZHwm2QbXfcuNgzAchc1Bm5nQ/5nALaIInYs=;
	b=3QGLxFJGKi6WWs8Wg0FHW/umyRHwiIbTksHWIa2s+PQehzD7lXTlaT6Pjh/nsGof3g5g
	 /o3A3eieZIILqDx6R/fWZZucZXAy31fqR7orQDbLh4spX8r4YHFH+7u9IYRO8mUjUMHPm
	 uS4QGIG6lo/RXwqRQ2JasMfnRFf9Il8mkLaAE+a2WcmnXHXp9aNeN3GVH+dJMRHrOL3FY
	 NNzKhyRPUAl4dYj6IENgK/RUesWEnZQb7v7zR1Uua8lAEc/2EZNvHvBtxme7c5+PBBsX+
	 pGYrzmz1hNVWzAvo4uEDU65kLvx26JwtnnW79I9mMo8xRL+QoXbSIBqC7AIv4CowqKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rcRZgM1P;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FF060A2630
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 07:35:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95FF060A2630
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rcRZgM1P
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a215e64962so19125375e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 23:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794296136; x=1794900936; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PHDIoEm9ZHwm2QbXfcuNgzAchc1Bm5nQ/5nALaIInYs=;
        b=rcRZgM1PKg2J1JQ5LF41jxrEtSDmU9PsA/mVX2U7WzkWWMzbzB14U5Beqh+b2xStlr
         5CHavIIrkckY9vZ1MQ76qxQvfb9c1rQgsnv6m7QCUcAVnGA2Qin4LJZM93AxAZf4VE6A
         NoZOCkd8+6ODzzKFgDYqBXPK6yuHeGKvl46YHjnxyGLAUd4nm9S06hzYpE5N6bi8BzZ5
         64yOh3MsgX8L538ywidwH/dyRQeWb5/phrRQdZydqNvj8RYFSDLEe7KwURziaZfyMiAh
         45eLie5PRjJ2aQDl27OUtS34ECvvfzhajXuhqhD6iYLkX+PLhmrk44/paCLtDSkEwsY/
         hSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794296136; x=1794900936;
        h=references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PHDIoEm9ZHwm2QbXfcuNgzAchc1Bm5nQ/5nALaIInYs=;
        b=WvP8vRs7WsfeqrsUcb6Xl14+EhM+NKvjQ9MD69uWXstGnVKLNG6jj0vWugNTSEwHFn
         TrXl/DiVpUboe1ywYKdvVganQPgH5R5IkdOA/J8fh8UF/srD+LZRgdZZQ2i/n9573keT
         j0eKd63bCPBA0F1F3cj7u2XS4krTUyByO1PRRy8lvZNIF9UhWyUXRMBuYyOob5NyNBlJ
         Qesb6CpBDru/kgAAY6ImUp3d6rFQOq/LJ/HW6VqKDgIyMK9VNu4PWFyeTzDnrnXJR9bg
         HLdrqnanQVPLNc5wdxIOPkl+UAE+7YoIVAIGxS6xMru7TVQN2KZ8HOqCcPkxWv2Iplua
         wyug==
X-Forwarded-Encrypted: i=1; AL+hErGJLAfNyghJebuA1zatQ0xsbiMlbAGZLA+oh82VL2nVvxK+yaNEmhchA+6efnRDowoZpQqCwdDCvAY1Ug==@vger.kernel.org
X-Gm-Message-State: APuU4Z8RumIQR2fdZT5X/REzz0GPYEzVi9QD8NCg0rMr6TXGvwcsLzQQ
	u099sHw72Rv/nag2sZ9hy/OpCyW/JvWKgxsbpcACGw2twMbMwWEcef0V
X-Gm-Gg: AYBFou0dAO3I8sT/XQMcNtJHH87CerZ1FSk2Rv7sw2ZRzx1Lwe0Jkntdic2ubkF4g3b
	3EEdk3ei4GNTzw55A9JAUZOFtHkST6uYxjGYAi2FEm9rnyvWJZP3MZmCIbACGFDpCMol8ev23AX
	ouhlHNm9GYK1TTAWo20kU4X2GhpJAGFe6EId2pvqEmksUWcO4vJ5eoPcu/UwyrTuWNJ3ehydoBI
	V2Lwlp25XJ+nFO2Wog2ArB6UGDsP5JDXfDzC7uXsxmk9attIFrdU/AkdRjxQIDzLXrtyZE9IulA
	N+XAgfDCL4UXZNADqBxowNhtSkobMmkL3Y+KmmYom2s0hZDZeWbPTu0dCa4V+ygplJwqCGDcCZ8
	JFU7XFP0LHuzckavf2OP6ml9hW/t1O2KAT1pEEv6a9gjWzfwBGX49/XgZp6brNdOI71DFbROjrT
	Ppy1vOr13n1hsY9zUZ3pPTVAxR9AMqVnHRRXclIDd2ImQWxsHDaDI4yytYTJRPkoDCo7LP4zl47
	clI9WeSe79K6sA0uFDn2zaC5B7eagIwCkwrWG9psW20KGeR1rSyBEH9zHxbWmeMCz8FaogavJ3d
	CTWzMEnWzToor1xJIblLyPrTc6A72/Xnx+zthWnPugqn9gEHIigXEGMFpF9+alRaMchtaXUqYr1
	zEPJwi/eZrcwPLyL5pjyfNDsZEtr46lsFU/w=
X-Received: by 2002:a05:600c:6094:b0:4a8:cb23:f71b with SMTP id 5b1f17b1804b1-4ba0234759bmr24627895e9.18.1794296135745;
        Mon, 09 Nov 2026 23:35:35 -0800 (PST)
Received: from localhost ([46.36.23.99])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498362eb158sm3448199f8f.36.2026.11.09.23.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 23:35:35 -0800 (PST)
Date: Tue, 10 Nov 2026 12:35:33 +0500
From: Mark Korenberg <socketpair@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: raid56: pass REQ_META to per-device bios
Message-ID: <f05b71b2a735d2b9d018c072f30a0b78@gmail.com>
In-Reply-To: <e29db0cb-2054-4894-958b-800d03ad4d79@suse.com>
References: <20261106-btrfs-sb-read-req-meta-v2-0-71c1afaf5c67@gmail.com>
 <20261106-btrfs-sb-read-req-meta-v2-2-71c1afaf5c67@gmail.com>
 <e29db0cb-2054-4894-958b-800d03ad4d79@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list

On 2026/11/7 06:56, Qu Wenruo wrote:
> NACK.
>
> One should not even use RAID56 for metadata chunks in the first place.
> Nor we're any different from other RAID56 implementation.

Fair enough, I'm dropping this patch.  Thanks for the reviews.

David, patch 1/2 stands on its own and has Qu's Reviewed-by.  Could
you take it from this series, or would you prefer a v3 with only that
patch?

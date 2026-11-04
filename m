Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793791184;
	b=ovl9QJNGV/LC2f9R/nihtSGDOZ4y4G0O4lHIM9/lWYwDMk1ZCOSqGMt9/AYNFYO4t5JQ
	 dx4nenrwq2MINNPJflkdb4mJN04f8rwNPGNb7bMhPAogYnXbh/NCxBmjwNcWK+YxowG7y
	 zEmJN2YmEbNZ2pLvpGcr15ALfbBoncAKbXx9hGRArFy9o6KCKKL2gGOS6Y5ndQWW9sNG0
	 fRlKz1DfrB7CRuPHaszrtB45JEZ2SuWgA+IGDcAvtpvKEnpcTK75bkQKQCPmW3CJ+vmH/
	 zMTG2pub6musAdZAJ+EgYAfLV1+TKcstKYo0lm8suxKRWi2KnhBc3f/BBzNVXxHpSUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793791184;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=43M7TAHND2IcgQAiZY49uLLcef6xiXCMYceLHXJh6d8=;
	b=PNVLGmq0c6oNmSrrnanZ2P/4dfUnRuUGZrGi/VCPGpDJQ5s3Ft9Od6j8OV5QCpKR5OOl
	 7DA/fqaAAeVzeAJIQAkYR2ns2QESBExfxGgvJaHSDQus8mgVxHn+MUfxWYtg2yAGMNgEB
	 z4WPUTs/7VeKHGiE5mG5EMzXOqM+Qnv6nTUAmvO0I08gh6AKAAz7j4iAR10VIe2e3t1kE
	 spIRVjqn/PWmc0OeXgAGGIZlX4YEFKZhlGZdSX8wPhH2NTqrWgmxGGhjStJCS3LTJc+ys
	 c2XgH7Cec2ASJA1/EuayRhYDTh2sXFYtDTlJgETY5bbDF7yEhKHEwYtjRgurU/o+0Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=SRtwxuD2;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2560A606A31B
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 11:19:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2560A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=SRtwxuD2
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-36661f953e4so720219eec.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 03:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793791183; x=1794395983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=43M7TAHND2IcgQAiZY49uLLcef6xiXCMYceLHXJh6d8=;
        b=SRtwxuD2UaSXKlZkigqHxPVcxKHp9ByY6a94nvRtJINRAH84FXB+wFOCl2PLxBifz2
         TtfqCidb8LPR6J6PypOoEnRrqOqhFiqgiii6748sksBaHqvR8mgSe5sDW9280rjI2TRV
         /dLIaD6B6bfyE6WkQY3pBuMGooqLWo4fImYZ6bF6M5zJ168dCZAIldQgXURJXhzQmiHQ
         3UgfGP0j6cyoW+k0FldI64Ttyf7lqxiSfsfEyJEaR2anjujeq2wlTRcOPvm3gDesfvQR
         qqBsI3IkXdBXyG+TsVyFrpARkDXUuswQMO936xIROY3De/qkWa1KHOhAGjAvGe0SZJi0
         OWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793791183; x=1794395983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=43M7TAHND2IcgQAiZY49uLLcef6xiXCMYceLHXJh6d8=;
        b=eNdqzaAKu+qJPTCqTcsHKklakb1dEV++lEkU498PF0vDKHbqXedG8oiu4buTgscYls
         d1tEeBiZuMSFu6v/WYBdqgr6qdeEoE6rMCMIfZkm9fYSgKrTl65aU9PzZr5vpJmJN4yN
         coP+L4PKGW5oFRyQq2QNvuvzS8uNQW4Vz9rz0xgumcsJekIUu+7g1LCrT4ogdGsWQGP2
         K/Qc2l8+cZEdw2m93Z3ZqO7Iqt49cWd/slVIz1ZYOxtauTuTRujwZ4BAkOSju38fn0lH
         2NjgfbCewXxXBKLW8upY9CAd9hZ6KdNCOUdo3dVrRqyWJQuNdcbW99X9nDnvFeqLHtxa
         bwOA==
X-Gm-Message-State: APuU4Z+/vFd6L9uk1rxgi1NII3kXrsCt23GUbYe3lZGMqyeWkYmvoXOc
	cQUvkr6RfdZreT/iFk6eT7WJpyOJK3EeZx/o5/O9K+qX07xObQjyDO1oEp3lBbxujw==
X-Gm-Gg: AYBFou3xjO+w14SIZIHYNgKzG27hGeRuouWkwPXmGAZJKeQTYAX/FXII52BX6MtaUqR
	L2GfaTonrBhx6IYaRXRMuOEt6JT/q4w5LSR7B53YGBC7ve53Bqs3vYkFc+JY4sUb8pWzgLzoIKi
	1ONH+E6Kq6nBOnmxoS5ct0WWQ8Or7WXgVVnFlIKWSobJ9I3+4K9u6FFuQg0I8mPHB58wZDflvE9
	DSP/4+HQF9SMXtnPxjjJHaDcx0u399tWlYT3sjOh72+3e4V/BCKw6li6DmkyVxCls0bvQp27+lN
	kzf4xke6ChCCiHhs8cIPQkaUvqvc0uwBkGM15nxqly+g4WoWAjxgP8AMeiBXqSr3fZLDRWjd+Bv
	aR8t4PoxmfJYrxNkJdpC+pmE0GYIxVNA3ZFqFJ2QcwgLNuck1XhrA/GSeWdubyfyUc83Vd7ABiw
	UN+OJNkllVO8IdcfKGmgiauhdHyu8JKtDvEtx6deRQvLh1mshGU8szmYYYl0WvZ/F6L+6j1lzzX
	iA1vabXgJW83Zxoi+a2ewTMCFVAWrlf7/QJjrypDQfXFtDEki3IDOn2SDNO+yMnnWa0FjWe6DqQ
	hzI1DAxtQIuT20tmPqEmtKMu79Dzra7X8HpdJwVesA==
X-Received: by 2002:a05:693c:894e:20b0:368:7c9d:1577 with SMTP id 5a478bee46e88-36a4238420dmr23201261eec.20.1793791183058;
        Wed, 04 Nov 2026 03:19:43 -0800 (PST)
Received: from localhost.localdomain ([2600:8800:1e00:25f0:ff01:97fc:f9e5:d7e1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38d36a1sm8044949eec.12.2026.11.04.03.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:19:42 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>
Subject: Re: [RFC PATCH 1/5] btrfs: qgroup: clean up config after rescan resume failure
Date: Wed,  4 Nov 2026 04:19:39 -0700
Message-ID: <20261104111939.311651-1-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <2d35ad0bec65ec74f998c7c1731b9a5aeed3f477.1789524388.git.zhudongjiang@fygo.io>
References: <2d35ad0bec65ec74f998c7c1731b9a5aeed3f477.1789524388.git.zhudongjiang@fygo.io>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Sep 16, 2026 at 11:14:49AM +0800, Dongjiang Zhu wrote:
> After step 4, the qgroup status item can contain
> ON|SIMPLE_MODE|SCANNING. On the next mount the kernel reports:
>
>   qgroup rescan init failed, running in simple mode
>
> and the mount task remains stuck in open_ctree().

I hit the same hang independently, from an image whose qgroup status
item already has ON|SIMPLE_MODE|RESCAN, so a plain mount is enough to
trigger it. The mount task stays in D state, on debug and non-debug
kernels. An image with RESCAN but without ON hangs the same way.

I applied this patch on btrfs for-next (df5b88a7914e). With it, the
first image fails to mount with -EINVAL and the second with -ENOTCONN,
and both mounts return instead of hanging.

Tested-by: Siddharth Mishra <smish149@asu.edu>

I can share both images if it helps.

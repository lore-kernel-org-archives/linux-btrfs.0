Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.27
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611750;
	b=vUFLkPwZ6wjSYI3qork18UU54fLxAqZxUNDayYS5/uiizP9EQnthWqQUGkstCUwCjLlR
	 WcyWkH2GtbXJDAhkN/dQGoW3LmOawQ9lHFr08k5ZcKMGPJNdBYU5pQ3D48uDvBLpOpe1t
	 iJa5ACwwmR9bfpZybcsttA3TCNTacv35u0l650PPTDtqUEYHyE3diMsXZ5C/G3LT/0Iiq
	 0QKu0ONs/eWadNuu4GDXg0cLiUvXeCq9RFwT3l2WvnlSo9cUlMwl/Y18g5nnHZRtAvzsl
	 GbdisOhzmHUULZ1YtN/ucX3uUZ2PRsDbwoyXVe6+4zKWyApq5DClgZSJIWAjNWTHXug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611750;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=lQ4BkntmN7HehJFvDo34oP6vrHB+te6z9NzGOwyNzJQ=;
	b=JmGf6t4F8Kyv3/6N+ihebeXqNef2PFAXSemrDOpsq2fBT/+hDv80THz2AsQ6lrHMFTsT
	 0ahS7HfnADmYsqFCPi3Cy4eKvO6koevyuVewBTamxHjY2p0AJBkY9pBgt2olBxgdEecY7
	 n3Daep9+fnm1VbAbLb1egaAryCnXsG6Y6VNrcqLVF09yFj6F/RytjN3IXnzhOgxjdhc16
	 v0tq0L06F7ip/TWeMz2RlhTcQK3vpoWoQmvFACxSDrE3lETq0jsd9H1YxHrBuljeEsNVK
	 D1x4XU+/LwDZ43hEYfOxUA7Hwuw/0sZ0uAS2hiYgdgJRdiOSQue6/0941kqAUEurhJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=0o1ggw97;
	arc=none smtp.remote-ip=79.135.106.27
Received: from mail-10627.protonmail.ch (mail-10627.protonmail.ch [79.135.106.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27370606A329;
	Wed, 25 Nov 2026 13:02:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27370606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=0o1ggw97
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795611747; x=1795870947;
	bh=lQ4BkntmN7HehJFvDo34oP6vrHB+te6z9NzGOwyNzJQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=0o1ggw97MY5uaMJIPjFbG/LlmVoipWdfjZLchOzJUbzu+SaSfoazJ7uwyDOyu78lk
	 htOluzmAmIC9CPAfX6uqtG/fkxA0y0UpnI7kXvK2SmUdYrcx/fyrW2yZzRWTA1g4zx
	 qkFaXMpAoqzd9PLoSHvCOp3vPaQ46qhKuiuAa4Q9UWPYwqBFVSGfRwqeybGBnAmPqw
	 TohSLzthR/k5WqRDlyOOwy28vSPnSHBnh+I0ivB/IalpjeDJKNAMwhMNWlO69kXOl7
	 nO03Jld3mDUDoc5gCLbK3XbIIbyYQY1//+smu0AV/IwBMaprio4vm2myi1N+7XST+5
	 lKQ9xZ1d9U4Sg==
Date: Wed, 25 Nov 2026 13:02:23 +0000
To: linux-btrfs@vger.kernel.org
From: Miroslav Cimerman <mc@raidlab.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] btrfs: zoned: RAID1 block groups with missing or stale stripes
Message-ID: <9-2mnnEeWtv9IB6_6WebTlE3yFWPBLEtc94ilVb2gMhId8z8pMjeVRwAhkniDIESZEJhl7xNsZ6KCwe759zYLm2asBJrtFbeJpWM-TVCU1o=@raidlab.org>
In-Reply-To: <20261121134550.216217-1-mc@raidlab.org>
References: <20261121134550.216217-1-mc@raidlab.org>
Feedback-ID: 232820807:user:proton
X-Pm-Message-ID: 4e8b79bfa9f5b485ae9143216898751988f6765b
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

A note on this series:

Johannes' v8 "btrfs: zoned: metadata and GC updates" covers 1/5 and the
active flag of 4/5 (04/27). 2/5, 3/5 and the highest write pointer of 4/5
are still needed. I can rebase on v8 if it goes in first.

Thanks,
Miroslav

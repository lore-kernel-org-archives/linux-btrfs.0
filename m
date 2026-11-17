Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916801;
	b=Hs+mE1kFvjnrtkDYZ7dsEGPdbCLvZX217zZWWpIhZkdMZVuZSoV6SoATezH4ehzi/yym
	 BeLa+laQ3mGYUXzvOUq2BK6R3cimKd2StnFWpbZYobkvufYr+iazwDyC9eRu/XqIENk3E
	 miVicynKJOWraTuHmTmKpf3DjpJSebYoY0g49vlAK5aUqeGgffV9CnujrNYsdfsp4AufR
	 tNBsY0QPZBHg6jTQuCybzRSo7xEZ9aZ5+aY3r/j6K/gxtahnzww9rth9uVyum66zYlCbs
	 BA1Jsr0fGvy3cGdb+oiWU5AeBOFtusFn3YGIkp82nQh68BjlcoaTxORG5W/joxSPZIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916801;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=2GOnbIhIFtjMO4txn3YzzVDHvTFA5v4rWedREUEmvfc=;
	b=oHiEdlChD4FbtAFiV/EK5dkMNczPabck+h89wtwpkK/v2f9ZEwdJmfhS4j1FkhAwehnE
	 zSPAHr8Mq9OS5tAAgeWJb5s20kL3UjSjgcUuLGqUx4St04urKjJBK1IVmZPIdSItrYaJ3
	 BYxPa7982+FSY9s9GZ+GV5nu7SBF+f3Qe+kn5rQhrOzYmH4dZr5K2C7cn7MVKEV0qyCNO
	 o2FIU2olhwoCc0IPCHg5Rr0ZGVD5p+NMNnzrtjkhqNNa4PdN8neaFIbkQK9jRi5cF4AYp
	 lSFVfxvTYhTKqm1qHfjUKvJcnSNwiTcorcfSNCKSqSMBfuo++z1QjDLS3aHRBO3ngag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AnqmKjcl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED01606A329
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 12:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AnqmKjcl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91501F000C4;
	Tue, 17 Nov 2026 11:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794916800;
	bh=2GOnbIhIFtjMO4txn3YzzVDHvTFA5v4rWedREUEmvfc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AnqmKjclDqrK7UlaiAFwodx9SoInvkvbbpUJ8pyomYtMmLIMGtlNXHQoBet0OKh1Y
	 Rew3GTCz5DCYBeyzl7VetsBctGDp/OOMax5pzNw6uZA45F55SwTwqSW5cOndbqrP6b
	 B4OTPZV65sT6f/9t+tJN/FP+9JCxSOZ/LIUjJmJfYvoaBAHCOLyggDfDrc++1vUtbH
	 W/W8xrOv2HhDBjILT5K25L73u4zgM6w9aO3sHKMNCjf8xGEPztRDYz34AmO2nHSbMX
	 WPONMkmqtqMlscX48HzY73Jnk2Y6w7jzppKaMdvSB4Xn22uOMPz/XgmYV115DWxYPg
	 BfgZEdfuGDDvA==
Message-ID: <d739c6a1-ff7b-48d9-89c5-bc1e0606cf97@kernel.org>
Date: Tue, 17 Nov 2026 03:59:58 -0800
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
Subject: Re: [PATCH 2/4] btrfs-progs: zoned: add btrfs_finish_dev_zone()
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Qu Wenruo <wqu@suse.com>, Mark Korenberg <socketpair@gmail.com>,
 Dongjiang Zhu <zhudongjiang@fygo.io>
References: <20261117084948.3848762-1-johannes.thumshirn@wdc.com>
 <20261117084948.3848762-3-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261117084948.3848762-3-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/26 00:49, Johannes Thumshirn wrote:
> Add a helper to finish a zone with BLKFINISHZONE and update the cached
> zone state, the counterpart of btrfs_reset_dev_zone().
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

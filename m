Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460911;
	b=2wgUEK/iTDlZYZ7CtEQgi9ZSX0M3bRZ2CmMCLGSdgkHihc7c/057fNyiV/EuBpPFOjnD
	 ZQhk2m2BAN3q0+SfTdYyNUWXxxzgyCkNkW4EVTJOUUSY5BgJkSWS70H8eBFxHi8GZYthk
	 g4xUlux/+wvC1atAlGpdG8/lPD6z1WSpgO4XgBtEb6xSyES/uuNTX4B4AuCekVhWs3SWq
	 bviFjY/Mzr3aAu8c7j5ZjBA7IfMJ7RmEzYgtKUf9Fq8ObX64f3F9nGh7djljuhUB+oK5K
	 kP3AJmEVaxeJ9RbXi81+/Vvn6JJnARXq/cUceyQuw+or4u4EUFwtBYMz+Vkua2p2I3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460911;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vsAgw1VfeeWM/+e489ddh7F+FNuBKxcy9f2jjrirCAY=;
	b=BMS2mpZ1Ro09Y3mctKc6P9aHCJ0em13Ou8Rua7nRCcrXFM8rXyXW30dtKjc5CU5fQSOR
	 H0NJqNivYlkr7muh7lbaF8Ghk/cYPm9TxQ8HyG+pnK+CsFQ5rhe932rU+6XqIJjZZoqfh
	 kVuHuklzkfkrkb//32NzfL5CWhKtc6faRB5V7nV3TdhJzUo2fANcf2I04XDkxm8qxxkN/
	 hJzDgwJKgKiLfxoDNiXgPCmQpDc0Ezcsb0oKfn3neF9xBvhNFVUOachw49prgaz5J5u6M
	 UM2oPnZMIAlJonT/AEUuxkO0u5nTI3v1mzY/jMoCfVxHJhTtBISK1FZdu+79YlleeNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=4YBPhukS;
	arc=none smtp.remote-ip=79.135.106.113
Received: from mail-106113.protonmail.ch (mail-106113.protonmail.ch [79.135.106.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41385606A32A;
	Mon, 23 Nov 2026 19:08:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41385606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=4YBPhukS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795460907; x=1795720107;
	bh=vsAgw1VfeeWM/+e489ddh7F+FNuBKxcy9f2jjrirCAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=4YBPhukSKQV/iaBxkMy1GpIQGGkXrxBQLl8Alr0A69FqObNyzBrKiX8h7QUNH1dNB
	 uyCavcjQo1txMiAcCu6uZhqpJP/PSqDm2FmVkATBTUPJkOf5BCvK2NbmtNOkHTjQ6b
	 dv7UO41miHvbX8qsAs3hj5y+zr28EPXt/xvaBL/F9cb0rN4sw2E8SFKHGGrHXjGENd
	 2xjbitDYE/SWVGvEmZvQpuSxMW7klekbUjTZpYvTwWj8sVFZJ70775LUKzhJoclFKi
	 pN0iwUkbHPsPJqsG/kgf/+FUDLd4DE3k0Zz619EdiD1sWSR7y+ZQJ4Y16DEpLWX+xH
	 7x4Jl96bRIvpA==
X-Pm-Submission-Id: 4jYFpH3PvCz1DDKY
From: Miroslav Cimerman <mc@raidlab.org>
To: josef@toxicpanda.com
Cc: boris@bur.io,
	ce3g8jdj@umail.furryterror.org,
	dsterba@suse.com,
	fdmanana@suse.com,
	johannes.thumshirn@wdc.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mason@kernel.org,
	naohiro.aota@wdc.com,
	stable@vger.kernel.org,
	wqu@suse.com
Subject: Re: [PATCH v3 1/6] btrfs: don't drop the error of the last split bio
Date: Mon, 23 Nov 2026 20:08:18 +0100
Message-ID: <20261123190818.2841562-1-mc@raidlab.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120-b4-btrfs-data-integrity-v3-1-4de4b91b826e@toxicpanda.com>
References: <20261120-b4-btrfs-data-integrity-v3-1-4de4b91b826e@toxicpanda.com>
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

I hit this on a RAID10 file system (not zoned, 4 null_blk devices) with
bad blocks on both copies of one mirror pair, on for-next 65101fe10b30.
Reading four 1 MiB files with dd returned EIO. After
"echo 3 > /proc/sys/vm/drop_caches", sha1sum of the same files returned
no error and a wrong hash for each file, in 2 of 2 runs. A dd of one of
them right after returned all 1 MiB with about half of the bytes wrong.

With this patch, all of these reads failed with EIO, in 2 of 2 runs.

Tested-by: Miroslav Cimerman <mc@raidlab.org>

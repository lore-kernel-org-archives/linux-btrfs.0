Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539F93AA1A1;
	Mon, 20 Apr 2026 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691281; cv=none; b=h3WhWIVMo0JRpUt3IS/fXKZ6VVCnpvlxJ2CDIusEhUctjr9+rHXJHnbzCkxxjzmIuXEGMyX9ppAfRqJiHVjI3yvoazjOY3Q3M5W01/gU0RdG1guMmTnNWv+osB6Ca8oVWX5TekoYNm6WjDlJ6K5zPzfLzNUD7Lm2JyRd4PtjGes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691281; c=relaxed/simple;
	bh=vQj4VUJZhGjq5bHtbpOjlPHydPbdB3zmrdYNrPI8Bu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9zoCZClgw3vxzl7bt6pQlhxpEuyAFOM6ejXwATnlvHOmiSyRZiApnPHwCxzBC96UYWCnr8OCK7weV4bQ1HG6AugrYK2aMb36Qzq3k56fXei1KtOYqoPAN051dhlSaHHKRppbzhE9wdOLCgTqn1+N/3kQ9Di5EX2p2Cioqivgc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gdr/sO/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gdr/sO/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533B8C2BCB4;
	Mon, 20 Apr 2026 13:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691281;
	bh=vQj4VUJZhGjq5bHtbpOjlPHydPbdB3zmrdYNrPI8Bu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gdr/sO/UVFZL8cE5KWo2c9vgAy5DkjtfzaRWoiGGMuS9iNv8wXWTL0KK3r9UoaMbG
	 ylh5YiNc366ofjbPHmQZC7veo14rPPzD5Q0/V+O8Mt6cixnWTAYXowTvfy7OW7xvhQ
	 MpjCZLhk7KbtdnOn5Ura5jabrzSkDpaKQ+7QiOk0rEODtgOzEg49sZCLifp2vPe/tw
	 WjSGb83R3zar98nXOGNxnDYkNoGhpMqLMb/Pks8zNZH4S0xEjsLcZBGa6UiAqIOeqp
	 KEGWr3VYbKn56s4ywm26hAwW93WtmCCG+6ly9kCG4Vyqh2HI7SuybBhd5HUWYlos/L
	 YTiRqdPnzp2ow==
From: Sasha Levin <sashal@kernel.org>
To: Ruohan Lan <ruohanlan@aliyun.com>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 6.6.y 0/2] backport to fix error propagation of split bios
Date: Mon, 20 Apr 2026 09:21:01 -0400
Message-ID: <20260420-stable-reply-btrfs-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260417025116.743-1-ruohanlan@aliyun.com>
References: <20260417025116.743-1-ruohanlan@aliyun.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Apr 17, 2026, Ruohan Lan wrote:
> Backport 9ca0e58cb752 ("btrfs: merge btrfs_orig_bbio_end_io() into
> btrfs_bio_end_io()") and d48e1dea3931 ("btrfs: fix error propagation
> of split bios") to 6.6.y.

I had to drop d48e1dea3931 ("btrfs: fix error propagation of split
bios") from 6.6.y as it doesn't build on riscv64.

The commit uses cmpxchg(&bbio->status, ...) where bbio->status is
blk_status_t (u8). riscv's __cmpxchg on 6.6 only supports 4- and
8-byte sizes and triggers BUILD_BUG() for any other size:

    fs/btrfs/bio.c: In function 'btrfs_bio_end_io':
    include/linux/compiler_types.h:474:45: error: call to
      '__compiletime_assert_386' declared with attribute error:
      BUILD_BUG failed
      ...
      cmpxchg(&bbio->status, BLK_STS_OK, status);

1-/2-byte cmpxchg support was added to riscv by 54280ca64626
("riscv/cmpxchg: Implement cmpxchg for variables of size 1 and 2")
in v6.10, which is why mainline builds fine but 6.6 doesn't.

The 9ca0e58cb752 prerequisite is in the queue; d48e1dea3931 itself
will need a re-spin that either avoids sub-word cmpxchg, or a
backport of the riscv cmpxchg8/16 infrastructure as a prerequisite
(which is likely more invasive than we'd want in stable).

Could you (or Naohiro) take a look at reworking the fix so it doesn't
require sub-word cmpxchg on 6.6.y? Something like a spinlock-protected
update, or storing the status in a wider type, would let us keep the
fix on 6.6.y.

--
Thanks,
Sasha

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A042475CB;
	Sun, 14 Jun 2026 22:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781476404; cv=none; b=oPmZaPULp/GsGnBCFCXK73kFOzqd07y8eGTKwUAxW7iBtyzUqr4Yy5TO+bBfdrKhbUGrlmMkFdzKRwquR1LdKz2x+6Vm2maQ+k+TrKt6QCJSZD9EQNMsNDJzIdTiTBC1TX6Gh0kNqQ7J5Lv4twmQfsZf9UETqxaSp/on9NQGxIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781476404; c=relaxed/simple;
	bh=+zEHZDzJQtQKUninfL0hHh7G8Cm4+WJrtjMGTXgWkvU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Message-ID:Date; b=CjUnmRaUqO9tZvovxQWJVQBNSyBx2rRP+7k7ZJkqT6XGSq/dagEwkmCaWZlTxevwA4Vs9ddRAAewZBI4Ulgpyvn1FqdcBUJAM1g/QM0BEuvQNU3EFVG6mfZejIsMGMkCqfPRr6UYsMa4N9X9Y2bmU5oI/OIhejonkdlR3qHZK7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2hlaqVc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2hlaqVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730821F000E9;
	Sun, 14 Jun 2026 22:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781476403;
	bh=+zEHZDzJQtQKUninfL0hHh7G8Cm4+WJrtjMGTXgWkvU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=o2hlaqVciJw7NfFQ1mxYqkoLd1I8iaotMRARFHb5g5POYwH9mVm1qC/O6pQwHU0ic
	 xYdOMx8fiOkQEsOVQTBn7ac2myaILsMmR22qZM0/I7mNwYK/1dkhXNLEtX3kp/PPwP
	 SuP3EZAFM7CLLoUY8JqiBwumbUTknmMjxbfxNDGxTk6K3PQ6N1HgY97j+WUOvZA9NP
	 UgYNIOAhF9qc61tr42DdJkzY1iisf15jdKS0NY5rscvP2syIEWDgnRcYB94DSrcy+V
	 7ZJX0GTDhj5liYRMBpB+Sd/GEIf600WoGjIw1uArVvShGB4ewEkjWh8N4eVbkT+2sq
	 WxJoN+DiECaBQ==
From: Tejun Heo <tj@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Marco Crivellari <marco.crivellari@suse.com>, Breno Leitao <leitao@debian.org>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Drop WQ_PERCPU from ordered_flags in btrfs_init_workqueues()
In-Reply-To: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
References: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
Message-ID: <wq-applied-btrfs-ae24176ab9a4@kernel.org>
Date: Sun, 14 Jun 2026 12:31:43 -1000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

Applied to wq/for-7.2, thanks.

Holler if there are any concerns.

--
tejun

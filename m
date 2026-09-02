Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B5D3F6C2F;
	Wed,  2 Sep 2026 22:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788387269; cv=none; b=P7koePQ9p2Ev0jFlc+9+VlZ5myvZEUzAPl0BM0cn8mJA7b9/aCddOQScDiY3cjnsKmhogB48P64/sAOO6uw9LWh3MFxHXY4O3xLLlqvwXOCdyJ6Z1lf6RwMMlodAH+agzeuVRG9yScrtYM7psAMXGLkhJ7Fq7qtS2HXU0HRdc9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788387269; c=relaxed/simple;
	bh=RnG8kUG7Oqu71fkL3nTnWt+1u7TQOetlVcg1xnccfsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+ZZAVj0nkJyu+YWQRqhacYcPZzv9gxnewIHXy7i0CeBPvtGHpje/A/GAzf2iXT9JGViewZDP3lKIJ11F5FZZd/+hxICCzbIChxzevwt0knAlWTSo5kxt4EqYR2dzkmMMAwGgRPuN2IS3HkgwHJV7zZ13p4CrMPdLrtbphcoiLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJTkrqN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJTkrqN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEF81F00A3F;
	Wed,  2 Sep 2026 22:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788387263;
	bh=4l0D0V2WOZ2tV5AKqiWhOBnE2LVrqUhLGOOmYcmG+RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJTkrqN2qBZ6Sd55gEJrWZgobXF0lyqYEk4Z0alU4S2BsEmvuxUuzPrEcvGSiB/IV
	 XJ7OEZu7mbbsFSCpNXit1cU/gqGvqOIrAgRI8iAN2aSB2pQyJjVGDIXNACGYLM1UIz
	 nuZcmPaoWiQtPJfyqJlW6evgYdhQ0RIlilZK33j3iwWgqvRkJ3hso68YQ7N0M/nBiP
	 FcS+9leaM5G50O5m/tfvWMrrKPJ8njfr5jo+ZR66wO4phbBIlyTCu2k1XjpE6PbGD4
	 frh/9U+QTDx2kWKbdcU1z2A336W7gfOoIK0dUqIuiMAfigF4cNA2qpIVQv49Vm7yaP
	 cnQihYvZSy6JQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-btrfs@vger.kernel.org,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Chris Mason <clm@fb.com>,
	Matthew Schwartz <matthew.schwartz@linux.dev>
Subject: Re: [PATCH 7.2.y] btrfs: write-protect folios during data writeback
Date: Wed,  2 Sep 2026 18:14:02 -0400
Message-ID: <20260902-daily-reply-0003-btrfs-writeprotect-7-2@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260901030945.738683-1-matthew.schwartz@linux.dev>
References: <20260901030945.738683-1-matthew.schwartz@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> From: Boris Burkov <boris@bur.io>
>
> commit 5376c9db45368eb210b4d71104ac00a59dc8b6e0 upstream.
>
> commit 095be159f3eb ("btrfs: unify folio dirty flag clearing") replaced
> the folio_clear_dirty_for_io() call in extent_write_cache_pages() with a

Queued for 7.2, thanks.

-- 
Thanks,
Sasha

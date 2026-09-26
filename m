Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B867411F90;
	Sat, 26 Sep 2026 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790436437; cv=none; b=ct41CoGNiUDsP0ws3fccna5D1y0RatIipO0PbHce98qNU9iQspO7V1OQJMofZLqlOtzQJQuujldyIlrU8SyHJziI4s+dsR04MF60OJf5HPSW0By/qbVL9W2zZ8AC6aBXe7TILSU722Wd5bxtHNqPJ43y8n1mVpWfn490g3SWR78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790436437; c=relaxed/simple;
	bh=/4LZ4oH3WWZy8nIDaSH3SyjjVo+VvdZPPy5tuZllreo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKXYOxDJ4DoGY02VXvmqGT6XCFWARhvovcRzj6yltCFHBFW/bNOPn7Eyvg+XQdpQWVYTSM4PwHXBCOmnwuSkEG6Q/zlofzVXrvhSrbiXWQImnXuDYUnB7vmyIK9YLsaZPj2bjO5zB48CCTEOrzix8ZWp/e9k6SFPYtGM/6LTNU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhOlrd95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhOlrd95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5F51F00898;
	Sat, 26 Sep 2026 15:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790436436;
	bh=XljTZBoagshJZulfIu8JeQbMfDCuMmwWnXLaCCu4BHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhOlrd9530eAb3QKL+EXyfl/03onD3p5ePvAKsbbdmPU/yV9/tqn3o+cU+Yvv9B4o
	 H0QLFbT8sx1Yvi9IqexlEz5vtI/n4rr6/5sI1KzXLZ2YwkVHkP4HcoYYiK+JQ6+NDv
	 ofr6V0U6o216AUTfZnm3EVmgFWSgac4xtYfBWuoT5SXiA1riJ/fOdzjt15rIaqYBn6
	 WXfDfob9JYQEVLO0SuxHRmmXpYBBhGfgDK36jCfbbDN6wVt41xa08hld4jszDD8PhE
	 pH2rm2aDZZ/8U6dabLmVC5zaboMNaThGoZdvA2c7WyEhACpcuq+U3NtdTl17a2Ydna
	 IYLh7MF2ul16Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y] btrfs: insert tree mod log move in push_node_left
Date: Sat, 26 Sep 2026 11:26:56 -0400
Message-ID: <2026-09-26-daily-reply-0003-re-btrfs-tree-mod-log-push-node-left-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925195350.31328-1-artem@trailofbits.com>
References: <20260925195350.31328-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This is the 6.1.y backport of the fix for CVE-2023-53538.

Queued for 6.1, thanks.

-- 
Thanks,
Sasha

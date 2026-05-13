Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D3F42A82;
	Wed, 13 May 2026 00:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778633027; cv=none; b=kalI/DZZI5uwoHjL+ircztJqA82A2DTq0lbPbrpGTVW3VTE0kcbuL2Tn02VKWtRch27NLNgQ7az2D/3ta+VmwD4FiLH8KekywE+1eqcl5MIammlZBR4irVlaoYzw1rI+y1KRbsJqY1ta4PhE8RhhNZm5zjGXvc8A/6494w8X8Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778633027; c=relaxed/simple;
	bh=oSC2vPGr/cqRklDEpJcJeWWGJ3FZEnXoePEt1Ui7O+Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=HUQooC+CWIlGQ7j03XmbpomUObSThTIGN5XZSC3VUwJ2Rld+KN58WYZKZ6lMV2uwrkW/QUz/6prbkZHcNfp6jT29xA9z+pB3ahxFCKEOBs9GWHnWZD8aIaJaMxtB8D1EHSVghQ+BRg9aXVm+3K8VYsGg6/6ozMXThtEoIxPk2JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=fxiukOl1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rnesUf7B; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="fxiukOl1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rnesUf7B"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 00BBFEC0176;
	Tue, 12 May 2026 20:43:44 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 12 May 2026 20:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1778633023; x=1778719423; bh=gOZgvVeSRQJmzZr0PiKwT
	TcHo9TZDQEHr35hNn+OUl4=; b=fxiukOl1ffmCSRj0ZeF8vXHSLrxBqOr/RU6qX
	mfEc0OX5v8wq29Ul3wNqEf3i71UMMZtzlzFRyMOvh5+PRwFwsk6I8OYJlYnGf55W
	ir3B6aos07ANJQyoxNGUJA9qjC8rut2R7Bs/O4zBRMu1pgjn0zuTcLOiEkEkQ2fP
	PfpxUQ48rLk0rFl0lsSCt5OArs0+gfVtUP5QQR8fOFAcnSjjywpyvm8+LYDb1n5z
	usrOdlyGGsTk7dphBGx9wvkcPAdK4tktzb+WXFPaAKCMXFJpIYS4Uxbq3TsM15zQ
	4SwuYieGKLMF5GpzJDTXQcSPDajWwoZWDz1AwlNmsLU7k+gpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778633023; x=1778719423; bh=gOZgvVeSRQJmzZr0PiKwTTcHo9TZDQEHr35
	hNn+OUl4=; b=rnesUf7BhwyZfEwTnBVjEKir4/wcwmyIfZV7qmvufrHyuoUiTh/
	j8GFJTea+UbBMf+nAuYsRMU30v0+CQYtNi9hdNlCGwjRk6EMKi78kWyeE1uqoLeB
	1QATKgVbDIxd9118ST82mVdVN4I+FmEuTdjeHnw3UcBLZqeebAG9KrNW3y7MWLG/
	pO0mKkR+5tbH9a98dKQxdaMc0zCT1gN/pc9mfdZKTO4QsYj0ngswjf6PQckjW9z5
	ANC4ANNr+60TF8pkiYvrWg4xtekDyLy42ii83GO0y7o9zcLYKLKZ/94D/cC6vKkg
	1U94iL2cLOKh2blItMdFAUSn4RUP23Pk6nQ==
X-ME-Sender: <xms:P8kDajyQr2x-xXOIOZ02QF2fEnKBPUFFuoIt4Ry0mX3ozKDt22BBZw>
    <xme:P8kDajDVcOq8nwPeRbT0vqBYkWCgj8JxuM_HOCfgy41C28ln-kc1w69E8HAej-iZH
    yQuXlwOW96XotnQZ1wr75s0ADclDqLiD37RA_mJmqg9w4PnhpCdNnQ>
X-ME-Received: <xmr:P8kDagZhNcSzyIOoud3kD_1VMMZyoP1zK1SzVRIiIwmte9u81D0Pub4ipXk_-PvYsKy4zqm6lYaeSEZjJBx-utPb6dI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvdefvdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtredttd
    enucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeen
    ucggtffrrghtthgvrhhnpeeiledtfffhhfdvtdefgedvieetleeijeejiedthfefgeekhe
    evheekjeelkeegkeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurhdrih
    hopdhnsggprhgtphhtthhopeefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehl
    ihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkh
    gvrhhnvghlqdhtvggrmhesfhgsrdgtohhmpdhrtghpthhtohepfhhsthgvshhtshesvhhg
    vghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:P8kDarg0_y-ytVlzLmtPpBdmTvVvQ4-4AR0xE0IJuLceWLVUtAfA3Q>
    <xmx:P8kDai7MeVC1UPi-nPih0Zql-u6i6Bh20caTdnMLNgO5WggULyKrLQ>
    <xmx:P8kDai4E5DKmrD3JU83hhkpqiYcuIF1CbqzN82_H3BapoeYCZObtMA>
    <xmx:P8kDamcpKbM-Pt3vvz5v02OOkTXe9IHu5yxRMXGUevN4x_naBkOOTw>
    <xmx:P8kDahtgYaHEOMxx9NSi3JNRTudKkRq5haqnlgxAcAnkoFy8h6ZMalql>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 May 2026 20:43:43 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	fstests@vger.kernel.org
Subject: [PATCH 0/2] squota delete fstests
Date: Tue, 12 May 2026 17:43:32 -0700
Message-ID: <cover.1778632843.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resurrect a failed previous attempt to land tests exercising edge cases
of squota qgroup deletion.

Previous attempt:
https://lore.kernel.org/fstests/ce4a79cafb6790ef6d1e141d65195f72f469ae4d.1706035378.git.boris@bur.io/

Since then, there have been some more bugs fixed so include some
additional testing reflecting that, as well as incorporating the last
round of feedback.

Boris Burkov (2):
  btrfs: inline enable_quota helper in test 301
  btrfs: test qgroup deletion races with squota writes

 tests/btrfs/301     |  14 +----
 tests/btrfs/348     | 136 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/348.out |  10 ++++
 3 files changed, 148 insertions(+), 12 deletions(-)
 create mode 100755 tests/btrfs/348
 create mode 100644 tests/btrfs/348.out

-- 
2.54.0


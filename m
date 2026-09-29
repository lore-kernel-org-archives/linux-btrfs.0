Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02225333730
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 00:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641244; cv=none; b=fHNa8jKOP/Dc+m3xHef4Gxpv+571qV8h0eNJR1ZrqITqompTMc6evnb1EkyiATl2arhp/owSShHpvfowGJ6ww4v6otHSsDOWXpfPmnlBM5l6Pq2dg7EMxyOROcGzBcmF3bXSBjLoRhGvaUs0+tb9N5EiHSI42wkZz9UZ6b/bX70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641244; c=relaxed/simple;
	bh=ZJwT8tDkQRpu/LvXlJq5i+frnoVwURBwM9ZkzkKrosw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=R1zxit2S8sHb1C3TAX8uJIPTtrWDYZJ7trzTP9KCXkBtQneLhOHJVUQ9ZyPH8SfhSWTQKIjCnunX2MZ4feYnEzIAxhMoZoYymRINM1+tjZGw+dxRVMBqa7zvKNbNzB8Nf9QsYHtLGXb4OZ3vZQgFMu/cvQirgh71/8tMl2gTCl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=jwUbVmhA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Xt5jo0yY; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="jwUbVmhA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Xt5jo0yY"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id E6EAEEC01F2;
	Mon, 28 Sep 2026 20:20:41 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 28 Sep 2026 20:20:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1790641241; x=1790727641; bh=3oADAuErzVf4czVV/H2Oz
	WGR+OVDjIAqsJ1hwKa15O4=; b=jwUbVmhAix2EULZo5UvBJufh5KrFGPDyyQRNx
	4nhPk8C+yDRXU+lyMtLSxiuENoHIJXVDzL3Wd9h1ujLZjqyUUibt29cTqpE//55V
	UhNxEfXxheY9BgQRs/3/HNn7aigr5ZugsaHfOEtHlAdanefC4GSpe3IBvLabu47s
	2hIvq9TksHugx+8eyLjrXoyRX/PmE++y/t7YPrxgT0b/Gk/xQrAzOXsQU8ewlDLg
	97cxhvXmqDB8guEKNmNnDW8us0itOGNrfKNKuxA2VpruEhzkIOt49/9s6TtMT+AZ
	EUtVf2p3BJADFzMdTCYwJS3k8oYKWVg0XkO72Ivdv4eMKfo+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790641241; x=1790727641; bh=3oADAuErzVf4czVV/H2OzWGR+OVDjIAqsJ1
	hwKa15O4=; b=Xt5jo0yYCcHBGrg2zd02jcrcRE6JXL7k+MqM5F27PAECF5UsWuk
	A6C5C8hWU+BhSH9v9QVvuWB/J4VqKl0DRY8pUoi64N9EPc/Zv7RyX2g13kXfhI1r
	DuqqZ/CN+JSot3SVt5PXcpiSNzSuuACKMowmFcT624H+h6L90bZSdzwjgLQnH72J
	7p2V6muggN1TwctQrxH2TkdhIN9vpWhdJBQvIXaaNpJEITBRMtgXz8NebvTWNpsr
	lX4boxiLqIunXGSPLLhhHKG14Q6TG6jTaBDh2N3VlD2nlUMuim/Kc04k+3p0YiR7
	+6L1YlBE2GKWojgrkDVk7YcH8mdzKakBhiw==
X-ME-Sender: <xms:WQS7asJuOGOQofxgEqoKeniaibGhnUYZWGATEn_fQFdcG8KcNFYI3Q>
    <xme:WQS7aiIU9SFnanFEQaerQ27UXZPtzfgd9ySAxZpskM6wlLlUqNuDCbyYIeoDqtgdo
    uGOW3nTw1IIa73tSKPiYQvIBzkDVmowtGc37qkR2zHQRRhvq_FB7JOb>
X-ME-Received: <xmr:WQS7aqUUEeXxm4pmANFBp_MyClhX0QxZNd9iJsloQyZXOP5z6-ihPpM>
X-ME-Proxy-Cause: dmFkZTE0LO4RTwqrRYHaqXXghA18NZoKWnp+fkszv/K/ir1EXYFjndWHBgRBrtp7Mge/w1
    gKz1Hepz3qDcxEHzsOxa5HEKU/D+1hXYrzuujKJCOlh+AZrBM4+pjeAPL3txxIq6UegtT6
    BL8E5qUIlV8cz2fOaUh8k0NSZcwRD4fM7B4pb0tlA2hQXEDc0mfSOK7+f0RdUztwsR3BDl
    ZB8dzfJnWReTwA/3DlzzgOhm6BDRpdZeB3C37SlvDuO2redUxMGPUH/CbxE0gtEwdOb7v5
    H1yyRq7QnWSD0cJUUVRdYIFbbCP8cavp1GOMgNq7WOIf3QPH9QqEpmjZEucdkz3+76wrJ7
    smt7P+rPCBlmugIPFBch3QQ1mBhxisCGl332Bh4jzdfSr3BdUMmZlIvmOgX/H5IAmLb0Xm
    VmpxbF2eHfkiSe82NUGI7Q3xNQZ+i7yowU+AXqHRceP+oRy152R7pPaqeLf6KGKK2yC0oL
    p3V4KBU6vlvi1BjvP2XLudhfhqzqwTaziIA0ANmn/oYRUr3aoKijMwGReDRwk7icCr00Su
    S0qGlDQ0wWyhtj6zI2C0wTHKzBOQcd61XTec9ZzNO2tJliZK+UNP+nyKXGkfu5RddspB77
    8FWsHsHtKLhrAxCMYUqLSX5qoBwrCY+ZAzJcfxTktP06/SStlY9Rnb5+J+QQ
X-ME-Proxy: <xmx:WQS7akhRyCZdBgZYIjZfPV0Py6nQw55WevED2c6ldlMqzNPf34TMYA>
    <xmx:WQS7al_Jd8RMlTNsGtMNmgsuhu9REjsS9w3WQDJw4RGLGzt2bHYrWg>
    <xmx:WQS7auACGOlTAEALtdxaenp7U3R0jKurt4mWcXBUwtFlOT6O4WkxzQ>
    <xmx:WQS7aiIs45P2s0661I5pNrNvBWjMdfhrJYiSg59WNHtwN43-rSLa-w>
    <xmx:WQS7amKx5nU9sXDowq84oyuwIyiucHGYx2_ZNPG3rZSbLKKG-y7EnuK0>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 20:20:41 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 0/2] btrfs: ENOSPC fixes for unused block groups
Date: Mon, 28 Sep 2026 17:20:32 -0700
Message-ID: <cover.1790641111.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A few fixes for system chunk allocation ENOSPCs caused by a sudden influx of a
large number of unused block groups in a filesystem with no free dev extents.

In practice, I saw this on a fully allocated fs with 30TB of space, a 4MiB
system chunk (single metadata mode) and ~10k unused data BGs.

- The first patch tries to avoid the condition by allocating earlier for the
  system chunk.

- The second patch eagerly commits a single deletion when the system chunk is
  at risk.

More details in the patches themselves.

Changelog:
v2:
- refactored some names and the flow in patch 1 to make it more clear.


Boris Burkov (2):
  btrfs: allocate additional SYSTEM space earlier
  btrfs: commit after deleting an unused block group if system space is
    low

 fs/btrfs/block-group.c | 59 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 10 deletions(-)

-- 
2.55.0


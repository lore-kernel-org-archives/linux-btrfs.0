Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795112906;
	b=ZlUSRE0ZmzRQ8eRIhzd0RhMnaTyzte7DvGsCavEz3+CZZmLSSbBPut3wCfkb+yzsD06j
	 eMjDr3TVK/Ic1LaPoAtYoPesw6DPOrxlCLtkkOj4DoUYRM1hP3jFh5VgLU152iwNfV5ZA
	 hD8u1s07G5BRA2iti9GvjYlQMm70ky+nh2cg36YsJTXHqJ+FLjOu+fm1n3GhpdnQz9BLD
	 3yfnZZXJ+vsdmlvTQK/etQ3Ey7ww0q40vbHP4Ibv8x87OzI+uCms9NUV7+swHYboifdwp
	 FXelps17JhGCsq1N29z9LFrQhQbjDEc5wa5p6XHNJO3bbENfuOWOuIWdcMHDdZ7aZ7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795112906;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E4k4FQR7cZtSP7jRaqM8RSUjtrbfpITtRlj5XMk1vD8=;
	b=B1r/9j2SZTyezOyM7qWGzMJHbf+WS66AwW/BYZ8GzIfXMQAHQVnoWIc4mMSGPHBLScaR
	 GuHr9V5T6D2cIFLgejCrJOb2+CRUKS5gxSXMBsyNiqwj6HvPpAd0KayrrQqWKAkcAPUpt
	 cxqWIwfACBl2CvEiQ/4DVCGvtyN+3IKqwSESJEo/2nKQFmxlU81TmKMGmDt/IRfzDa5O6
	 qq58RkGrdUjCs0UDKZRppO5d/5s4luLih9xYPGQGDovnVoHwfmsUQwwnmZtFwGy//SEw/
	 X/38tPle24+TnuU/Klo99KXIFIlm3QsRyG1ZJc6vJGc9vQ3oOk8vLYF3Ih8FihPTEFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="EAyjurJ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C24606A320
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 18:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EAyjurJ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F671F000C4
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 18:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795112905;
	bh=E4k4FQR7cZtSP7jRaqM8RSUjtrbfpITtRlj5XMk1vD8=;
	h=From:To:Subject:Date;
	b=EAyjurJ/uI6Uy4tBkCRJm/Ed4q9FA2zFaXTNGx5ciqB1biMzQ5Pj6rtWKPGVsbHxY
	 7kGfNEoOtzPY+9VODm0gK+yzZNJXBTmkyLStpyOutyLiVgU5bAW8T4Ml39cIMlsqcX
	 bY5UnrMWFAuN1qLohXz2yYrzQAwbAYBzk/O+bC/DX4qxVUXvIckFhEZBfKv8JyK02n
	 w9NZH1vAbQ7nR+HYyh47EAwh+l6H8yCVQ4M5YgQR/ch6Yr3bLTIPWyL6Tc0faRakYn
	 VYCJfSw/zTVWL3UbHwHutGIw7Kqjw4eyAL5tBO0Bu5QKyA4dckhttL4qqnRvuO5h1U
	 KwUUrKicminyw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix and cleanup for btrfs_control_ioctl()
Date: Thu, 19 Nov 2026 18:28:19 +0000
Message-ID: <cover.1795112801.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
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

From: Filipe Manana <fdmanana@suse.com>

Details in the individual change logs.

Filipe Manana (2):
  btrfs: fix incorrect memory copying in BTRFS_IOC_GET_SUPPORTED_FEATURES
  btrfs: use AUTO_KFREE() in btrfs_control_ioctl()

 fs/btrfs/super.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

-- 
2.53.0


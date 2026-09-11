Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EF649E130
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 00:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789086356; cv=none; b=V4DT5btn41HKJbqJdud3/sZW4MHTKC3WrqPcJdSMULAzSn2pFcL7FSK/uMCzkRsvzBbl8IRGKvPRmMd5wVy8kg9a2sDs0ryi8SJXE1JpUh56O98mL5kDEk9YWUzktH/P9vVXxYeDsxbzTA/n4Uf2cSeo0+arTkEPvhx6+o8hr4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789086356; c=relaxed/simple;
	bh=pxa+1dCMOhVFKM/pzrXqFsV1GsytY7F+tj4JASg4HCY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bdBY/2ByNapPhcNeWZ66vjGWzYc0OPvs9nER2mw3lWdMIxCDzFC5PyIWFIdZkGM+D/HpPYOsW40dMMXLaImS1JPTGXCtW885aL5T/Qa3ZBWRO/uvCTC+e4cCFD32CirUAQkuTIX1tUmK4Gag6mwCx11BgCHDd7xSjEqJYPH0UVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=oG5U26ki; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SsH+1eoJ; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="oG5U26ki";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SsH+1eoJ"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4B6167A0100;
	Thu, 10 Sep 2026 20:25:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 10 Sep 2026 20:25:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1789086354; x=1789172754; bh=8ZW4l2UYV1i3CEj41Gpj9
	1Td1abd3HVRiNIRl9ol9J0=; b=oG5U26kiEHAfIoO5jfMCXJWyevXQli/wYshzb
	ADyF048yxU5aHD1+CP5ah05md+BCEyVyuju3Ei4Se27S4yyhip+d6WksypVRZykH
	WhUCa2/R2fvr6ucuHzQLeomS/SPh6czuFzz5Wnm2SsjRAQRYfFv7ZIxuHuJmjBSr
	jIiV68BN7SOq5LlW3XOmBaxCvZZIuEL6I7LuxV95dBA4sUFXEFfq3E4gww3g8V3Y
	YUQWSlvy0PbC8VF6bn3ZNd2zHEK+0Z6O2h1ftfRbzLSp59DcJ1vXORqjy3rziZ/3
	4jXXm64eQm+twsEKqaePu1vmkBq/KQv0kZMI9VP52yL5WHeNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789086354; x=1789172754; bh=8ZW4l2UYV1i3CEj41Gpj91Td1abd3HVRiNI
	Rl9ol9J0=; b=SsH+1eoJTVTdGYdmG0FhpiowgP+7aqMVPZIdq2BxQrO6pXkirM9
	SPHc0dmLik2CKVow/3F9HIOuYp39H5AtdVUSsG6AFuEsvNU6npa2cTS4eRlMtezr
	nY62XTt5L37o5l/DybhsFMVQ3gsuhfmAUZBo3lJ0GIbvtrL+utXCABm4k4P3i9A6
	hCLfIpKKEKCHVjhIEXfmYxoNXsb2ihnKgJYXBYeH1MK7tOtqo56jn8pDiRvLfFY/
	7Zdf6qBTEXKNdxhSPybvPxwlItuHUjw3FIsaB+pr2/vSqh+pJt9n6QuaVRbSOMEO
	0c0gbT6UqXNebWLFpwMlHLIpVhviTBC8TjQ==
X-ME-Sender: <xms:kkqjaqsnUE9FX68XCUIPu74csoJ-ajrlarfrw8w5T72iYKK6H8xS7Q>
    <xme:kkqjalcl_HykSyfsy0dFKuu9suGzOSvawmm-kN2sPhcb-ydFOQ4ByUV6Bqo9n0c9m
    3QT-Z6Yk2CSwHSzjhC9pq9fjEEw0IajKgIIyKR3FqoHXPxEMCmRtIzL>
X-ME-Received: <xmr:kkqjajYGZdPw48en7eixHD_Gra1djK0ljB_f4QNJRpCOsuaOD-973lI>
X-ME-Proxy-Cause: dmFkZTFeG/puS1oLuoawzfAf4OaIslt73zvfq3nHktGCbklGk/OU6pCSfcHd8HIWzhX0h9
    K9syaMHWV2jWkzdmpvjkYC+XkQEamd8OS9wS1Dcwt5EIUgPEUgzB4g/KFAnx80p8T0VSP/
    LhSWH9PMTGUklXua5yu3rEkVajDPVA/PuNdgQpWpG5+Tr0J0QZk3QHsNzxxMmsJTkT3zFa
    wtb211oP/845cZ3Ur9/G1n5HqyKmpJpf5Hm0l7ebvkN8qMFu0dDjdht9yRvN3/eStXwd87
    1acIyJ4v/c76eSyo8gq/s2lEEMXOukotDon7AW6VLMTqNMFQYKbY8eJTQY11JuGTYSD9SV
    SMYBkq+hyYfu26wbITolcYq9taKEG7QL2HWl1TlNoHEDv5F+TnfGnrnzjBrSYratDk7CTP
    7N+avKi/ZKB+bR2px3rvfZBiP0gUE+Xl4mUSCMijkAbp6xVh/huyJrFqvqhrZnm3e1VwKk
    yuj/wAx/mUSYyIzeehgmT6tatHM3MuR/0cJMOGP4+ZlbE5dya0yjxXX4n2Dom3Z3lpST1S
    /70zR1qHKdboG4HgYhwzlQYslGfdyeG058JvAcJmiiaAHUS7V3vRObd76eXbw2iGjXInbZ
    InHaAS8CbsueJbfrWnTautP3Am12KnopOHsW/F9flG+hjGbwLpXYE6sJVu7w
X-ME-Proxy: <xmx:kkqjagVyOnt1AzklqYXGSbNqjUVQ-R1xYcN3P4lzIa8wVyAT8IAf-Q>
    <xmx:kkqjatiHtVZkxR2Ea0GJTfW_GTzZuprpvE8HtYLNDm-xenVkAtgDEA>
    <xmx:kkqjamXSDiwymXhWWtSwhS750pUCte-Q27HJnwggm2LnN4giHg5T1A>
    <xmx:kkqjasMFB3pMRq-Ts9J1ptW9NEj3qzXKXidPH8l4LKWHNHrGMGOd2w>
    <xmx:kkqjags_MRNbCri1zILwJFaW2ps7J24XRe9Agji3HvVBLax1pNac8HfY>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 20:25:53 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 0/3] reduce reflink src inode lock contention
Date: Thu, 10 Sep 2026 17:26:16 -0700
Message-ID: <cover.1789085863.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We currently take the src and dst inode i_rwsem exclusive for the
entirety of a reflink which includes writing back all of both files and
walking all the src extents and duplicating them to dst. This results in
contention on those locks which I think can be reduced.

The basic strategy is:
1. try to do obvious easy src writeback outside the lock.
2. downgrade the src lock to shared where it is safe.

Boris Burkov (3):
  btrfs: pre-flush reflink source before taking inode locks
  btrfs: skip unlocked reflink source flush if the inode has writers
  btrfs: downgrade the reflink source inode lock for tree walking

 fs/btrfs/btrfs_inode.h |  6 ++++
 fs/btrfs/direct-io.c   |  7 ++++
 fs/btrfs/reflink.c     | 72 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 83 insertions(+), 2 deletions(-)

-- 
2.55.0


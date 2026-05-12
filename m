Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0E035979
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 19:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778614516; cv=none; b=eKhoPIQj6zeocSr+107YTP1/1WALDMM3T32He4vGRU76+QsBJ0ygmdJiEPmagYsSg5NeYXrJ29SPF/vJ0Ydl7kUt5j+sOTBPC50ss85Y4Up4Js6ZJSGSIsAhj9Ezn8+1Px6Oo7RxP891xrqDH5Z6xKAuJTHKbWOsc8+o5Kyrbss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778614516; c=relaxed/simple;
	bh=8HDUTIHkYxnn+JH8IMlPoWDfIaxltilBPHP9U7ATRgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bWrCLulFyOulRWyAEvsG892Kc+okKKqqu3haJwue7+PnvKjtC9S5zyy8C/0deKNwiUAX2MI+73pBJx6SMrKyoGaq1CnZw92n4OVjVVk0on7i1CGamIJAgBMcVV2xLjTzIqinfd2AgdVRhl0Wvd5XOoaj22eZy0+j6WGj92Yvauk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=IDDbWStX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=f68/9bpk; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="IDDbWStX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="f68/9bpk"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 21AB114001A1;
	Tue, 12 May 2026 15:35:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 12 May 2026 15:35:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1778614512; x=1778700912; bh=HU5wTAN9SyF8zKObufLZF
	FYjtL18S2I5R0wi2H8VYog=; b=IDDbWStXW3pQO2Wf35DHOUpZbThw7qJGcVULt
	cTZV+aL1DAfKAlniQR2AHlHMYT91Qdw9kiLWcjyncYiM8+FwoaM/KXAnJLKytUi6
	K7nTG3QQYJpMGCZVFGJeK2WLAHuABdlDvaWSRyKvauSjYTitq76Ic5ekhfQFn2gD
	aVrpA2OFsZWHSUxn17Jeb6cWpsL/OpJBMUJHnu14pWXtN8q2UA8Mh7URq/dZVecy
	zuWtOA0GjcROp6ZQbQkq/ZMQcY9/tthfgvw9tCc6D8Ax6/IYIDKFqMjlpDw7p60I
	+Q8d/IaRXrIbN00tyj5JJjuZjknG0giNij+rt2StQoz2sLxiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778614512; x=1778700912; bh=HU5wTAN9SyF8zKObufLZFFYjtL18S2I5R0w
	i2H8VYog=; b=f68/9bpk6cbqUdsn6odGe4Qfpl1tLXNhNS4Wqx0y7FQZvLBnrp+
	HAblqpBIGy+2P0GuEtvb6Cu7YdQ+r/st84DOy/n1bn7cVfejOknslkqL68Vh+lpM
	ctZVLXWMvxyuWyqCb0iP9wtfAAgZUB+igCMLTvVriBCDWst1JoBGjYPolm1gfbKd
	NDHkKnzWQK9T/bTzEgze73i6Tst5DdPOWFEtVHrnNmpntAwbFlOWBKw9c9Uzf/Sr
	tEsLe//o0uZo5DyKJv4i4K6B5fL/0zXbfoUau0eaprKDaBaZ/UUglumlryOewQdq
	Nkv4jeM6ROmJe2pwYtIsgF3t7E1UmEujpwg==
X-ME-Sender: <xms:74ADamRz4Ks39lT0Zrj0o3ZniQIM2BxutxSnTiyDjqOGwUE4AHfk9w>
    <xme:74ADajPxPqDHB3Q2NKUWwgZgeL8DgvzsT3GFm8BXyqoPXt7rfmEd6v7QzvwLLFQzZ
    ikMDSCQyRRkqCPrkzA0ZWa2yBO3Wra-loJKTzGpKMNTywRPfUiCzgk>
X-ME-Received: <xmr:74ADahONApHSalFjkO0fHh3GQ98UVGZL9zg1IlVBi24ywmyEeLir60P73PTJKw-u-2QgnABaB9tFqHXndcY0_ZCsphU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvddvieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieegleehjeelfeeifeeiuefhfefgvefgkedtjefhiedvve
    etgfduleejheeifffgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrd
    hiohdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohep
    lhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hkvghrnhgvlhdqthgvrghmsehfsgdrtghomhdprhgtphhtthhopehmrghrtgesmhgvrhhl
    ihhnshdrohhrgh
X-ME-Proxy: <xmx:74ADarumI3neKnYlbn0PNXIWGQ90Px1nBOKtrOIRAsqyVYTY5SVxyw>
    <xmx:74ADajV7v-Sh26T8-IHDG7Xd9Ic990advt94blzYJC0zvg6_QSi3Vg>
    <xmx:74ADaruUpgNATs1Whbq-3eaJGl1GsHQ07d4DgBO0nwyUungtEKGsXQ>
    <xmx:74ADanVfxOu50NbeDMQFeOFcF0yHkxUZuGqtHTzBQxF4fahxT7gw1A>
    <xmx:8IADahzBprDCsHh00iyzp555zTmm7x0v8mI1nY0KajG5kd5Zk9cUmi3u>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 May 2026 15:35:11 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: marc@merlins.org
Subject: [PATCH 0/4] btrfs: squota lifetime fixes
Date: Tue, 12 May 2026 12:34:52 -0700
Message-ID: <cover.1778613519.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A recent report of read-only filesystems since enabling squotas:

https://lore.kernel.org/linux-btrfs/adnBhWfJQ1n3hZC8@merlins.org/

led me to investigate a handful of issues in squotas and find some trivial and
not so trivial bugs in their lifetime management. The aim of the series is to
strengthen enforcement of the invariant: "a squota qgroup must outlast extents
that are accounted to it".

This series consists of two fixes to squota lifetime bugs and two patches that
reduce the consequences of errors in lifetime management from full fs goes
read-only abort to "warning and inaccurate squotas which can be deleted
eventually"

Additional improvements to btrfs check and fstests to follow.

Boris Burkov (4):
  btrfs: check for subvolume before deleting squota qgroup
  btrfs: fix squota accounting during enable generation
  btrfs: clamp to avoid squota underflow
  btrfs: swallow btrfs_record_squota_delta() enoent

 fs/btrfs/fs.h     |  1 +
 fs/btrfs/qgroup.c | 99 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 68 insertions(+), 32 deletions(-)

-- 
2.54.0


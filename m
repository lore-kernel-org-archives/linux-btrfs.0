Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55C3374185;
	Thu,  9 Apr 2026 21:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775768962; cv=none; b=LX8nJzqm8wuFPCfQkjOH+3/6OIMm4zx2vjgR7XzqayUHbQK/jYz9Cq3Azh39mjlJ2zwMfVpvRAM745PQXgWGAg+4bQD1UAiZp/pVzpMPE8d0xTukSvRHGF1VOx2oD9LNgOAzJq6Efv3YF83IyHxN1bAunz8dnVQMtfz60WTuJ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775768962; c=relaxed/simple;
	bh=MZunF1xN5zrge3JmcTJNc0v9YAdspsz5QhxRbtTKwcs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KbQLQ4bkVRok+I265DyFdP7GqeufyGyxeMdGXWTwdsbBLlffGqflq1SSiusJYZhs3jxbEk1v5Npd6gNA8Dwn5JnV6qisjjhchJTbRfgL9J1Xui2t4Lhc1JmEpU5zSFG3+8aiOdhzhAHrFNKoW7y+6i+QSxmfevZyZQM69UeRe4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=o2L2wXFF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TogtoZrx; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="o2L2wXFF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TogtoZrx"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id EF21C1D001C9;
	Thu,  9 Apr 2026 17:09:19 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 09 Apr 2026 17:09:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm3;
	 t=1775768959; x=1775855359; bh=MZunF1xN5zrge3JmcTJNc0v9YAdspsz5
	QhxRbtTKwcs=; b=o2L2wXFFkxCVBbna22tFAs8DtCjafPn77fvQX55BlUe5hyLZ
	am0LxTcNf4z5FFULlAgQwj317NreS6UcntlHscIfFJ207fiw61//jTdwozksAlGQ
	xRnOYKHcn209iRF7JlDzTaoQUKxoHhy00VAarAxwuWiO+AoVIsJjVYeEGt3c7ayq
	LagUC7sNf+kArBNw6IKEqmCIx6km3FBq4nispZBa9XiQImZiAIcJ32cCQsE5I1P0
	W+Pf+DoJH04S6FCRq9USSq2O6XCk3G+iHVKHYheavy7OLGQsB8bcuxr9OIow7oP9
	uuvMOqLN0tb8K5HhxbtGFmIQZ5oqjIrlH86EoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775768959; x=
	1775855359; bh=MZunF1xN5zrge3JmcTJNc0v9YAdspsz5QhxRbtTKwcs=; b=T
	ogtoZrxkMyhClXEh8CIly+y8MXpCcoMJf41gxBmru+I386BL+Sde8gLeltuKzInU
	jExRog3UsF/G5/9V7+8VmL5dFxRvQaF4ntAYDx4n1/AIC9WqQYkA3tlaZO7E9J2z
	FYeBAwAQV62ouLfop/bPUq8qj+HsYi8iaBhj2irlsSSDhRbEg4/Fl3N4INVVIOvT
	buBGIXsXrTCn3KugrZ2M4nSvngBGfYxho25insJrD1ZkhDNxpOLYxzBrKKj1Uvyu
	P30/o7RilhbTffVJE88RnmSgKoBeST7v+yNhdTOiC4GVIq9H8oWSwthIMVY02sxR
	bt+ynAL/FrGZz9YRKHb6A==
X-ME-Sender: <xms:fxXYabRkq9CslWKeydbjtoR9P20h378nO2y2TLbomNrSYPs_N8kwpg>
    <xme:fxXYaYPm-REosQhquMp4ZPzu8XwPqfVJwBgaIH9rIaoQO_I8xQDOKKJJDkgvL3SMW
    blVEVVnl47AYLLRDw59HXUvzIN02LOO7ZBbIr-zaBLtOCcvUrTkWc2a>
X-ME-Received: <xmr:fxXYaUXrL88NJXiJoCdIbYyrf9VOm8enq-BR5SU-I1ck321gnudt9_G5P72aBlYorwFAymyP4NJ2HNlH6d6uBkAoATU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvjeehgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkgggtugesthdtredttddtvd
    enucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeen
    ucggtffrrghtthgvrhhnpeduveeuteeufeefvefgtdeifeetgedvueefgfeuffelvefghf
    eijefgledtuefhieenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdihohhuthhusggv
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheplhhsfhdqphgtsehlihhsthhsrdhlihhnuhigqdhfohhu
    nhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdroh
    hrghdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdho
    rhhg
X-ME-Proxy: <xmx:fxXYafcQkBn3kzt5BaJu2kdJry-fMqsxpw1CAkSz4UFCQ5jnfaz7bA>
    <xmx:fxXYaQu2W8qMhERm3eTgoYgiRFfANb4VsXRg6hi_171RsLEk6Ebngw>
    <xmx:fxXYae-OX3BkObPDBmBGr1xIA2IvDGZWHL7a7JZaLNHBJqYZFxuCTw>
    <xmx:fxXYab1ShO5W28Sn5qoT5kCCCSCVIAQ30CHboTmO6E-b0UHWPval7w>
    <xmx:fxXYadnvMes_hzHxNipBwKkvFZnG_P6JjnV-HizTeu6ORW-EqQRe3W41>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Apr 2026 17:09:18 -0400 (EDT)
Date: Thu, 9 Apr 2026 14:09:06 -0700
From: Boris Burkov <boris@bur.io>
To: linux-fsdevel@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	linux-btrfs@vger.kernel.org
Subject: [LSF/MM/BPF TOPIC] Direct Reclaim and Filesystems
Message-ID: <20260409210906.GA881465@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

A theme that we (Shakeel, JP, I, and others at Meta) have observed in the fleet
at Meta is a tension between btrfs and direct reclaim. This has manifested in a
variety of different ways. All situations also must be considered w.r.t. memcg
reclaim and global reclaim. There is no overall "assignment of blame" intended,
just a desire to build a deeper understanding of best practices and paths
forward for all the components involved. I work on BTRFS and have minimal direct
experience with how other filesystems besides btrfs handle such challenges, but
I imagine there must be some overlap in challenges.

I think this is probably too large a topic for a single session, but I am
curious if any of the categories of issues are broadly interesting. I
personally think the one that cuts across the groups the most is the question
of reclaim cpu usage.

- The filesystem triggering direct reclaim [2]
Especially when the filesystem is holding a lock like the inode rwsem or
a filesystem internal lock (like the btrfs btree locks), this results in
unexpectedly high latency for the filesystem user, and in the case of memcg
reclaim and held locks, will unfairly affect the latency of other cgroups not
under reclaim. We are working on categorizing these and reducing them case by
case, but a clearer statement about valid allocation contexts and GFP flags
could be broadly useful.

- Reclaim freeing metadata and/or forcing metadata writeback [1][3][4]
In btrfs, this results in redundant work fetching and writing btree nodes if
it happens to hot nodes in the btree. Should we be trying to lock some of
these nodes down from reclaim? If so, how many is appropriate/safe?

- High reclaim CPU usage [1][4][6]
It is possible to rapidly generate a very large amount of direct reclaim, for
example by doing parallel page cache reads larger than the cgroup limit from
many tasks in a memory.[high|max] constrained cgroup. This will then use a great
deal of CPU attempting to do the direct reclaim. This CPU usage can become so
extreme, and can be emphasized with cpuset cgroups, that we end up being unable
to schedule tasks holding important shared locks and massively tank the
throughput of the system. I have been able to reproduce conditions where even
killing the offending cgroup can take minutes. Some crude early experiments have
shown that throttling the reclaim cpu usage reduces the intensity of some of
these problems. Can this also be attacked via cgroup cpu throttling? Proxy
execution? What about the same issues under significant global direct reclaim?

- Filesystem doing expensive work while in direct reclaim [5]
In BTRFS, compression can result in relatively expensive work while trying to do
writeback urgently. Jan brought up issues around synchronous expensive work in
inode reclaim as an LSF/MM/BPF topic already.

Thanks for reading and thanks in advance for any feedback and thoughts,
Boris

Links:
[1] btrfs memcg accounting separation (AS_KERNEL_FILE)
https://lore.kernel.org/linux-btrfs/f09c4e2c90351d4cb30a1969f7a863b9238bd291.1755812945.git.boris@bur.io/
[2] btrfs readahead direct reclaim reduction
https://lore.kernel.org/linux-btrfs/9fd974c2-00aa-4906-8cab-ec0d85750c4b@gmx.com/
[3] btrfs re-cowing inhibition
https://lore.kernel.org/linux-btrfs/cover.1772097864.git.loemra.dev@gmail.com/
[4] btrfs csum tree write locking reduction
Link: https://lore.kernel.org/linux-btrfs/aa5a3d849cb093a767e08616258c03c7eec8fe26.1753806780.git.boris@bur.io/#r
[5] Jan Kara's proposal to discuss complex cleanup in reclaim
https://lore.kernel.org/linux-fsdevel/c18f8189b755c13064f51d93bfcaddb15300f9f8.camel@kernel.org/T/#m319eb6245485bb7c71171a55bf700cc1409a144d
[6] LPC previous discussion of cpu hogging and locks (unrelated to reclaim).
https://www.youtube.com/watch?v=_N-nXJHiDNo

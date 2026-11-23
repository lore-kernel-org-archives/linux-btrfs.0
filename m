Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795475837;
	b=wtWcwMIC/7BdGr9vZ9Az4VvlzefuGVcC85CKxmvrGMmiWA1F1oOJ3otygR9sDmDxKqgl
	 MfwtNf/L7jwY/R3EgxOM6W6h+KgISm8/NyVsMSrbRQOIZaOKRPtqPUdGi8EN1pbHr9Xmk
	 5UnbP0MD0EaP5fWR7ACuusKcy6Kq4JGRGC+rORUkFZynf/8g8/c5sLXIE85Sa05hYSq2O
	 dQpGpKa2fpp4OiMH+ncwe7ZvTZgIzcgFqOvG+jDBrXKws+v6fajDjplcj5k4qqR4iUC0k
	 ez/9kW9cXH9/H/IeAVntRfnIoDhLy0ZwxhooEaC9SJCocjrla4VOiUwQ2PuZlV6axbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475837;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=E4SDdrx4FRbf2KWuxTzy+q0+4FEA2n8yksJS7sNqLYE=;
	b=n2CGBPNUH0aiRlJZLxcVXrs1nG4HzS+y+0XqIU3GwM/sQxuDlAmdgT+d5891qWfyqQwR
	 Rxfk+DUWJGvaAmX3oz7XuKObZDaSaT81oCOndvrgC09tInf+9VDlrla38CGToR8AKehbZ
	 FQNy0Uen6uMX9JB2eRQOUbD8GAPAa2jwmzBz9mB2d1FkEKlxvXvXFC47zTHyWpzxBXplr
	 3mvvtnTu9ekYAXCucMU3Yc8Frp7hy86bXh9LOiU2fnZi2W6iEPCoNfWRxMb6b81zYCx2P
	 PLX3p9neQ2wtgJbtCEwDj3ywqPtHQ9Y197M3BEQSTk+k5SjHR4SreeYPV9r5YAbVZ2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=s1ij40Nq;
	arc=none smtp.remote-ip=109.224.244.120
Received: from mail-244120.protonmail.ch (mail-244120.protonmail.ch [109.224.244.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B608D606A321
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:17:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B608D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=s1ij40Nq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795475834; x=1795735034;
	bh=E4SDdrx4FRbf2KWuxTzy+q0+4FEA2n8yksJS7sNqLYE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=s1ij40NqJk7p/x7l1QTESnVvs6FwQjzLrthduHmPUvu7S1E0fTrMLLtqJu0f5uwCf
	 iu8R9fUL+SzuFSJtTOjyMyePLqSEvyfD2OlZWd8vcWZ4O2Z/wlywPad10maqUfDeS+
	 zJuXIb+BonkaqLasI7Rd+4LJFufr6tUccv6O7HAOI+4csMbIdYqethZ8bTiBXec6Q8
	 Hsfi2JBwikaoBSOgeJDqk7kOzAV6HXB3toWTMerk4mm9Zb6zIu0UV5dIcB8rhalQZf
	 eW3KHdrRFqAMBvCr2TSCKSrEln+x/Hi21T/WlL93SXPQ1QjJBL5vMSQnTEMW1psRJH
	 E53cXW9FcEMWw==
Date: Mon, 23 Nov 2026 23:17:09 +0000
To: Qu Wenruo <wqu@suse.com>
From: Miroslav Cimerman <mc@raidlab.org>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix NULL end_io call when submitting a repair read fails
Message-ID: <h14jGSKDU0qpAKjGzrCSTvYwSfd0CAOnpFGyda5F0IRcl6PXpRYxJ2qas2hhpXxeHoKpviPUl5r5bWK7-6Vfd7zdkWWkEH2WFCkN7ZsLNn0=@raidlab.org>
In-Reply-To: <6887e526-a0ba-414e-a44c-0e7b861192b4@suse.com>
References: <20261123175633.2058431-1-mc@raidlab.org> <6887e526-a0ba-414e-a44c-0e7b861192b4@suse.com>
Feedback-ID: 232820807:user:proton
X-Pm-Message-ID: 3014334216a0239d45dc23ee2ee28f9dad874a55
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Qu Wenruo <wqu@suse.com> wrote:

> This looks overkilled to me.
>=20
> If the end_io is no-op, why not just define a no-op end_io for it?

A no-op end_io avoids the NULL call, but then btrfs_end_repair_bio()
never runs for that repair bio. The original read waits for it and never
finishes, and no other mirror is tried. I tried it with the same
test-only injection, and the read hung in 5 of 5 runs. A direct call to
btrfs_end_repair_bio() would nest once per mirror, and on RAID6 the
number of mirrors is the number of devices. So it is queued on the end
I/O workqueue.

Miroslav

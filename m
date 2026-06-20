Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616AD341077;
	Sat, 20 Jun 2026 07:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781941192; cv=none; b=KuwXBRVZNhbfFW/TgR1CaaZ4VWzZnIQHw83/OU2CEeerq0AhBB2Y3cVM6ljOtdG+RszF2VDIu9vsq3e/7Q0DWONTZ6x1we+sZiUBP8iFYCKEsxBxKuKWr7PRMUGcQWy8U6VPVXTuLAgJ1KlrreKzcPkX8SUS7lyG583uYehjbKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781941192; c=relaxed/simple;
	bh=PGC4VHw71GKTPQ4/0tQFkLMHEQPWRYLq7blHWDcw/kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qqpVoyB9kOTdet5M+CvITGFm1SJarTNvV/tVPcpLroF2K9HyqMGvFAuSXZOciNF3mIVV3t+YMlE9AiUkQIlpVmjfNY5yZQ2ZZX07pCyO46qKYpC/AJiBrTMKtFCU4EiksM6QY4PAFU6MKTYt4Zq79a12phgI+JjyHjWIWZDmgjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=A63KADGy; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="A63KADGy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PGC4VHw71GKTPQ4/0tQFkLMHEQPWRYLq7blHWDcw/kc=; b=A63KADGy92fBacifXq56Osipet
	fVTkkra101oERpJvFFoxr/GwrITRXw989AiJDzyFl9FIFB0skC7Ya1xsVI9kVBbJ7meoHEHqaGEy2
	U+xn/HPpQmyzntYQriki65sFENhNMintgwcc+ji3wB1WIJ98A5DCM2tpdE5waWUeyTd12UjZw+XCb
	kKYjEEdknQqvYZSI51NN5e5vVeem6z8GdgyNgHPaXCJ9eSwjAFxCBIUPcCXE0ByhSwx2bFyNp7wtK
	pvNCpY5eUqaxAhhJK/+aoFhScxXBrO4JqqEnzmS2Vv/Q2RysRSbooxa2dFWbvJm9+XLCSrMFJKqMF
	a/7LXTrw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.4 #2 (Red Hat Linux))
	id 1waqIl-00000001Obt-2UZA;
	Sat, 20 Jun 2026 07:39:39 +0000
Date: Sat, 20 Jun 2026 08:39:39 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH v4] loop: Fix NULL pointer dereference in lo_rw_aio()
Message-ID: <20260620073939.GF2636677@ZenIV>
References: <20260529220600.1226-1-hdanton@sina.com>
 <b27609f0-59f0-403d-90af-274c55df817e@I-love.SAKURA.ne.jp>
 <3244d4dd-8254-47c0-9609-b1db53450c7c@I-love.SAKURA.ne.jp>
 <20260609175013.GH2636677@ZenIV>
 <9f8b5ab0-efbc-4cf3-a1f8-b43377416946@I-love.SAKURA.ne.jp>
 <a9254bf0-fc7a-4b2e-a62f-064e71016fb6@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9254bf0-fc7a-4b2e-a62f-064e71016fb6@I-love.SAKURA.ne.jp>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, Jun 19, 2026 at 11:33:11PM +0900, Tetsuo Handa wrote:
> Sending this commit to linux.git will be the fastest way to identify who is issuing
> I/O requests too late. Therefore, I want to get a conclusion on xfs/259 breakage.
> Al, can you get the same result?

Not a peep in the logs, breakage still there (with cherry-picked fb1d5846e99c8aa4ce
and CONFIG_KCOV enabled, that is).

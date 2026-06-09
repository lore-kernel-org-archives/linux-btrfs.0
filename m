Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E440481259;
	Tue,  9 Jun 2026 17:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781027426; cv=none; b=gJuBE4Qrf7Fq99a7SLAInroiY3tafOI+q89fBK7DKXJcwNCdT7gMAWXyHjmdjyqUL5llBhkZZbBvVAZB6mG3i135rNnCVXE27oS05tKhWztG2/EJuUivLAJ6LIb5PFdqpwQFPGrsGHH26rTO71G/ve1Onhr58oPQZnejYHlINR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781027426; c=relaxed/simple;
	bh=szuALeMmtswSAm5ZUQxf0VhMw8eSL/O9P3Llp9PZgZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZA3R5rs5/IUlybAEVEVfIvByo+RgeaOFooc7xk1NHkQyUAucRm2IW6HkpgUlF3S7GWua8SB/A0iRkXyN3zjgziin2RCDlZzTxhrCz1OMpUEmCpSKb0y5WjNZjgUe5nPv216Q55UMs/sJH2TASh0CrhBRH2/RydFE95yICuToEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=b1ahRbQp; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="b1ahRbQp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jrCsj4gn7vi5WO8BmPN7e9LdzveNQRxZdeDb2ikqQ8c=; b=b1ahRbQpgWZaeboUHTlQPeK6QG
	4C6bX1CjDmyyBL+2vnFNA9juzWdTfpe95sA6bl9DSRjRX8AR2WZX1TqK3QIJzq06zTx65ZB1uerCn
	rXhIt5aN5/XrR1rCyFXTP/bJaWvM4XuLq31i83tOvBb18FPcl809EzsK3W17mu4JyyHETIh/a2UdZ
	85TnfU3l3gZRhJOuU+/O7RLKaG2WDbajUlmKXSDgf02Wi2POgV/MnD1YkPH186DDG8C2lq1/pFd5t
	TzRQijMx49LLlVSXQRm82IUztQRk2CVTaWm+dx+esFY6rY8qLOf0RfRw5en9I5jmeg6jGjLfnGQTL
	VBFilyCQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wX0ab-0000000EaZi-3BMR;
	Tue, 09 Jun 2026 17:50:13 +0000
Date: Tue, 9 Jun 2026 18:50:13 +0100
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
Message-ID: <20260609175013.GH2636677@ZenIV>
References: <20260529220600.1226-1-hdanton@sina.com>
 <b27609f0-59f0-403d-90af-274c55df817e@I-love.SAKURA.ne.jp>
 <3244d4dd-8254-47c0-9609-b1db53450c7c@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3244d4dd-8254-47c0-9609-b1db53450c7c@I-love.SAKURA.ne.jp>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Jun 07, 2026 at 07:54:58PM +0900, Tetsuo Handa wrote:
> syzbot is reporting NULL pointer dereference in lo_rw_aio() [1][2].
> An analysis by the Gemini AI collaborator [3] considers that this problem
> is caused by a timing shift primarily exposed by commit 65565ca5f99b
> ("block: unify the synchronous bi_end_io callbacks"), along with helper
> refactorings like commit 92c3737a2473 ("block: add a bio_submit_or_kill
> helper").
> 
> But due to difficulty of reproducing this race, discussion about what is
> happening and how to fix this problem is stalling. Also, we haven't
> identified how many filesystems are subjected to this problem.
> 
> Therefore, this patch introduces a grace period for flushing pending I/O
> requests (which should be a good thing from the perspective of defensive
> programming) so that we won't hit NULL pointer dereference problem, and
> also emits BUG: message in order to help filesystem developers identify
> the caller of an I/O request that failed to wait for completion so that
> filesystem developers can fix such caller to wait for completion.
> 
> Note that emitting BUG: message is enabled only if CONFIG_KCOV=y, for
> this check is a waste of computation resources for almost all users.

Still breaks xfs/259, same as the version in next-20260605...

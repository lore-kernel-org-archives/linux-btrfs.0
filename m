Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820F641D65E;
	Mon,  7 Sep 2026 12:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783112; cv=none; b=CJeiDISrA/Wa1QfpZuLFDkvUC2KPtDqErVFX7P6/9fd5g6ZYtnLYaAle6+Jpx5tDkTrubDw6v6swhppDJ0Xz68Jg4G097KyHS0FZrTUGXDzMluOQJBMJfeJSWpjC+VQ2m0B8SjQ8uSeWypqq/oFnDivyEsMHXOv8JBavZ6AzI1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783112; c=relaxed/simple;
	bh=N6Q8Bw3DKfPTv3lCh7BLqb+juFaPKLUZrQ8cJYLMYgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uI2uW+utR5bPY+ISCvWKNWGEUgB5IAp+w+gcjw2UEiz+jtemhAtEhYOBexPJotKAicPUD/yC2INBZoUAajfezwDZHWX2SUFFuk2IMasdlSvj2Bj9VTZevIC6m8VVXsO8BTa2QDpwZbSaTuW1YbxxYvJbiJcUevJ7A7JzC9QE2kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pgiN76Uk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mXPenClQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rOhjoG1r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LkL34JYX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pgiN76Uk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mXPenClQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rOhjoG1r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LkL34JYX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 65F01219CE;
	Mon,  7 Sep 2026 12:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788783104;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2nyCVCafhF66aES1ZARwbKdgjnfQ2c0L7HTujcp7JRo=;
	b=pgiN76UkFGa7Z3P0qZhNSx8pCIeiknT4vmX0KXQH0PJU/EY68WtCVMnXnPR52VdcyOX4n9
	26lKly2VqeDiORZM78qCVb2E3JMAuxQahDYFGByo8a9x4fqE8Jop6pWNm4ZUaWsHY4zT7/
	JbYLzVyC+SOzl3vSH82M/UcorlmqTe8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788783104;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2nyCVCafhF66aES1ZARwbKdgjnfQ2c0L7HTujcp7JRo=;
	b=mXPenClQb8V9//C/YbR6mv0+rVk2eaMsrCoZDW1tZtjFc/5Vu4FLlxWC+Gm0mqcsI80jYK
	CzqPEuNmLTFegcAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788783100;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2nyCVCafhF66aES1ZARwbKdgjnfQ2c0L7HTujcp7JRo=;
	b=rOhjoG1rLhMT8N88WEHcF+MK00pCmF5MUEHyec+J3LY2jmVxT3wKUhJiwMGfirzt7S91fL
	vasAHkCnmZIODjOXpVf++l8GvCtVCSGlgMKVxZZnBHJKWQpW87UC6O5kpNAHukICInn7KX
	le5khx3FnlWLXW+twnhmkLz7QkObejM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788783100;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2nyCVCafhF66aES1ZARwbKdgjnfQ2c0L7HTujcp7JRo=;
	b=LkL34JYXRN813404yzPDFC/Me+wxQVJnM+cWWM2GsetoeHzUn83lacxByO0hBJMUNyXHEQ
	mVO/JAPEmPO2FzCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30E261339B;
	Mon,  7 Sep 2026 12:11:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Rni3C/ypnmoUHgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 07 Sep 2026 12:11:40 +0000
Date: Mon, 7 Sep 2026 14:11:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, terrelln@fb.com, terrelln@meta.com,
	mason@kernel.org, clm@fb.com, fdmanana@suse.com, boris@bur.io,
	wqu@suse.com, loemra.dev@gmail.com
Subject: Re: [PATCH] btrfs: zstd: avoid a copy in zstd_decompress_bio()
Message-ID: <20260907121134.GV9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260904164148.2664280-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904164148.2664280-1-usama.arif@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spam-Score: -2.50
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,vger.kernel.org,fb.com,meta.com,kernel.org,bur.io,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,linux.dev:email,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]

On Fri, Sep 04, 2026 at 09:41:48AM -0700, Usama Arif wrote:
> zstd_decompress_bio() gives zstd a sectorsize-sized scratch buffer, and
> btrfs_decompress_buf2page() then copies the part overlapping the read bio
> into the destination folios. Every delivered byte is written twice.
> 
> Instead, choose the output buffer per streaming call. zstd_map_dest()
> kmaps the current page-bounded segment of the read bio, so zstd writes
> into the page cache directly. The scratch buffer is kept only for output
> with no destination: the prefix before a read starting inside a
> compressed extent, which zstd cannot skip, and gaps left by folios
> already in the page cache.
> 
> Varying the output buffer across calls is safe: btrfs uses the default
> ZSTD_bm_buffered mode, where the sliding window lives in the dstream's
> internal buffer and the caller's dst is a pure sink. The read bio's
> iterator must still advance by exactly the bytes delivered, since
> btrfs_decompress_bio() zero-fills from it; that used to happen inside
> btrfs_decompress_buf2page() and is now an explicit bio_advance(), made
> only for output that reached a folio.
> 
> bio_iter_iovec() exposes at most one base page, so direct output is
> page-bounded. Compared to the old sectorsize-sized chunks, this can
> increase stream calls when sectorsize exceeds PAGE_SIZE, but eliminates
> the extra btrfs copy for output delivered to the read bio; the 64 KiB
> sectorsize row below shows the copy still wins there.
> 
> Benchmarked the change in 2-vCPU x86-64 KVM guests (4 KiB pages, RAM
> disk) using a 64 MiB zstd-compressed file. Results are medians of seven
> cold-cache reads in each of six interleaved A/B boot pairs; mincore
> confirmed zero resident pages before every run.
> 
> Normal sequential reads with readahead produced:
> 
>   sectorsize       base       patched    reduction
>   4 KiB          8.678 ms     8.004 ms       7.80%
>   16 KiB         8.216 ms     7.934 ms       3.64%
>   64 KiB         7.875 ms     7.344 ms       6.88%
> 
> Random 4 KiB preads at 4 KiB sectorsize, means of six interleaved A/B
> boot pairs, patched better in all six:
> 
>   base           patched        gain
>   264.33 MB/s    272.67 MB/s     3.2%
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Nice, also good that it's measurable as it's a microoptimization. The
btrfs_decompress_buf2page() is there because of LZO which does not have
the internal copies. ZLIB uses it as well but I'm not sure if it's
needed and similar optimizaiotn could be done there as well. It's less
used because of zstd so we can keep it like that.

Reviewed-by: David Sterba <dsterba@suse.com>

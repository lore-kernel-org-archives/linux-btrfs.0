Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ACD329386
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 04:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768968330; cv=none; b=U28rwwp26DeSjt9xC3BmK3gIhvCCGpDefOqgXWkYxlanOGc0pyw7HWmlRWOCSK4JzaBoz2VnzvKdM5ciHGGyxc8gqK1/sCWhqsnASLlGd0/1C+ho9/TSEZptojIaJa4ARz3c/Xf8M53HJUGmktuXdbgMI/lSyUsISFrkcdZAwFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768968330; c=relaxed/simple;
	bh=xVngUE33LtB2vLRwfibmdW5aVEeD2AJ+1QkFr+388X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NseczpsfM0EdyEpfo4LWiiIkDBAbuL9BtVRoYt9eruELwIhELbfZRgW+WV4U6CqGlfsUjBoi6/94PdAUmQRxK+ioVwggf/ipxSxlqGDyfbMMEbijMZlhLWwI4Ysgfo/EXxeoRZ254Gt4NOVdRwagXlLvq0Zcliyasap5V0tIogY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QvmvBZn8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H4VEsYEk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QvmvBZn8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H4VEsYEk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QvmvBZn8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H4VEsYEk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QvmvBZn8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H4VEsYEk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C7D6233684;
	Wed, 21 Jan 2026 04:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768968323;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bqcRQwX3EJt02zepJmvC/zX2Jqt1aZ7NBUZWe7NrDTM=;
	b=QvmvBZn8d00LTOiLqhUonrdCd2SdOWSa+kaHk1yMfwv8Wi0EtngTmhQMiyxSLnxcuzXU08
	UJHyejD17rYzjy6bsE5GRtJsyvfZ4jFb+B0aSmS0/YNV+rTH+/Vm0VTLaZp2WlolY47gYD
	BM3Q0Th+gip5vlmFAX82DgKIgp8KLng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768968323;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bqcRQwX3EJt02zepJmvC/zX2Jqt1aZ7NBUZWe7NrDTM=;
	b=H4VEsYEkb4/v5ri9+jVci9w9ORJlRgMXKxmwjkiTV3Kh4Q68CTeoJjH4sZqz8rKStIUrJe
	Q+hPoDxmBOOtiaCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768968323;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bqcRQwX3EJt02zepJmvC/zX2Jqt1aZ7NBUZWe7NrDTM=;
	b=QvmvBZn8d00LTOiLqhUonrdCd2SdOWSa+kaHk1yMfwv8Wi0EtngTmhQMiyxSLnxcuzXU08
	UJHyejD17rYzjy6bsE5GRtJsyvfZ4jFb+B0aSmS0/YNV+rTH+/Vm0VTLaZp2WlolY47gYD
	BM3Q0Th+gip5vlmFAX82DgKIgp8KLng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768968323;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bqcRQwX3EJt02zepJmvC/zX2Jqt1aZ7NBUZWe7NrDTM=;
	b=H4VEsYEkb4/v5ri9+jVci9w9ORJlRgMXKxmwjkiTV3Kh4Q68CTeoJjH4sZqz8rKStIUrJe
	Q+hPoDxmBOOtiaCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5B923EA63;
	Wed, 21 Jan 2026 04:05:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lWksLINQcGkXBAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 21 Jan 2026 04:05:23 +0000
Date: Wed, 21 Jan 2026 05:05:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix the folio leak on S390 hardware acceleration
Message-ID: <20260121040522.GM26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <bcf36edfb7ac3caf3373174e741bb29c0feb268b.1768802004.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcf36edfb7ac3caf3373174e741bb29c0feb268b.1768802004.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On Mon, Jan 19, 2026 at 04:24:04PM +1030, Qu Wenruo wrote:
> [BUG]
> After commit aa60fe12b4f4 ("btrfs: zlib: refactor S390x HW acceleration
> buffer preparation"), we no longer release the folio of the page cache
> of folio returned by btrfs_compress_filemap_get_folio() for S390
> hardware accerlation path.
> 
> [CAUSE]
> Before that commit, we call kumap_local() and folio_put() after handling
> each folio.
> 
> Although the timing is not ideal (it release previous folio at the
> beginning of the loop, and rely on some extra cleanup out of the loop),
> it at least handles the folio release correctly.
> 
> Meanwhile the refactored code is easier to read, it lacks the call to
> release the filemap folio.
> 
> [FIX]
> Add the missing folio_put() for copy_data_into_buffer().
> 
> Cc: linux-s390@vger.kernel.orgaa60fe12b4f49f49fc73e5023f8675e2df1f7805
> Fixes: aa60fe12b4f4 ("btrfs: zlib: refactor S390x HW acceleration buffer preparation")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

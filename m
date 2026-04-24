Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04008363C4E
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 10:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777025634; cv=none; b=bjJvLjp1EAYqIOwCtpxA75EuT/ZviZ6kPQMvcc9sXBXhMx9OChXVt8vTNrAn4f3X5rKz8QytteuWht0fPwxUKAYIWKfhsX1D31DUGbl/Ct3I+yT6mslpG6aA0JIrgqSltBh1+Xhm79oSsPdermpzpkE43swDp9EgiYdj3oxqLj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777025634; c=relaxed/simple;
	bh=Ojh6NIvOWIjNBbUOq1FRtgXiIjOQPx2fuJnN/VBZGVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AkQ/vHHZlKCneVk5TEmm53hJqxvb09kOvmNvOJLl3iyWT3G7Iezi6twV3VLkiv7m5vtod7/NGN1n4CtAXUs2Mrgbeo9q8+u7+Ni19gEr9E6U7OBMhxjcIZyicvRXE2xr+mthocv+3EwFpo1jrSmeFkCQJEMXxIXJrzwKpEedj4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OYlAhtAo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aj/dUhaQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OYlAhtAo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aj/dUhaQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OYlAhtAo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aj/dUhaQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OYlAhtAo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aj/dUhaQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0D72D6A867;
	Fri, 24 Apr 2026 10:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777025631;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tXrf2ixEZcNNblmGMTmyzWktuO95rf/gqFjEjF1G5hM=;
	b=OYlAhtAoerDTJIL6mfwuB1CDGScrqIyGvoLjeHdt7HJTllo0EMjghSzwOVQfCrbcHo8h+7
	ONhjKcryMSkHuL6D/8ajQzg5P1eKak/2ebsVhGPc6UJWF81MH9xk51rOPZe2l/60FG1LOy
	Fq2d2QEcXb1lmW25/a/7JfV9T3IxdZQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777025631;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tXrf2ixEZcNNblmGMTmyzWktuO95rf/gqFjEjF1G5hM=;
	b=aj/dUhaQRzBWraAN+0dY/7cuXRewp26WxJG1f+fJrP+FHJAmYlVgR+Wd4lg/W7IxUF7tf6
	QTnGM6fCvYiA0DDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777025631;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tXrf2ixEZcNNblmGMTmyzWktuO95rf/gqFjEjF1G5hM=;
	b=OYlAhtAoerDTJIL6mfwuB1CDGScrqIyGvoLjeHdt7HJTllo0EMjghSzwOVQfCrbcHo8h+7
	ONhjKcryMSkHuL6D/8ajQzg5P1eKak/2ebsVhGPc6UJWF81MH9xk51rOPZe2l/60FG1LOy
	Fq2d2QEcXb1lmW25/a/7JfV9T3IxdZQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777025631;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tXrf2ixEZcNNblmGMTmyzWktuO95rf/gqFjEjF1G5hM=;
	b=aj/dUhaQRzBWraAN+0dY/7cuXRewp26WxJG1f+fJrP+FHJAmYlVgR+Wd4lg/W7IxUF7tf6
	QTnGM6fCvYiA0DDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED75B593A4;
	Fri, 24 Apr 2026 10:13:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zU3COV5C62nxbwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 24 Apr 2026 10:13:50 +0000
Date: Fri, 24 Apr 2026 12:13:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 4/5] btrfs: remove 2K block size support
Message-ID: <20260424101345.GA3906171@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1777019132.git.wqu@suse.com>
 <0673de432dd2e64c8d32671247710aab33f7254d.1777019132.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0673de432dd2e64c8d32671247710aab33f7254d.1777019132.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Fri, Apr 24, 2026 at 06:21:33PM +0930, Qu Wenruo wrote:
> Originally 2K block size support was introduced to test subpage (block
> size < page size) on x86_64 where the page size is exactly the original
> minimal block size.
> 
> However that 2K block size support has some problems:
> 
> - No 2K nodesize support
>   This is critical, as there is still no way to exercise the subpage
>   metadata routine.
> 
> - Very easy to test subpage data path now
>   With the currently experimental large folio support, it's very easy to
>   test the subpage data folio path already, as when a folio larger than
>   4K is encountered on x86_64, we will need all the subpage folio states
>   and bitmaps.
> 
>   So there is no need to use 2K block size just to verify subpage data
>   path even on x86_64.
> 
> And with the incoming huge folio (2M on x86_64) support, the 2K block
> size will easily double the bitmap size, considering the burden to
> maintain and the limited extra coverage, I believe it's time to remove
> it for the incoming huge folio support.

Ok then, the 2K support is inferior compared to the folio updates so off
it goes. You can add it now so you don't have to keep it in the series.

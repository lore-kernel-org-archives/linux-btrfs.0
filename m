Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422308;
	b=x/XeWEpusptUE7OxsolbSpHKYA8TOfOWZsT7et7QhRVRoh89xv4Rx1DpQrxYz2irUtqs
	 S8uhp7COkYLlmfKrzIXaI53iI9EsS+DFFErLV1rN4nNc4x9VbQ+IHuEjjlUa2clJVeWM2
	 ZCaw2xBKk3c3F7pvWdy/jFY+p5Bt5goUDN7y60alAlBGhSWtpjR0lG4MQ6avUSUOshdOv
	 k9ABFCw99Eu49XfhH3v5uGlAVVmrDfh6vGi3YsWNwaAn/SDzVjeRretyIV+JwL9Hf8P67
	 IuxpfFAwAJvmAHjKAX8XijqRShN7MYKv3Fp5JuPtp1SH5saCBE+FiUg3d3MlkBIHRXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422308;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:User-Agent:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Spamd-Result;
	bh=xp7tAbYMTxUvwugqYEZ/EGoH6iiMMyHUKj9Q7EP+qkg=;
	b=MoaWlgtnfhzjnDFPOnyyY+C2WoyUeSTgN7X6yotnSyB42qfhfnH5i7IvfcLF7pV0aJby
	 j1S5vAmAtbCRcrDwrZqyNkCJoWdQGn+a0yVjThhELkkWIF2DfD7Z6UQFQtevGbWBSrgm6
	 +XoPiTGTJz39R6BljNtigYG4TqVPwPopB4yTP/0L6SCNFJbBlrrgMq+yP+QXLXDVbCdEh
	 TQCVHlnwEy8i1m6a5wmakX/MfSl4JS+iwJ6x5dh+TLANqWwj1V8JkviZ4X4Rs8ZaM6nXa
	 3kBsjoexp83EPwAgPZPY5IFqb45JwtSAcfHI/eAynVyjfSCBOhauZJa6WJdqNO52L4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1vxifcaL;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=W+kG5mDE;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1vxifcaL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=W+kG5mDE;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BCF6080A81;
	Mon, 19 Oct 2026 15:05:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7BCF6080A81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1vxifcaL;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=W+kG5mDE;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1vxifcaL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=W+kG5mDE
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0145B1F7A8;
	Mon, 19 Oct 2026 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792422306;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xp7tAbYMTxUvwugqYEZ/EGoH6iiMMyHUKj9Q7EP+qkg=;
	b=1vxifcaLo6rs6wHoY/sBCkIYXltbhiWQIUuE+qLWyrvDXm+1JDeq0F66e9tFyWWcNo99Qn
	8PooJ8VkRCD4vu8M9d59BIV/ocvgQ/Zn1/OuhhSl+09QtnuMaB9xnCDESc7rN5RgWzTaDD
	MVUmdIK3ZmjvnEmYCV6NkPbV9tYDd/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792422306;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xp7tAbYMTxUvwugqYEZ/EGoH6iiMMyHUKj9Q7EP+qkg=;
	b=W+kG5mDElUtI2UNcgbldHnvpTH2U4FufRnUPdSvmoapZNzuVGCwIvHucEiqeKpF4yyAuHd
	Obkm9JFFkBg8meDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792422306;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xp7tAbYMTxUvwugqYEZ/EGoH6iiMMyHUKj9Q7EP+qkg=;
	b=1vxifcaLo6rs6wHoY/sBCkIYXltbhiWQIUuE+qLWyrvDXm+1JDeq0F66e9tFyWWcNo99Qn
	8PooJ8VkRCD4vu8M9d59BIV/ocvgQ/Zn1/OuhhSl+09QtnuMaB9xnCDESc7rN5RgWzTaDD
	MVUmdIK3ZmjvnEmYCV6NkPbV9tYDd/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792422306;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xp7tAbYMTxUvwugqYEZ/EGoH6iiMMyHUKj9Q7EP+qkg=;
	b=W+kG5mDElUtI2UNcgbldHnvpTH2U4FufRnUPdSvmoapZNzuVGCwIvHucEiqeKpF4yyAuHd
	Obkm9JFFkBg8meDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3E6B134B3;
	Mon, 19 Oct 2026 15:05:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OmfsJqEx1mpmEQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 19 Oct 2026 15:05:05 +0000
Date: Mon, 19 Oct 2026 17:05:04 +0200
From: David Sterba <dsterba@suse.cz>
To: guolingxing <guolingxing@tju.edu.cn>
Cc: David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
	Chris Mason <mason@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: prevent deleting the wrong subvolume by ID
Message-ID: <20261019150504.GD1310987@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20261018073709.1586733-1-guolingxing@tju.edu.cn>
 <20261018153810.2692021-1-guolingxing@tju.edu.cn>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018153810.2692021-1-guolingxing@tju.edu.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Sun, Oct 18, 2026 at 03:38:10PM +0000, guolingxing wrote:
> When deleting a subvolume by ID, btrfs_ioctl_snap_destroy() first
> resolves the requested ID to a name, then looks up that name again
> under the parent directory lock.
> 
> A concurrent rename can change which subvolume is associated with
> the name between these operations. Since the deletion path does not
> verify the ID of the resolved subvolume, it can delete a different
> subvolume while leaving the requested one intact.
> 
> This was reproduced by repeatedly exchanging the names of two
> subvolumes using renameat2(RENAME_EXCHANGE) while deleting one of
> them by ID. The wrong subvolume was deleted in 9 out of 14 independent
> tests.
> 
> Fix this by checking that the resolved subvolume ID matches the
> requested ID while holding the parent directory lock. Return -EAGAIN
> on a mismatch so that userspace can retry the operation instead of
> being told that the requested subvolume does not exist.
> 
> Fixes: 949964c92843 ("btrfs: add new BTRFS_IOC_SNAP_DESTROY_V2 ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
> ---
> Changes since v1:
> - Return -EAGAIN instead of -ENOENT on a subvolume ID mismatch,
>   as suggested by Qu Wenruo.

EAGAIN is a good choice here, usually used for restartable operations,
which in this case it is and allows user to see what happened.

Reviewed-by: David Sterba <dsterba@suse.com>

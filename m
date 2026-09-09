Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D152EACF2;
	Wed,  9 Sep 2026 01:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788918030; cv=none; b=D5ieSsB6ACdlUapKOfQmkpYK2hczNY1+0oppCMwhVDeqrIqymSNWyRdUyUa1LtTO/nNHIPowewRiuCQhQMSu6ZFe0ugM3JX1MPUb3p301qi7OYvA6PXqjqyjVhLWZ+5vsRj7RwE7b5H4yhRznBgTeS6e30GZGidk3IgKnjHfp50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788918030; c=relaxed/simple;
	bh=4cq0uyDwJ/K4kJ7Gao26bSV90BTeCDTYUX976XCLRcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uuZqkPy8iOIJXh2Cn9sjW5kTRBV3Bqnq6HzRfVbGn4GcfIrLaFY7VYrwxZCROGs7ko+ehncBXBC25Ehs6qcPgzaHHZvEa9i88E5a56rxBBSSdTBQQnh59gp1kwpbFZHMh0ifEkylwnIHww/6/JqMhkXNaGaP5VtvcKTDTLIgk00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HDCfyEOl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BeBWoS8I; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hsR+d/Ig; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s9cR3EPi; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HDCfyEOl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BeBWoS8I";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hsR+d/Ig";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s9cR3EPi"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0937921A01;
	Wed,  9 Sep 2026 01:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788918026;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PCzDYzyCEHu+T1f/wyhUzqHlIYIKWubAd45Hrr6xr2Y=;
	b=HDCfyEOlibgQ6+6ZE8Eeh2Yls1mh64VXMItHWChZTFpKdLXZhkVszQgU1DA//44uad4zyQ
	RmppVnSTeTG/RS8P++feJOjedX439fCKGcB8FoYpPUryjTHJ/B3KdxXZh7w/LmNEY8suIA
	G2wc+f1WwFjx3mwTBMRSb4YMm4Wqu5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788918026;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PCzDYzyCEHu+T1f/wyhUzqHlIYIKWubAd45Hrr6xr2Y=;
	b=BeBWoS8Iy9hjJ6X7NiIGK9qq6ub7/OUgkbhv4U7jL5EmGRqDdQRyWQZbwvaJwYqBQYsklD
	XJf5C2DKn3+WdyCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="hsR+d/Ig";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s9cR3EPi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788918025;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PCzDYzyCEHu+T1f/wyhUzqHlIYIKWubAd45Hrr6xr2Y=;
	b=hsR+d/IgD4KGWL4dXbfjErJPm1O3VXuINISxElhurHxGDtC69x7A/7aavHAPhPTdnWWlUc
	cNjW2/ux5NYrZyExQ7vk9bnEds0ufkQ3CbVOnT4a03d24MjJiU/t0NA9EqzoHupkW8Zgjv
	CC8wf/88+Fa1x+U/pGWQcq0Jj6A4cMQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788918025;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PCzDYzyCEHu+T1f/wyhUzqHlIYIKWubAd45Hrr6xr2Y=;
	b=s9cR3EPivag/+DOwKfDdqhK/ZrBc/eviLdcE5CGkUrTeMV4u0GGLG0XMCKnolHzAMBHh2D
	iRll29mZzAIpyKDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B264F13354;
	Wed,  9 Sep 2026 01:40:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RuJYKgi5oGpUCQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 09 Sep 2026 01:40:24 +0000
Date: Wed, 9 Sep 2026 03:40:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: clm@fb.com, dsterba@suse.com, naohiro.aota@wdc.com,
	josef@toxicpanda.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhongling0719@126.com,
	stable@vger.kernel.org
Subject: Re: [PATCH RESEND v2] btrfs: fix use-after-free in
 mark_block_group_to_copy
Message-ID: <20260909014019.GJ9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260831053801.51572-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831053801.51572-1-zenghongling@kylinos.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0937921A01
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[126.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[fb.com,suse.com,wdc.com,toxicpanda.com,vger.kernel.org,126.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Mon, Aug 31, 2026 at 01:38:01PM +0800, Hongling Zeng wrote:
> mark_block_group_to_copy() iterates over the commit root with
> skip_locking=true. A concurrent transaction commit can swap and free
> the commit root during iteration, causing use-after-free when
> accessing extent buffers.
> 
> Fix by using path->need_commit_sem to protect the commit root search.
> 
> Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for device-replace")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

Added to for-next, with adjusted subject, thanks.

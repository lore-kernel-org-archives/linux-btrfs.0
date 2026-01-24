Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1201519D093
	for <linux-btrfs@vger.kernel.org>; Sat, 24 Jan 2026 00:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769215508; cv=none; b=iVEWpSZAaBvjZHrAbBxBLGTsLLPjUsbkJfcErPYZOQ1b75hcT6yS6oESk5s/2HmCKDUIDI5V5fmiLgCzR3rKPj3bm14U8DUqjE9HYLzpe5illg1H2To81gQMsdDlouTfAUeEfam9usmwYfdFc8yxxzQViVYMfa00wCUSdbLDmBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769215508; c=relaxed/simple;
	bh=ERDe90MQDtvH36V7BQdVraE93tLkhjbi+wW7CbjvF5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QAdUbfYdj0KZ4pFAwGQ6Aen2rIZthctBOrfkOQ2GWDEsS3kTJzJ979NVHspjymXlzx4bx1IOAibvXKHc8TwOof5iD3V+h/VoEqCNqDWmdxebDWfbm5wBx6qP2k2z9xZsEqdOzrZbk8zF80sMBU1GrqMtg9m116uoyd9K9RdKRY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UV5pPKjX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yN2Fzmo5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UV5pPKjX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yN2Fzmo5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UV5pPKjX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yN2Fzmo5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UV5pPKjX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yN2Fzmo5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A0B4C5BCE5;
	Sat, 24 Jan 2026 00:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769215504;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XSfwIcKcIuV2iGy/TMXDUy7pAkbMHnUSRptGk5+cLhA=;
	b=UV5pPKjXtrTXmsH6PVlvUhexDFI3xoNspLdiYkCgm/9h/fXobcgkMYo3iOGchayrWhPOsg
	t62guLtc47qWMtMR/Bv1uN5OckGPyEjkS84zW+Vpcsji8cnMFUkxnFYhs0z9yge5rrqvAr
	1mZqeaAczjUn0KpSy4x4ZTLe021kPiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769215504;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XSfwIcKcIuV2iGy/TMXDUy7pAkbMHnUSRptGk5+cLhA=;
	b=yN2Fzmo5KG4kYzsbBJQ48ncNnZuwEJjn/6+Xh2GBFFjs3+W7Rw1dQM2uD0eVMkUWceruvZ
	ZZFg4w6eaUz+BEBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UV5pPKjX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yN2Fzmo5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769215504;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XSfwIcKcIuV2iGy/TMXDUy7pAkbMHnUSRptGk5+cLhA=;
	b=UV5pPKjXtrTXmsH6PVlvUhexDFI3xoNspLdiYkCgm/9h/fXobcgkMYo3iOGchayrWhPOsg
	t62guLtc47qWMtMR/Bv1uN5OckGPyEjkS84zW+Vpcsji8cnMFUkxnFYhs0z9yge5rrqvAr
	1mZqeaAczjUn0KpSy4x4ZTLe021kPiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769215504;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XSfwIcKcIuV2iGy/TMXDUy7pAkbMHnUSRptGk5+cLhA=;
	b=yN2Fzmo5KG4kYzsbBJQ48ncNnZuwEJjn/6+Xh2GBFFjs3+W7Rw1dQM2uD0eVMkUWceruvZ
	ZZFg4w6eaUz+BEBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 847DE139ED;
	Sat, 24 Jan 2026 00:45:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A3fyHxAWdGnSfAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 24 Jan 2026 00:45:04 +0000
Date: Sat, 24 Jan 2026 01:45:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: corrupt-block: allow to specify the value
 for key corruption
Message-ID: <20260124004503.GY26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8460d20765914390ac2600d8e3f613f5b89060f3.1766975209.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8460d20765914390ac2600d8e3f613f5b89060f3.1766975209.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: A0B4C5BCE5
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Mon, Dec 29, 2025 at 12:56:53PM +1030, Qu Wenruo wrote:
> I tried to use btrfs-corrupt-block -K to corrupt a INODE_REF type, but
> unfortunately the field is always filled with random value, and
> sometimes it even break the key order.
> 
> To make it more useful to reproduce the biflip recently reported, allow
> "-K" option to work with "--value".
> 
> There are some minor points to note though:
> 
> - (u64)-1 will not work
>   We use that value if detect if "--value" is specified.
>   For most cases we do not have key objectid/offset set to (u64)-1, so
>   it should not be a big deal.
> 
> - Will keep the random value behavior if --value is not specified
>   So old behavior is still kept.
> 
> - Values over 255 will be truncated for key.type
>   Just give a warning and do the usual truncation.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to devel, thanks.

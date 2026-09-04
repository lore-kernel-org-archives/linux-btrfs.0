Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C9D481FDF
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 16:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788540848; cv=none; b=TxjpFJURNgwNTeRN5spaAnCfOeJxQJgByEtos0kbuhotuaZmQtApEXI0ZJifxuPmFFBtzmKPIk3PEOhXNjLOz3Tf4eq15IkS9hdrp53Q5BQsOc7JTYJMOYRY3EXSpKQDMDpAQeh7psaWhDUqspqpurgrDbz8G7cmFZ8Y+vmI1u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788540848; c=relaxed/simple;
	bh=ZQO4jbaG/zwR+LT3FO2ONNCuEHnsQ/Px8KvFD1At55w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZdMd82Ybtl2Ci0tmgMeyMvPDV5vA2W8Ro263TsTJzkWucuejZIpLHhrcUHZK87aM04nkRRdHgs4rEiIQLL8116pI6Wou5aYZMfPxuZOF9Pwl48W/iat0wXQ3sM4DpdyU2qQ1Zv+EQI7H6V6PrCfPZbZXm30zxxPATUaj5D1bYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YQjh+cNE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=v6HJk6U3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=X3Tp+2td; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VsOPfR3L; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YQjh+cNE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="v6HJk6U3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="X3Tp+2td";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VsOPfR3L"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C125120374;
	Fri,  4 Sep 2026 16:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788540840;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwUmZPzHbPmPrvvjeKJLArwwcpFSQQjO+upPzIbtVh4=;
	b=YQjh+cNEAj+PTdOekcdPYm1SATI/gJm6htWd76iOf0aZWcmScEMEq/XCFHQjUMURYKOTyG
	dnpIUh+wLi+Fdz7XMlGVeGd64LZgDCgGANNy7OIUyXSvGet83xRcRGlBM0KJ0bCB+6KaIn
	aTh+MxrB/lLk6yXOKjI/MqUgZd95bBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788540840;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwUmZPzHbPmPrvvjeKJLArwwcpFSQQjO+upPzIbtVh4=;
	b=v6HJk6U3ZiGlwbwdaZDieFpx5WroMp4T1/Wnjzrelap1MMO//3K3NUt1xtp8a9a3Kt8xi6
	2k3sL8plUN4xGCAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=X3Tp+2td;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VsOPfR3L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788540836;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwUmZPzHbPmPrvvjeKJLArwwcpFSQQjO+upPzIbtVh4=;
	b=X3Tp+2tdURSEqBLbSjHgEc0juxdrm8270OCJeVcmm2E5HFnBV7X1W02tv00IXM6cmqFfhi
	C9lshPty1iF/QmfNpG4MP1tSwEIOnhcySL5G43lyuXgND8ksY6T9ZymDb3qA+GQP79ZypA
	XMifH3E+Yqrmk0LZSsEabH5EMdAc5MU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788540836;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwUmZPzHbPmPrvvjeKJLArwwcpFSQQjO+upPzIbtVh4=;
	b=VsOPfR3Lj30yztDcaD8cKvKJwg/uzDxlGG4S046Rb/YadcRAY3z1fwdiTAnWeTCAZxhci4
	bcR+CcEGAloUdeAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9FD0E13726;
	Fri,  4 Sep 2026 16:53:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y03IJqT3mmpVWwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 04 Sep 2026 16:53:56 +0000
Date: Fri, 4 Sep 2026 18:53:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Daniel Vacek <neelx@suse.com>
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental
 features
Message-ID: <20260904165355.GL9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: C125120374
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid]
X-Spam-Flag: NO

On Thu, Sep 03, 2026 at 06:09:41PM +0930, Qu Wenruo wrote:
> Commit dd57c78aec39 ("btrfs: introduce btrfs_bio::async_csum")
> introduced asynchronous data checksum generation for data writes.
> 
> That feature can improve write performance, and was introduced in v6.19.
> We have not experienced bugs related to that, so it's time to move it out
> of experimental features for end users.

Agreed, we'll have enough time to test it until the code freeze.

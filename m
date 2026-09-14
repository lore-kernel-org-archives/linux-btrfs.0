Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6229F49B5B3
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 15:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789398506; cv=none; b=FPFCVFKr8v/5bAJDYrXuQ2GcitIwAO0hgPU1mOh5rVTZroLWozXV95ZJO2KDbctrYv++VEur4EG/JfcHE0QtJ6O4NGbyGQ5SvgMsxOiK62+6MDZsenjhONhI+MORntYDUCz54igebIziTTd+1QnYspsrthnYnzPE9urxv7xAm7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789398506; c=relaxed/simple;
	bh=brXfZjH+wfeolFTekWXf8wJF/x9EXR7ogNUFNbn93+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZssSxHAozHZIw9SeRH6JQa+FZnMsMrvHC2bLcLKchYBcQ/TNia/+1xDEsECZRGsY53qxt4PLr5seMWKJmscXGsp5jxiE6pM874L4qcbk3ZtyPRVVSpaqzSeULwR9axCUdFCpjljMZJdfj8g+65VvuEeEd3JVTjl/uaPehqsGbQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QoMT/JDQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+zpk0HzI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=emQSJJ3w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bcLuNLph; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QoMT/JDQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+zpk0HzI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="emQSJJ3w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bcLuNLph"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 36A1A21D93;
	Mon, 14 Sep 2026 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789398497;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QGRGRsKDpEwwkL6EWLB1bC2gLZpaV4ZyAMrU6bCa4PE=;
	b=QoMT/JDQiW98Hz4cl+B+rHZSgzjPYDrvrojxn5dzqjo4HWFuBwCWnmtS3d050v1Sfs4Zdc
	V/QZ6RoYS1jRclDoK/hloBmZUf7oOMnfmDRtQJTOT7FBLRrp7FpLM9LcpKA6t1e7lS8GtG
	xGf46QQLi1QWeYPeztWDFKlH3yj8nuk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789398497;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QGRGRsKDpEwwkL6EWLB1bC2gLZpaV4ZyAMrU6bCa4PE=;
	b=+zpk0HzIwjKsfWmKw/HfQsxjpGIHZoh95IMwk7kVfyIJQibcAabjuaOwVEuLidkU4btnDT
	6ZvKkxwpPrDQF1Ag==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=emQSJJ3w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bcLuNLph
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789398493;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QGRGRsKDpEwwkL6EWLB1bC2gLZpaV4ZyAMrU6bCa4PE=;
	b=emQSJJ3wVyPk80TNfEREM4hi2tLxDvKP6rl7MNpQS4E7Rx1cfTiX6c0/TW9gmGXmO6h65X
	QNsfXbrqIFoTVu/coBSJnpQ+7bPSHeTgoNwAsSEOEtkFMLcGDpkp9hY46CjvZM/mxRS4AK
	aeXPwNIxoBVsQN2jc8dikzzDB9FSnp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789398493;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QGRGRsKDpEwwkL6EWLB1bC2gLZpaV4ZyAMrU6bCa4PE=;
	b=bcLuNLphT/IP/BP65Cxe4fxsBdf2fV/oEazJBSwet/AkVENQ0Rs6b95ONw1RPY0sLYAi/X
	Raw9OlVYB0Bo36BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A28E1368C;
	Mon, 14 Sep 2026 15:08:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qlFHAt0NqGqVTgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 15:08:13 +0000
Date: Mon, 14 Sep 2026 17:08:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH 4/4] btrfs: zoned: avoid underflow of bytes_zone_unusable
Message-ID: <20260914150811.GJ54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260914085248.347198-1-johannes.thumshirn@wdc.com>
 <20260914085248.347198-5-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914085248.347198-5-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 36A1A21D93
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,wdc.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Mon, Sep 14, 2026 at 10:52:48AM +0200, Johannes Thumshirn wrote:
> The two functions btrfs_free_reserved_bytes() and
> btrfs_reset_unused_block_groups() both manipulate
> space_info->bytes_zone_unusable without using the accessor function
> btrfs_space_info_update_bytes_zone_unusable() potentially risking an
> underflow (in case of btrfs_reset_unused_block_groups()).
> 
> Use btrfs_space_info_update_bytes_zone_unusable() in both function, in
> the case of btrfs_free_reserved_bytes() it is mostly for documenting
> purposes.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

The two cases cover all modifications of the bytes_zone_unusable, it
could make sense to force using that wrapper, eg. renaming the
identifier and providing only a get/set helpers.

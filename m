Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB33375F87
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 08:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773650994; cv=none; b=ABbryd3o8PC8DxYltsaFvKK7C10p8IKmQhlDU10vTCjjWGYp28yG1cDXwfPtdVYDZK/1ohb0Spjiya3e5uDlG5+Ur5D6ozqFyX+SkjwzvGoSMs8+SeedfZMiXz/l4oNq1502WFu07jzmlwjVYcJdBeUrnHI6VvgwbQFWh65uy+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773650994; c=relaxed/simple;
	bh=JVY1XPWKQSKxkLbyw9piYkNyOttVZEVBRCuL1cR4O8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IW5EQ0+K12yDjhcYJpFMBrI4vHtOssyfP/Wyu2v75enuKiVyYD7qfZ1gQovH9dtSqFb8Gd1v8mqC/kHCnE70EJN0FTEhxr7hh0BzsLkekj7m2dKQ7oHLTIU9l6CUga0HrMcd23/ToCoLTy+HwZiVLo8OYV+nIthXFCedxZ0Fdpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TZUnuCX3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ft0lMUpH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TZUnuCX3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ft0lMUpH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TZUnuCX3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ft0lMUpH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TZUnuCX3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ft0lMUpH"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C03A04D28F;
	Mon, 16 Mar 2026 08:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773650991;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i3gZy9xA2nI7xZye0tWK5MviN4vWprrJ54WKg/cDZ4E=;
	b=TZUnuCX3M5PeHuvQmuF9azIc7L8Z/E9VPk0CFVwJVGBGAJoMFcWG1CmfBXHn/3lXyaF3L3
	Sdf4UbrrYXXWHs+Q8z8Lk4E44ZqB84lKsUD9wFLP8mz+FM6b3me4e90kBGsc0iH1cDH5mk
	vO7sCzDMvS4lPWEfT8bSg2Id5Y1VIBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773650991;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i3gZy9xA2nI7xZye0tWK5MviN4vWprrJ54WKg/cDZ4E=;
	b=Ft0lMUpHd6oloseo227d5KlOeKPwQPW0dCPyqB2raC4smMniDSKrRCxbZEtdgjmff6Y2m9
	CEOFHdt+kAgF5ZAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773650991;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i3gZy9xA2nI7xZye0tWK5MviN4vWprrJ54WKg/cDZ4E=;
	b=TZUnuCX3M5PeHuvQmuF9azIc7L8Z/E9VPk0CFVwJVGBGAJoMFcWG1CmfBXHn/3lXyaF3L3
	Sdf4UbrrYXXWHs+Q8z8Lk4E44ZqB84lKsUD9wFLP8mz+FM6b3me4e90kBGsc0iH1cDH5mk
	vO7sCzDMvS4lPWEfT8bSg2Id5Y1VIBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773650991;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i3gZy9xA2nI7xZye0tWK5MviN4vWprrJ54WKg/cDZ4E=;
	b=Ft0lMUpHd6oloseo227d5KlOeKPwQPW0dCPyqB2raC4smMniDSKrRCxbZEtdgjmff6Y2m9
	CEOFHdt+kAgF5ZAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A86C84273B;
	Mon, 16 Mar 2026 08:49:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Mk7wKC/Et2nwcgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 16 Mar 2026 08:49:51 +0000
Date: Mon, 16 Mar 2026 09:49:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] btrfs: enhance BTRFS_ORDERED_* flags sanity checks
Message-ID: <20260316084950.GN5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1773446363.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1773446363.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Sat, Mar 14, 2026 at 10:30:37AM +1030, Qu Wenruo wrote:
> [CHANGELOG]
> v2:
> - Minor grammar fixes
> - Change the output message when overlapping OEs are found
> - Use has_single_bit_set() to replace hweight*()
> 
> 
> During my development of introduce a new DELAYED type, I incorrectly
> called something like:
> 
> 	oe = alloc_ordered_extent(.., BTRFS_ORDERED_DELAYED, ..);
> 
> That doesn't trigger any warning at runtime, but will cause unexpected
> bugs due to the fact that, BTRFS_ORDERED_* can not be directly used as a
> flag. They are only bit numbers, thus should be utilized with bit
> operations like "test_bit(BTRFS_ORDERED_DELAYED, ..)".
> 
> My stupid bug inspired me to enhance the @flags sanity checks in
> alloc_ordered_extent().
> 
> The first one is to make sure that my stupid bug can always be caught
> early.
> 
> The second one is to enhance the error message when a duplicated OE is
> found during insert_ordered_extent().
> 
> Qu Wenruo (2):
>   btrfs: check type flags in alloc_ordered_extent()
>   btrfs: output more info when duplicated ordered extent is found

Reviewed-by: David Sterba <dsterba@suse.com>

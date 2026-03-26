Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D2C37EFFE
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Mar 2026 14:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774534587; cv=none; b=UxFwCn9ouJAg263LoRoNItf8qeeULZNvXpEPAK7mVIPlRA3bIXHm+WZ+jYZeb5Pk+4pWya8ediYbRHpB0QkpLtoPjFZ4X7Mjc4s4lGKHSk4m1wKv5RxzNiadfGQDHTp+RdkXBA3r3YJH1JbSoPNgelGQMBhcxcmLfhLfgOa8rvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774534587; c=relaxed/simple;
	bh=lUmNVRbS0r6DS4Ge/tCLs+T+dZlT1RRk/Vs6/eejr7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tkRGxYjzwdHfa5PbhEU0eqSs76eevkkHU95cSg6PRGb+0wOZ98gKkHnTk039jJrV+d+JxoO6VqOUJrGiG122/hcZKm86IWMidO998EKRw85FlSCvxohofQP44EbsANbaxeZyP2wUWYmA5fjUxFZ/Vb2mJSj/XrU5KoUOutDchow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L4MYNbql; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kYjviFy/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L4MYNbql; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kYjviFy/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L4MYNbql";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kYjviFy/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L4MYNbql";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kYjviFy/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 32EEA5BD11;
	Thu, 26 Mar 2026 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774534579;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/9UgprE/wm0W/eVBFFDuSx93/Smz0Rd2MYG+AUD8CNs=;
	b=L4MYNbqlnxr/FE1lRVNEoT1tFI9ZuevtlY0vHQ94SYLkAIbzLJJ1y5DOqkAztTZgFJ+Hpw
	tCNIn3KMm1Emo84suEnU5VAjnj41BSK9hTdUNw9qMVsqW0uTjmUwj4SFs+RNhUSObfJ9j7
	HXYNHwOuCXrMGBAGZHvIGaNyo4G4b08=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774534579;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/9UgprE/wm0W/eVBFFDuSx93/Smz0Rd2MYG+AUD8CNs=;
	b=kYjviFy/uFJidCcChzD8/rgjB6641Xz2RqqLXZmwy9PWxt0Ff/AM+Fs6Okzuk2OnEL3Skf
	MEHqMliJh/WkmdBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774534579;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/9UgprE/wm0W/eVBFFDuSx93/Smz0Rd2MYG+AUD8CNs=;
	b=L4MYNbqlnxr/FE1lRVNEoT1tFI9ZuevtlY0vHQ94SYLkAIbzLJJ1y5DOqkAztTZgFJ+Hpw
	tCNIn3KMm1Emo84suEnU5VAjnj41BSK9hTdUNw9qMVsqW0uTjmUwj4SFs+RNhUSObfJ9j7
	HXYNHwOuCXrMGBAGZHvIGaNyo4G4b08=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774534579;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/9UgprE/wm0W/eVBFFDuSx93/Smz0Rd2MYG+AUD8CNs=;
	b=kYjviFy/uFJidCcChzD8/rgjB6641Xz2RqqLXZmwy9PWxt0Ff/AM+Fs6Okzuk2OnEL3Skf
	MEHqMliJh/WkmdBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 149F14A0A6;
	Thu, 26 Mar 2026 14:16:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sFUwBLM/xWkPGAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 26 Mar 2026 14:16:19 +0000
Date: Thu, 26 Mar 2026 15:16:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: add remap-tree checks to
 check_block_group_item()
Message-ID: <20260326141602.GW5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260325125349.123889-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325125349.123889-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.985];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

For tree-checker please add prefix "btrfs: tree-checker: ..."

On Wed, Mar 25, 2026 at 12:53:43PM +0000, Mark Harmstone wrote:
> Add some write-time checks for block group items relating to the remap
> tree.
> 
> Here we're checking:
> * That the REMAPPED or METADATA_REMAP flags aren't set unless the
>   REMAP_TREE incompat flag is also set
> * That `remap_bytes` isn't more than the size of the block group
> * That `identity_remap_count` isn't more than the number of sectors in
>   the block group
> 
> Signed-off-by: Mark Harmstone <mark@harmstone.com>

Added to for-next, thanks.

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7299C350D74
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 03:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776541; cv=none; b=Cev90cGzLnRnUM1m1bGo/0if53NNXaBneJ8FYqLfbN0Un1UFLJQ/ulnmKOsTkOxDcB7IL9fAPa6ESOtj6pSK0SUDAUXqLmd3quGHrK92CrWtvYgSWFMl94/GmOIaghHeIaisFQ8/q6GaI3LVjViTcyqhtDNB3oubmb+JELfOO7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776541; c=relaxed/simple;
	bh=J6QlyZskhag1RJ56QG/TYiQ4Bm+zL3WYebWlkX2VnZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Il84UxqGh9sxO2d8On8uDGsUEET+OXlmazFBtxuOfJ3HFxCnJ57cLR+Cnk8qb2G6z0uxZQbUFuNi8n8RDizoj0q5SHpRkDn8EYInfverjbBgvWl9UTmOL0G2nQdMFTR0Mx5VDUZ0JVi7IbNVyjTemHSDrHEFSAIVJFjNVohL5W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H8Rz+BjL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CPwgAnFm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H8Rz+BjL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CPwgAnFm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H8Rz+BjL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CPwgAnFm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H8Rz+BjL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CPwgAnFm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A11B97AE36;
	Thu, 23 Jul 2026 03:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784776535;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvvYz3neytuWl0fWIzqOSA0tXubFV/qI7jB95og6pQE=;
	b=H8Rz+BjLZgJIWOAYHWZXWljzoQ1uCocS+AzE0vDf5cotirPnUk2SLsoKq5JLgX/A8nLQPd
	vUD4xSWwkmGv/2EH9gQzSNh6ydQ/PhWAzrXwaeE6F8xoo1OSvkhLHPHRMLEe+/FVg0Iupz
	Ji+5VNT1wIXgxLPgwFMI7ktpehadBeg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784776535;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvvYz3neytuWl0fWIzqOSA0tXubFV/qI7jB95og6pQE=;
	b=CPwgAnFmFKPHvAclcJbO84HCBVjat93EKfoKc+14LmgxJDy7gOP5HHQYOO+vX/ri13xZy1
	lceYG4+2fiHQqNAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784776535;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvvYz3neytuWl0fWIzqOSA0tXubFV/qI7jB95og6pQE=;
	b=H8Rz+BjLZgJIWOAYHWZXWljzoQ1uCocS+AzE0vDf5cotirPnUk2SLsoKq5JLgX/A8nLQPd
	vUD4xSWwkmGv/2EH9gQzSNh6ydQ/PhWAzrXwaeE6F8xoo1OSvkhLHPHRMLEe+/FVg0Iupz
	Ji+5VNT1wIXgxLPgwFMI7ktpehadBeg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784776535;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvvYz3neytuWl0fWIzqOSA0tXubFV/qI7jB95og6pQE=;
	b=CPwgAnFmFKPHvAclcJbO84HCBVjat93EKfoKc+14LmgxJDy7gOP5HHQYOO+vX/ri13xZy1
	lceYG4+2fiHQqNAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 941A0779B5;
	Thu, 23 Jul 2026 03:15:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sgL0I1eHYWoYVAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 23 Jul 2026 03:15:35 +0000
Date: Thu, 23 Jul 2026 05:15:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>, Matthew Wilcox <willy@infradead.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: retry verity reads for not-uptodate Merkle
 folios
Message-ID: <20260723031530.GQ10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260722025435.1493093-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722025435.1493093-1-chenyichong@uniontech.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:replyto];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]

On Wed, Jul 22, 2026 at 10:54:35AM +0800, Yichong Chen wrote:
> btrfs_read_merkle_tree_page() can find a folio in the mapping that is not
> uptodate.  After taking the folio lock, the current code treats that state
> as a read error and returns -EIO.
> 
> That can make a previous transient read failure sticky.  If the failed read
> left a not-uptodate folio in the mapping, later callers find that folio and
> fail instead of retrying the read.
> 
> Keep the existing page-cache insertion and locking order, but retry the
> Merkle item read when a not-uptodate folio is found in the mapping.  Also
> unlock the folio when read_key_bytes() fails so that a later caller can
> lock it and retry the read.
> 
> Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
> Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>

Added to for-next, thanks.

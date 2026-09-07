Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8021B4223;
	Mon,  7 Sep 2026 10:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788775605; cv=none; b=A7bIt12ve6FrS0cOwzk5tDP8RO9h1YupkdHj9N40jQjKIkLXxsOmBT/Dcm6nB/o8aiGhRLKqaVV3pMYQHCMwP0Bo/61ljd5kAUzC+felleCMy2S11xZ9C5tHN46lO4SDm9Lq1BUnpUKvlUcdwCNpZEm19GfGKuLXoZy8SbCsOYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788775605; c=relaxed/simple;
	bh=iR+ouRZSgudAUubhPbtWPIF1DIqALlnk2uBCLxgQZ9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aReqDia1uf1cDTZ3cgKewCoy2vVq5e6HSC+45D2j3XAXIp1W07jeu2g4dKvjZXnHxkgkgAdlWw3az/XHG1GkXL5Zogk8aRf+9QTP5xaPj6U8Bmxc7GHT0h67i8GSjWaT+D7W4IRGf2xq+rYUifdtMFGAWNaowPkt7/OW1PtM7Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=t+VESbmp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wxIW4jeF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d+u+KEB8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SQVSZ697; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="t+VESbmp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wxIW4jeF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d+u+KEB8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SQVSZ697"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 457091F45E;
	Mon,  7 Sep 2026 10:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788775597;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PfoTAYFqTl2Hak1JlmZCMv1BTYA+TeE2F5LGEJs0pn8=;
	b=t+VESbmpnboxICr1KOGyA+1+6HvXRH1GTZYni8Exsde0oh4yDJoTA0Clp9v/l0HT5/g/XD
	tHXb3lEkMBR8GDtFVm4fs62rIORm8exaMjtwN3aEnxObkZX6v7Sfsr7huJ3jNU1Dheaq50
	hDZuFxudJX86DTCod57yCJMn6fKaScE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788775597;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PfoTAYFqTl2Hak1JlmZCMv1BTYA+TeE2F5LGEJs0pn8=;
	b=wxIW4jeFuYirg6E7infoShmTHnHMLSv7WOToij/gugB9dXFf1vkAoI0dG074u60buQWilY
	0or7mkp1vrc4tmDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788775593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PfoTAYFqTl2Hak1JlmZCMv1BTYA+TeE2F5LGEJs0pn8=;
	b=d+u+KEB87XgOBkSCAchxtzJ2XMpDXf/Bt5NJgObhcBPRZX/x853mhZdiySeWqQOMaJDHIj
	1YCTOdN/FxnTCSwFl8uUGTrBEtM6eAJvI7K/yZpVbOvHsfz0ugNQzjHAGhu8JltDQ2OW+6
	sSBdFMoNf9X++UXfipmvpbuGj89uLE8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788775593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PfoTAYFqTl2Hak1JlmZCMv1BTYA+TeE2F5LGEJs0pn8=;
	b=SQVSZ697+iV1UgcmOkOAM8WkDQVfZCeUmi2M5/gFvLp55EDnqENfD845Hk3CNp7fYQCWjD
	H/GCrbuXsuyQauBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 00C221339B;
	Mon,  7 Sep 2026 10:06:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vvAhO6iMnmocIgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 07 Sep 2026 10:06:32 +0000
Date: Mon, 7 Sep 2026 12:06:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix typos and repeated words in comments
Message-ID: <20260907100627.GR9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260907044801.9088-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907044801.9088-1-hemanth.selam@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -2.50
X-Spam-Level: 
X-Spamd-Result: default: False [-2.50 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Mon, Sep 07, 2026 at 10:18:01AM +0530, Hemanth Selam wrote:
> Fix misspellings and repeated words in comments, found with
> scripts/checkpatch.pl and codespell.  Only touches comments, no code
> changes.
> 
> Changes since v1:
>  - the typo and repeated-word patches are folded into one, as they only
>    touch comments
>  - rebased onto btrfs for-next
>  - picked up the further typos codespell found, which David Sterba
>    listed: Temporarilly, Checksume, coresponding, caclulated, wheather
>    and cannnot ("commited" in block-group.h was already fixed by v1)
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Added to for-next, thanks.

Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A9222A4F1;
	Mon,  7 Sep 2026 09:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772980; cv=none; b=PPhdVZHlVtv0ollLs6IkX/lIUHzfTmMj0L40jLZAOVKA0cCPIq5pQAt+1LHNfQk7H1Bnsl2rUmO7XEjFvAOT7XzAYe0ZX+XNDDFFn0oouda7N0PJH+FB/U4JlVs2y+3lUwp4qsB1HkyATrEbYRvlSyFwrALymuGL9rUesfMRzRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772980; c=relaxed/simple;
	bh=MKtLa1IhgHKeHKhnsVZh7ZvPJrp/BffwYqom7d9Acg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LpqNo16/NtQ2YOAlYWNIN4c3IHSfqLeoil33alsZIb8D+/AO7HCsqPpGBYIUFCR3ug7kr2ecu6rO3E4RX4oNO4yjuLSNbEZAI1DYfAvkvNKZU0mQYTKKoYok/3yrjN0zNgYoAG3H4KWp1X+kBvBG18jtMzPZeOEB9ZmoSDP2WxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IHy8wklt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=e9Q8Sic5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vuT8mqeS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=q18bsIrO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IHy8wklt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="e9Q8Sic5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vuT8mqeS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="q18bsIrO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D05FD1F397;
	Mon,  7 Sep 2026 09:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788772972;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vz1OjNiCGVWHkKUxQaOO5ojg7oFzygU9xZMIvnCtbpo=;
	b=IHy8wkltR2qJKpLE6b4aY/pyimEhDdZg2z1vqHJljHK3q0Xs8SD6LgZsIKQxQWmZvGHZfc
	NVrbYhwO/fqV5a9vvvb2rhkUAAQbS9eM48XJ57DxiaPYJHJCz1c2CQMQYwbtd3OuJFs/LI
	if3RDr8N+748qONQJbbiVWuron+xjMI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788772972;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vz1OjNiCGVWHkKUxQaOO5ojg7oFzygU9xZMIvnCtbpo=;
	b=e9Q8Sic5EshDXVjrekzU5nLlbWdP8IBqgPiVzCwVXWmZrCMitTXZ3FNLkObICgmc7XndGU
	yv1wR5Q80eKWaEAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788772968;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vz1OjNiCGVWHkKUxQaOO5ojg7oFzygU9xZMIvnCtbpo=;
	b=vuT8mqeSOs1lTY4YlVepLyvDG9IX/eCIrKNtuf2slubpR0vHVjleG8DhHg//INTHAOpcAe
	7eNtVTPnxl+neVv81YbFy2f2bJgNDyyFYuuibt/3dxIwBz2lADJBjxH69pyqUC+esiKyf/
	wc6F6tBysk6pem0UoBPbD4anroVtElA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788772968;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vz1OjNiCGVWHkKUxQaOO5ojg7oFzygU9xZMIvnCtbpo=;
	b=q18bsIrO2RgbmngB1bTYEFEmm7u2CNS8b/Ysz9ryBv/s3ZWn1Gbbj6wprlPIY4yp7Sxs6j
	jUUyHc7mm38sZzAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADA9C13432;
	Mon,  7 Sep 2026 09:22:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7/oxKmiCnmrLdgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 07 Sep 2026 09:22:48 +0000
Date: Mon, 7 Sep 2026 11:22:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Daniel Vacek <neelx@suse.com>
Cc: Hemanth Selam <hemanth.selam@gmail.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix typos and repeated words in comments
Message-ID: <20260907092247.GP9053@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260907044801.9088-1-hemanth.selam@gmail.com>
 <CAPjX3FfQ4X4Bd-1-_Q3h4azLM98vnJLfZ8TvduPK6zf=y==Z2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPjX3FfQ4X4Bd-1-_Q3h4azLM98vnJLfZ8TvduPK6zf=y==Z2g@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,fb.com,suse.com,vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Mon, Sep 07, 2026 at 11:15:33AM +0200, Daniel Vacek wrote:
> > --- a/fs/btrfs/raid56.c
> > +++ b/fs/btrfs/raid56.c
> > @@ -953,7 +953,7 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t status)
> >
> >         /*
> >          * Clear the data bitmap, as the rbio may be cached for later usage.
> > -        * do this before before unlock_stripe() so there will be no new bio
> > +        * do this before unlock_stripe() so there will be no new bio
> >          * for this bio.
> 
> The sentence should start with a capital. Perhaps it would also fit
> into two lines?

Reformatting whole lines makes the typos harder to spot, so it's fine to
leave it like that and reformat at commit time eventually.

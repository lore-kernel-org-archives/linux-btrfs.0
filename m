Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817243370ED
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2026 16:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768927728; cv=none; b=NAQMyAIjhoSHmy7UN3XAFAB50C7cJyDLHC+sOl0NCFalbGUdqllp+Qx+8tVANvX7icmqP3LDItCC4l40dIfvjmUqAfZR4Pm9CmRApoKpobG1RlK78MARi6sOyXqM7/EmDBqSWgHqFbQHAUkD7la2jw6oXwzZhmgJ8wDC2VQ74B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768927728; c=relaxed/simple;
	bh=AEtesSFOnRHDfTxBpu+I94SUn6ca0VG9+6SRSzycjHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8udeqgwOuoxkVQnO3W5iTwLksi0Vc4SwU7xTkMjLkoeISwXZ7SH+FtFbfTX/IgcB2e4ZmmOzdzo5QGACbB+FL2rWrJlxbmHe0ba5Hr7XozZUWTp7tMJc/f2awytS8F0vNOz/YBNqbwrGsGzBL6zccgy66t12BYOcYR1XDa7DRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yATWyaO5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CSdnheJL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hdBW/Ccw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JZOP2deB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yATWyaO5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CSdnheJL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hdBW/Ccw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JZOP2deB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BADA55BCCC;
	Tue, 20 Jan 2026 16:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768927724;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fjmZtd32A/Ht1WROFUKzw8xj1CTSmEifcjg0ejnC3E0=;
	b=yATWyaO5FAP0zMmGPPRhYsetV9Z5ARjUNfDdu8asPQJhvwcIBa7/pnNhX5895T8vqmMGTs
	FCpLP6Q0tMpLgasVdQR9kneR3GBAZryCPmTVyXhAcobmLZBjZIghIPlJ2pJd3cqaiKsogN
	MsP0mjPRH6KR6iINNyc/ExiNxsFZ/Ko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768927724;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fjmZtd32A/Ht1WROFUKzw8xj1CTSmEifcjg0ejnC3E0=;
	b=CSdnheJL69AIyCdw3v7SMRYkD6D4NrKKyPDU34JnsV0q3J1WwO43D2eBW5p++9DwRqL7vc
	KFR3piws1z0jQNDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768927723;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fjmZtd32A/Ht1WROFUKzw8xj1CTSmEifcjg0ejnC3E0=;
	b=hdBW/CcwjlyUfj9R1QHtnhy69m2c1gwMR/ZapmbK+GpZDWigYmcCEzV7btCIQPzpFUzc0A
	72mWANyykLQx20xcwLO9bD1fPjWfuywTdQ5Ny7Mw2VV4iK6sli0QMJ8SEze88scNZ+rUAs
	SYyXq2J23PIUwMjFzA3pd/EP/XHeFsM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768927723;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fjmZtd32A/Ht1WROFUKzw8xj1CTSmEifcjg0ejnC3E0=;
	b=JZOP2deBkKDHPBMaKq5TJMt2xMZ5RFr2NflNkio7phVE5MlsdsCJlFfjEBZ0JEWUMSmAqE
	1AQwbK4/q36fatBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E1443EA63;
	Tue, 20 Jan 2026 16:48:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 674nJuuxb2n2bAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 20 Jan 2026 16:48:43 +0000
Date: Tue, 20 Jan 2026 17:48:42 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: some cleanups to the block group size class
 code
Message-ID: <20260120164842.GG26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1768911827.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768911827.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Tue, Jan 20, 2026 at 12:25:50PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Simple changes, details in the change logs.
> 
> Filipe Manana (4):
>   btrfs: make load_block_group_size_class() return void
>   btrfs: allocate path in load_block_group_size_class()
>   btrfs: don't pass block group argument to load_block_group_size_class()
>   btrfs: assert block group is locked in btrfs_use_block_group_size_class()

Reviewed-by: David Sterba <dsterba@suse.com>

Thanks.

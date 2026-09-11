Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCF943441C;
	Fri, 11 Sep 2026 17:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789147605; cv=none; b=FrrFIjcxwUI0YoffOUI3/iQ3t1xFwQP1vEiaJf5UjHmTxveZ1fu4o33BGXYB7CIWjAY6BKVT54FWU25sfJuebAA7eqW3h7M4wrXQaF8EP4zG78X+Uk2e5jYwZ6edyNF+WKhLUUbVol8j+yRSN1XVIFAWpJofXbrV2EDxjA+F/UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789147605; c=relaxed/simple;
	bh=nKRJhJDrxQ9jsObvPolWqtGfKCTaiAcxTgP2gAWw53s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ADZN0Z3Tg8aOcvsIuOn3myAjWwOVkmYY5pwSwf7x6WOqh5I3eF1oj7+8e4yE0UgB/uL765EsoRqdGX6fkGB/7EOtBD/gKEcRYv/bDmuG8XLDNkfn2MoJKflSCtbizATLvAsuxbk+FfFPjJ1fne4HqeJ5YQfVE4o8AfM8+w2aVE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wnpCwKun; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2/jK/wmK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=adlq5OOI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VlDUfpIV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wnpCwKun";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2/jK/wmK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="adlq5OOI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VlDUfpIV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7561D1FE50;
	Fri, 11 Sep 2026 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789147597;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v/WBwzamLlHdjRUYNBCXwKr7sqGsbmUY0eu3vlLRyxg=;
	b=wnpCwKunZbsPhe4ndWK9Ix+GqIyoUkV2j20/HIwO35FFyGgKedFZU7sXhKeD2QVDIPEiek
	S7c393zL/LRYGf1DUwyrh3SSh5Ocg4yp+7BXpvu0x+e1o3Lglw8LtJRWi603bW7WtEcDZ+
	wgmmN8kGs+9qnFmsNG7TtEYYlCDBJBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789147597;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v/WBwzamLlHdjRUYNBCXwKr7sqGsbmUY0eu3vlLRyxg=;
	b=2/jK/wmKntMbZNFUx6EMhDAFce3VxfJoWTe4FdJafk88VK+FEUogk7s38g6kMjAz1b4QMC
	Qc/sUStwnNFs+QDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789147593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v/WBwzamLlHdjRUYNBCXwKr7sqGsbmUY0eu3vlLRyxg=;
	b=adlq5OOI0L+MKhkhnEFmudgFbLv28RzmdvbVhZ4yYNizMFLSRizZAjjQyyIo6CGAfQTDKE
	Vc4klKIbumugTZZowYoT8fveFXWZS/AZOfs8GifEs7q/Rps85flzg1/T95LvK+K14I4k4z
	CsKAXXIL8gI4xFa0XRE6tjqhO4dqgSw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789147593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v/WBwzamLlHdjRUYNBCXwKr7sqGsbmUY0eu3vlLRyxg=;
	b=VlDUfpIVyk+B71U0wS8BPh4IpznykuGL/79ggpJfRfIdwNJbl57oW47SJJ/PyyZE8wPr2P
	6Dt3coMCFwWj6hDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 25D3113715;
	Fri, 11 Sep 2026 17:26:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WhgCCck5pGqTMQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 11 Sep 2026 17:26:33 +0000
Date: Fri, 11 Sep 2026 19:26:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: use u64 for the page indices in
 heuristic_collect_sample()
Message-ID: <20260911172631.GB54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260909-btrfs-heuristic-u64-index-v1-1-8606b3c89807@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-btrfs-heuristic-u64-index-v1-1-8606b3c89807@columbia.edu>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Sep 09, 2026 at 01:10:48PM -0400, Tal Zussman wrote:
> index and index_end are derived from the u64 start and end offsets, and
> index is shifted back into a byte offset for offset_in_folio(), which
> needs a cast to u64 to be safe on 32-bit. Make them u64 instead so the
> cast goes away. They still fit pgoff_t where they are passed to
> filemap_get_folio(), as they came from a valid file offset.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Added to for-next, thanks.

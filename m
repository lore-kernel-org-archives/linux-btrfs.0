Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537F42BDC1C
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 17:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788802931; cv=none; b=poalCogQGOvyAnqhdk9Iknmhzbz3DzxtzaRfaF/0FUCXoEoDOfdoBQYK3JDIgGj6LCk5zOHv0J9PnQvvbAnAMIwzVYG6utyayz4r/o48i/Rbl5wIDQpRneU8nL3WQXSItgNbJ6XNkTDQVEupX+0A5GLzb+qtN7smqPBxRWgFgVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788802931; c=relaxed/simple;
	bh=F99nqAbAbBwIzX7c7osxcKdIbo4f1cL96N+y3odNwVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVZ3nRlt+j+NG4sdRTzmV1F5BBm3FBwNJuWToRnTKV2+lMJ17ofu1pTsEWlDIY22Dkz8wzZnz/ngkB7ohSN9+a/Sz+7pAc9uHoNNe/N7VTkokFdQG3CJ6ljrx9HX5zsVJ8C3TiP3YHZctTVYmuDJRYjp+lkeT2eSdX4hlwDaDmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d+fkOnOn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=y9Z7AtDo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HVbEpSYY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=67B/BQlO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d+fkOnOn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="y9Z7AtDo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HVbEpSYY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="67B/BQlO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D850C21275;
	Mon,  7 Sep 2026 17:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788802924;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NTyS31lkQ7wrLikOttIosNpuIk/z5wcUxEhx7O53XQU=;
	b=d+fkOnOnTH8Otqyg0gAtjJz+sQG9Dyd594Mg5yz9nnsAvG7mp+XcpzsNFtIIyXPd7gYgGx
	4vTVm0MsLbNO4L8AX9mMewK73uKBzohkCCYB3LpztiE890b+prpat5hhxMtIsXUBauSJ+V
	WXBmoqmfzhNLvRW5RSjWc7gm5uDQZf8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788802924;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NTyS31lkQ7wrLikOttIosNpuIk/z5wcUxEhx7O53XQU=;
	b=y9Z7AtDoZNBXM1Slon4h9VTV18nfU98QUpi+x8/94znKGHuLBOGtBtp/CwDZ/nKgZ0o40k
	+Umt+aQIBtJ22+AQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788802919;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NTyS31lkQ7wrLikOttIosNpuIk/z5wcUxEhx7O53XQU=;
	b=HVbEpSYYkCEot99at/dJ/D6gBK+315d+4nkPZMHirrBzuOVUzvRSTZxd72MrS7+QduddNf
	3WTegclJO4cWroQiQIaltcBC8EdSE3/NvLXFmyK9ZrttrEQKdJHPpkvb9cXYdh7aNDFzOI
	YRneVViR5kM7u0eH7I4OR+Hke5NxPuo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788802919;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NTyS31lkQ7wrLikOttIosNpuIk/z5wcUxEhx7O53XQU=;
	b=67B/BQlOffRLbcUXLFFiQ5flcQj15fKqLzEE9661CD9cSNp9+lRbZ9iyVnOd38CL5Z61N5
	zYlk1luEVcWawgBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B451D1339B;
	Mon,  7 Sep 2026 17:41:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0EPMK2f3nmpgYwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 07 Sep 2026 17:41:59 +0000
Date: Mon, 7 Sep 2026 19:41:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: dsterba@suse.com, Johannes.Thumshirn@wdc.com,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: replace is_data_bbio() with is_data_inode()
 for direct usage
Message-ID: <20260907174158.GY9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20251222035942.1482587-1-zhen.ni@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251222035942.1482587-1-zhen.ni@easystack.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
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
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wdc.com:email,easystack.cn:email,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]

On Mon, Dec 22, 2025 at 11:59:42AM +0800, Zhen Ni wrote:
> After commit 81cea6cd7041 ("btrfs: remove btrfs_bio::fs_info by
> extracting it from btrfs_bio::inode"), the btrfs_bio::inode field is
> mandatory for all btrfs_bio allocations. The NULL check is redundant and
> can be removed.
> 
> Replace all calls to is_data_bbio() in bio.c
> 
> Link: https://lore.kernel.org/linux-btrfs/20251219084316.1164580-1-zhen.ni@easystack.cn
> Suggested-by: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
> Changes in v2:
> - Replace all calls to is_data_bbio() in bio.c

I haven't noticed you sent v2 with the requested changes, sorry. Now
added to for-next.

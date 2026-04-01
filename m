Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1A154774
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 00:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775002639; cv=none; b=CmHQQmMsyAPKxV3SDpVfqnM0bHlhZev8u2xOjgiiC6cvwke3HGV9zGtLqmvTxAVzP7CDgN1ty1CIqKoQG4qPQNVATLUlPQudLBl3UV54Uila995KDv1uSRBntjLHCqN7SZ3DZo4TfhFZBalyGOAcGhhaAolSHoYpfdgOsi22vDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775002639; c=relaxed/simple;
	bh=ZhKWfgU/YC01YMnvIXX0W+wl/BIAilEZ0cx6hosYZgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QtrH1LezC+0Nm94sAgrvFzHyt9P7XdDeKGlxwNxPgVtLdk5Bxtqj4Vm1vIhZHCtfAyjY3NmVBI/X8ySlS/PKVYeIyt+GxRYVcGEwydShG3LbxI//7O33VPKvKCG3+zfP/BaPmiLN2etZTLE+61I3lry/l4NU13nvGozDukPy2oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IXuf6CoL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mOnFznQX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IXuf6CoL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mOnFznQX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IXuf6CoL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mOnFznQX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IXuf6CoL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mOnFznQX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CC8FA4D2AD;
	Wed,  1 Apr 2026 00:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775002636;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P3ZQCLTxJ5PnbQOIlXwyLtwb0roi2wUYJiKV72Fn+e8=;
	b=IXuf6CoL2/f+KmwJEktFnymulmG6ZaPkYhUJe/p6jwBqD6I4z8M04m+UD5ledvF1AVXt5B
	TV8ha35yytoA8bhuLmThn4xQcsMivOZT0Jdm0Y1r1XKXhxkjhdlCFFU4lk8HZUYqTFo5Fr
	m6jLKHn9oNYvqNAlhBHQjJQWXxyfrKg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775002636;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P3ZQCLTxJ5PnbQOIlXwyLtwb0roi2wUYJiKV72Fn+e8=;
	b=mOnFznQX40XOKiACtXcCt+eqmeyUl3fIR0NqvZvm1e8jRVyx0rN7XRUpxZ6ex8iza+Oe9c
	u7ivJssHlyXM+CBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775002636;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P3ZQCLTxJ5PnbQOIlXwyLtwb0roi2wUYJiKV72Fn+e8=;
	b=IXuf6CoL2/f+KmwJEktFnymulmG6ZaPkYhUJe/p6jwBqD6I4z8M04m+UD5ledvF1AVXt5B
	TV8ha35yytoA8bhuLmThn4xQcsMivOZT0Jdm0Y1r1XKXhxkjhdlCFFU4lk8HZUYqTFo5Fr
	m6jLKHn9oNYvqNAlhBHQjJQWXxyfrKg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775002636;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P3ZQCLTxJ5PnbQOIlXwyLtwb0roi2wUYJiKV72Fn+e8=;
	b=mOnFznQX40XOKiACtXcCt+eqmeyUl3fIR0NqvZvm1e8jRVyx0rN7XRUpxZ6ex8iza+Oe9c
	u7ivJssHlyXM+CBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B1CD54A0B0;
	Wed,  1 Apr 2026 00:17:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NcOUKgxkzGkScAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 01 Apr 2026 00:17:16 +0000
Date: Wed, 1 Apr 2026 02:17:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Jaron =?iso-8859-1?Q?Vi=EBtor?= <jaron@vietors.com>
Subject: Re: [PATCH] btrfs: do not reject a valid running dev-replace
Message-ID: <20260401001711.GD5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <03c15f51597e61c4d669db55f5c627b3a3af9b20.1774998167.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03c15f51597e61c4d669db55f5c627b3a3af9b20.1774998167.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-8.00 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -8.00
X-Spam-Level: 

On Wed, Apr 01, 2026 at 09:32:57AM +1030, Qu Wenruo wrote:
> [BUG]
> There is a bug report that a btrfs with running dev-replace got rejected
> with the following messages:
> 
>  BTRFS error (device sdk1): devid 0 path /dev/sdk1 is registered but not found in chunk tree
>  BTRFS error (device sdk1): remove the above devices or use 'btrfs device scan --forget <dev>' to unregister them before mount
>  BTRFS error (device sdk1): open_ctree failed: -117
> 
> [CAUSE]
> The tree and super block dumps show the fs is completely sane, except
> one thing, there is no dev item for devid 0 in chunk tree.
> 
> However this is not a bug, as we do not insert dev item for devid 0 in
> the first place.
> Since the devid 0 is only there temporarily we do not really need to
> insert a dev item for it and then later remove it again.
> 
> It is the commit 34308187395f ("btrfs: add extra device item checks at
> mount") adding a overly strict check that triggers a false alert and
> rejected the valid filesystem.
> 
> [FIX]
> Add a special handling for devid 0, and doesn't require devid 0 to
> have a device item in chunk tree.
> 
> Reported-by: Jaron Viëtor <jaron@vietors.com>
> Link: https://lore.kernel.org/linux-btrfs/CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com/
> Fixes: 34308187395f ("btrfs: add extra device item checks at mount")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

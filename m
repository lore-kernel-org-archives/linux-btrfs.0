Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B76338238B
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 19:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107769; cv=none; b=Hyw8plXMqkY+40g/jyasSnYsTnlxxUWISRJRqsO7FEHtpD0i0wh4T8qeF+KypEqNchhEPlT67WECastewL43lSWlaeLsARdam84qshvZZucPmjz4IqnGVYBfELbKNaxtuJRhlCn0eyedjO5BYfTXeaTvpv1Mf/CMa/yL6IReTpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107769; c=relaxed/simple;
	bh=g6VK+tcLq5gseA1IGe1XRFBoz8lvwnjzi2kgBQhVyRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tEMbXQoyOYtCRdSqWVJQyvxQio+SMM89LoONOk0HQrozfUVhY9C5VgusDjQDR4WUnHKu7Rw8mG/ZxYqaIazKnxzlyyKRLoHjzkw5dGfpyxR7OtukB+uVRS8pLBqRJ0TtbPXEFzf3rmEQHMsVvqNvdbdmedT2omtJQN8NWCOsJUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Zy62Wbkw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=F5yiVL85; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=biYVOvRy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=q0Jav0Hl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Zy62Wbkw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="F5yiVL85";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="biYVOvRy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="q0Jav0Hl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 414285BDB9;
	Mon, 13 Apr 2026 19:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776107766;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GajDZedZDB94Sqnd/wsZiINU7ipRNuc+2YLbw0BDHGc=;
	b=Zy62WbkwEBJj5RQsXhncyO0ef5yTeOuCZ1xOAj7Nd6nNakGqFyHuzgNW/FbkUAwnZYojNi
	fLqhvzMFAk/twg0u6QeekmSI+DjJTNhuBQ5a6BIxZcLrAX90m48lhL64/W6csBn2juRE6Z
	9jM9YAprhSOmUzP/K/05Gs/XikO7w/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776107766;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GajDZedZDB94Sqnd/wsZiINU7ipRNuc+2YLbw0BDHGc=;
	b=F5yiVL85Gl+71+1FKYPyFy6BnCAd1ZXJgol5LK+x0calweu9ewpelkMfnkZSTGgiVvelkD
	lrXIfWdq5yu6CoDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=biYVOvRy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q0Jav0Hl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776107765;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GajDZedZDB94Sqnd/wsZiINU7ipRNuc+2YLbw0BDHGc=;
	b=biYVOvRy1SHOhVLiAn2rjJ/LFcyLyDuf4DjX1qT0WNSujA+HRFDglGwzFFNhXP7QjJQdmu
	xk9n8th0KcAPBnUrAOdFZOV3OWbMT4h0l2VmvTcu01SMl2otalPNsiaEumKLfIDCrKx2eD
	KgjNPXvWelv0+l3dkIREUU3zuoCz8k8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776107765;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GajDZedZDB94Sqnd/wsZiINU7ipRNuc+2YLbw0BDHGc=;
	b=q0Jav0HlCEWya5JwX5mNAqQfOwcxDcc1OjKkYGS9pEazGiJZqXgDWUlcm3F5Ll+fLVlGjV
	Z5/rUt97Gp0l+yBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 26B3C4B041;
	Mon, 13 Apr 2026 19:16:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KBLWCPVA3Wl9GAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Apr 2026 19:16:05 +0000
Date: Mon, 13 Apr 2026 21:16:03 +0200
From: David Sterba <dsterba@suse.cz>
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs: fix multiple bugs in raid-stripe-tree
 deletion path
Message-ID: <20260413191603.GJ12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260413065249.2320122-1-robbieko@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413065249.2320122-1-robbieko@synology.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: 414285BDB9
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Mon, Apr 13, 2026 at 02:52:31PM +0800, robbieko wrote:
> This series fixes six bugs in fs/btrfs/raid-stripe-tree.c, all within the
> stripe extent deletion and partial deletion code paths.
> 
> Patch 1 fixes btrfs_partially_delete_raid_extent() failing to copy the
> devid when rebuilding a truncated stripe extent, resulting in zeroed-out
> devids and corrupted stripe mappings.
> 
> Patch 2 fixes btrfs_delete_raid_extent() using offset=0 for the search
> key, which can miss entries when the target is the first item on a leaf.
> Changed to offset=(u64)-1 with proper boundary handling.
> 
> Patch 3 fixes btrfs_previous_item() being called with min_objectid=start,
> which prevents finding the preceding stripe extent whose objectid is less
> than start.
> 
> Patch 4 replaces an ASSERT(found_start <= start) with proper error
> handling that returns -ENOENT, avoiding kernel panics on unexpected
> B-tree states.
> 
> Patch 5 handles -EAGAIN from btrfs_duplicate_item() in the punch-a-hole
> case and refreshes the stale leaf pointer after a potential leaf split.
> 
> Patch 6 adds return value checking for all three call sites of
> btrfs_partially_delete_raid_extent() to avoid silently losing errors.

Thanks for the fixes. The cover letter does not need to mention each
patch and what it does if it's clear from the patch subjects or the
changelogs. The first paragraph would be enough, eventually you can
mention anything relevant for the series but not worth tracking in the
commit logs.

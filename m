Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793021690;
	b=yE4fuW8oyT1fLibgcEcqFcksWe+6L/YpB78/G3prQKoEN72rlS/m8vemxDnlCqCb7Gbw
	 Se3WXyL/azsPXGr/wDYZ+G1GeO7nv02CMhH4XgDHhGiKeOyRzbd4HTDgMQQa/4ZA9rAnU
	 Qmgra7qZmZCQF+Jze32pm+5ch/bDX2uGQyN0IlvmL0+gGNZtI0v7yVWjf7riLKBlDGvcW
	 sBZP6WoE/PteXZYXvZ5P23Xj9h7sPrOsG2J8SKbx2xClNa/iddNYWu9Yx6thVAPiE4S0s
	 xP7leZjSOOHONZQ0Ylirjv9m7YivwsJKp6R2WalvqxgPSN/4rg5+HstSXULdiDson8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793021690;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=4UlIvTTjkwmlBrzOjLPzKgJbLMN24EsBnbSBGjdQ+TE=;
	b=2VI7S75yrPWWolOXo3YtsWpn+inAdHCjWcGHeRm1/awmFw1/b1qmo/OjPcUPsiR70TpM
	 GE5byCsv+XT1ubAkJnj6urSy0LXwKjuSiT4Ga9m6k1B/In3g/NSl6geAl0j3VhXwbtf0+
	 AfljbQfwOTZlWBh3tDMptZnENDsAJxOtELMHJluh0ecb5EUZ6BiVVSyqOGnfMFXDZS7bj
	 zy1VLXDEFfU8n+iGHgps5QkOIKDlmEFKk0eGxDWg9ECyr8Hr8ashawXBQGTaneEvc4bdo
	 wCKma788Extoe/hK6RNsmv+IyaPrAcx94IaoKtFMWnBHI1/58VxPCEISnXc1Z3tPSvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=baI+UOMl;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7pHTPEqS;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=baI+UOMl;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7pHTPEqS;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B31606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 13:34:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6B31606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=baI+UOMl;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7pHTPEqS;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=baI+UOMl;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7pHTPEqS
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B845E1F7A1;
	Mon, 26 Oct 2026 13:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793021687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4UlIvTTjkwmlBrzOjLPzKgJbLMN24EsBnbSBGjdQ+TE=;
	b=baI+UOMlKVAy3SWCcAr98EiYZLZvmrWlccCTf02DOWVOrnJX/ISyma56FnRwTFbfuCon6h
	lx/tzrp4GMc1zXOWaDywKiyMLCCR7zodJecV0Zdvx82R9Dp0z4l82nnID/cBxa+Pz+Uq+c
	QMOerZp32U/ZYvdRD6F9awM2TMH6IuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793021687;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4UlIvTTjkwmlBrzOjLPzKgJbLMN24EsBnbSBGjdQ+TE=;
	b=7pHTPEqSTCXYGCNfP9M5J0/15pUqHHP0l/X4U8Nb4FAiZSRQLT/xF1CGaS5QDMbQNLb2u3
	QKVaoBXGziMD4sBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=baI+UOMl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7pHTPEqS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793021687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4UlIvTTjkwmlBrzOjLPzKgJbLMN24EsBnbSBGjdQ+TE=;
	b=baI+UOMlKVAy3SWCcAr98EiYZLZvmrWlccCTf02DOWVOrnJX/ISyma56FnRwTFbfuCon6h
	lx/tzrp4GMc1zXOWaDywKiyMLCCR7zodJecV0Zdvx82R9Dp0z4l82nnID/cBxa+Pz+Uq+c
	QMOerZp32U/ZYvdRD6F9awM2TMH6IuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793021687;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4UlIvTTjkwmlBrzOjLPzKgJbLMN24EsBnbSBGjdQ+TE=;
	b=7pHTPEqSTCXYGCNfP9M5J0/15pUqHHP0l/X4U8Nb4FAiZSRQLT/xF1CGaS5QDMbQNLb2u3
	QKVaoBXGziMD4sBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B7D3134EA;
	Mon, 26 Oct 2026 13:34:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G4pgF/dW32pJfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 26 Oct 2026 13:34:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0753BA1419; Mon, 26 Oct 2026 14:34:43 +0100 (CET)
Date: Mon, 26 Oct 2026 14:34:42 +0100
From: Jan Kara <jack@suse.cz>
To: Saleh Mammadof <salehmammadof@gmail.com>
Cc: linux-mm@kvack.org, jack@suse.cz, hch@lst.de, dhowells@redhat.com, 
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: filemap_invalidate_inode() - losing -EBUSY from
 invalidate_inode_pages2_range?
Message-ID: <o5sj6bswd6arkusrxj5w5ww3jwk5hz7ktzxvdik72h7c4uen5i@fnwkmk6hvuf5>
References: <CAKu0nJUGwnmuuT6fBz0phH=1Nyi6BguH2PHvs9+hDnrc_X0zWw@mail.gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKu0nJUGwnmuuT6fBz0phH=1Nyi6BguH2PHvs9+hDnrc_X0zWw@mail.gmail.com>
X-Rspamd-Queue-Id: B845E1F7A1
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUBJECT_ENDS_QUESTION(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.com:email]
X-Spam-Score: -12.01

Hi!

On Sun 25-10-26 02:27:13, Saleh Mammadof wrote:
> Been going through mm/filemap.c lately and something caught my eye in
> filemap_invalidate_inode(). It calls filemap_fdatawrite_range() (or
> the wbc variant) and then invalidate_inode_pages2_range(), but doesn't
> seem to check either return value directly - just falls through to
> filemap_check_errors() at the end.
> 
> The thing is, invalidate_inode_pages2_range() can return -EBUSY if a
> folio won't evict (release_folio failing, launder_folio erroring out,
> folio going dirty again mid-invalidation, etc), and filemap_check_errors()
> only looks at AS_ENOSPC/AS_EIO on the mapping. So that -EBUSY just...
> disappears?

Yes. Whether it matters or not depends on the caller I guess so you should
discuss with the users of filemap_invalidate_inode() what they'd like the
function to do. Adding btrfs people into the loop.

								Honza

> If I'm reading this right it could matter for callers that actually
> branch on the return value - btrfs reflink bails out on a negative
> return when clearing the destination cache, cifs sets
> CIFS_INO_INVALID_MAPPING again on failure, that kind of thing. If they
> get back 0 when a folio was actually left behind, they'd think the
> invalidation fully succeeded.
> 
> Could be I'm missing some other path that catches this, genuinely not
> sure. Haven't tried to reproduce it, just going off reading the code.
> Let me know if I'm off base here.
> 
> Saleh
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

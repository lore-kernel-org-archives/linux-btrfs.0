Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3061030DEA6
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 13:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777297826; cv=none; b=HYPS7LRzbVqakZHMi8iO7ZgkIjSTXheby70a8pz67cQN2161t1EcGYsQY9fcxq9DzpE2krpYIw6MJMJwCsq/FOyIeP2Ct0eZ1N8YA1AClpuMJOGcCQQKWcOUjBopeAsO72QyZjBdjxiz6YCBKPWX/2vjBifs+ghuvgXU2zW7kV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777297826; c=relaxed/simple;
	bh=cE8VMAqeOjeQvQXLodmUXA6wmXh+w1D80ewH1PLD1Vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJN7eLFDRLDCzHIu+voUfyeiL7yDHxIVXwKeWviaHbMpJtffXNucwZvG9bZ9TEYQyBE+b07Bpz75QVs8UAWSFxD//4AvUsOiNb1s7pbKfsud1StZXVWA1/apuZMyhQbBsoyMrpeYBi5nF21TkJeSpuasXeUiv8RrYViJ3O3cdhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0jBP2wXT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/MVS+BUQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0jBP2wXT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/MVS+BUQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0jBP2wXT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/MVS+BUQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0jBP2wXT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/MVS+BUQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7E8385BD22;
	Mon, 27 Apr 2026 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777297823;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HD8E079s5VQUGQSwp3s9LQ4w6J+BZkpDsf5WjA+BBA=;
	b=0jBP2wXTpVKieL/ai/KGc77fbk0V0ObrL3+fggoIM4fnETnLaFca13fkRslruPfthUfIH2
	ar/whcE1OMRhAj0CmdjYNiOeevAuVT8Igu6XfmmH7UCAfCuIFNXU2oADbPDiX5+mS9iQMG
	qRNdxvBhQZwwdLJqAn5hSO6yjSatQB8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777297823;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HD8E079s5VQUGQSwp3s9LQ4w6J+BZkpDsf5WjA+BBA=;
	b=/MVS+BUQG2DYxohqMchZpx5IO+0AfGVKF4j0fMdif0+kWRvsMpvadwl+GhiFNuQy8JVrmx
	2V058yD7psQN7MAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777297823;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HD8E079s5VQUGQSwp3s9LQ4w6J+BZkpDsf5WjA+BBA=;
	b=0jBP2wXTpVKieL/ai/KGc77fbk0V0ObrL3+fggoIM4fnETnLaFca13fkRslruPfthUfIH2
	ar/whcE1OMRhAj0CmdjYNiOeevAuVT8Igu6XfmmH7UCAfCuIFNXU2oADbPDiX5+mS9iQMG
	qRNdxvBhQZwwdLJqAn5hSO6yjSatQB8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777297823;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HD8E079s5VQUGQSwp3s9LQ4w6J+BZkpDsf5WjA+BBA=;
	b=/MVS+BUQG2DYxohqMchZpx5IO+0AfGVKF4j0fMdif0+kWRvsMpvadwl+GhiFNuQy8JVrmx
	2V058yD7psQN7MAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 598F4593B0;
	Mon, 27 Apr 2026 13:50:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I/ydFZ9p72nQbQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 27 Apr 2026 13:50:23 +0000
Date: Mon, 27 Apr 2026 15:50:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org,
	dsterba@suse.com, clm@fb.com, wqu@suse.co,
	linux-kernel@vger.kernel.org,
	syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.co,
	syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] btrfs: replace BUG_ON() with error return in
 get_new_location()
Message-ID: <20260427135014.GM12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260425061214.235982-1-27rabbitlt@gmail.com>
 <20260426201605.36626-1-27rabbitlt@gmail.com>
 <54f27c1a-eb99-43d0-bf57-9e99caf07cb5@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54f27c1a-eb99-43d0-bf57-9e99caf07cb5@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-2.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[3e20d8f3d41bac5dc9a2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,suse.com,fb.com,suse.co,syzkaller.appspotmail.co,syzkaller.appspotmail.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.50
X-Spam-Level: 

On Mon, Apr 27, 2026 at 10:49:26AM +0930, Qu Wenruo wrote:
> > @@ -835,10 +836,16 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
> >   	fi = btrfs_item_ptr(leaf, path->slots[0],
> >   			    struct btrfs_file_extent_item);
> >   
> > -	BUG_ON(btrfs_file_extent_offset(leaf, fi) ||
> > -	       btrfs_file_extent_compression(leaf, fi) ||
> > -	       btrfs_file_extent_encryption(leaf, fi) ||
> > -	       btrfs_file_extent_other_encoding(leaf, fi));
> > +	if (unlikely(btrfs_file_extent_offset(leaf, fi) ||
> > +		     btrfs_file_extent_compression(leaf, fi) ||
> > +		     btrfs_file_extent_encryption(leaf, fi) ||
> > +		     btrfs_file_extent_other_encoding(leaf, fi))) {
> > +		btrfs_print_leaf(leaf);
> > +		btrfs_err(fs_info,
> > +"unexpected non-zero fields in file extent item for data reloc inode %llu offset %llu (offset/compression/encryption/other_encoding must all be 0)",
> > +			  btrfs_ino(BTRFS_I(reloc_inode)), bytenr);
> > +		return -EUCLEAN;
> 
> This looks like exactly what we did in tree-checker.
> 
> And we have enough info to do this in tree-checker, the data reloc tree 
> has a fixed id and owner in extent buffer header.
> 
> What about moving this to tree-checker where we already have 
> check_extent_data_item().

I think it would be better in the tree-checker, as this verifies the
item as it's read and not after the relocatikon is started.

The BUG_ON can be turned to an assertion though it duplicates some of
the checks, but this is otherwise harmless and cheap.

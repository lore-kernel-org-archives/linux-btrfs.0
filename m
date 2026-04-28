Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7F83126A9
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 15:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777390170; cv=none; b=ZvhDGe/VayqrdEtRbJ6MP+toWmIwgHhZ1KuGQB2brYa+IZZ30B96u0X1NxrKoUZMydYYcksmA/XNbzs8x5coTaiwHSUcUwrFmqC6Kg+MX1UfPyINmEmd13QaHkzDksjF/nNyORCfRa9l/YHgo9jgVocHyx7h20L9+xeDqRsX358=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777390170; c=relaxed/simple;
	bh=VF2LNSiZRJD6gTtVCugwOA6c9s5qjWe8n/lBu1fY1Zg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTbFKDi/LHrEkT51BYzuXEtioIWSVJtUMuSG4mL6g1dpWirYZBgUzH2U/h3LgyCI2IOyo/XIJz42h1v8UKtlU8EOGBuSKV13dnC6sAOkckXS1L5VvJSI3r7WA1lquqDJnx0XXRj38vliQFRIAVgTq4xL6JWBq8cV3BVKaMGkWsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p15/ei1d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MZLtkPOy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p15/ei1d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MZLtkPOy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p15/ei1d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MZLtkPOy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p15/ei1d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MZLtkPOy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 771315BD4E;
	Tue, 28 Apr 2026 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777390167;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5HsCg4xwWA4bZlO9jpHa3jCP+F2N/lXL475gQKTzGjM=;
	b=p15/ei1diWlppLjjm9CdUlVXX1S90Bbun7uGPzY7RclapT0aKkkzGesD0L2bEt57V4W9nc
	GYsxCa4leADFKTn7jqbG/vp5N4A/x/wQmjMXSD9AIJ2HyHYtL3KwV3GcFMol/AOxsjOx2y
	x4wTp87JZPLH4KsiLVFfPeZ7vPPSfAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777390167;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5HsCg4xwWA4bZlO9jpHa3jCP+F2N/lXL475gQKTzGjM=;
	b=MZLtkPOyZCiIUrIVdDSc97LBwHoIcB+QuWeizQwoZVwoTomISNFUNQDFeG9z6wQQOD87Cu
	mgOQA+NDtSpeIWDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777390167;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5HsCg4xwWA4bZlO9jpHa3jCP+F2N/lXL475gQKTzGjM=;
	b=p15/ei1diWlppLjjm9CdUlVXX1S90Bbun7uGPzY7RclapT0aKkkzGesD0L2bEt57V4W9nc
	GYsxCa4leADFKTn7jqbG/vp5N4A/x/wQmjMXSD9AIJ2HyHYtL3KwV3GcFMol/AOxsjOx2y
	x4wTp87JZPLH4KsiLVFfPeZ7vPPSfAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777390167;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5HsCg4xwWA4bZlO9jpHa3jCP+F2N/lXL475gQKTzGjM=;
	b=MZLtkPOyZCiIUrIVdDSc97LBwHoIcB+QuWeizQwoZVwoTomISNFUNQDFeG9z6wQQOD87Cu
	mgOQA+NDtSpeIWDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48AE4593B0;
	Tue, 28 Apr 2026 15:29:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QmOHEFfS8GmmZwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 28 Apr 2026 15:29:27 +0000
Date: Tue, 28 Apr 2026 17:29:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org,
	dsterba@suse.com, clm@fb.com, linux-kernel@vger.kernel.org,
	syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] btrfs: validate data reloc tree file extent item
 members in tree-checker
Message-ID: <20260428152922.GH3906171@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260426201605.36626-1-27rabbitlt@gmail.com>
 <20260427202822.278326-1-27rabbitlt@gmail.com>
 <aeb71a41-2727-472d-a869-20ca9bd2b005@suse.com>
 <4fed7e18-4bc7-43a5-8438-62bff279fbe7@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fed7e18-4bc7-43a5-8438-62bff279fbe7@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -2.50
X-Spam-Level: 
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
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,suse.com,fb.com,syzkaller.appspotmail.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Tue, Apr 28, 2026 at 10:14:40AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/4/28 07:45, Qu Wenruo 写道:
> > 
> > 
> > 在 2026/4/28 05:54, Teng Liu 写道:
> >> get_new_location() uses BUG_ON() to crash the kernel if the file extent
> >> item it looks up has any of offset, compression, encryption, or
> >> other_encoding set. The data reloc inode is only written by relocation's
> >> own paths -- insert_prealloc_file_extent() and
> >> insert_ordered_extent_file_extent() -- which always leave those four
> >> fields at 0 (the data reloc inode is created with BTRFS_INODE_NOCOMPRESS,
> >> and encryption/other_encoding are reserved-and-zero). Observing a
> >> non-zero value therefore means the leaf decoded from disk does not match
> >> what the kernel wrote, i.e. on-disk corruption. A malformed image can
> >> reach this code via balance and panic the kernel.
> >>
> >> Move the validation into tree-checker's check_extent_data_item(), where
> >> the constraint is enforced when the leaf is read off disk rather than
> >> after relocation has already started. The data reloc tree has a fixed
> >> root id (BTRFS_DATA_RELOC_TREE_OBJECTID) recorded in the extent buffer
> >> header, so check_extent_data_item() has all the information it needs to
> >> apply this check on its own. Report violations via file_extent_err() and
> >> print the four offending values.
> >>
> >> In get_new_location() replace the BUG_ON() with an ASSERT().
> >> The caller in replace_file_extents() already handles non-zero returns 
> >> from
> >> get_new_location() by breaking out of the loop without aborting the
> >> transaction, so no caller changes are needed.
> >>
> >> Suggested-by: Qu Wenruo <wqu@suse.com>
> >> Suggested-by: David Sterba <dsterba@suse.com>
> >> Reported-by: syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
> >> Closes: https://syzkaller.appspot.com/bug?extid=3e20d8f3d41bac5dc9a2
> >> Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
> > 
> > Reviewed-by: Qu Wenruo <wqu@suse.com>
> > 
> > And merged.
> 
> Unfortunately this tree-checker got triggered during btrfs/061 runs at 
> write-time tree-checker, with arm64 64K page size.
> 
> The offending file extent is as the following:
> 
> [  536.885066] 	item 69 key (258 EXTENT_DATA 4063232) itemoff 12400 
> itemsize 53
> [  536.885067] 		generation 28 type 1
> [  536.885067] 		extent data disk bytenr 10512723968 nr 36864
> [  536.885068] 		extent data offset 24576 nr 12288 ram 36864
> [  536.885069] 		extent compression 0
> 
> Note the offset is not zero, and the type is 1 which means it's a 
> regular file extent.
> 
> So the check is causing false alerts.

I maybe have an idea.  The difference from the BUG_ON and the
tree-checker is the context where it's called. In relocation it's
somewere in the middle and there are actions fixing up the offset. OTOH
when this is done in tree-checker the constraints are different.

  get_new_location() - verifies offset, compression, ...

The offset corresponds to 'bytenr' and is returned via *new_bytenr to
replace_file_extents() and then updated in the leaf

  btrfs_set_file_extent_disk_bytenr(leaf, fi, new_bytenr);

This eventually ends up in in the pre-write check.

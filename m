Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C9A2F7EE9
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 18:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779907834; cv=none; b=nocZ8S02L1p62NEAEPEc9Vm6/5cH3luccov9yAqA/Ood9yIbEBgJ2tJeMdVOJ+BjpJ430wOyEtk1w9+rxDCm9oAGkPHuhEzIz+A6RYPmor4dOHnXDWW6sZXXelbaNTBUqtIq9De3tfVSwW5VWOvSoLA+3GjtCBLBXM2qESDGkHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779907834; c=relaxed/simple;
	bh=qUIwgFLLBdVU2uhekTFMiZ/8vh0M5zSJerkjHXKnLSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wa1qaHCgAFMfqBKfX8Yeg0skT6/4LRoCwS0cCok7frqPmy/G10uMcidI+eRQPiKUeTtEJzRhhQPMY4xHLeEfR/rVLYiOCFDXR7CeKD9X+Udnx6Y+I5uInRnaH8lyLXDj9Ochvb9ngRDd5KZAT6Wi0l7o/riMTx2/hG/0TkCAKVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0q0nMsc/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iCoFwUU6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vA0u+yGU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cuRFKpkv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0q0nMsc/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iCoFwUU6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vA0u+yGU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cuRFKpkv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D6D856AD4E;
	Wed, 27 May 2026 18:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779907831;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xJkd7CdGShlqnkt04nVSHYIKXoNQf7Z05+0TxdpP/DQ=;
	b=0q0nMsc/fgcCj5HN97LxZ18nIY1hTxTXityn2vTl7hVCMjgK/Vc897+53StJ/reRKKSc+l
	Fi6Hto6cL/cHHJ4uC189tPmn4p9a+Xw2wBz/YEYu5dfSVWA4otOQTAwOKAns6fdsY3PlA8
	MtRB+5Fzd9LvWxnTwc5AwPnAsG9q8EQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779907831;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xJkd7CdGShlqnkt04nVSHYIKXoNQf7Z05+0TxdpP/DQ=;
	b=iCoFwUU6TQA8shK3a3Lk8jo78Y1VRbIyJERsfNCuO6+g/xy742E2m7eUeQCwqJSbvmMHSO
	RwyzBNa/t2uH2sAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vA0u+yGU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cuRFKpkv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779907830;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xJkd7CdGShlqnkt04nVSHYIKXoNQf7Z05+0TxdpP/DQ=;
	b=vA0u+yGUdvt6NAIx6nWc1DzHtLytBkXqvvW0ck5IK8cKhQPxDq6SVivjnraeKCvLK2iFBY
	hQ1CLkt/Q4PCt46hECRFMwciOS41APH1wYBDXwT0sRd4CQjjjU/nd7rIy8Q7wQY6TVvfrS
	2HhMw6gaV8Ws/wUaZbS6Chcaq6HIK64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779907830;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xJkd7CdGShlqnkt04nVSHYIKXoNQf7Z05+0TxdpP/DQ=;
	b=cuRFKpkvVnHoNM3CoykJCDLrLTiq86ZD6JCQ0musyEy2SFZWih4OyFIEp/QXLqUpqoy2gJ
	n352MGSNSDpSzJBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BEB7A5A988;
	Wed, 27 May 2026 18:50:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XnpRLvY8F2q4agAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 27 May 2026 18:50:30 +0000
Date: Wed, 27 May 2026 20:50:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use shifts for sectorsize and nodesize
Message-ID: <20260527185029.GC880787@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260527111652.944584-1-dsterba@suse.com>
 <20260527160409.GC1981571@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527160409.GC1981571@zen.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D6D856AD4E
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Wed, May 27, 2026 at 09:04:09AM -0700, Boris Burkov wrote:
> > --- a/fs/btrfs/relocation.c
> > +++ b/fs/btrfs/relocation.c
> > @@ -1560,7 +1560,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
> >  	 * and * 2 since we have two trees to COW.
> >  	 */
> >  	reserve_level = max_t(int, 1, btrfs_root_level(root_item));
> > -	min_reserved = fs_info->nodesize * reserve_level * 2;
> > +	min_reserved = (reserve_level << fs_info->nodesize_bits) * 2;
> 
> Is it nicer to just add 1 to the shift operand?

There's fragment of the comment in the diff context, in full

        /*
         * In merge_reloc_root(), we modify the upper level pointer to swap the
         * tree blocks between reloc tree and subvolume tree.  Thus for tree
         * block COW, we COW at most from level 1 to root level for each tree.
         *
         * Thus the needed metadata size is at most root_level * nodesize,
         * and * 2 since we have two trees to COW.
         */

so the "* 2" matches it.

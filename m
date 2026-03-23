Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7237B37F000
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 17:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774287232; cv=none; b=l1bPQ9DBE/HzwCjPYm1jK+SN/N8jAdREoou+TE1MnQ+gnqGvf6wCyVsJLwi1ieGMDhtOMU8+iOMCq8d2AX86qg5rfHD3AH6AdfbNy/6XWab//dLrCsPFABnv5pyxMHQ7ZDwd81lNEAtEgu/snwAexNVa1dhbX6fGM6wvUr/sGu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774287232; c=relaxed/simple;
	bh=tKSfz7JU//9G3EpPknsJjpFvLCRDRjafkCnH8BEJE4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=scBubjS4B2+4b3OSjNsLW9jBcycL+NQDQ0LIKoUHnnDpB8o6ofdcKS/q4te3fms3SPm/8NjieUanCsdwtq3MkunjIz/8xeizzyudEaVhzXB9f1QKyQzeOL1fK06mbOQnHhxTcsTE4tcOdaleeKvb8t81bGfwSIog9lcmEGGafWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ocJyBLlF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CzSigA57; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ocJyBLlF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CzSigA57; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ocJyBLlF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CzSigA57";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ocJyBLlF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CzSigA57"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C460B5BE3E;
	Mon, 23 Mar 2026 17:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774287229;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/8Fx1DqGDMYjlZTrCj0cwWt13xKtJ1CVN27uToE5Pw0=;
	b=ocJyBLlFxUnzpJdpc9TVDDdXcj7FlRS+thI9ThOjgumIPtAjkFVkVJe3uiRmqwfi42E63c
	DGX1b67xGcm0PJ3yUwcpxAl6vjK+Dj/hQX+yl8lI5iLtGtEvKw359/WFLCrtqDmgRDRP9v
	4nCIcbZVV0YCpXSCcbffMgIYzAPOJ1o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774287229;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/8Fx1DqGDMYjlZTrCj0cwWt13xKtJ1CVN27uToE5Pw0=;
	b=CzSigA57A3gPQ/A+jkzsWBK+upMafEZ0PLdGHTY/SIpmx98hl6C6M3Ys+i5P86LJtDXR0L
	wEnWZRBe3yMMVvCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774287229;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/8Fx1DqGDMYjlZTrCj0cwWt13xKtJ1CVN27uToE5Pw0=;
	b=ocJyBLlFxUnzpJdpc9TVDDdXcj7FlRS+thI9ThOjgumIPtAjkFVkVJe3uiRmqwfi42E63c
	DGX1b67xGcm0PJ3yUwcpxAl6vjK+Dj/hQX+yl8lI5iLtGtEvKw359/WFLCrtqDmgRDRP9v
	4nCIcbZVV0YCpXSCcbffMgIYzAPOJ1o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774287229;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/8Fx1DqGDMYjlZTrCj0cwWt13xKtJ1CVN27uToE5Pw0=;
	b=CzSigA57A3gPQ/A+jkzsWBK+upMafEZ0PLdGHTY/SIpmx98hl6C6M3Ys+i5P86LJtDXR0L
	wEnWZRBe3yMMVvCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A0502439C2;
	Mon, 23 Mar 2026 17:33:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id thfuJn15wWkwYwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 17:33:49 +0000
Date: Mon, 23 Mar 2026 18:33:40 +0100
From: David Sterba <dsterba@suse.cz>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: dsterba@suse.com, clm@fb.com, idryomov@gmail.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH v2 0/3] btrfs: fix balance NULL derefs and chunk/bg
 mapping verification
Message-ID: <20260323173340.GM5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260314123741.1439792-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314123741.1439792-1-gality369@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,fb.com,gmail.com,vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Sat, Mar 14, 2026 at 08:37:38PM +0800, ZhengYuan Huang wrote:
> This series fixes two NULL dereferences in btrfs balance usage filters and
> the underlying mount-time verification bug that lets the corresponding
> chunk/block-group inconsistency go undetected.
> 
> The balance crashes happen when metadata corruption leaves a chunk present
> in the chunk tree but without a corresponding block group in the in-memory
> block group cache. In that case, the usage filters call
> btrfs_lookup_block_group() and dereference the returned pointer without
> checking for NULL.
> 
> The first two patches add the missing NULL checks and propagate -EUCLEAN
> back to userspace instead of crashing. They are split because the usage
> and usage-range filters were introduced by different commits, which should
> also make backporting easier, as suggested by Qu Wenruo.
> 
> The third patch fixes the root cause on the mount-time verification side.
> check_chunk_block_group_mappings() is supposed to verify that every chunk
> has a matching block group, but its current iteration starts with
> btrfs_find_chunk_map(fs_info, 0, 1). If no chunk contains logical address
> 0, the lookup returns NULL immediately and the loop exits without checking
> any chunk at all. As a result, the corrupted mapping can survive mount and
> only crash later when balance reaches it.
> 
> This series makes btrfs reject the inconsistency earlier at mount time,
> and also hardens the balance filters so the corruption is reported as
> -EUCLEAN instead of triggering a NULL dereference.

As I understand it you're using some advanced fuzzing tool (patch 1
mentions runtime fuzzing), so the errors would not normally happen. With
fuzzing it depends on the capabilities, at runtime it is possible to
confuse the filesystem so much that sipmle checks can't detect it.

Here checking if block group lookups are ok makes sense in general.
There are existing checks that seem to be following the same logic like
in unpin_extent_range().

> 
> Changes since v1:
> - split the two balance filter fixes into separate patches
> - reworked the third patch to fix the case where
>   check_chunk_block_group_mappings() does not actually check all chunk
>   mappings
> 
> [NOTE]
> Some of the changelogs may repeat parts of the bug analysis, which can
> make the series somewhat verbose. I did that intentionally because I was
> trying to follow the usual expectation that each patch should be able to
> stand on its own and explain the specific issue it fixes.

This is good, thanks. For simple fixes or cleanups it's fine to
make a vague reference to the main patch or a "in the previous/followup
patches".

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3741E35979
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2026 04:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776745280; cv=none; b=CJONK+MiExCcIBTHAim7YJcYWd9Gbavfccq702xgUzMwT1WsTPf5mfsWvCa6AiAJBvt3z77tluYdDOWGy43sBPlt3UUH5ooPt1EAmsKfSAErzvqPfBwUsAfIvAeEpHH8+CuIgb+CBgmYPwbj9vOLPFquhie2YI3cUzQq23r93bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776745280; c=relaxed/simple;
	bh=pcYKdvHLiiNWnY+2ZHWpRUJkvnF2qc8cTn5w01b56Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgadL9NDYh542oXVn5D3AS0RxCfJUvBPCTWT8NKazWDecWxjkw5vozHQX0ZhYL5J9GqPKowRt7CErrwVIwDje3CRzmaCQndNAQ/AC4Lt9ECuPFvRqjga+Lu7/QM1dKxLXLa9q2w0PW7r5bBddfZ87xHnT4VQLKXUavS/tJVKq/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wIr0kl8o; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5rQEx6+I; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wIr0kl8o; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5rQEx6+I; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wIr0kl8o";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5rQEx6+I";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wIr0kl8o";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5rQEx6+I"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7A5526A7ED;
	Tue, 21 Apr 2026 04:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776745277;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wlkHHta1yfNch7h6EMkjv2LbGKFjaRgVaeuoyuxUtIc=;
	b=wIr0kl8oDVv1TlEa6+izTCY7c3/ynKjkhiwAdcHYVhDQriJLqKyw4+QYp3FjFEHaeBkxx5
	wugdZCncKQz26zAzS455rwUmAuuXIAOJZvzD4EBp4Jak2cxRhLVk45VbaydxgdyKGtIPsv
	0itL1kBr/AlmKzNFccw6/SAhxbRk3n4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776745277;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wlkHHta1yfNch7h6EMkjv2LbGKFjaRgVaeuoyuxUtIc=;
	b=5rQEx6+Irs3rnpt+qNdln81LHp7xZGhEb9BH5+4yp11wjuCo8WL5wal3/9m63B1d/ikEpI
	g5FbsS1PJc0LnvDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776745277;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wlkHHta1yfNch7h6EMkjv2LbGKFjaRgVaeuoyuxUtIc=;
	b=wIr0kl8oDVv1TlEa6+izTCY7c3/ynKjkhiwAdcHYVhDQriJLqKyw4+QYp3FjFEHaeBkxx5
	wugdZCncKQz26zAzS455rwUmAuuXIAOJZvzD4EBp4Jak2cxRhLVk45VbaydxgdyKGtIPsv
	0itL1kBr/AlmKzNFccw6/SAhxbRk3n4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776745277;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wlkHHta1yfNch7h6EMkjv2LbGKFjaRgVaeuoyuxUtIc=;
	b=5rQEx6+Irs3rnpt+qNdln81LHp7xZGhEb9BH5+4yp11wjuCo8WL5wal3/9m63B1d/ikEpI
	g5FbsS1PJc0LnvDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5AD48593AF;
	Tue, 21 Apr 2026 04:21:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uin7FT375mmvdgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 21 Apr 2026 04:21:17 +0000
Date: Tue, 21 Apr 2026 06:21:08 +0200
From: David Sterba <dsterba@suse.cz>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: dsterba@suse.com, clm@fb.com, idryomov@gmail.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH v3 0/4] btrfs: fix balance NULL derefs and chunk/bg
 mapping verification
Message-ID: <20260421042108.GF12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260325004339.2323838-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325004339.2323838-1-gality369@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,fb.com,gmail.com,vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Mar 25, 2026 at 08:43:35AM +0800, ZhengYuan Huang wrote:
> This series fixes three NULL dereferences in btrfs balance paths and the
> underlying mount-time verification bug that lets the corresponding
> chunk/block-group inconsistency go undetected.
> 
> The balance crashes happen when metadata corruption leaves a chunk present
> in the chunk tree but without a corresponding block group in the in-memory
> block group cache. In that case, balance reaches code paths that call
> btrfs_lookup_block_group() and dereference the returned pointer without
> checking for NULL.
> 
> The first three patches harden the affected balance paths:
> - patch 1 fixes chunk_usage_filter()
> - patch 2 fixes chunk_usage_range_filter()
> - patch 3 fixes btrfs_may_alloc_data_chunk()
> 
> They are kept separate because the affected code was introduced by
> different commits, which should also make backporting easier, as
> suggested by Qu Wenruo.
> 
> The fourth patch fixes the mount-time verification side. Based on David
> Sterba's feedback, it now explicitly relies on the mount-time context and
> uses a lockless traversal of mapping_tree. check_chunk_block_group_mappings()
> is supposed to verify that every chunk has a matching block group, but its
> current iteration starts with btrfs_find_chunk_map(fs_info, 0, 1). If no
> chunk contains logical address 0, the lookup returns NULL immediately and
> the loop exits without checking any chunk at all. As a result, the
> corrupted mapping can survive mount and only crash later when balance
> reaches it.
> 
> This series makes btrfs reject the inconsistency earlier at mount time,
> and also hardens the balance paths so the corruption is reported as
> -EUCLEAN instead of triggering NULL dereferences.
> 
> [CHANGELOG]
> v3:
> - added a new patch to fix the same missing-block-group NULL dereference
>   in btrfs_may_alloc_data_chunk()
> - patch 1 and 2:
>   - changed the bool return flow to explicit int error propagation
>   - used ret2 for the nested filter return value in should_balance_chunk()
> - patch 4:
>   - reworked the changelog based on David Sterba's feedback
>   - clarified the mount-time context for the lockless mapping_tree traversal

Thanks for the v3 update, I've added the fixes to for-next. I've edited
the changelogs a bit in places where the explanations felt stating the
obvious, but otherwise the problem descrtiptions were good.

Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7163B19D1
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 15:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782315335; cv=none; b=lLDdfqpcDGv0beXz7nWfKYUwPS19gXw77aJ+GQ2lGefr5XRQRCPvmsLYHutqQ1ZmPV70TqPAWG4g0ZxLudTe2hR4gVq3bBDP10IVxY5c2im30hTlKe5uIF2KMBXF5mQ83JiMDOGkaU9TQNKr7dy39ltaWiFd5PpUYKW595hWogs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782315335; c=relaxed/simple;
	bh=uCVYAvot4MZf3+dFwBs1E3N/KfjPmGdLkhuXLsI5jes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q9l4/fphoRrMS34eEQJ5KYKyqUq3iKGlUnqPW95XhvmSYAan26H9kvPA66PsWwGlJotjezsKgsppUzFLv4j6LRxiDYevn8hhOPQsZrEtezldZOVz77vzoUJLRkNsUdZcEFg0pFFo7zdib3bLo7DVF6Y6BOsTPz7djfZ5LavZKkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xDpf6NeG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bD4pgStI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=D/mD1mBk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=T2xkv1Px; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xDpf6NeG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bD4pgStI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="D/mD1mBk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="T2xkv1Px"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F236375F37;
	Wed, 24 Jun 2026 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782315332;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=udREYRx4M5uYeIQo6d9UVQsR5jp8kYPf4qli6U4L4LU=;
	b=xDpf6NeGv0WgFTBe99o3NGWng6nV4Qq7zO5GCfs0GIH+pnneMIa4C+cBBdBFv+ZD0hUcE8
	g2tUaw6ECqIP9XI75b+sQ/npSJzWQZwYCJqRO1TB/8uI0f8XLclQk1+f43+INYYm78eu2+
	2BhtmwbypJh3RK13ilpNoWDzjqf6mUs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782315332;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=udREYRx4M5uYeIQo6d9UVQsR5jp8kYPf4qli6U4L4LU=;
	b=bD4pgStIvHViw5PI/QzHedBRxFEKSTgusXUHxYI8qab6k4Pv/gldLVEayCJEYXe9ldfQAW
	NdKAuquzIuZXKqDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782315331;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=udREYRx4M5uYeIQo6d9UVQsR5jp8kYPf4qli6U4L4LU=;
	b=D/mD1mBkrfMX9yY8b+hUFblS0YFZzZFZpJqF+bDW/fcz9WAapkkQMRlDJGqUpQBnDmi13x
	Y2Qv3uR1x5jiCXn78oi86U7R9Xdp3HeeTNO0c/WXlFALMyrrnxgyXFY2sjH+A+MfRvGY7K
	PEQh1UZCDDleOOlVHzxkd47XlxAtFiU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782315331;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=udREYRx4M5uYeIQo6d9UVQsR5jp8kYPf4qli6U4L4LU=;
	b=T2xkv1PxEbfNtmtS0hlsbWJNOfsFfLYImoqUKRN1UGMZwai8UD/CyIG3yra5eoFCKSejDu
	SCOMALj+3cZ9+zAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA902779A8;
	Wed, 24 Jun 2026 15:35:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rvkYNUP5O2qBBgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 24 Jun 2026 15:35:31 +0000
Date: Wed, 24 Jun 2026 17:35:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Sun YangKai <sunk67188@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: uapi: fix stale BTRFS_SYSTEM_CHUNK_ARRAY_SIZE
 comment
Message-ID: <20260624153530.GC150664@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260624070806.4534-1-sunk67188@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260624070806.4534-1-sunk67188@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,twin.jikos.cz:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Wed, Jun 24, 2026 at 03:08:01PM +0800, Sun YangKai wrote:
> The comment claims room for "14 chunks with 3 stripes each", which
> was correct when the structs were smaller.  Since then three additions
> grew each entry:
> 
>   commit e17cade25ff8 ("Btrfs: Add chunk uuids and update multi-device back references")
>     added btrfs_chunk.length (+8) and stripe.dev_uuid (+16)
> 
>   commit 321aecc65671 ("Btrfs: Add RAID10 support")
>     added btrfs_chunk.sub_stripes (+2)
> 
> A 3-stripe entry now takes:
> 
>   sizeof(btrfs_disk_key) + btrfs_chunk_item_size(3)
>     = 17 + 80 + 32 * (3 - 1)
>     = 161 bytes
> 
> 2048 / 161 ≈ 12.7, so "14" is no longer achievable.  Update to 12
> and add the explicit calculation so it does not rot again.
> 
> Signed-off-by: Sun YangKai <sunk67188@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -504,7 +504,11 @@ struct btrfs_header {
>  
>  /*
>   * This is a very generous portion of the super block, giving us room to
> - * translate 14 chunks with 3 stripes each.
> + * translate 12 chunks with 3 stripes each.
> + *
> + * Each entry takes sizeof(btrfs_disk_key) + btrfs_chunk_item_size(n),
> + * which for a 3-stripe chunk is 17 + 80 + 32 * (3 - 1) = 161 bytes.
> + * 2048 / 161 ≈ 12.7, so at most 12 entries fit.

Nice, thanks.

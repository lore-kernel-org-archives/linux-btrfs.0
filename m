Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7D038330E
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 13:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779714820; cv=none; b=nZeHCZzWLaa6A5rJlZ6ANbyVmCP9rm66CWoVgX5tr1v+1BrOWQSK+H3lrmZFFoWbvhbMaF85XJ+wW/gAVQGzzkdEhOtOn4XH/zgC/VNiHFJlzFPhn+K9QibML4Hc7hMhU4IbtAKbzf3+4RTqNQ2rkFH26mIeenMk1d2vLR7H6ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779714820; c=relaxed/simple;
	bh=C00j6TdLnFPwkJwFgPFJ85zCrXzw8ppIcJ0ZfxTZwOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWPP/JMypteZ1TRo/BHjHtQTXSGPDrTY02UpkkVzL5FBO4FGXWPQF8ynTEj6nIo5BuZTcLxu3inkQWoaazr+PbXfbWHQwc7+uT2v1ziOO8nFJ/By1wKWyXQRaUpt+mj7pmWMfM0U9KihYccGMNzcoXJJ6bb6YztR2Qo9e6WZans=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J58sWZqk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QLTbu2T+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J58sWZqk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QLTbu2T+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J58sWZqk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QLTbu2T+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J58sWZqk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QLTbu2T+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1259167B2B;
	Mon, 25 May 2026 13:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779714817;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y62scvcJHXE+i/StosY25uI08rn72nU0gC/V0cuMyOM=;
	b=J58sWZqkRhUIa5dnh8jXYRfi/XiI+IiLEzio/yTkO3xqh5tIRVSR6ilZcYOLXzMaaypWQv
	VHw3OdiY3AuF9/nQM2QXorSaBKmTNGSiM+Qu6fpo/66wVMmsDeQYcYeGNVVtpONToZ+z1w
	j0Y5z1TlhzkEYjtRj6iOunp1g/tORoA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779714817;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y62scvcJHXE+i/StosY25uI08rn72nU0gC/V0cuMyOM=;
	b=QLTbu2T+yNK3uNTWC66wY2TqiKVhjBDDy26oieeua7Tneefr21QrugaTYtKObz2TIs3H3u
	6IoPF4Ypi8o2OEBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779714817;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y62scvcJHXE+i/StosY25uI08rn72nU0gC/V0cuMyOM=;
	b=J58sWZqkRhUIa5dnh8jXYRfi/XiI+IiLEzio/yTkO3xqh5tIRVSR6ilZcYOLXzMaaypWQv
	VHw3OdiY3AuF9/nQM2QXorSaBKmTNGSiM+Qu6fpo/66wVMmsDeQYcYeGNVVtpONToZ+z1w
	j0Y5z1TlhzkEYjtRj6iOunp1g/tORoA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779714817;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y62scvcJHXE+i/StosY25uI08rn72nU0gC/V0cuMyOM=;
	b=QLTbu2T+yNK3uNTWC66wY2TqiKVhjBDDy26oieeua7Tneefr21QrugaTYtKObz2TIs3H3u
	6IoPF4Ypi8o2OEBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E553A59C6C;
	Mon, 25 May 2026 13:13:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JXF/NgBLFGo7ZgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 13:13:36 +0000
Date: Mon, 25 May 2026 15:13:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
Subject: Re: [PATCH] btrfs: annotate lockless read of defrag_bytes in
 should_nocow()
Message-ID: <20260525131331.GD12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260401022153.743576-1-zzzccc427@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401022153.743576-1-zzzccc427@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[fb.com,suse.com,vger.kernel.org,gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On Wed, Apr 01, 2026 at 10:21:53AM +0800, Cen Zhang wrote:
> should_nocow() reads inode->defrag_bytes without holding inode->lock,
> while btrfs_set_delalloc_extent() and btrfs_clear_delalloc_extent()
> update it under that spinlock.
> 
> This is a data race.  The read is a quick check used to decide whether
> to fall back to COW for a NOCOW inode: if defrag_bytes is non-zero and
> the range is tagged EXTENT_DEFRAG, we force COW so that defragmentation
> can rewrite the extent.  Reading a stale value is harmless because:
> 
>   - A missed increment may skip COW once, but the defrag pass will
>     redo the extent later.
>   - A stale non-zero may force an unnecessary COW, which is a minor
>     efficiency loss, not a correctness issue.
> 
> On 64-bit platforms an aligned u64 load is naturally atomic so tearing
> cannot happen.  On 32-bit platforms u64 may tear, but we only test for
> zero vs non-zero, so the heuristic stays correct regardless.
> 
> Add READ_ONCE() to prevent the compiler from caching or splitting the
> load and to document the intentional lock-free pattern.
> 
> Fixes: 47059d930f0e ("Btrfs: make defragment work with nodatacow option")
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Added to for-next, with the data_race() annotation. Thanks.

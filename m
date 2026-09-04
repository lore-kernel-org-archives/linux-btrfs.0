Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F9A48CD53
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788540941; cv=none; b=OBKXa1yK4GGQJbO2qMjZzin3iEYgU6Cq3JPv0kboVV5nDLhZV7ZnEtpjdDTCMLjS8Epzhr8L/XbFhYDckeWQbhQhtHUy53OIngSY/7MC9j7HiCQfoUR75zdsfHO94aqfz1Em6ogFMUdcAjETCuqL6pYRv1Y+Rn1QPvShVtqHv7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788540941; c=relaxed/simple;
	bh=0qLGXXQ/qlZaJsq4i5/ZCKpUolN8/NbVi4yL/6tOO3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCSRqpOtBGJmvmNEqgfa643XU639biIfkXeaUuWlQc2cQE+B914I8RXThfSm1STeTERylXm6cXVbdQVp9i5nIi+NVZzKkPlfc5KpIEULKlwaU4oKJHqIlcOlcgU8T9RDDmdJw+n4/QvKCv1btgQzn6ThIBYP/STHQgo4AP5L4MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z6bYv8Dq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dZlyDeXS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qPhTfjrm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2C7xshZN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z6bYv8Dq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dZlyDeXS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qPhTfjrm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2C7xshZN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CC96322A8E;
	Fri,  4 Sep 2026 16:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788540934;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WPRsvSqNMVoTy54dMqYT8iKlw6snkh8bOJXtr0xce0s=;
	b=z6bYv8Dq5ukkG9ykcqh/DTBcWx286vSAuNZ1LBXce1X2ZrAj3dDUn0ehECIFyE4ASZzUIc
	re/6Bhnel8OYd2CU3pQo5YJCtsWZwSAxFdStnXZr6IMvAbdwCM/+t88gwT0LDuhu8mshUC
	gq72Y/sB1LtsyeqKMbrr+hpJ7ucjAHc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788540934;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WPRsvSqNMVoTy54dMqYT8iKlw6snkh8bOJXtr0xce0s=;
	b=dZlyDeXSoVq4W6MYHcRRqV8H0dny1vp2E/1CpCEXn/IVrMNxoZ9+89VJ33SFGU6H6tX9GB
	dtMXPYz8BWPg/UCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qPhTfjrm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2C7xshZN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788540929;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WPRsvSqNMVoTy54dMqYT8iKlw6snkh8bOJXtr0xce0s=;
	b=qPhTfjrmWNQBvkPAESJHKz1jYTQU7Vk6k8fCQee59BfsD2Nqnb+GqO9ZzHDasbIuPpFqko
	EKW7M3r9TCNiO3i/0n949uFbnm+L7JHJmIg7BODVQ4C4zJAJX7cdZiVd2d/ktopERuGVq8
	/h3wUDPq5zEph2BgGEya98K6aPKdflo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788540929;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WPRsvSqNMVoTy54dMqYT8iKlw6snkh8bOJXtr0xce0s=;
	b=2C7xshZNrDfOxYFyJtq6LxgrLQS5vOmQU0ukYsUD2YQanc1oahEDmdOPpg7yzdO8TUgzqv
	HyoEwjnyKyBQBmBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9FD4713726;
	Fri,  4 Sep 2026 16:55:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PSHTJgH4mmpIXQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 04 Sep 2026 16:55:29 +0000
Date: Fri, 4 Sep 2026 18:55:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Daniel Vacek <neelx@suse.com>
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental
 features
Message-ID: <20260904165520.GM9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: CC96322A8E
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Thu, Sep 03, 2026 at 06:09:41PM +0930, Qu Wenruo wrote:
> -static bool should_async_write(struct btrfs_bio *bbio)
> -{
> -	struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
> -	bool auto_csum_mode = true;
> -
> -#ifdef CONFIG_BTRFS_EXPERIMENTAL
> -	/*
> -	 * Write bios will calculate checksum and submit bio at the same time.
> -	 * Unless explicitly required don't offload serial csum calculate and bio
> -	 * submit into a workqueue.
> -	 */
> -	return false;
> -#endif
> -
> -	/* Submit synchronously if the checksum implementation is fast. */
> -	if (auto_csum_mode && test_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags))

The fast csum implementation is not used anymore, so the
BTRFS_FS_CSUM_IMPL_FAST definition and related code can be deleted.

> -		return false;
> -
> -	/*
> -	 * Try to defer the submission to a workqueue to parallelize the
> -	 * checksum calculation unless the I/O is issued synchronously.
> -	 */
> -	if (op_is_sync(bbio->bio.bi_opf))
> -		return false;
> -
> -	/* Zoned devices require I/O to be submitted in order. */
> -	if ((bbio->bio.bi_opf & REQ_META) && btrfs_is_zoned(fs_info))
> -		return false;
> -
> -	return true;
> -}

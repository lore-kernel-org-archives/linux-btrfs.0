Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D75F27732
	for <linux-btrfs@vger.kernel.org>; Sat, 24 Jan 2026 01:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769216747; cv=none; b=OvhBpd2DjN9RemvePViVsGAoSnrc5UH3t2dRKIDMFH4Et+FLkVW3KMSNGr2nqIojyapzPOpBeTTMK0OgkzUhvAKuIKFV6sfoJ1vkMixfMgT7GkEqLQetMTg/LZ8dmnDbXJJaDCefroGD+ZwMtkS4SGohKyonAduzm2gqmH+ZNQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769216747; c=relaxed/simple;
	bh=7Ftq5NXmU2WeYH1BnKE2DHt62KFZ7z7HLmCJbJWrbPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aED0vQWxMaSdTyzabM2lsrG6NBCaVLNoxOP+MIn9JCOyiAgCcM7xET34Q32ZiCEasz9nZSGJZDT3jjQqdZX/2fG4a+PZX0AOoLOnXC+c3EVt1ZfKsm1Ck6vWzi9t7JRRuNiEr4PUm5qQXO+hUaYEeB+qoii7wAfD5KKpj5auWIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sSeglnzE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fLXO9EXr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sSeglnzE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fLXO9EXr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sSeglnzE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fLXO9EXr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sSeglnzE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fLXO9EXr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5D64233694;
	Sat, 24 Jan 2026 01:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769216744;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ksn6oTYEM1nin8poWs3VbUFs+hvEZkUkqHaUpPCEBbY=;
	b=sSeglnzENd8IktdR0D2O0o6jHJz0Rr18a5t+ZCOADsnprLntHmOLNQdb+c+ToQqLgj5pS4
	4DAIk0uE0adwhm9XKXJBmWnmj0nAJRpGhv0l/KnqURQEphURDYJ2GjGorx+qp8yfhduEm6
	52KAvYyGYWtHt6ny3xe/Yl+ux8RJpEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769216744;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ksn6oTYEM1nin8poWs3VbUFs+hvEZkUkqHaUpPCEBbY=;
	b=fLXO9EXrhUBCAZpbatRbuJsmpUGNd/kvzVRjkkMpPvTt4DrzufZM/DXVzDngLEmpkj+RZm
	qLrpQOg9A4T91DCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769216744;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ksn6oTYEM1nin8poWs3VbUFs+hvEZkUkqHaUpPCEBbY=;
	b=sSeglnzENd8IktdR0D2O0o6jHJz0Rr18a5t+ZCOADsnprLntHmOLNQdb+c+ToQqLgj5pS4
	4DAIk0uE0adwhm9XKXJBmWnmj0nAJRpGhv0l/KnqURQEphURDYJ2GjGorx+qp8yfhduEm6
	52KAvYyGYWtHt6ny3xe/Yl+ux8RJpEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769216744;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ksn6oTYEM1nin8poWs3VbUFs+hvEZkUkqHaUpPCEBbY=;
	b=fLXO9EXrhUBCAZpbatRbuJsmpUGNd/kvzVRjkkMpPvTt4DrzufZM/DXVzDngLEmpkj+RZm
	qLrpQOg9A4T91DCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4120F136AA;
	Sat, 24 Jan 2026 01:05:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NJK4D+gadGmDEQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 24 Jan 2026 01:05:44 +0000
Date: Sat, 24 Jan 2026 02:05:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] btrfs-progs: enhance detection on unknown keys in
 subvolumes
Message-ID: <20260124010539.GA26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1765876829.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1765876829.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Tue, Dec 16, 2025 at 07:53:46PM +1030, Qu Wenruo wrote:
> [CHANGELOG]
> v2:
> - Add a new test case
> 
> This is inspired by a real world bitflip corruption, where an INODE_REF
> is now 8 (an unknown key type), causing btrfs-check to freak out and the
> existing INODE_REF/DIR_ITEM/DIR_INDEX repair is not cutting this
> particular case for the original mode.
> 
> Lowmem mode is better, but for this particular image it's too large and
> lowmem is too slow to be practical.
> 
> As the first step, detect and report such unknown keys in subvolume
> trees as an error.
> 
> With a new test case for it.
> 
> In the long run we should allow btrfs-check --repair to delete such
> unknown keys.
> 
> Qu Wenruo (2):
>   btrfs-progs: enhance detection on unknown inode keys
>   btrfs-progs: add a test case for unknown keys in subvolume trees

Added to devel, thanks.

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675A819B5A3
	for <linux-btrfs@vger.kernel.org>; Wed,  6 May 2026 13:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778072475; cv=none; b=TIaKXkB3QGtuHPsJ4RjaKxn7nzfUD5MZr6RitsjMsAFnqZ16TvC50P/vTgkae/fi4hKIWPs1BBNUGWwTpCsO4k6eTGh/o2SFdzFTst06df6s7DkHzcOjeTnWeTPMp2o2xeCpMJGi9IZRG8hdfINncQ0n1RqZjWUizTZbx3AhrqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778072475; c=relaxed/simple;
	bh=+yPHaBJ/OcUc6JnscwHHK7ux/vGOSe0F5nabbcqTShM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UvxGYzp+0h4RDDdAiiW+TuImIX/GNNbr+cQhy47aQIbano/7KdLpL/gV7L1lCOn6FuVR4TkznfumyleuC/AKQqDpHkvhdSo8f1Zf0WuEEcJFvlQxHgZzWOfOzwqNio5WzDjEIMKCNCDbk13y4kRPQSGfmrVRrIsDpac+OkmCTOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0QS3gKmN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OK8ciN4+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0QS3gKmN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OK8ciN4+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0QS3gKmN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OK8ciN4+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0QS3gKmN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OK8ciN4+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1CEDA6BC72;
	Wed,  6 May 2026 13:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778072459;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yPHaBJ/OcUc6JnscwHHK7ux/vGOSe0F5nabbcqTShM=;
	b=0QS3gKmNIYIkMOv9R1+zjkky1+bkxXSzHjOt4TfqcfPkTSX5GKYF/FjYFRsduQ/RGZrsYU
	+CZpWQYZhcd/qlxvPXgK5wSTVPYWxofXqWl1F554lAGIxv/ChwnckGheSEIYPLduuT3QBI
	YMV0UBDlfrLXr2f0PtiLuHIyZeEP1MY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778072459;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yPHaBJ/OcUc6JnscwHHK7ux/vGOSe0F5nabbcqTShM=;
	b=OK8ciN4+lLpGsjnXRk+A5XeKUDdKi7nWPOp5gtmNfyNl2HkG/Nnqceci1iwXliuXkWIR4C
	iGoS+9INg9EICXAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778072459;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yPHaBJ/OcUc6JnscwHHK7ux/vGOSe0F5nabbcqTShM=;
	b=0QS3gKmNIYIkMOv9R1+zjkky1+bkxXSzHjOt4TfqcfPkTSX5GKYF/FjYFRsduQ/RGZrsYU
	+CZpWQYZhcd/qlxvPXgK5wSTVPYWxofXqWl1F554lAGIxv/ChwnckGheSEIYPLduuT3QBI
	YMV0UBDlfrLXr2f0PtiLuHIyZeEP1MY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778072459;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yPHaBJ/OcUc6JnscwHHK7ux/vGOSe0F5nabbcqTShM=;
	b=OK8ciN4+lLpGsjnXRk+A5XeKUDdKi7nWPOp5gtmNfyNl2HkG/Nnqceci1iwXliuXkWIR4C
	iGoS+9INg9EICXAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0859B593A3;
	Wed,  6 May 2026 13:00:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0gacAYs7+2k2UgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 06 May 2026 13:00:59 +0000
Date: Wed, 6 May 2026 15:00:53 +0200
From: David Sterba <dsterba@suse.cz>
To: AlaEldin Mohamed <aeiedamo@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Will Btrfs progs get a 7.0 release?
Message-ID: <20260506130053.GC2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4575d1380ada67bcc34b60f0245ad37e316a6ac3.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4575d1380ada67bcc34b60f0245ad37e316a6ac3.camel@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spamd-Result: default: False [-3.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUBJECT_ENDS_QUESTION(1.00)[];
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
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,twin.jikos.cz:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -3.00

On Tue, Apr 28, 2026 at 09:58:11PM +0300, AlaEldin Mohamed wrote:
> According to the btrfs-progs release cycle, we should expect a 7.0
> release by now. Is there any regression preventing this from happening?

The release ETA is this Friday (+2 days).

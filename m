Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B07C2571DA
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 03:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784777477; cv=none; b=nAT4yyy44mbNqEG6Gh/bNlLwz0cXjLFBWQTUQKB4WM702tUwpZrnWDTsl/6vpBCLnZ8CnJwYzAWW8je5AF/NcsKWE98st1t44kP00rjlPiwx2Zlm0ci12exiwBZS7MqNeCxpExFF3N8DMH9a319QN3AT6OQ/Uev7H0Jf1Qtx2DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784777477; c=relaxed/simple;
	bh=KhjThxoPQmmy90ni4q/pgRvCdx5TuyFf42nS2GMYEt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDs8jZC6kSVr1rP5JycWnwNXeALtoXeHPSl2l+cUzsfeNO9gewCqJcYPoMal7Z3MvK+z+Uw54+RmpuaybAI0bWicqvdR0Jd0giQ3jj6j5szLEVzCvWyexL1kgitfiYxWFmFrJzrBG7VkF5G0WJgFx3FgNtxOaV/UUYSHQdwnk0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fEMNPbkI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7DsFPklL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fEMNPbkI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7DsFPklL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fEMNPbkI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7DsFPklL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fEMNPbkI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7DsFPklL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A2CF7AE49;
	Thu, 23 Jul 2026 03:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784777474;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1MbxNvPn/wyAftBtg/TygaX5o57oMCAcrjyNRvfldkc=;
	b=fEMNPbkIHf6PnmLCxKl87AmeD+gzgCBCgIhqj1yMJAMoHRzGIXfRrhdgPUGXqcj7qZb9Cq
	hbynKwfpz6Arg6NWY4oQ9JABcS15BcxCWYVWIHVHaxZnjyCF8fQ6ju6EByCAwLpjVNtC8Y
	rXgCg3URwEa+VVNb0f6J0Z2A3ViHepk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784777474;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1MbxNvPn/wyAftBtg/TygaX5o57oMCAcrjyNRvfldkc=;
	b=7DsFPklLXr/MuKc0hKXxpM7WqvWO8nBThV91VA/+GBfp8bE0kNuzqMbU+Gcx/v8SlH0fzl
	2SlEyNJwYMYmESBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784777474;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1MbxNvPn/wyAftBtg/TygaX5o57oMCAcrjyNRvfldkc=;
	b=fEMNPbkIHf6PnmLCxKl87AmeD+gzgCBCgIhqj1yMJAMoHRzGIXfRrhdgPUGXqcj7qZb9Cq
	hbynKwfpz6Arg6NWY4oQ9JABcS15BcxCWYVWIHVHaxZnjyCF8fQ6ju6EByCAwLpjVNtC8Y
	rXgCg3URwEa+VVNb0f6J0Z2A3ViHepk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784777474;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1MbxNvPn/wyAftBtg/TygaX5o57oMCAcrjyNRvfldkc=;
	b=7DsFPklLXr/MuKc0hKXxpM7WqvWO8nBThV91VA/+GBfp8bE0kNuzqMbU+Gcx/v8SlH0fzl
	2SlEyNJwYMYmESBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D406779B5;
	Thu, 23 Jul 2026 03:31:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nFdcHgKLYWobYwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 23 Jul 2026 03:31:14 +0000
Date: Thu, 23 Jul 2026 05:31:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, clm@fb.com,
	dsterba@suse.com, rdunlap@infradead.org
Subject: Re: [PATCH] btrfs: sysfs: fix path of the "read_policy" module
 parameter in comment
Message-ID: <20260723033113.GR10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260621074626.11193-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260621074626.11193-1-zenghui.yu@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.990];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,suse.cz:replyto,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Sun, Jun 21, 2026 at 03:46:26PM +0800, Zenghui Yu wrote:
> The correct path of the "read_policy" module parameter should be
> /sys/module/btrfs/parameters/read_policy. Fix it.
> 
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>

Added to for-next, thanks.

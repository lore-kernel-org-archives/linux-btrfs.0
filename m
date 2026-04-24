Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002231C5F27
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 02:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776998329; cv=none; b=tBox9ZOrhshZ4XyAGLEIqmT9gqiJmrsSLcFnSOmCs+4s/iJV75KXNBaeWIwVhfFbJJgXNHUx6PE0qZw98Rtvfrlcj5h7etx3grULlOU9FFSfnHtymn1GiavjGd/FrEIZU3eHV3xOqN71EO5IVSHUPCqyimW5ZuzR7aNHt8NnNp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776998329; c=relaxed/simple;
	bh=DX9lh7qnTF7bpoi+gBAZl2O6bWpS/bFbiqMEOsR3Oig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBK0vrX8luZRP8pF1Qx/6aA7skwrQkEqWrqWwpqIOzZESCpDWdkLZp8YBJxksE8BQLe6vAhkUaqzJ4VXZ85TV+yCjLWxD+swZYwig89iWZOF5XXh/pBcOxljPwwR4UJwPnh0u7+J1CNuF426SFwykoiKGeUXwMD/vwW0FeHdrhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eK9Rgyma; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4PxRh1ja; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mui2xMrp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iyQ4JerA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eK9Rgyma";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4PxRh1ja";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mui2xMrp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iyQ4JerA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A03D55BD1E;
	Fri, 24 Apr 2026 02:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776998326;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CGW6OiKZAezC0qSenVaam0YHIf633rZGNFrAUFVKGDo=;
	b=eK9RgymaksjlQAZ8QEW6ECkMUHUmSUKyDOzrH76M2nAKEGgHRf16BD1QmZnfHB1ZLLgs5C
	/wFz+e5XgY4taXYgfBVsTr4U0nvc7Ko5PnQvPsD4K9oHuMwbYvHIfMpnjpd35K1m8W+KXL
	o410SZ77omjhfykdAT/YzwZN3bhn1FI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776998326;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CGW6OiKZAezC0qSenVaam0YHIf633rZGNFrAUFVKGDo=;
	b=4PxRh1ja3ZQMZrg1Zrj9dVuWEMP/CE5oTtuzfDHOZbt3K7qACYKKNnOLJKHpFz6QLwx0Nm
	h9CbdoDL+uJ9wdCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mui2xMrp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iyQ4JerA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776998324;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CGW6OiKZAezC0qSenVaam0YHIf633rZGNFrAUFVKGDo=;
	b=mui2xMrpYE46VV/4MhfiVfHAITvJgw6mZ8MQ2CjeF0ydKkbfO0JTR9bvltXyJfeuYzUzyL
	BNf2VZlid7UCP3POhTlWPSbdmH7O0HId5PbFj8vkbJmNiArnIIHVazXp1O5+DqswiJaBPN
	vMclC8pVZXdv2NRlSrnOAM4wOHcoEBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776998324;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CGW6OiKZAezC0qSenVaam0YHIf633rZGNFrAUFVKGDo=;
	b=iyQ4JerAivjYja+Z871pPvu2LwypA3WbTElOIC1bXD9WarOCJraFmvY/eFNWrILXe/tSj9
	ZAtG2o/nnMwfbTBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DDC5593AE;
	Fri, 24 Apr 2026 02:38:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C93qIbTX6ml3NAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 24 Apr 2026 02:38:44 +0000
Date: Fri, 24 Apr 2026 04:38:35 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: collapse report_eb_range() into its single caller
Message-ID: <20260424023835.GA3542906@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b2dc0f485fc063e2b666e150002f59a278b97023.1776944252.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2dc0f485fc063e2b666e150002f59a278b97023.1776944252.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A03D55BD1E

On Thu, Apr 23, 2026 at 12:38:13PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> There's no point in having this static function since it's too short and
> it has a single caller (check_eb_range()), so move its code into the
> caller and remove it.

The point is to separate the check and report functionality, so the
check part is inline and a simple if (a few instructions), while the
report is not always inlined and is considered cold code.

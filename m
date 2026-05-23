Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12665317169
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 17:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779557107; cv=none; b=HsLlGDgcqkute4iB8QxX3uevJT/s4UQ2TWeaYS5N3Vf9R1xU9fTEtf2EyuK4Vnj/6/ecyAz6fdGdCzEJzuRqmES7ns6NiMUNouSBsT8aKo97tor0BfXbdwXfbv5KvBpcKf2e5VJxBD76q7kmQyeLObASh56mxHnbadcfr1V5bEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779557107; c=relaxed/simple;
	bh=zSWOuhDVwYLR1/c+7i/LoMM3ymqpuahGRo2RneEDjn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=haNeJ5qBQTg56I1PiSl7RR27hmYZV1B3gVtFNQvig/wJdzVtEvmqHWt5nCmZc9wrUl0tzeFIU7bdrxHLznahBS4bbUhpu+VR3RkLs8fqMAbIMSuQxfF/fsWwnYvsO3y58nGjtuXw83kbeOa9OSpl7n4j7pQ+2sDF6K0WEtcqBek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OD965H57; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JDilFspj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OD965H57; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JDilFspj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OD965H57";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JDilFspj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OD965H57";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JDilFspj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4E4D167449;
	Sat, 23 May 2026 17:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779557104;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JawnFgml8JZFshp6fMA2fzsD/86KB1tEH5NjbbeuTQI=;
	b=OD965H575sH6Aub9QSiYJWf+evUr7F+ABCce0IM23f4XTQ5NL9OVqCnT37nEempUKrBLVR
	l7yfAg4WfiwQEWKMUfPNYC9xH4c91rh8JTkN/7jjFT3DVpcZo0HX+JV63pu8Qjy0pNhZsL
	JMmFmsnqCCAH/DPvoIXjMg7ngwojnG0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779557104;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JawnFgml8JZFshp6fMA2fzsD/86KB1tEH5NjbbeuTQI=;
	b=JDilFspjk03ow6RTRWAqdEisJmscqWX67P/9YHPN3NwRyHGg2ehGL9QsL1GPWxss/JMSjH
	mNYLNwqYIVsZGXCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779557104;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JawnFgml8JZFshp6fMA2fzsD/86KB1tEH5NjbbeuTQI=;
	b=OD965H575sH6Aub9QSiYJWf+evUr7F+ABCce0IM23f4XTQ5NL9OVqCnT37nEempUKrBLVR
	l7yfAg4WfiwQEWKMUfPNYC9xH4c91rh8JTkN/7jjFT3DVpcZo0HX+JV63pu8Qjy0pNhZsL
	JMmFmsnqCCAH/DPvoIXjMg7ngwojnG0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779557104;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JawnFgml8JZFshp6fMA2fzsD/86KB1tEH5NjbbeuTQI=;
	b=JDilFspjk03ow6RTRWAqdEisJmscqWX67P/9YHPN3NwRyHGg2ehGL9QsL1GPWxss/JMSjH
	mNYLNwqYIVsZGXCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43F16593A8;
	Sat, 23 May 2026 17:25:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mCxeEPDiEWpbVQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 23 May 2026 17:25:04 +0000
Date: Sat, 23 May 2026 19:25:03 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 15/28] btrfs: tracepoints: add trace event for
 btrfs_log_inode()
Message-ID: <20260523172503.GJ183694@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1778776706.git.fdmanana@suse.com>
 <f5142a40e34dc0588818348f5104269b960209d1.1778776707.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5142a40e34dc0588818348f5104269b960209d1.1778776707.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Fri, May 15, 2026 at 06:00:12PM +0100, fdmanana@kernel.org wrote:
> +	TP_printk_btrfs("root=%llu(%s) ino=%llu type=%s transid=%llu gen=%llu"
> +			" logged_trans=%llu last_unlink_trans=%llu"
> +			" last_reflink_trans=%llu last_sub_trans=%d last_log_commit=%d"
> +			" logging_new_name=%d logging_new_delayed_dentries=%d"
> +			" is_conflict_inode=%d full_sync=%d copy_everything=%d"
> +			" no_xattrs=%d log_mode=%d(%s)",

For normal messages we follow the "format on one line" style so the
message can be found from its fragments.

I thought we had the "format on one line" policy for tracepoints as well
but it's not documented as such. Also checking the rest of tracepoints
we have many more with split lines, so I guess we never needed it. I'll
update docs.

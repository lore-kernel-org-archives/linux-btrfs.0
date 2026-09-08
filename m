Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC7A560AB7
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 13:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788873296; cv=none; b=LSGU3bjDKv4cBTZmkBRwKePngBklqAiBr6k9c1taqXEkADF7/WtxYENTYVrjHgQqalkt5FhNDPPp0nVJY3mMKq4dMwLWld6928aPY5EV3g3g49/HcvFylfWxqrwRBNlMaOhwjGPZ8+c6c928ylTxkJY1jVTV/9G1oXaA8I0xVIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788873296; c=relaxed/simple;
	bh=hc4xQggyY6vGMtwwV7+BgXlrCZl///vjpEQ0lPLMNVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdT4Ws+IaoArCwP3kDap424G1PYp1qYp05n9qo81PL+tMSBl/+lWNlTmnD1XeL1ZQD2mJTmdr+SYApwZc3kgh92V9rPUdRaJsTqr1DkaLKNUdbZ3sND3YLTdHhVn5KsvK4coabio4pf9cJqb3v6lHANI0zlYomSFVEtAUhXKWHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=t22QadxQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UuWTMUf0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=joQsVfHG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=G41KNN7e; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="t22QadxQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UuWTMUf0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="joQsVfHG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="G41KNN7e"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 976761F7EA;
	Tue,  8 Sep 2026 13:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788873284;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CzPeryxx0K0Qj67z4wPXQ1OzNGAepL/TiC1f+1dD9yQ=;
	b=t22QadxQFQ5SY/wHCbnJ06iHnTMvo5AnC6W3I+Bac75H1KGOyt8Yt8aVKk9CHJcmcuXUj9
	qXPdW3Szsv+yjHlfINzgzRXar5ErJvWFC0GA4vyG1KHZzXoUA+WiZli/4ulLFoa7XVfR2y
	5NB4JKcgHrsFtl3lvODZtMyPG0G/2is=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788873284;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CzPeryxx0K0Qj67z4wPXQ1OzNGAepL/TiC1f+1dD9yQ=;
	b=UuWTMUf0J1v9WzWyfuQ+Bsx8IBTZK4OFWt63UcIkJCm+OU7kREm4FVyQGJrsUgaMW89myw
	zgzK9ie/KyaeJhCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=joQsVfHG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G41KNN7e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788873280;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CzPeryxx0K0Qj67z4wPXQ1OzNGAepL/TiC1f+1dD9yQ=;
	b=joQsVfHGQzeBZTRlc0VYdVDnkj88fx6KzFnfTlCY5Prui6AfNfylJkMuM17cFUK3Ne8G46
	P5IGkYyE8910a6PujOeunhFOcD9T+ctu6iRIA7T+L97O7Y45X35Tkzm7QgL0K08KD1fQTd
	5SjaovpNd4SVpPuQo6XLoMsk1zVdd7M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788873280;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CzPeryxx0K0Qj67z4wPXQ1OzNGAepL/TiC1f+1dD9yQ=;
	b=G41KNN7ekHLz0yezoOLAs1jEAZn0YDw74uFgbUG5+eLJGAsvZzMSzYMf7k6SGf1U+YU5fy
	WCxuJxPcqDJmteAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B9F61347F;
	Tue,  8 Sep 2026 13:14:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tJUTGkAKoGo/PgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 08 Sep 2026 13:14:40 +0000
Date: Tue, 8 Sep 2026 15:14:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Fwd: btrfs: OOM in split_item().
Message-ID: <20260908131439.GC9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <nka8fLGwxf2NcMXCcuLi4CkGSIKrKG4Sc9IbvTTBG5L6T63w6tImgOKYEmu-pWaoZZFO4Eqg8zDyMggihfvlFRTd1Vubz6E52PVEhU83gn8=@protonmail.com>
 <250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 976761F7EA
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,protonmail.com:email,twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Tue, Sep 08, 2026 at 07:45:58AM +0930, Qu Wenruo wrote:
> Forwarded for archive purposes, as patchcheck requires a link: tag 
> following reported-by: tag.
> 
> Meanwhile the original report is only a private mail to me.
> 
> -------- 转发的消息 --------
> 主题: 	btrfs: OOM in split_item().
> 日期: 	Mon, 07 Sep 2026 20:10:56 +0000
> 发件人: 	xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
> 收件人: 	wqu@suse.com <wqu@suse.com>
> 
> 
> 
> Hello.
> 
> Attached is a kernel log entry showing a strange out of memory issue 
> that rarely seems to happen.
> It's kind of annoying and makes me wish GFP_NOFS would go the way of the 
> dinosaur.

What is the story behind that? One way or another we will get GPF_NOFS
semantics, either the flag or the scoped NOFS and this limits the
allocator.

Using 64k nodes is problematic and so I'd rather people not use it on 4k
systems.

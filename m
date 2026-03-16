Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B5E37417D
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 08:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773651498; cv=none; b=EqIPzYQelyY2WIdSWg2YC+CW4AREArVu9IR2WPKMpDco0GFe2xBaaHcjLeHwlA39IeBm1xLNQfbqOlpQ74Vcz/r18joGAFDaXslT1zRSdJtdPuCpDLtnxziRcwdjYR6K07tOzfjcPZv3Ch6oAoTkAXGdDavzK2IRJ15z8I9C6N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773651498; c=relaxed/simple;
	bh=XGbUeFYbDHoPeQzaUszs5qS+nuFjLkYy4nY2nE1cQkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tr2yHfFZbNlHvyMI2+b4gtMjC8B1ECrmd8ERr+fwkxdCQUqyDWniX01RXCA97cbRbuqkOiJNs7stzpMPFmD8I188tai89t/z/fcrHIzwZUtdRy/kxrveEsfOH9LgJ74aVF+LpTJ5nklXwg0CuBADdMquycxgQspalj4aZ+jnUAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tIDIuIRK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7yFUxAXJ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tIDIuIRK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7yFUxAXJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tIDIuIRK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7yFUxAXJ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tIDIuIRK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7yFUxAXJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 506C25BCC3;
	Mon, 16 Mar 2026 08:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773651495;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B7DixuMuxJPXtSm0awLlDTu7mZodMjk1EWd7Z3GlIFg=;
	b=tIDIuIRKE19U/P4tFjKhHfF7wlc/q/8xKtdYIHCF4GIMJ0j4L2UB/h32K8aKyCVkdd51FV
	KtLH3pcSlKRePtQC69dQDxZXC60sVVu3UeennkHBlgPf996h7Xnr0ZX+hX+vovoq1NWjP4
	tJZmkOxqfYLORrflONkP+hDtXSEFBXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773651495;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B7DixuMuxJPXtSm0awLlDTu7mZodMjk1EWd7Z3GlIFg=;
	b=7yFUxAXJSxXQ134HcsdY9h0mE3Lv0akqKCezwACcFZQs/hOrzbcosxSMjx9mviI+Yvkbxs
	F3PaJaJ/QwptkpBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tIDIuIRK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7yFUxAXJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773651495;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B7DixuMuxJPXtSm0awLlDTu7mZodMjk1EWd7Z3GlIFg=;
	b=tIDIuIRKE19U/P4tFjKhHfF7wlc/q/8xKtdYIHCF4GIMJ0j4L2UB/h32K8aKyCVkdd51FV
	KtLH3pcSlKRePtQC69dQDxZXC60sVVu3UeennkHBlgPf996h7Xnr0ZX+hX+vovoq1NWjP4
	tJZmkOxqfYLORrflONkP+hDtXSEFBXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773651495;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B7DixuMuxJPXtSm0awLlDTu7mZodMjk1EWd7Z3GlIFg=;
	b=7yFUxAXJSxXQ134HcsdY9h0mE3Lv0akqKCezwACcFZQs/hOrzbcosxSMjx9mviI+Yvkbxs
	F3PaJaJ/QwptkpBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 388DA4273C;
	Mon, 16 Mar 2026 08:58:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CE2jDSfGt2ljfAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 16 Mar 2026 08:58:15 +0000
Date: Mon, 16 Mar 2026 09:58:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/4] btrfs: move some features out of experimental
Message-ID: <20260316085810.GO5735@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1772162871.git.wqu@suse.com>
 <20260304035752.GH8455@twin.jikos.cz>
 <a19ad870-a52a-4e26-8ac7-cfabfb4a5e4b@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a19ad870-a52a-4e26-8ac7-cfabfb4a5e4b@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:32098, ipnet:2800::/6, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 506C25BCC3
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Wed, Mar 04, 2026 at 02:34:32PM +1030, Qu Wenruo wrote:
> > Adding all of them at once feels a bit risky. I don't think that it has
> > enough exposure and testing because of number of the possible
> > combinations.
> > 
> > The shutdown is orthogonal to the rest so this can be enabled by
> > default.
> 
> So can I add that shutdown one into for-next branch?

Yes please.

> > For the rest the bs/ps is namely an ARM thing with the 64K
> > pages,
> 
> Thus I'd say it shouldn't affect most end users (if any).

AFAIK the 64K pages are used on big machines with lots of memory and the
support for 64K/4K combinations was needed for interoperability. Yes
there are users.

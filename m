Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E589838CFE5
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773403037; cv=none; b=nxF67dJ8b12wrvwkeaSmcMlMI9ZsxaAsXMahYKqeGobZvdmAmopx1y8HxJafEJFIubdGpAmJFoBE7fIZjwFg086odxPIfpSOPkmOdkolyhOtFDD6Prlk6q0i3cOs3ZhyoeqM6wc9V3Ga1oXkV7l0fxqGfKFdRmZ8+waUBfdnQ+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773403037; c=relaxed/simple;
	bh=lH1uhOdjYFmC3JrvjmKwXDjfQwtszuioLTDCY7UeKts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxJ6L6pvDIPeUQ/97fpbZ3sTbxJEEyM8CJrh4Hn0V8KEC51ICTnHSNIRSATICYkibrKyxVhdUUI3mlhz27Ew0gW9C0Iip6VD4ThDLrYYfv9sGy5Hn7VFNciwGPwALzGu1KVipAgA4YHTC99dmgK9tMSThQhSGbjmSWuQXSsDXrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eoJiSPEk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NTw0Td9b; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eoJiSPEk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NTw0Td9b; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eoJiSPEk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NTw0Td9b";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eoJiSPEk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NTw0Td9b"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 259835BD5B;
	Fri, 13 Mar 2026 11:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773403034;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dFd6Wl1Szr2Hs94RLnDBxd3xZiFagKqf54VnDXVEQ24=;
	b=eoJiSPEkMKBrHBRhU8JtCrk5gSGYIYO/G1OD/4t84umSXM4H8nx/7hgLIjRnPSXvNnGwf0
	uJumiXxFKj0ZbdYTiZpfVcE3ZT3t7HJ5liEI28PSSmLaDmsuJSv44b7In12maTKAnH/ycZ
	/wo3RxCyRI1q9jjSsDOldulzet+XyRw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773403034;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dFd6Wl1Szr2Hs94RLnDBxd3xZiFagKqf54VnDXVEQ24=;
	b=NTw0Td9bHq3QnNwMHKIkCR1vqGZCNuPXXbaFev/5q6vEp+KHnDrOVTEYqK8sJEYkZInqjx
	LyhvpVY7hnpr71Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773403034;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dFd6Wl1Szr2Hs94RLnDBxd3xZiFagKqf54VnDXVEQ24=;
	b=eoJiSPEkMKBrHBRhU8JtCrk5gSGYIYO/G1OD/4t84umSXM4H8nx/7hgLIjRnPSXvNnGwf0
	uJumiXxFKj0ZbdYTiZpfVcE3ZT3t7HJ5liEI28PSSmLaDmsuJSv44b7In12maTKAnH/ycZ
	/wo3RxCyRI1q9jjSsDOldulzet+XyRw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773403034;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dFd6Wl1Szr2Hs94RLnDBxd3xZiFagKqf54VnDXVEQ24=;
	b=NTw0Td9bHq3QnNwMHKIkCR1vqGZCNuPXXbaFev/5q6vEp+KHnDrOVTEYqK8sJEYkZInqjx
	LyhvpVY7hnpr71Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08F32404EF;
	Fri, 13 Mar 2026 11:57:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MAcEApr7s2meIgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 13 Mar 2026 11:57:14 +0000
Date: Fri, 13 Mar 2026 12:57:12 +0100
From: David Sterba <dsterba@suse.cz>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] btrfs: Use trace_invoke_##name() at guarded
 tracepoint call sites
Message-ID: <20260313115712.GG5735@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <20260312150523.2054552-16-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312150523.2054552-16-vineeth@bitbyteword.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[8];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Thu, Mar 12, 2026 at 11:05:10AM -0400, Vineeth Pillai (Google) wrote:
> Replace trace_foo() with the new trace_invoke_foo() at sites already
> guarded by trace_foo_enabled(), avoiding a redundant
> static_branch_unlikely() re-evaluation inside the tracepoint.
> trace_invoke_foo() calls the tracepoint callbacks directly without
> utilizing the static branch again.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Assisted-by: Claude:claude-sonnet-4-6

Acked-by: David Sterba <dsterba@suse.com>

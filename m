Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716743C9ED9
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 17:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774288409; cv=none; b=aka9pGTwJ7g0hiJaQg+nT/n/FG7OMzyLnurZWMUmMvF1AmEA0+xkQ9bmMFiKl0iuCjHSGwIwKYlqElOgO/F6BRIS5Vi1N3c3dYmQpXw+HhEd/QbSSTf4gMsQhdicBggI8ciCILzmRXcX2SuAJBPhWXlQO0o/zO/HScdKHECwXjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774288409; c=relaxed/simple;
	bh=wABEVCaymgDsOAF1C8bFFBLnXQtbAubY7mopUnaE2lE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dz9Bx9wpMPDrXjxfvn6pUBu2fYL7FViesGMvVukqAOcOwapkoGwUzPqK/ogRJrr4rbE1OW4QvDLu6qAarioEPZ0AGSwv7ZFVHD0lt/gdrppMb5TJv2G6blnQCG8lpV04HHmrgfVXA5RaFqHafsWaKaFJwO4+bHhpWM4u8gjg6So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Q9xCa/0A; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9IZe8hZK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Q9xCa/0A; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9IZe8hZK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q9xCa/0A";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9IZe8hZK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q9xCa/0A";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9IZe8hZK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD3BD4D364;
	Mon, 23 Mar 2026 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774288405;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iiJSeib8y2tud2R3DO0GagCuPq+oG5UXOA7+MtsD6X8=;
	b=Q9xCa/0A878LAsjrb9GpKyTJ5sENDwBnVZ6soEMCamUg7IHmxM1PFIm6teIbEGHi+NhjmJ
	ecmI0X4sWjhGdncsvZK/WzqlPJEpjvhMYoj47pUdiMeEfisBsJQq1IW6PXpIkaY21PHW7z
	qDX7Z3QXsX1lzTIpJcyLbo0h1iJTWAI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774288405;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iiJSeib8y2tud2R3DO0GagCuPq+oG5UXOA7+MtsD6X8=;
	b=9IZe8hZKLVCMqKMQm+mElS1xXFLwK8up+zge414uSCVKUrm2ePr6hs8+DDVzwK0XqbwcYL
	q+YHuouj/2VaLODA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774288405;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iiJSeib8y2tud2R3DO0GagCuPq+oG5UXOA7+MtsD6X8=;
	b=Q9xCa/0A878LAsjrb9GpKyTJ5sENDwBnVZ6soEMCamUg7IHmxM1PFIm6teIbEGHi+NhjmJ
	ecmI0X4sWjhGdncsvZK/WzqlPJEpjvhMYoj47pUdiMeEfisBsJQq1IW6PXpIkaY21PHW7z
	qDX7Z3QXsX1lzTIpJcyLbo0h1iJTWAI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774288405;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iiJSeib8y2tud2R3DO0GagCuPq+oG5UXOA7+MtsD6X8=;
	b=9IZe8hZKLVCMqKMQm+mElS1xXFLwK8up+zge414uSCVKUrm2ePr6hs8+DDVzwK0XqbwcYL
	q+YHuouj/2VaLODA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4BA8B439D7;
	Mon, 23 Mar 2026 17:53:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hCJIEhV+wWmBdgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 17:53:25 +0000
Date: Mon, 23 Mar 2026 18:53:24 +0100
From: David Sterba <dsterba@suse.cz>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 15/19] btrfs: Use trace_call__##name() at guarded
 tracepoint call sites
Message-ID: <20260323175324.GP5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
 <20260323160052.17528-16-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323160052.17528-16-vineeth@bitbyteword.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.cz:replyto,infradead.org:email,goodmis.org:email,twin.jikos.cz:mid];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,goodmis.org:email,suse.com:email,twin.jikos.cz:mid,bitbyteword.org:email,suse.cz:replyto,infradead.org:email]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Mon, Mar 23, 2026 at 12:00:34PM -0400, Vineeth Pillai (Google) wrote:
> Replace trace_foo() with the new trace_call__foo() at sites already
> guarded by trace_foo_enabled(), avoiding a redundant
> static_branch_unlikely() re-evaluation inside the tracepoint.
> trace_call__foo() calls the tracepoint callbacks directly without
> utilizing the static branch again.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Assisted-by: Claude:claude-sonnet-4-6

Acked-by: David Sterba <dsterba@suse.com>

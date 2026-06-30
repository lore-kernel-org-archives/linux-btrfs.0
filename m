Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB8623BCEE
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 01:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782782770; cv=none; b=lP67P9cAhA3tgmezO5tVGE1ObvF8JDYprRqJLvZr3LMeE9OQw2bP8Af2Ki2yWy6RDkOQ0nL/7cmDNEZgo5zf2SmjGXLD/l+zTUQTk1/IZDnzpiYM/vPkGTWkByHXgXdotFXho1syLv8DPfJfU2SWuxGbIK/Qj/xa2sMwx3yxGe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782782770; c=relaxed/simple;
	bh=rko1dGBneff4HJ5zacuh0UFv276rfxhIaLqznqjTNUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcmrB4XjWtAPCo1EHy+C1I9rSF33eBrF/ssp7mE7hznu5bRDxvU0VH5HQy00Hhe9XKx8RjnZvch7PED/K/AaYY+nPWIf6iG9Ig0YnAYklK63Ao/0DVb5OFOn0XRJY9+HrhckBifZ0AsGrhL0avaQdcG4SFuWWI63GaSFJOnvZBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nYjXiJyt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UMXRZSvo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nYjXiJyt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UMXRZSvo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nYjXiJyt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UMXRZSvo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nYjXiJyt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UMXRZSvo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 93922733B1;
	Tue, 30 Jun 2026 01:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782782758;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RWtyheR9hw0Ikqdy80GrwZ4J9xlq2dR30rrios/yBo0=;
	b=nYjXiJyt3nODhKMX0wL8vv4JO+im8+2sjMZPojE6EyROaCMlSk7iCSaU9MlG5i+QZBN0ZI
	m2d5oLxeyIkv9qOvwjCvnMwLERFXLkVYNqRHOfpHIH6rqPXcGxOhgr9d7UlZ8WriwKsgtT
	16EIPY1WXv+Xelywh8bGVgI5xruNkew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782782758;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RWtyheR9hw0Ikqdy80GrwZ4J9xlq2dR30rrios/yBo0=;
	b=UMXRZSvo3mcjh9jNsGMmKVUPdB0wd56Jxojw2ewo3WImlyxhrxi4qfdSnRBsVOCgWgcH+D
	5v6JPVp+kOxscvCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782782758;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RWtyheR9hw0Ikqdy80GrwZ4J9xlq2dR30rrios/yBo0=;
	b=nYjXiJyt3nODhKMX0wL8vv4JO+im8+2sjMZPojE6EyROaCMlSk7iCSaU9MlG5i+QZBN0ZI
	m2d5oLxeyIkv9qOvwjCvnMwLERFXLkVYNqRHOfpHIH6rqPXcGxOhgr9d7UlZ8WriwKsgtT
	16EIPY1WXv+Xelywh8bGVgI5xruNkew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782782758;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RWtyheR9hw0Ikqdy80GrwZ4J9xlq2dR30rrios/yBo0=;
	b=UMXRZSvo3mcjh9jNsGMmKVUPdB0wd56Jxojw2ewo3WImlyxhrxi4qfdSnRBsVOCgWgcH+D
	5v6JPVp+kOxscvCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8768A779A8;
	Tue, 30 Jun 2026 01:25:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4ffTICYbQ2p0BAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 30 Jun 2026 01:25:58 +0000
Date: Tue, 30 Jun 2026 03:25:53 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix NULL pointer deref during assertion in
 btrfs_backref_free_node()
Message-ID: <20260630012553.GE2398896@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8bc196601d6cd471a97a175a3f328425e1efc62f.1782745731.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bc196601d6cd471a97a175a3f328425e1efc62f.1782745731.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 

On Mon, Jun 29, 2026 at 04:09:17PM +0100, fdmanana@kernel.org wrote:
>   ASSERT(node->eb == NULL, "node->eb->start=%llu", node->eb->start);

> It seems that this happens on some systems for some reason, when the
> ASSERT() macro calls the inline function verify_assert_printk_format()
> to evaluate the format string and arguments, causing the NULL pointer
> dereference on node->eb.

I wonder what are the conditions that lead to generating code for the
assertion and verify_assert_printk_format() in particular. It's a static
inline so lots of space for optimizing out everything.

There was a review report

https://sashiko.dev/#/patchset/b6f6b52824e4b9e6ee9f883e09e53da9eb8152ee.1780409231.git.fdmanana%40suse.com

that we discussed on slack and my compilation test did not generate any
code for it and your actual test run did not hit the crash.

So for any verbose assertion we must assume the printk expressions must
be valid in connection with the condition being either true or false. I
don't think we can check or enforce that by tools, so we remember that
or get reminded by sashiko.

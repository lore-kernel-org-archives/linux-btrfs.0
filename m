Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C651361DBF
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 19:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776885267; cv=none; b=BXtZX7R4l1mBI35B7PvMWH1n2gW+8kfa4b3qthIInYrP3SAkdXAGcM7zlHYaGx/9BBteBYNIWFKrTpyEQnRxDQGbMYu1+Itk+6Bnr7jhH4rRjJ49fEox1uEUZt4CgqQF39+lR3DcJsFMFsvlcrm7kGuZlrxan/5z3sJxZUyM/uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776885267; c=relaxed/simple;
	bh=v3k6BW0VjtHYSkTtjZWNvzXiA+F5vkZY+kYFdoYFF6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NTcYpNLVCfKsWIDWaYGq8MACQK4WBxm6nuVFO5XFatwiBXewL6zoNGLP+owMnspcETQdCndtnRk2o9ldpLk4SQmfya7FFBkAG3XHoKaQO8jkZ8kMvjT2zbdU5CzpwOH95yaM0erTOjyxPcElgpGG7kHMCVoN8RnKXL97bX0b4Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=REnHlWwN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hj/9OoPc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=REnHlWwN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hj/9OoPc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="REnHlWwN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hj/9OoPc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="REnHlWwN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hj/9OoPc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 48EE46A827;
	Wed, 22 Apr 2026 19:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776885255;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kVuxbSAzewsAYv8/qYWz0g/O7K1OXFm7e8ZlxXnfSt0=;
	b=REnHlWwNhU+aY9Fe7p+ZajDg+lfd0uFecBx1jOdTU0hn6kEFp6Z9Bf2E5Pz2d7C2hhEZNz
	YqUtg3r4rlpSQ3+bsxiBcsZX05/iEKYemleZbTCA+L1bpRRhq4f5JYClOVT0IjKgfmEHBI
	VkfwFdSsYyGaNmnpKWbhd284Rj8bnRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776885255;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kVuxbSAzewsAYv8/qYWz0g/O7K1OXFm7e8ZlxXnfSt0=;
	b=hj/9OoPci7zg8PPoyMK0MyMxe3VC2eAGp6yMRvAy6bpbYPxDfjounNHVHFtjkvEqgKhrP0
	/9O821rA4F0IZDDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776885255;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kVuxbSAzewsAYv8/qYWz0g/O7K1OXFm7e8ZlxXnfSt0=;
	b=REnHlWwNhU+aY9Fe7p+ZajDg+lfd0uFecBx1jOdTU0hn6kEFp6Z9Bf2E5Pz2d7C2hhEZNz
	YqUtg3r4rlpSQ3+bsxiBcsZX05/iEKYemleZbTCA+L1bpRRhq4f5JYClOVT0IjKgfmEHBI
	VkfwFdSsYyGaNmnpKWbhd284Rj8bnRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776885255;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kVuxbSAzewsAYv8/qYWz0g/O7K1OXFm7e8ZlxXnfSt0=;
	b=hj/9OoPci7zg8PPoyMK0MyMxe3VC2eAGp6yMRvAy6bpbYPxDfjounNHVHFtjkvEqgKhrP0
	/9O821rA4F0IZDDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EAD4593AF;
	Wed, 22 Apr 2026 19:14:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TleCBgce6WnqegAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 22 Apr 2026 19:14:15 +0000
Date: Wed, 22 Apr 2026 21:14:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Aleksandar Gerasimovski <Aleksandar.Gerasimovski@belden.com>
Cc: Sasha Levin <sashal@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Rene Straub <Rene.Straub@belden.com>,
	Filipe Manana <fdmanana@suse.com>, Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>, "clm@fb.com" <clm@fb.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 7.0-5.10] btrfs: be less aggressive with metadata
 overcommit when we can do full flushing
Message-ID: <20260422191413.GG12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260420132314.1023554-1-sashal@kernel.org>
 <20260420132314.1023554-174-sashal@kernel.org>
 <SA1PR18MB56923AA957ABED674340E52C992D2@SA1PR18MB5692.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR18MB56923AA957ABED674340E52C992D2@SA1PR18MB5692.namprd18.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Apr 22, 2026 at 12:24:52PM +0000, Aleksandar Gerasimovski wrote:
> Hi everyone,
> 
> Can you add Rene's tag to the reporter as well, he was the one seeing
> and triggering the that internally and I continued with following that
> with the mailing list:

Technically the Reported-by tag can be added but that would be only for
the stable patches and I don't think this has even been done. Credits
are collected before the patch is merged, after that it's immutable
(574d93fc62e2).

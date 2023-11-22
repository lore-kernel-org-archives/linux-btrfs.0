Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hPDpkkem";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mp6//vQl"
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76135D52;
	Wed, 22 Nov 2023 05:27:21 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2925C21921;
	Wed, 22 Nov 2023 13:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1700659640;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=06UQgvsDM53FhAa50yA1PK2H2q0c8nNVYFtY8QHFOPk=;
	b=hPDpkkemSi/LHTp/83GdAddL+tceDWiAUaJYsuNGU4bpa5N+xRZOoLGNkaAKE2shTFp2Q2
	CyvvQfiDHQ4rierXtVcw+ZAxpxLVhx2gR2H8Zh+/PpNdgFqgb6IVlPZ7AHmdKi+pD/x7YJ
	kk9XE3197KwPHg4FP4d9kQls2OEbpm0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1700659640;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=06UQgvsDM53FhAa50yA1PK2H2q0c8nNVYFtY8QHFOPk=;
	b=mp6//vQlfM7M5vChcsh6kH92WmuRK5LTLD1uO1K+YyW17cFcV4fyHZ+gSOAQHz99AZHhFf
	J7thqYdRx9Ys5BCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E61B313467;
	Wed, 22 Nov 2023 13:27:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id vXxfN7cBXmVJagAAMHmgww
	(envelope-from <dsterba@suse.cz>); Wed, 22 Nov 2023 13:27:19 +0000
Date: Wed, 22 Nov 2023 14:20:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH 1/5] btrfs: rename EXTENT_BUFFER_NO_CHECK to
 EXTENT_BUFFER_CANCELLED
Message-ID: <20231122132010.GY11264@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20231121-josef-generic-163-v1-0-049e37185841@wdc.com>
 <20231121-josef-generic-163-v1-1-049e37185841@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121-josef-generic-163-v1-1-049e37185841@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -5.11
X-Spamd-Result: default: False [-5.11 / 50.00];
	 ARC_NA(0.00)[];
	 HAS_REPLYTO(0.30)[dsterba@suse.cz];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLYTO_ADDR_EQ_FROM(0.00)[];
	 REPLY(-4.00)[];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.11)[65.94%]

On Tue, Nov 21, 2023 at 08:32:30AM -0800, Johannes Thumshirn wrote:
> EXTENT_BUFFER_CANCELLED better describes the state of the extent buffer,
> namely its writeout has been cancelled.

I've read the patches a few times and still can't see how the meaning of
'cancelled' fits. It's about cancelling write out yes, but I don't see
anywhere explained why and why the eb is zeroed. This could be put next
to the enum definition or to function that does the main part of the
logic. You can also rename it to CANCELLED_WRITEOUT or use _ZONED_ in
the name so it's clear that it has a special purpose etc, but as it is
now I think it should be improved.

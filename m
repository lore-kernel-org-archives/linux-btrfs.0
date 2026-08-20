Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2760F339398;
	Thu, 20 Aug 2026 12:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787227485; cv=none; b=FtUeqFQ7At3UAzxIDjr8dX1/Q8N3VZGBTyyXuNy5ITtAT1wTF8cBhwKqIH8/J+npt1GXSY3DtWCfLI1Gqt6PpcrNitXrYrDB3QMsa8uaecL/zXbgtNYb4L9TF55cOjMI6ou2BjoNRFhHARYrgjCVy6kJICCTkwK9wy/E6bG6PXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787227485; c=relaxed/simple;
	bh=oPY9MwFDH1nBhBE4pJzyglYuq1pyjVZ12hluz1Tqdec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ExBQ+YcFRreBZDFJY6cBlaauJKVXGorkvqJM34FuWmQZKI2RLipPYPVpMJvaNqLFkTjgBsVAQtqwN/W3E/1oqgLFKFt+FS2NH+U3MJ57VX2+I7v/t5GbP49YtlQ0jHnXf3uEPI98DALWBl/eEVIKGeeV3hBpfsJJhtbbSWlTZfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JmVCUADJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+NRv9kqi; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FCyNFIh1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bVoulNe1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JmVCUADJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+NRv9kqi";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FCyNFIh1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bVoulNe1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EC20C3ED5;
	Thu, 20 Aug 2026 12:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787227478;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+/wgi+uWNJcDqopiZMGg4cofqXIzIsjKBJfuo8Bec80=;
	b=JmVCUADJSVXy4GLUOn2TQweifYUHeRqTE6sMA+R+JhxSaZsIi4D5t27HkC24uLq+wLDIvN
	mQ9RmE/GuN/lAWjySaNqojlFWqICbjdN7yfK5WYxA7J1g18LzBpDRWBRj3pe27R71V77u7
	p0OBikoAwovsK7cWT/R83aZ5wNwENz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787227478;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+/wgi+uWNJcDqopiZMGg4cofqXIzIsjKBJfuo8Bec80=;
	b=+NRv9kqiDXSh43R73UXYVZFbbPr27GqYY624U3Qdk0X9xaefi2f/6GQvIjzm396nY7LhEN
	lwF3im12wJZJHxBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787227473;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+/wgi+uWNJcDqopiZMGg4cofqXIzIsjKBJfuo8Bec80=;
	b=FCyNFIh1vBjfYMlnZ/OY3gzmKU97cZ2hT5CNpK5Lv0+w+lCzrNEO8QUgLq1OedB98JX+zY
	Wqet+fMzIorE5dPV3VYk19Gy+vZmA+8+Rjbvsn6lDzL5xSh9UmRNRwGCP9ugEgaterqYGU
	zYbgj1EsStqhaneMoqa3qFcr6VkVG3E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787227473;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+/wgi+uWNJcDqopiZMGg4cofqXIzIsjKBJfuo8Bec80=;
	b=bVoulNe1r3EHWWluKYyVsQ+aT1NXH6lPMhzksJ4pZ+XQcWNh/qN/f6VlT5JGnjkt0su3+A
	DN7LnhIuTMSzA0DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D3BAE351D;
	Thu, 20 Aug 2026 12:04:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DGF1M1HthmqFXQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 20 Aug 2026 12:04:33 +0000
Date: Thu, 20 Aug 2026 14:04:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 1/6] btrfs: use an on-stack path in
 btrfs_insert_orphan_item()
Message-ID: <20260820120428.GA9053@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
 <20260811-btrfs-enomem-v3-1-46a993fc3fe5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-btrfs-enomem-v3-1-46a993fc3fe5@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Tue, Aug 11, 2026 at 02:14:54PM -0400, Jeff Layton wrote:
> btrfs_insert_orphan_item() allocated a btrfs_path with btrfs_alloc_path()
> which returns -ENOMEM on failure. It is called from btrfs_orphan_add(),
> so a path allocation failure there turns a recoverable error into a
> transaction abort.
> 
> btrfs_path is only ~112 bytes, so allocate it on the stack instead.

112 is too much for on-stack, we've avoided that for btrfs_path in
particular, except some justified cases. This means in general the
beginning of call stack like ioctl, syscall handler and such. Otherwise
we assume there are other layers in the IO stack, like block device
drivers (DM), NFS, encoding layers or networking (iscsi), and obviously
the lowest level device drivers.

The trade off with possible allocation failure vs stack consumption
needs to be argued in the changelog, "is just 112" is not sufficient.

Getting back the consumed stack space is painful, we've been reducing
unneeded or redundant parameters of functions for years. The gains are
like -8 bytes here and -8 bytes there, allocation of +112 wipes that out.

If the place of allocation is critical we can consider that but we have
too many of them, anywhere during the transaction commit path or
irreversible metadata changes. Possibly using __GFP_HIGH could work, but
I haven't explored that.

Qu added the patches to for-next but I had no chance to look closely at
this patchset yet and am hesitant to leave it like that.

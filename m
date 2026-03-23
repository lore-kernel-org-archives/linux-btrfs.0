Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943273DC4C5
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 19:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774295257; cv=none; b=R3RI9pSwEgz607qYdHZ/jGm9/KWWnvPDClb9kGuT0l/g/ApUwB5HaeTp2TemKBkQV1/N149MAUFmj2u2V9vQt2VfLpLxgA4wvdqWsCHeHnmebE+neKGiBVjAUHuxLZzyhKsSOtmyHnb7C6CBxLAjbPnGztHzGJLbUj14m3/07po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774295257; c=relaxed/simple;
	bh=WXr7Uxqfd7ZzWimGkQ0qZJa2qQrNfnB0X4JxZ0VqxZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxnIp+OsgloM6gQVGYneqpXPsyIl+dz+1Q9yeSQpk9SNedgrekJ1Gu7CmT/h5JLOa0AD8wbrB+22+e+eixDFaT1g01yC6UpFkPV+MgjzvvGZf79YnPCavLiBm1sEELgCAldB1ntNaPvY7EFrYYC58wGGbUgIffQnQJtIEkXqhng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CfcOVf+2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FZgaYQ22; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CfcOVf+2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FZgaYQ22; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CfcOVf+2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FZgaYQ22";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CfcOVf+2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FZgaYQ22"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 971355BDCC;
	Mon, 23 Mar 2026 19:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774295254;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=prLONiCqlXJiiAxHJr03M3hsqyprosNVDfpQ4OI7XGU=;
	b=CfcOVf+2EtjmXB9lMuGJGkBV2rEi8DmoLYvI4g8ObdtDFDxBADTO5q00gO7v3rW0ui7CJc
	ee9IglSpniLV7rqq3Hn8uBaDW9iMevELe7XCrnthS+XOOHoZrPUShYzh5+5+hRR6yX4rQm
	X4ABHiKMYzI8mrlQAteUJn6OEC0Y060=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774295254;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=prLONiCqlXJiiAxHJr03M3hsqyprosNVDfpQ4OI7XGU=;
	b=FZgaYQ22LNg76nbzRP0MzF7XwK31TkwHANuGS7cggIhRbKh8QIMbztPr5Pbc3/LoVrGluZ
	/xb89BX7wWuBRGAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CfcOVf+2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FZgaYQ22
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774295254;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=prLONiCqlXJiiAxHJr03M3hsqyprosNVDfpQ4OI7XGU=;
	b=CfcOVf+2EtjmXB9lMuGJGkBV2rEi8DmoLYvI4g8ObdtDFDxBADTO5q00gO7v3rW0ui7CJc
	ee9IglSpniLV7rqq3Hn8uBaDW9iMevELe7XCrnthS+XOOHoZrPUShYzh5+5+hRR6yX4rQm
	X4ABHiKMYzI8mrlQAteUJn6OEC0Y060=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774295254;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=prLONiCqlXJiiAxHJr03M3hsqyprosNVDfpQ4OI7XGU=;
	b=FZgaYQ22LNg76nbzRP0MzF7XwK31TkwHANuGS7cggIhRbKh8QIMbztPr5Pbc3/LoVrGluZ
	/xb89BX7wWuBRGAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66FB543A47;
	Mon, 23 Mar 2026 19:47:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id scjtGNaYwWlgawAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 19:47:34 +0000
Date: Mon, 23 Mar 2026 20:47:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 09/11] fs/btrfs: remove a comment referring to
 READ_ONLY_THP_FOR_FS
Message-ID: <20260323194729.GU5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-10-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323190644.1714379-10-ziy@nvidia.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto,nvidia.com:email];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	R_RATELIMIT(0.00)[to_ip_from(RLmi6urjzmorgytm9rghjcwzox)];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 971355BDCC

On Mon, Mar 23, 2026 at 03:06:42PM -0400, Zi Yan wrote:
> READ_ONLY_THP_FOR_FS is no longer present, remove related comment.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Acked-by: David Sterba <dsterba@suse.com>

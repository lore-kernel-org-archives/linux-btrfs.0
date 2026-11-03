Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712311;
	b=rEV1PJRLZAqFpPtnK/Oqb8aJ69Fx3tladj+UBbWsaiNcrvOH6mT/KkP2B0hvfA4zPNfQ
	 8qnFzwHfWPAw1KORmJG7hy96olqwgtcBvfA3xomdOOLIVSKcwzRUeziZRoSxniPE+dWUW
	 ipHbydGS5IKoqO9zdMoVM1UBsoDd3RB+WscQf1FdqT/wamW/MR0T2j5RAkJRXlkLsIPxX
	 1JEZK5Y4GVwCv7OlZexcVG6wZ++MZ0SvR64mnUhrC352Yvdc7jDtw/JMFC1XoL9p83CYX
	 LyX45/NXbee6fGPpnqIcKR5h9Oj3Cs/bzAMZeA+lGg1AfM4iFOlVN2kxyO4TB4PIfzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712311;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=Ig+S13a8vEqhb2EJ96UgMbCZDWWH93JU5OrFhKM4hSc=;
	b=4Ho66FCWEjpGgjSZDdrNmViRX00iWd1CFgX/6JbvIcBn3aHSqpFtuhbd3eQBaRvmymqM
	 Gh/oqkP0oIGQTRUuJcjvqO6gQwOfOR+DwPGEGfK+6FF8HuqbLMvVsjWzlyJa4CG2q+8Z2
	 6m3oRL7dwBY2tcYxnnZ1igdiztOg93Yxq6KzlRkVMEF4sZt6i57IyOiUZnHtM95jdpb+m
	 eBWV2LartVPcsVGIJ7ebInTHItKbBOmIaaZv1NpaVI2eJN0TfMRz9lhUq16xLGYUOuRX/
	 ZoC7d3/+eJAGzENFsfD9X0W9hbsf7bmk6W7qzP2l03pv4dgwIY3nsVH8iEYnIELqmmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=jDIYE2Wy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6S6FpgMY;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=jDIYE2Wy;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6S6FpgMY;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F1F606A327;
	Tue,  3 Nov 2026 13:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8F1F606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=jDIYE2Wy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6S6FpgMY;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=jDIYE2Wy;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6S6FpgMY
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A28131F7BC;
	Tue,  3 Nov 2026 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793712308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ig+S13a8vEqhb2EJ96UgMbCZDWWH93JU5OrFhKM4hSc=;
	b=jDIYE2WyfEg34pmcsp5C7MlEr/x+GVmfAFm124V/oYwJ3GZpUmKp5C3a7qk9I2aymIgWT8
	d7pedixGoDB+KB4mNQofMO4sbv+P7kdmDLfXjTSjqMFczzKffj1AcfI8jzZgw+F9+g4WzE
	Z6ZrRFvGKoLbi/58D705kL7qyyZZA64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793712308;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ig+S13a8vEqhb2EJ96UgMbCZDWWH93JU5OrFhKM4hSc=;
	b=6S6FpgMYG3bx+g6WkrUiadtUXmTWKgKMyBaO1W+ddpp4yaxoQru2A8S5vIn2xOpcfE9TOm
	KakV7dD4y4YfxLDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793712308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ig+S13a8vEqhb2EJ96UgMbCZDWWH93JU5OrFhKM4hSc=;
	b=jDIYE2WyfEg34pmcsp5C7MlEr/x+GVmfAFm124V/oYwJ3GZpUmKp5C3a7qk9I2aymIgWT8
	d7pedixGoDB+KB4mNQofMO4sbv+P7kdmDLfXjTSjqMFczzKffj1AcfI8jzZgw+F9+g4WzE
	Z6ZrRFvGKoLbi/58D705kL7qyyZZA64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793712308;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ig+S13a8vEqhb2EJ96UgMbCZDWWH93JU5OrFhKM4hSc=;
	b=6S6FpgMYG3bx+g6WkrUiadtUXmTWKgKMyBaO1W+ddpp4yaxoQru2A8S5vIn2xOpcfE9TOm
	KakV7dD4y4YfxLDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 772411350A;
	Tue,  3 Nov 2026 13:25:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hhHQFLTg6WqLPAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Nov 2026 13:25:08 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 08FB9B272; Tue, 03 Nov 2026 14:25:08 +0100 (CET)
Date: Tue, 3 Nov 2026 14:25:07 +0100
From: Jan Kara <jack@suse.cz>
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chris Mason <mason@kernel.org>, Jan Kara <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] add provenance time (ptime)
Message-ID: <upe7qvhod63zd724s7uiql6kanqyrcwplodoavcvqjt35vd4ee@s3iglizxejlr>
References: <20261027220532.736352-1-koray.fra@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027220532.736352-1-koray.fra@gmail.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,zeniv.linux.org.uk,kernel.org,suse.cz,gmail.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30

On Tue 27-10-26 23:05:30, koraynilay wrote:
> This is an initial implementation of a new timestamp to indicate the
> time when a file/directory was initially created.
> 
> This patch series takes inspiration from the one by Sean Smith
> <defendthedisabled@gmail.com> [1], but using
> file_setattr()/file_getattr() as suggested by Darrick J. Wong
> <djwong@kernel.org> in [2].
> 
> The semantics of this new timestamp should be at least these:
> - it should be the same as btime on a newly created file
> - it's user-settable, so it can be preserved for backups, filesystem
>   conversions, archives and any similar operation
> - it should be preserved every time mtime gets preserved
> 
> and the correspondence with the other timestamps is as follows:
> 
> ctime <-> btime
> mtime <-> ptime

One thing I miss in this series is an explanation what this new timestamp is
good for. Because frankly, I don't miss such timestamp as a Linux user :).

								Honza

> 
> Examples:
> 1) a .zsh_history file created in 2019, then after a few years the user
>    decides to switch to another filesystem, copying the .zsh_history to
>    the new home, in that case btime would have the timestamp of the copy
>    and ptime would have the 2019 timestamp (just like mtime would have
>    been preserved)
> 2) a symlink created in 2020 from the home directory to a /path going
>    through the same process as the .zsh_history, in this case it would
>    also make sense to sync the ptime to the 2020 timestamp instead of
>    keeping only the btime (so the inode creation time).
> 
> The proof-of-concept code (for testing) for stat(1) and cp(1) is
> available at https://github.com/koraynilay/coreutils (master branch)
> (Note: these coreutils code changes are a prototype and won't be
> submitted upstream as-is, but they work as expected in simple stat and
> cp -a/--preserve=ptime tests)
> 
> Lastly, the name "provenance" and "ptime" are not final, I personally
> don't have a strong opinion on any name, but while testing with stat(1)
> I noticed that "Provenance" is definitely too long for the normal
> output, so another option which would fit well is "Origin time",
> abbreviated as "ntime" (OrigiN time) and not as "otime", as that would
> conflict with btrfs' internal naming and create confusion.
> 
> Thanks.
> 
> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gmail.com
> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
> 
> koraynilay (2):
>   vfs: add provenance time (ptime)
>   btrfs: add provenance time (ptime)
> 
>  fs/btrfs/btrfs_inode.h          |  4 ++++
>  fs/btrfs/delayed-inode.c        |  6 ++++++
>  fs/btrfs/inode.c                | 17 ++++++++++++++++-
>  fs/btrfs/ioctl.c                | 12 +++++++++++-
>  fs/btrfs/print-tree.c           |  1 +
>  fs/btrfs/tree-log.c             |  3 +++
>  fs/file_attr.c                  | 24 ++++++++++++++++++++++--
>  fs/stat.c                       |  2 ++
>  include/linux/fileattr.h        | 27 ++++++++++++++++++++++++---
>  include/linux/stat.h            |  1 +
>  include/uapi/linux/btrfs_tree.h |  3 ++-
>  include/uapi/linux/fs.h         |  8 +++++++-
>  include/uapi/linux/stat.h       |  7 ++++++-
>  13 files changed, 105 insertions(+), 10 deletions(-)
> 
> 
> base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
> -- 
> 2.56.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

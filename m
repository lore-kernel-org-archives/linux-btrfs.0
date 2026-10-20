Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792537548;
	b=hUG77yZzg8X4Qm3jUxIEmO4nZfltnz73SyvGujxW0riJ5qjIVk8HP5pSPtSOxXc7wGH5
	 Z8Pn7PxMFCJrZHQHByAWbNqDvJ/00i0W2XzUgVCpwyqP+bgsDVaC8UJtFzLolr4mRADZP
	 CuqpAEAcs/76SHDZnwxlsw/lBFPkYxlUYQDrxyPUVd1RlXZULCyV7zKkizDKiP1eDyc4r
	 uoYa+BqqUPbviVG2b4Or5Pfcs8i+HodC8Aoea7fErgRCnCoWXcgg71piVs/MuUealnJ98
	 AyeR1DtDJGzRQ5DZc6/7BUuPtvtu3nJVcbdZCr/LNkTmsBscsLe1otH2srdem3l7PsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792537548;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:User-Agent:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Spamd-Result;
	bh=XKhjLKQ7pnErhWvl+DXz4TsW1tt9aS2NSVqwiX2X5VA=;
	b=1Q74Zoa14RsC0iyQjzxxz3Vwu27zTgQPAL58uHTNxFsPuF03/Y+TotLCx8hWh7xn/4PO
	 xX8s8yLl6XugQFGZq1paZBi98CK/DS/PIYDusiS8lS9ADPJjFwDUGTVRtYTn87ownRQ5i
	 b1r10cjdpqyUV0VtA3MWoxm/sAtyD2BtRfrA0+VP/mk62h6a2wd4Lpn2qWVp9eLR87qdF
	 +V4q5xfG5JRcaWYfRl3sHe4gqKIM5V4SfmVRo57GlsAPK4von54D+tqmYi7Sio4nF8Ogw
	 AVtU5XN2ATkNH7D25lxlUuReeqYW9bsCypv7a1vwqjlICZgMi9/ePfQjGt4YglIZx+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=LzXr9Rhn;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LO1zPBw4;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=LzXr9Rhn;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LO1zPBw4;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B16606A31A;
	Tue, 20 Oct 2026 23:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58B16606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=LzXr9Rhn;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LO1zPBw4;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=LzXr9Rhn;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LO1zPBw4
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2690121E5D;
	Tue, 20 Oct 2026 23:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792537545;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKhjLKQ7pnErhWvl+DXz4TsW1tt9aS2NSVqwiX2X5VA=;
	b=LzXr9RhnneuNXJLh04KCf/VYZElb3Z13KO8m33YRxtr5iFywbo4P9bnPONv/hS1oZguvoC
	xF0+zfk6tFXK8I9u1c5dN2vm8PIW/ajgvW5gr2BvxlYLcq5oS8PlRuuW7nfQHbTl7bpIDi
	h/xUU7o2d52oyI4O3QEbCghknV0U818=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792537545;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKhjLKQ7pnErhWvl+DXz4TsW1tt9aS2NSVqwiX2X5VA=;
	b=LO1zPBw4n9IZWd1hXkN9DkLd7ZdY42Buecidvv3vcaVeLeOEUn3Y7AkHJUWOSeJaVGl8Q2
	hK4CBAq2nAuSWYDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792537545;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKhjLKQ7pnErhWvl+DXz4TsW1tt9aS2NSVqwiX2X5VA=;
	b=LzXr9RhnneuNXJLh04KCf/VYZElb3Z13KO8m33YRxtr5iFywbo4P9bnPONv/hS1oZguvoC
	xF0+zfk6tFXK8I9u1c5dN2vm8PIW/ajgvW5gr2BvxlYLcq5oS8PlRuuW7nfQHbTl7bpIDi
	h/xUU7o2d52oyI4O3QEbCghknV0U818=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792537545;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKhjLKQ7pnErhWvl+DXz4TsW1tt9aS2NSVqwiX2X5VA=;
	b=LO1zPBw4n9IZWd1hXkN9DkLd7ZdY42Buecidvv3vcaVeLeOEUn3Y7AkHJUWOSeJaVGl8Q2
	hK4CBAq2nAuSWYDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E206E13872;
	Tue, 20 Oct 2026 23:05:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IdddLcjz12qcXAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 20 Oct 2026 23:05:44 +0000
Date: Wed, 21 Oct 2026 01:05:43 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?Adri=E1n_Garc=EDa?= Casado <adriangarciacasado42@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
	Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: add __printf and __cold attributes to
 do_abort_log_replay()
Message-ID: <20261020230543.GF1310987@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20261020194659.246816-1-adriangarciacasado42@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261020194659.246816-1-adriangarciacasado42@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.com:email];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]

On Tue, Oct 20, 2026 at 09:46:59PM +0200, Adrián García Casado wrote:
> do_abort_log_replay() formats its variadic arguments via struct va_format
> and %pV, and is only called in error paths when aborting log replay via
> the btrfs_abort_log_replay() macro.
> 
> Because %pV hides the format string from the compiler, GCC does not warn
> about the missing format attribute under -Wsuggest-attribute=format, and
> callers do not get compile-time format string validation.
> 
> Add the __printf(5, 6) and __cold attributes to do_abort_log_replay(),
> matching __btrfs_handle_fs_error() and __btrfs_panic().
> 
> Signed-off-by: Adrián García Casado <adriangarciacasado42@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>

It's a bit confusing that the function definition
__btrfs_handle_fs_error and __btrfs_panic don't have the __printf
annotation, only __cold. It's sufficient to have them only at the
declaration. This would be good to unify, either have it both
declaration+definition or only declaration for the public functions.

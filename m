Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CF21D5CE0
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 12:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784637132; cv=none; b=REV8zVm2Nm+gTcbAsXUnK+WenMPhbI/PkA4pPbXHuEaUNZfP5HeijN+0RMz3Faj7ulY8TtJfZNGuBMbTBCxfAt78FZ3PPL67+16C1N1Kd1+I0qjxV4FObgF0Yl766va8tmDEPGhW8BRB2cseI95hWNS7Vz27vLgLDRNayyrkqYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784637132; c=relaxed/simple;
	bh=7Z8jcEyC3gbjh4BzZGCbdLvTjLw1lN5FgLvlAlr48Y8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VLLRIEa/8IbkW6ybnU/JQh8USrFKrLqYGmWx2UiGiT4Eg8hVHZtx/iltuZHeae6YG+ODzNmE3hSOs3TKUjqrY6LfF8NnC13rWU3WoUdXQ8OQ80vaYmt2jPgnsZ+iWUgv2nGCFrvVdZmQV1gCWR9BQHiYj8YRo6kF3y9s54kN9hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MJ8Tk/tz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=465JPw81; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nAZxrBpk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RIxjp+0g; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MJ8Tk/tz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="465JPw81";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nAZxrBpk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RIxjp+0g"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A082D7A4FB;
	Tue, 21 Jul 2026 12:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784637128;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e9nzk1R41YyQ+ooWjGh3sO/Pjrr6nn/N0OLfzNxRSjc=;
	b=MJ8Tk/tzvtkYSU0ITpL6S4DeCitlKbSrg8UNgcaN0aXCfi0UB0/REwFLQhpfVQ5ySGl0TS
	DPaTzoVylLcETyizTiA1bKI/gfGk0A4hHgJrSOgnH7caHw67mtg47FnTMlpiS9WcnDZMP3
	K8K4VEpXZ3zoevh/QlpGrilP9qmdqfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784637128;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e9nzk1R41YyQ+ooWjGh3sO/Pjrr6nn/N0OLfzNxRSjc=;
	b=465JPw81pH7dyTUgPFuiqzqJ0l9/HFwKU9JRQWsQosIIKqd2LLXo0HNZf8Qn2xcuv5EF1R
	5PQ/iB2HbI6+vOBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nAZxrBpk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RIxjp+0g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784637127;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e9nzk1R41YyQ+ooWjGh3sO/Pjrr6nn/N0OLfzNxRSjc=;
	b=nAZxrBpkP4OrzTy/4j5XIq0S2vUMoByMJWTaKXrvysmq/EdzcEAIFjKuUFx0cf5lrbmem8
	XBAqrRifdSpK33B7vCpcv4ZutD0kxRuKZcrIrck4ZnLerEodiE9hD03EwcPd7/yqqvh3jU
	xZQle1RB0we6y63upY3sMF7u1z9eNK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784637127;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e9nzk1R41YyQ+ooWjGh3sO/Pjrr6nn/N0OLfzNxRSjc=;
	b=RIxjp+0gpBR1kzbk4KqtW/IUy+HX+HDEV3GYiza86TMJ2JMmZZFF3Xsgnv9Tr/g4glqGu+
	qRX0hWoK3ZYl5HDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 904F5779AA;
	Tue, 21 Jul 2026 12:32:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ueYDI8dmX2pxUQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 21 Jul 2026 12:32:07 +0000
Date: Tue, 21 Jul 2026 14:32:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Chengfeng Lin <lin2530632123@gmail.com>
Cc: Leo Martins <loemra.dev@gmail.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, kernel-team@fb.com,
	Filipe Manana <fdmanana@kernel.org>, Boris Burkov <boris@bur.io>,
	Sun YangKai <sunk67188@gmail.com>,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v2] btrfs: replace writeback inhibition xarray with a
 fixed inline buffer
Message-ID: <20260721123202.GK10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CANGjgd=fQkHht2PdDi-+EAdzWH7UtxxWhhJ7b80Rr17PbpgxOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANGjgd=fQkHht2PdDi-+EAdzWH7UtxxWhhJ7b80Rr17PbpgxOw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A082D7A4FB
X-Spam-Flag: NO
X-Spam-Score: -2.71
X-Spam-Level: 
X-Spamd-Result: default: False [-2.71 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,suse.com,vger.kernel.org,fb.com,kernel.org,bur.io,intel.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Fri, Jul 17, 2026 at 01:11:11AM +0800, Chengfeng Lin wrote:
> Hi Leo,
> 
> I independently tested the exact v2 code diff on a physical x86-64 machine.
> In this narrow synthetic Btrfs remap-range microbenchmark, it was consistently
> faster than the unpatched xarray control.  This is not an application
> workload.  It also differs from the LKP fio 4 KiB random-write case: this test
> exercises the same Btrfs writeback-inhibition functions through 4 KiB clone
> and dedupe ioctls.
> 
> I applied the code diff from this v2 message to a frozen Linux 7.1.0 source
> snapshot containing the Btrfs change at
> f9a48549a15aa369d42cebc08a6a72b71a53d547.  The exact saved diff used for the
> build has SHA-256
> 5ec741be5a89d6dae0c0608cc036512770b55d6a49e9b576b4aa3115ebfdffd3.
> Aside from the v2 diff, the control and patched kernels used the same base
> source snapshot, normalized config, GCC 15.2.0 toolchain and Kbuild metadata,
> with `CONFIG_PREEMPT_DYNAMIC=y` and `preempt=none`.
> 
> The machine was an Intel Core i7-12700KF system with 20 logical CPUs and
> 32 GiB RAM.  For each kernel point I created a fresh Btrfs filesystem on a
> 1 GiB RAM-backed brd device.  The timed process was pinned to P-core logical
> CPU 2 with the `intel_pstate` `performance` governor.  Each point ran 15
> rounds; each round performed 10,000 4 KiB FICLONERANGE operations and 10,000
> 4 KiB FIDEDUPERANGE operations.
> 
> In a control -> v2 -> control sandwich, the means across all 15 rounds were in
> ns/op (lower is better):
> 
>   operation          control A   v2         control B   v2 vs control midpoint
>   FICLONERANGE 4 KiB  2943.790    2159.123   2970.446    -26.986%
>   FIDEDUPERANGE 4 KiB 3535.456    2762.835   3546.942    -21.980%
> 
> The two control points drifted by only 0.905% for clone and 0.325% for dedupe.
> Dropping the first round from each point produced deltas of -27.178% and
> -22.128%.
> 
> All 90 timing rows passed the semantic checks: expected_match_ratio=100 and
> unexpected_results=0.  A separate ftrace direct-hit run on the v2 kernel with
> 1,000 clone plus 1,000 dedupe operations observed 2,000 calls to
> btrfs_remap_file_range, 7,473 to btrfs_inhibit_eb_writeback, and 2,033 to
> btrfs_uninhibit_all_eb_writeback.
> 
> For this specific brd-backed 4 KiB clone/dedupe workload, v2 reduced the
> measured per-operation latency relative to the unpatched xarray control by
> about 27% for clone and 22% for dedupe.  I have not tested application-level
> impact, physical-storage impact, or a broad filesystem matrix.  The Tested-by
> below applies to the v2 code diff identified by this message and the SHA-256
> above.
> 
> Evidence bundle:
> 
>   https://github.com/lcf0399/linux-regression-evidence/tree/7e47ea94a4d151610f16e98429efc3c3b8865265/btrfs-remap-writeback-inhibition-v2
> 
> Standalone workload:
> 
>   https://github.com/lcf0399/linux-regression-evidence/tree/7e47ea94a4d151610f16e98429efc3c3b8865265/btrfs-remap-writeback-inhibition-v2/reproducer
> 
> Tested-by: Chengfeng Lin <lin2530632123@gmail.com>

Thanks for the report, I've added link to the patch.

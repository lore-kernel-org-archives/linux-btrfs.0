Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0891CA6B
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 00:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782779577; cv=none; b=jpnlijExGW1zV08A1p99L9H/4G9OdFm08VZRroi2O6hZtNt05RQ6yGCfdLLGPmaX8IT7TEvclwW/Y3jdGE3pXW7cVI2E2/76SPmkJzmwFuQ3eg6IsmmuW7+W8/XrNC3TKB24zAwJ+MUsQ5YwTH/7N1h1i6+OVwKOSjN2v8hbr8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782779577; c=relaxed/simple;
	bh=EDxEOT3gvIJ8/wA3o9p8++aEEHYfbB/jBrRZJ2EVaig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDBeS2ww6xUB3hx/pgWvI8NL+TSB5ZFxaENpgqJgb4LacJaxyREnl1GfuCXgCPpD/yFArvqO+fi0natXXqCv3t0kO7NdPBm4vGN7hEr+2UlemUkAOarS+hUQF09Lg9kV6wZVri9ceBuub3KMrTsaY8S3r5MbJPrmSdv9wlDBy+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MgF64HRx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pKqvGZ/y; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mltxUtT1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Iki+oOqc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MgF64HRx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pKqvGZ/y";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mltxUtT1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Iki+oOqc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D6AB67336D;
	Tue, 30 Jun 2026 00:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782779574;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UESE60JHIs+CWEtBRXRW5+zlue1Qd5KBJQO+FipUKUU=;
	b=MgF64HRxa0PWS8FnPK/Zha5U1RQD5iF2YSqLigzemoupPjltCvYx84uuGPHr9eABblWLOL
	b0wEJ6DqmDOKytBxpaL0i5oHNwffeGYbjMtSWgwR8Z3bm6GtgFajuFRaKIanXkNtRK9TJ6
	08opQy+2hWVWbqvy/pXxOm52wrzzhk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782779574;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UESE60JHIs+CWEtBRXRW5+zlue1Qd5KBJQO+FipUKUU=;
	b=pKqvGZ/yiDZbeNWcNfDHMJnfqqGpVLgVdh6LIooHlFjQ9SUQnMJf7MtFPfaGI7/i9iaZQM
	36hfkFfOPBBCP5BQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782779573;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UESE60JHIs+CWEtBRXRW5+zlue1Qd5KBJQO+FipUKUU=;
	b=mltxUtT1vlMWgYHIC28Qvslgzp6DhIjXH8QFqKeTOkiDL3fLDerySGPpHtLKPIPfTrvIcd
	u4lySO0cI/qkgEg3ZaJMdx5UAqlr/WgubQ2JI97zYnWwEiU+mH9HiPlMaFfL8tcCxJhwKK
	7IAzSedGhyNyr+5ZxEIHo3r7FwHBzFM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782779573;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UESE60JHIs+CWEtBRXRW5+zlue1Qd5KBJQO+FipUKUU=;
	b=Iki+oOqcEIfR4gEgEfJoHNH6nJ2ZLoVC+KEkuc1mkkkiUeLHB+Yz3y+VLydQcReD8MGlGw
	5vyDe6KUQ5qPGhBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BBF34779A8;
	Tue, 30 Jun 2026 00:32:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GcKmLbUOQ2pbUgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 30 Jun 2026 00:32:53 +0000
Date: Tue, 30 Jun 2026 02:32:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Dave Chen <davechen@synology.com>, linux-btrfs@vger.kernel.org,
	dsterba@suse.com, cccheng@synology.com
Subject: Re: [PATCH] btrfs: fix u32 to s64 type conversion in
 dirty_metadata_bytes accounting
Message-ID: <20260630003252.GC2398896@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260629070843.4116053-1-davechen@synology.com>
 <CAL3q7H5x_nz79nJv418DpWCeU=Pk3Q7zL3cCDpNNtj2to0ij9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H5x_nz79nJv418DpWCeU=Pk3Q7zL3cCDpNNtj2to0ij9w@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Score: -4.00

On Mon, Jun 29, 2026 at 01:08:05PM +0100, Filipe Manana wrote:
> On Mon, Jun 29, 2026 at 8:09 AM Dave Chen <davechen@synology.com> wrote:
> >
> > The percpu_counter dirty_metadata_bytes is updated by negating eb->len
> > and passing it to percpu_counter_add_batch(), whose amount parameter is
> > s64.  Since commit 84cda1a6087d ("btrfs: cache folio size and shift in
> > extent_buffer"), eb->len is u32.  The u32 result of -eb->len, when
> > widened to the s64 parameter, becomes a large positive value instead of
> > the intended negative value.  For eb->len == 16384 the counter adds
> > +4294950912 instead of subtracting 16384.
> >
> > The counter therefore grows on every metadata writeback instead of
> > shrinking by the extent buffer size, permanently exceeding
> > BTRFS_DIRTY_METADATA_THRESH and causing __btrfs_btree_balance_dirty()
> > to trigger balance_dirty_pages_ratelimited() unconditionally, adding
> > unnecessary writeback pressure.
> >
> > Cast eb->len to s64 before negation at both call sites so the
> > subtraction is performed in signed 64-bit arithmetic.
> >
> > Signed-off-by: Dave Chen <davechen@synology.com>
> 
> Curious, do you have any performance data to give an idea of the impact?
> 
> I'm asking not only for clarity but also to determine if adding a
> Fixes tag for stable backports makes sense.
> The commit that caused this issue is 84cda1a6087d ("btrfs: cache folio
> size and shift in extent_buffer"), which changed struct
> extent_buffer::len from unsigned long (64-bit on 64 bits platforms) to
> u32.

Oh my that's very well hidden signedness bug. I'd rather not rely on the
correct implicit conversions and add a helper like
percpu_counter_sub_batch() that takes the positive value to subtract and
correctly casts it to s64 inside.

We have more places with negative unsigned value passed to
percpu_counter_add_batch(), e.g. in btrfs_remove_ordered_extent().  The
entry->num_bytes is u64 so it's correct.

In the rest of kernel the negative values are not used frequently, in
xfs, networking, bpf.

This fix can go in as-is as it's minimal, the API update can follow so
we can be sure gems like

lib/flex_proportions.c:fprop_reflect_period_percpu()

		percpu_counter_add_batch(&pl->events,
                       -val + (val >> (period-pl->period)), PROP_BATCH);

can be made more understandable.

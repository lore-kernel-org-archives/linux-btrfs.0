Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC5F285CBA
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 19:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789415743; cv=none; b=nTOj+q4myLViPjhhwWhWf1NvPmoyF1g25Z/ShpZwDxt0UawoMyJIDD4RFLHbzb/YsajGoz6uRQdCj2O7WqfuqnXtYzT2+ICG7GJLLITpxokJEoFPnpGTxCHmInLjU0l49g5edzuVXVWqo5GW6dOnpXOhejJTuJSJsCPpPwp4Pv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789415743; c=relaxed/simple;
	bh=OCSVbG1p0JVLCxhViyb9l2DQjQka8tuKH1yw5Cyocts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TX+0MAZ6pNH+xmwTpblQX91f3UQ6ZawPuDc9SHEkP8lrLlXBj2mVUfN4NqIqbe4kD5ocIVNnAcLNmwM8ow3tARkWimaOnmTwq7Vamm+c+naWeM9ZRZx32+P5PSvsXXQ/mU5hh6m7qYTbd0DpeEKVUzOMMs4fIFl0nw7U7ojdD30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0MORLPQC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yW3dTzEd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mCek5FKa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uB+s2pgR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0MORLPQC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yW3dTzEd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mCek5FKa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uB+s2pgR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D3ADE21C46;
	Mon, 14 Sep 2026 19:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789415736;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KNaROsHSEE18lxcGShaWo+aBp9UBjyiWjMsEkz/m4LU=;
	b=0MORLPQC3oPq+BpG5fxHVCURbARLwLmwz+qq9grdDSL0U6qK2nkRh+a6HcTsoMIXqETCHW
	GtT4dKyETTm+4hpxOH1WpQaJEEwl7Ji1OkN6OvzNcryNBKTV0LnZMpGemVMHu5oAxZeG1x
	5QV+kKjl67bo+oIHKbGEdU+LZU/c0NM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789415736;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KNaROsHSEE18lxcGShaWo+aBp9UBjyiWjMsEkz/m4LU=;
	b=yW3dTzEdc+lnigiLpYBMeRPVvuY01+JUj6ghfZCUSxj4lg43TMjl+c2tlmPfVQ7MixGCXu
	YtLtTRHYB94i4hCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mCek5FKa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uB+s2pgR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789415731;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KNaROsHSEE18lxcGShaWo+aBp9UBjyiWjMsEkz/m4LU=;
	b=mCek5FKaNjSxRLkegKpns0L9MiI99hZmuw7+1AIuFYhL/0fBF6485iYY+3W6XnaRUHZqsc
	JYt0Hjxs6REH/mB0Nk1iifIYls3wQ9NWE9rh7n4xXBHJXk93uUbA8NrDj+We/ORVtG1+/2
	3fXadvy8GbhOIekfUs+G/CBKOr0EmOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789415731;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KNaROsHSEE18lxcGShaWo+aBp9UBjyiWjMsEkz/m4LU=;
	b=uB+s2pgRgHLXyj7HJXLr0ZizUFWJm4uo7VDNWpMftsv1CMUSSkj/7g7Eaio8/eJPIe5ljr
	EYeRUxaxK/nlnEAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A5C4D13515;
	Mon, 14 Sep 2026 19:55:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3pZDKDNRqGorAwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 19:55:31 +0000
Date: Mon, 14 Sep 2026 21:55:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v2 0/2] btrfs-progs: fix stale active zone after mkfs
Message-ID: <20260914195530.GS54722@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260904062444.3467618-1-johannes.thumshirn@wdc.com>
 <20260914174012.GR54722@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914174012.GR54722@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D3ADE21C46
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:mid,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Mon, Sep 14, 2026 at 07:40:12PM +0200, David Sterba wrote:
> On Fri, Sep 04, 2026 at 08:24:42AM +0200, Johannes Thumshirn wrote:
> > On zoned devices, mkfs can leave a stale zone behind that is used as a
> > staging area but never reset. This zone is not backed by a chunk or
> > device extent, so the FS itself does not account it as used. On devices
> > that have a limitied active zone budget this can lead to premature
> > ENOSPC and/or an exhaustion of active zones.
> > 
> > Fix it in mkfs for new file-systems and also add a check to fsck to find
> > such zones and repair them with '--repair'.
> > 
> > Changes to v1:
> > - fix a bug in fsck where it had a stale return value propagated.
> > 
> > Johannes Thumshirn (2):
> >   btrfs-progs: zoned: refresh stale cached zone state in
> >     btrfs_reset_dev_zone()
> >   btrfs-progs: check: detect leaked active zones on zoned devices
> 
> The build fails on older distros (Centos 8, Leap 15.3/16.0):
> 
>   CC       check/main.o
> check/main.c: In function 'check_zoned_active_zones':
> check/main.c:9220:12: error: 'struct blk_zone' has no member named 'type'
>     if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
>             ^~
> check/main.c:9220:22: error: 'BLK_ZONE_TYPE_CONVENTIONAL' undeclared (first use in this function)
>     if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
> check/main.c:9220:22: note: each undeclared identifier is reported only once for each function it appears in
> check/main.c:9222:12: error: 'struct blk_zone' has no member named 'cond'
>     if (zone->cond == BLK_ZONE_COND_EMPTY)
>             ^~
> check/main.c:9222:22: error: 'BLK_ZONE_COND_EMPTY' undeclared (first use in this function)
>     if (zone->cond == BLK_ZONE_COND_EMPTY)
>                       ^~~~~~~~~~~~~~~~~~~
> 
> The types were added in f5f2bad67a45 ("block: make the new blkzoned UAPI
> constants discoverable") in 2016 and with the rest of the zoned userspace code
> so it's not something recent.
> 
> I haven't looked what's the problem, this should be reproducible locally using
> the "ci/ci-centos8" scripts (needs docker).

It fails with --disable-zoned, regardless if the zoned headers are
present or complete. Centos 8 build fine with --enable-zoned, I don't
know when it started to work. On Leap 15.3 the header is only partial,
lacks zone capacity, so it must be disabled.

As a fix an #ifdef around check_zoned_active_zones() should work.

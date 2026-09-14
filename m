Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA64449551A
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 17:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789407626; cv=none; b=qG0N/3zc9ONI+1NBS2kfVvrEhCx7Ah4rUx6/FY6B2t27/2ZK21Quj22YSnupof8EkpWKqp4PaPQIGlaaZMN4DStRZsqkXQUsFEVRNQyCjEpDte8gXvtOH+bFyGJuE2fy8qIUjOodEWAIDOMSl6C5I+Pkbb9YlYGpYRr7TOkhmSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789407626; c=relaxed/simple;
	bh=GnssOQHpSJG+jdPM4vkll7FKGOM2qNLronIwDCzc8F0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1vGG+tM+644toAKKQHNjn+f5ltSFtfINgDCRWGEKWSmI5qQlL3+3i8HwH1fmLScUv2wliLVxTtkInNYa0GhY80I59LIeEySUbu4TP1wb3ZMZUWyxg2zl/1t81pcp8s2VjTZuL5D+ZtVaKZmeO2Sb6braQb+NPk5Ponb0jE2QOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L61Gdj4j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OWLKKngD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Gd3A4MTC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Mb6+rTPM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L61Gdj4j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OWLKKngD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Gd3A4MTC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Mb6+rTPM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5368121D8F;
	Mon, 14 Sep 2026 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789407618;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/E3ZxvRJzapinVukHfzhswMdq1kVvzDnFHs701vkROo=;
	b=L61Gdj4jhJ90MXCr22JFFAk2UaK6UekG3LWotHYK7p01g/FyCyWmDaOUww0Z4dLNtWgu8n
	iNtIU2iVR4m3ax73v3dkh5uUOmQ2JMZ0K2tZD4G45DPWkEopoHpMct9YvxZvBsAcs5vHRO
	zw9lbUe5hlkP+Pbtc/gGTZhK5bybPbk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789407618;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/E3ZxvRJzapinVukHfzhswMdq1kVvzDnFHs701vkROo=;
	b=OWLKKngDOTokieuIAeD2TdqFLo4ndufMfFy0gsBL/pYUP7ejhVnOPcSTH+uLmUYvQ7utlu
	mO76zXQp8enOs7BQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789407614;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/E3ZxvRJzapinVukHfzhswMdq1kVvzDnFHs701vkROo=;
	b=Gd3A4MTCafJItvJg07BiTD7vmLrrS+oV2oZeUNcy6r+wLk6x6mfU5qwkwP4NFn4B+It1XN
	hWB2oOryZug58+letowauGMLVPEsn1jZ9DwKJzoQaTSPXz/sG3p/pCsvfnAoi9cPby0jMI
	cbzpQ3xE/2noWdM2SYk1zAOi/Pgs8XA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789407614;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/E3ZxvRJzapinVukHfzhswMdq1kVvzDnFHs701vkROo=;
	b=Mb6+rTPMlvRhJjCNJN1erLpK8FPF9uxii1fE9ewo5U6bt9Sg3nRUxsnQdBCmJOekDcv0go
	MLInnaqQu4Ul27Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2659D1368C;
	Mon, 14 Sep 2026 17:40:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F4YoCX4xqGoOeAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 17:40:14 +0000
Date: Mon, 14 Sep 2026 19:40:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v2 0/2] btrfs-progs: fix stale active zone after mkfs
Message-ID: <20260914174012.GR54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260904062444.3467618-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904062444.3467618-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,twin.jikos.cz:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]

On Fri, Sep 04, 2026 at 08:24:42AM +0200, Johannes Thumshirn wrote:
> On zoned devices, mkfs can leave a stale zone behind that is used as a
> staging area but never reset. This zone is not backed by a chunk or
> device extent, so the FS itself does not account it as used. On devices
> that have a limitied active zone budget this can lead to premature
> ENOSPC and/or an exhaustion of active zones.
> 
> Fix it in mkfs for new file-systems and also add a check to fsck to find
> such zones and repair them with '--repair'.
> 
> Changes to v1:
> - fix a bug in fsck where it had a stale return value propagated.
> 
> Johannes Thumshirn (2):
>   btrfs-progs: zoned: refresh stale cached zone state in
>     btrfs_reset_dev_zone()
>   btrfs-progs: check: detect leaked active zones on zoned devices

The build fails on older distros (Centos 8, Leap 15.3/16.0):

  CC       check/main.o
check/main.c: In function 'check_zoned_active_zones':
check/main.c:9220:12: error: 'struct blk_zone' has no member named 'type'
    if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
            ^~
check/main.c:9220:22: error: 'BLK_ZONE_TYPE_CONVENTIONAL' undeclared (first use in this function)
    if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
check/main.c:9220:22: note: each undeclared identifier is reported only once for each function it appears in
check/main.c:9222:12: error: 'struct blk_zone' has no member named 'cond'
    if (zone->cond == BLK_ZONE_COND_EMPTY)
            ^~
check/main.c:9222:22: error: 'BLK_ZONE_COND_EMPTY' undeclared (first use in this function)
    if (zone->cond == BLK_ZONE_COND_EMPTY)
                      ^~~~~~~~~~~~~~~~~~~

The types were added in f5f2bad67a45 ("block: make the new blkzoned UAPI
constants discoverable") in 2016 and with the rest of the zoned userspace code
so it's not something recent.

I haven't looked what's the problem, this should be reproducible locally using
the "ci/ci-centos8" scripts (needs docker).

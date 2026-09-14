Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025B339EF3F
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 20:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789417607; cv=none; b=rrsIxS8q/q+jqwz4GpGgmvYZ+05pr2JBbcEc3ubhZMfLVqRLXP7uY3tEzDd9DzQFLlQrqBoWLExqz8djqukbanjPixTyt8zgxcqy4gXUZISEDyPTsjL3jqAGJLA5C6Jlt0jqlA3Py23EYFnqhvQEnHaVmjfVi8LXaZ27O4IT6DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789417607; c=relaxed/simple;
	bh=Ct0MvktwNUPSHO2RlB82DbD3YcYkrcwwVTWETsr1q9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBtSFAcsxZKvi69+ehAheaZvblgghwKXBxA3GFwjHgPIOJRW3YLWciCzxi33w2NCdnZn8QruVM2D79sSJkWNPZIiK2ON4ULjmR2RSAoxpK/A1rmkO2A0OL+fckGqY4Xmb5TOIo74N0krr4abdv1moADLHvbRkepQ8VkVEIAy7Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VkcnKGsT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PoaLjZFH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Sh4c6Wr/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ar2pVXxC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VkcnKGsT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PoaLjZFH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Sh4c6Wr/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ar2pVXxC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BBAF41FF51;
	Mon, 14 Sep 2026 20:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789417599;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=up+sOIOcneBe9aTLHh+JzbIU7RqahvtniqXqiOvazBA=;
	b=VkcnKGsT3j/8VR0XcNW29i/HZTwzZkbH46cUyAlRnJ4XENTP24D4ZPZ9luUz/coK+jaOaS
	URiSdn1wOa0+VSZgY+WhaAY+HIgDhckPT21pEEhG4Ccj1qcJyeXsk3LZsbdndw+QvOFIUE
	vo4EHybTFiGjNEFL1lKFgKjqwhMpoUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789417599;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=up+sOIOcneBe9aTLHh+JzbIU7RqahvtniqXqiOvazBA=;
	b=PoaLjZFHdGUw36UlZdrLuZUOnZm5jHnnYYOoTtyULo/zb5vmzNb2xVU9RUWgrUzMwEorl7
	7py8I+gb6sW9jACA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789417595;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=up+sOIOcneBe9aTLHh+JzbIU7RqahvtniqXqiOvazBA=;
	b=Sh4c6Wr/v+F8ojtRgRSje1L4Tbn4iKbxQmY2pA7HBpoAFt3MUdXhEdjOQr7olLFaxFXEcS
	Bc/+3HirKMSFAekc6YfuR048aFnHM2geccpAMagPQ/HOly1IgFoeQtO5KFRbaIPAjvXqaF
	l8nDINHlKlp3YjJ1qSrNdfGlUYZ26lA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789417595;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=up+sOIOcneBe9aTLHh+JzbIU7RqahvtniqXqiOvazBA=;
	b=Ar2pVXxCBDl3AxeN89FBY2qTIVuXqTjrw2wJfJf/pKSnC/P7rHcBx/1apHcM3iL+sVWIP3
	n1ZXamUwWI5hMUAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 85ABB13515;
	Mon, 14 Sep 2026 20:26:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XZ1pIHtYqGprIgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 20:26:35 +0000
Date: Mon, 14 Sep 2026 22:26:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v2 0/2] btrfs-progs: fix stale active zone after mkfs
Message-ID: <20260914202634.GT54722@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260904062444.3467618-1-johannes.thumshirn@wdc.com>
 <20260914174012.GR54722@twin.jikos.cz>
 <20260914195530.GS54722@suse.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914195530.GS54722@suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Mon, Sep 14, 2026 at 09:55:30PM +0200, David Sterba wrote:
> On Mon, Sep 14, 2026 at 07:40:12PM +0200, David Sterba wrote:
> > On Fri, Sep 04, 2026 at 08:24:42AM +0200, Johannes Thumshirn wrote:
> > > On zoned devices, mkfs can leave a stale zone behind that is used as a
> > > staging area but never reset. This zone is not backed by a chunk or
> > > device extent, so the FS itself does not account it as used. On devices
> > > that have a limitied active zone budget this can lead to premature
> > > ENOSPC and/or an exhaustion of active zones.
> > > 
> > > Fix it in mkfs for new file-systems and also add a check to fsck to find
> > > such zones and repair them with '--repair'.
> > > 
> > > Changes to v1:
> > > - fix a bug in fsck where it had a stale return value propagated.
> > > 
> > > Johannes Thumshirn (2):
> > >   btrfs-progs: zoned: refresh stale cached zone state in
> > >     btrfs_reset_dev_zone()
> > >   btrfs-progs: check: detect leaked active zones on zoned devices
> > 
> > The build fails on older distros (Centos 8, Leap 15.3/16.0):
> > 
> >   CC       check/main.o
> > check/main.c: In function 'check_zoned_active_zones':
> > check/main.c:9220:12: error: 'struct blk_zone' has no member named 'type'
> >     if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
> >             ^~
> > check/main.c:9220:22: error: 'BLK_ZONE_TYPE_CONVENTIONAL' undeclared (first use in this function)
> >     if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
> >                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > check/main.c:9220:22: note: each undeclared identifier is reported only once for each function it appears in
> > check/main.c:9222:12: error: 'struct blk_zone' has no member named 'cond'
> >     if (zone->cond == BLK_ZONE_COND_EMPTY)
> >             ^~
> > check/main.c:9222:22: error: 'BLK_ZONE_COND_EMPTY' undeclared (first use in this function)
> >     if (zone->cond == BLK_ZONE_COND_EMPTY)
> >                       ^~~~~~~~~~~~~~~~~~~
> > 
> > The types were added in f5f2bad67a45 ("block: make the new blkzoned UAPI
> > constants discoverable") in 2016 and with the rest of the zoned userspace code
> > so it's not something recent.
> > 
> > I haven't looked what's the problem, this should be reproducible locally using
> > the "ci/ci-centos8" scripts (needs docker).
> 
> It fails with --disable-zoned, regardless if the zoned headers are
> present or complete. Centos 8 build fine with --enable-zoned, I don't
> know when it started to work. On Leap 15.3 the header is only partial,
> lacks zone capacity, so it must be disabled.
> 
> As a fix an #ifdef around check_zoned_active_zones() should work.

Fixed in devel.

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCD13E9F85
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2026 13:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770213131; cv=none; b=I5iOKsGzAqwFNepCCqiBxXHehMtl/+7cuLFPwaQ/muKLqq57CRr5Ehlop8bt3dS53NymYPskeSh0uQZDnNeLj82oyLzrgvEwcD9qoyvv5NWA5oDCBSTUOWRJ830PrWCKq1eeY1e3X9+pi2tlFClib2S+2ViypobDFiXgFQwz8po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770213131; c=relaxed/simple;
	bh=0OcU8vTl37MYI54uZVQk+bmhrAE2sR1f+kN0zy+o9ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TasLFbp2vqez3K/BZWHuRQnYsd53bEw3F4EGISqdKmMfiyoK+NZk2GGhf3aTtv59JP8bXWUWxBSQp+Rv7JyhVYqjtrXAuHMENXSGx0XpjMNB3kotie0gevVp2V2xnJRMQqWEgyuxY+PCwwISFHdkI0mHlxOCm50aJL+M4wWh2Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qFS1blT1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZuPWIIj+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qFS1blT1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZuPWIIj+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qFS1blT1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZuPWIIj+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qFS1blT1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZuPWIIj+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C4E2A3E720;
	Wed,  4 Feb 2026 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770213128;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zm67DhTAaK6t4uZlzkie9RriwIw+ktaYZr8B9iwpKeo=;
	b=qFS1blT1CFAlRHqPVrmUBVkbLzpo9G71vgZYTdemqSBNgK0tIOmG7+DWDf3KPxtUovsTDi
	KgZRCf/XKpdTZo/fizZXlRTlZXImJGIOAYbOFzDRJnHhHlprOd4ijLtyNe5bvjNHCj/Bg8
	JXQ/CAlolIABKgKkrNJzA8MGNt8nEP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770213128;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zm67DhTAaK6t4uZlzkie9RriwIw+ktaYZr8B9iwpKeo=;
	b=ZuPWIIj+GfADEdJjUR+R1APzKosbrFNNXczt/UC8vRZBNCuSlsMsuz4CNT28TtsBCyRgrg
	L6gV1RwY589p1XCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qFS1blT1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZuPWIIj+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770213128;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zm67DhTAaK6t4uZlzkie9RriwIw+ktaYZr8B9iwpKeo=;
	b=qFS1blT1CFAlRHqPVrmUBVkbLzpo9G71vgZYTdemqSBNgK0tIOmG7+DWDf3KPxtUovsTDi
	KgZRCf/XKpdTZo/fizZXlRTlZXImJGIOAYbOFzDRJnHhHlprOd4ijLtyNe5bvjNHCj/Bg8
	JXQ/CAlolIABKgKkrNJzA8MGNt8nEP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770213128;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zm67DhTAaK6t4uZlzkie9RriwIw+ktaYZr8B9iwpKeo=;
	b=ZuPWIIj+GfADEdJjUR+R1APzKosbrFNNXczt/UC8vRZBNCuSlsMsuz4CNT28TtsBCyRgrg
	L6gV1RwY589p1XCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A708F3EA63;
	Wed,  4 Feb 2026 13:52:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Nj6cKAhPg2n6agAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 04 Feb 2026 13:52:08 +0000
Date: Wed, 4 Feb 2026 14:52:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/1] btrfs: tests: zoned: add selftest for zoned code
Message-ID: <20260204135203.GP26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260204073125.3173982-1-naohiro.aota@wdc.com>
 <20260204073125.3173982-2-naohiro.aota@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204073125.3173982-2-naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,wdc.com:email,twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto]
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: C4E2A3E720
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Wed, Feb 04, 2026 at 04:31:25PM +0900, Naohiro Aota wrote:
> Add a test function for the zoned code, for now it tests
> btrfs_load_block_group_by_raid_type() with various test cases. The
> load_zone_info_tests[] array defines the test cases.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Thanks, now in the 6.20 queue.

> +struct load_zone_info_test_vector load_zone_info_tests[] = {

Added static const (and test_load_zone_info() updated).

> +	/* RAID0 */
> +	/* Normal case */
> +	{
> +		.description = "RAID0: initial partial write",
> +		.raid_type = BTRFS_BLOCK_GROUP_RAID0,
> +		.num_stripes = 4,
> +		.alloc_offsets = {
> +			HALF_STRIPE_LEN, 0, 0, 0,

The zeros are implicit, but as it should match the num_stripes it looks
better as you did it.

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFB434D916
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 07:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776931038; cv=none; b=QZ1uNZDZp9drM0aMsj3gKExzrAwfvG1G60WsC11HF1wkYY4ur6NEAl2mBgSA2QYaEBji+MQV9mLfMFhusMZUiIRY4SZlexhjIGWogv9wwMd97P5MRdHpinAtubLQjJN/HuOA0z9OumpMVvAL/Jn4N6Mql8IrfM6YHWhLOc/O310=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776931038; c=relaxed/simple;
	bh=uU5YD/8rqWOlEuCl7VBrwle4b7tRuwOdt12nwA8vpn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p8rFX018TQYlojRPqBZTEqtWvRNTWAFG43NIn5yerIdSxl/l7YuPRjn+mdcDoqlHTlK1atQ/OQPEl93X/pvhfl+F/hcWVGK2vwqwQZmarQZUwT+sw77aBqG6WosRS8EJ8fR1dCO5Oo52dyFu7w5uvXiKAY1O+3fp2NG8PdBYC+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1OcAEk76; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UElwDtqb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vqiLeGXj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HJEw4Wxn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1OcAEk76";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UElwDtqb";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vqiLeGXj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HJEw4Wxn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C8ED66A823;
	Thu, 23 Apr 2026 07:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776931034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JzWCH7HrpLt5lXmaaGBfTLa9Owo7kGAgdniQq2wp3cw=;
	b=1OcAEk76PMQzVakUjm1RRVmKqX0qWK42m2UnsOw+TgEV4wzoalpkvUcCz4HIpyqdgfDIzZ
	++2RGmT+uPa/CAwjN4lGJe8kmaQCYdKlhtJ819fn5IpTKWfluBB4HBnJthXgSR6qXQBRVO
	apgITL8tDDYTodMznw3ZrLwWoFYvhRU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776931034;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JzWCH7HrpLt5lXmaaGBfTLa9Owo7kGAgdniQq2wp3cw=;
	b=UElwDtqbVyWJeQAC17sSzwT36yfj+wTxZIsOy2YVgSGRyLierYxmJegu44zu7CNl1ddmhS
	zhuYOFIrV9Wut+Bg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vqiLeGXj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HJEw4Wxn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776931033; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JzWCH7HrpLt5lXmaaGBfTLa9Owo7kGAgdniQq2wp3cw=;
	b=vqiLeGXjZhVdZxYw2ls+k5C/0SNIyNtd1Ofg0arR943eIUaxTIHR2pWGTG7wU52zQ0rhkD
	JVX4SPOYGlW4tbF14RA0A4CeEy/8kBcRI0LXNfW08VrMQt6mS4JaiqTgTrouPa8Un6V3vT
	3e0IhJsnt93nQOW9kiL/d9jf/PZDHiw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776931033;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JzWCH7HrpLt5lXmaaGBfTLa9Owo7kGAgdniQq2wp3cw=;
	b=HJEw4WxnSTV4ZA0zREJuS9pFf0OcWO10Fw2ayeY+vmV650m6Df09Tw+/v51+21JY6tQFNQ
	9jZeP6Zm3ntnSBBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A8946593A3;
	Thu, 23 Apr 2026 07:57:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 97QiKdnQ6WlmUgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 23 Apr 2026 07:57:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 50872A0A2D; Thu, 23 Apr 2026 09:57:13 +0200 (CEST)
Date: Thu, 23 Apr 2026 09:57:13 +0200
From: Jan Kara <jack@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.com>, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Limit size of bios submitted from writeback
Message-ID: <yiyxz3rhwoppms6reo7yg66fr2dvn66z5qjl43vdssl6r3inyd@dnm3jrvzilri>
References: <20260422094255.12672-2-jack@suse.cz>
 <2f467264-0f15-4ced-858e-bbfdad4dcefa@suse.com>
 <kfksarpckjgqr52rk2p2uhabgb666rfrp2hewnra7mbzbcujqr@5pwsegezuzuf>
 <13e12285-329a-46d2-8182-b6e8568275e6@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13e12285-329a-46d2-8182-b6e8568275e6@suse.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.com:email];
	FROM_HAS_DN(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim]
X-Rspamd-Queue-Id: C8ED66A823
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Thu 23-04-26 07:13:59, Qu Wenruo wrote:
> 在 2026/4/22 22:19, Jan Kara 写道:
> [...]
> > > Iterating through all chunk maps may take some time for huge filesystems.
> > 
> > Yeah, I was wondering a bit. But since this is done only on mount, I
> > figured it doesn't matter much.
> > 
> > > Meanwhile the device list is way smaller than the chunk maps, what about
> > > iterating through all devices instead?
> > 
> > I was thinking about that as well. But as you can see below, we also need
> > to know how the devices are put together in a raid and AFAIU that
> > information isn't there at the device level... If there's some better data
> > structure to iterate to get information about raid configurations of all
> > pieces of btrfs filesystem, I can certainly use that.
> 
> My idea would be just ignore the detailed RAID configuration completely.
> 
> One point is, btrfs can have more than one data profiles (e.g. during
> balance, or canceled balance, or degraded writes), and even there is only a
> single data profile, we can still have different optimized sizes, e.g.
> RAID10 on very unbalanced disks.

So these would be corner cases I'd be happy to ignore...

> Furthermore for real multi-device btrfs setup, it's very likely the data
> profile is at least striped (RAID0/RAID10), thus the huge bio will be split
> into 64K stripes by btrfs before submission already.

But this is a good point. With RAID setups btrfs is submitting one bio per
stripe (64k) anyway so there's no point in computing any larger limit. It
will never get used anyway.

> It's really affecting single-device profiles like SINGLE/DUP and mirror-only
> profiles (RAID1*), where we directly submit such huge bio to each device.
> 
> With that said, it will be much easier to ignore the complex RAID profile
> iteration, and just grab the min/max optimal io size of each device,
> multiple it by the number of disks and call it a day.

OK, you've convinced me :) I'll change to iterating all devices. Just I don't
think multiplying by the number of disks makes sense - RAID setups don't
matter as we agreed above and with simple setups you're always submitting
to a single disk at a time anyway. So I'd go for max of opt_io over all
disks.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

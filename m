Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79804346A0A
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 10:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779704235; cv=none; b=sJ4LXM3IoFVEn+JzcnR9tUxCqSl75qXcY3BaZCLKwhRI4tGYpoudg6ToFI8TmsQj9diTBlM11nom3t2HciIIwcQcpokjHHdTYC0eV874+IlKW55rDvGy1tFH8s7fAl6eFxE73u9vNWVynwHwSBe0T+PppvhV/MZ1YKHWwrYrxTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779704235; c=relaxed/simple;
	bh=OmEEm2PCDtqK32Gs6A+DDu668INb3nOxd2MaLiD8Qdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZWcPZ440OAs7FuV52+V4SOmYGjEBuYJFdWTJpPn0UHPqMMmue47EW1dkSD+7uFszTf7KUc4QEpMi/44mCBl4a6ABBuMXpyFd6p12V2y+h/J0RJZ6JxZ4DXUmGBLOSTWtAkBkbdzaVWjxrJ1FM+9i4XiIe9PP0egRDGfQdYjDbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bthwkkkE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fRLTfRV8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bthwkkkE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fRLTfRV8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bthwkkkE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fRLTfRV8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bthwkkkE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fRLTfRV8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E2B7B6B3DA;
	Mon, 25 May 2026 10:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779704232;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/hnsceYyM19/MbhX5bdjmRK4Ysicv9FRuHCSOw6CjVM=;
	b=bthwkkkEB61QH4M/2CgfobNLIhwi1is5lXxtx0d2lsfMIi+ZHAlX8fNyl+TysDiYQ7N5f7
	XqOvInMiu9e/M2YSPfhKfdawKWrH3ClmurEc5C2qLmB+vra8GLaXnWiVSj3W0Meh3hjuWT
	3SfCIhIVNRKO6r4LdBltQHJPsZUUxas=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779704232;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/hnsceYyM19/MbhX5bdjmRK4Ysicv9FRuHCSOw6CjVM=;
	b=fRLTfRV8DN+yZ297bBcYDHiuZHQLmgb0vHSB/5GFYPQK4oxgAiv9A/Czd6T8+kTNRbkQhy
	+ZFxB1LsIGzEBrDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779704232;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/hnsceYyM19/MbhX5bdjmRK4Ysicv9FRuHCSOw6CjVM=;
	b=bthwkkkEB61QH4M/2CgfobNLIhwi1is5lXxtx0d2lsfMIi+ZHAlX8fNyl+TysDiYQ7N5f7
	XqOvInMiu9e/M2YSPfhKfdawKWrH3ClmurEc5C2qLmB+vra8GLaXnWiVSj3W0Meh3hjuWT
	3SfCIhIVNRKO6r4LdBltQHJPsZUUxas=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779704232;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/hnsceYyM19/MbhX5bdjmRK4Ysicv9FRuHCSOw6CjVM=;
	b=fRLTfRV8DN+yZ297bBcYDHiuZHQLmgb0vHSB/5GFYPQK4oxgAiv9A/Czd6T8+kTNRbkQhy
	+ZFxB1LsIGzEBrDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6CAAC59BBC;
	Mon, 25 May 2026 10:17:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qhdJGqghFGrgOgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 10:17:12 +0000
Date: Mon, 25 May 2026 12:17:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
Message-ID: <20260525101707.GV12792@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1779412152.git.wqu@suse.com>
 <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com>
 <20260523142344.GC183694@twin.jikos.cz>
 <20260525060030.GB3370@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525060030.GB3370@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On Mon, May 25, 2026 at 08:00:30AM +0200, Christoph Hellwig wrote:
> On Sat, May 23, 2026 at 04:23:44PM +0200, David Sterba wrote:
> > On Fri, May 22, 2026 at 06:53:53PM +0930, Qu Wenruo wrote:
> > > Recently kernel RAID56 lib is trying to remove the unexpected
> > > single-data-RAID56 (2 disks RAID5 or 3 disk RAID5) support, meanwhile
> > > btrfs still supports such setup, which means in the long run btrfs has
> > > to handle such corner case by ourselves.
> > > 
> > > Thankfully single-data-RAID56 is really RAID1/RAID1C3, since data and
> > > P/Q stripes all match each other, rotation also makes no difference.
> > > 
> > > This patch will disguise those single-data-RAID56 chunks as
> > > RAID1/RAID1C3 chunks.
> > 
> > I don't think this is the right way to fix it. Calculations are an
> > implementation detail and should be done at the time of the xor_gen or
> > raid6_call, not touching the upper level structures related to format.
> 
> It absolutely is.  Adding fast path workarounds for this is completely
> stupid when it can be trivially handled on the mount side.

It's a lazy hack at best and fix on absolutely wrong layer. The library
should provide the support for the edge case. But we disagree on that.

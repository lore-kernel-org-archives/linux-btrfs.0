Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764FD14AD0D
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 03:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777000322; cv=none; b=cG7MBZB/1/tx2jqEXSBOM2uBQVP9OUxKEa0yaCFKeIsclcgdEmM/p0+FKUrM/POPFtmIap8nBUB2jw/CdnkaGyxNcSx6APJf4UanXysicSrCm3hNtf9tPxwtiKr7HwMPtyeQIFd7WcaFSnKPlMwD+rU+q306f4/AQSZmbR1qwfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777000322; c=relaxed/simple;
	bh=YaXSm7Kku+k18LK5O0Pxf89Qi+rYnVs1wCYOSgtcGRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9y0tmbOP1+iQuaeFt+6DnMQjqEEv60axvhAgP8aZ3VY95IFTtVUWIyXGzS+UZLI/8uyNFgO+rfZsfZ3nJ4+05bf0zseJiRMFNklSnmwW45bCHu7+wRKy1ImcOh3SdexahinGWcNPGDIT+TBw2CsBB+IPRyHl2hX+UUYbAWlgBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=miT5dJbE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/29xLpXv; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=miT5dJbE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/29xLpXv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="miT5dJbE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/29xLpXv";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="miT5dJbE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/29xLpXv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7724F6A7FC;
	Fri, 24 Apr 2026 03:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777000319;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v7KLwxGXhdQchdiAxOpalyYg3mEJv2FlkIsWfaSHZlc=;
	b=miT5dJbEJDIUH+JbJieuL/td4ukW0osOGHfQktLuNqeU8PC1fZQMGukDhoAgwH47SvNwkn
	fo35T6TTBG82cSVI1SqbrbdNeG3vHk+GsA6gVVkQGQaGo3WxbByYMnKvvwHVoHJrZ8rBLd
	8nKKouyxdu1n6AbPi9yg+uUnGbIsy7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777000319;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v7KLwxGXhdQchdiAxOpalyYg3mEJv2FlkIsWfaSHZlc=;
	b=/29xLpXvs1AnDZ7KTDhMFURUOgBw+FZRFSTvQlx+hTtwrCbO709BtWwnnKWcJp5ANe2Rhd
	M1xLSRAgkOtfhTAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777000319;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v7KLwxGXhdQchdiAxOpalyYg3mEJv2FlkIsWfaSHZlc=;
	b=miT5dJbEJDIUH+JbJieuL/td4ukW0osOGHfQktLuNqeU8PC1fZQMGukDhoAgwH47SvNwkn
	fo35T6TTBG82cSVI1SqbrbdNeG3vHk+GsA6gVVkQGQaGo3WxbByYMnKvvwHVoHJrZ8rBLd
	8nKKouyxdu1n6AbPi9yg+uUnGbIsy7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777000319;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v7KLwxGXhdQchdiAxOpalyYg3mEJv2FlkIsWfaSHZlc=;
	b=/29xLpXvs1AnDZ7KTDhMFURUOgBw+FZRFSTvQlx+hTtwrCbO709BtWwnnKWcJp5ANe2Rhd
	M1xLSRAgkOtfhTAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5684A593AE;
	Fri, 24 Apr 2026 03:11:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zVRcFH/f6mkXUwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 24 Apr 2026 03:11:59 +0000
Date: Fri, 24 Apr 2026 05:11:54 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: collapse report_eb_range() into its single caller
Message-ID: <20260424031154.GB3542906@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b2dc0f485fc063e2b666e150002f59a278b97023.1776944252.git.fdmanana@suse.com>
 <20260424023835.GA3542906@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424023835.GA3542906@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [1.00 / 50.00];
	REPLYTO_EQ_TO_ADDR(5.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto]
X-Spam-Flag: NO
X-Spam-Score: 1.00
X-Spam-Level: *

On Fri, Apr 24, 2026 at 04:38:35AM +0200, David Sterba wrote:
> On Thu, Apr 23, 2026 at 12:38:13PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> > 
> > There's no point in having this static function since it's too short and
> > it has a single caller (check_eb_range()), so move its code into the
> > caller and remove it.
> 
> The point is to separate the check and report functionality, so the
> check part is inline and a simple if (a few instructions), while the
> report is not always inlined and is considered cold code.

But what compiler does is not what was intended, there should be either
__cold or noinline for the report function.

The effects of __cold on unpatched:

     text	   data	    bss	    dec	    hex	filename
  1742535	 150224	  15560	1908319	 1d1e5f	pre/btrfs.ko
  1742159	 150224	  15560	1907943	 1d1ce7	post/btrfs.ko

  DELTA: -376

Stack effects:

   copy_extent_buffer                           -8 (80 -> 72)
   extent_buffer_get_byte                      -24 (32 -> 8)
   memcmp_extent_buffer                        -16 (80 -> 64)
   memcpy_extent_buffer                         -8 (72 -> 64)
   memmove_extent_buffer                       -16 (64 -> 48)
   memzero_extent_buffer                       -32 (40 -> 8)
   read_extent_buffer                          -24 (72 -> 48)
   read_extent_buffer_to_user_nofault          -24 (72 -> 48)
   __write_extent_buffer                        -8 (88 -> 80)

   LOST (0):

   NEW (40):
	   report_eb_range                      40
   LOST/NEW DELTA:      +40
   PRE/POST DELTA:     -120

As can be seen it's all in the extent buffer manipulation helpers so
the hot path functions where the micro optimizations have impact.

The effects of 'noinline:

     text	   data	    bss	    dec	    hex	filename
  1742535	 150224	  15560	1908319	 1d1e5f	pre/btrfs.ko
  1742033	 150224	  15560	1907817	 1d1c69	post/btrfs.ko

  DELTA: -502

Stack:

  copy_extent_buffer                            -8 (80 -> 72)
  extent_buffer_get_byte                       -24 (32 -> 8)
  memcmp_extent_buffer                         -16 (80 -> 64)
  memcpy_extent_buffer                          -8 (72 -> 64)
  memmove_extent_buffer                        -16 (64 -> 48)
  memzero_extent_buffer                        -32 (40 -> 8)
  read_extent_buffer                           -24 (72 -> 48)
  read_extent_buffer_to_user_nofault           -24 (72 -> 48)
  __write_extent_buffer                         -8 (88 -> 80)

  LOST (0):

  NEW (40):
	  report_eb_range                       40
  LOST/NEW DELTA:      +40
  PRE/POST DELTA:     -120

So the same effects on stack (this is consumed by setting up the printk
and other things to report it), and difference how exactly is the code
inlined.

Either way, merging the report to check is not right.

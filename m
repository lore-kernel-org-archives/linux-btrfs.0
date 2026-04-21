Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8D1366054
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2026 03:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776741175; cv=none; b=qt3S52EUPkkBlD5qtsSokTVh5T1AXY5IjY3xVp/LV2qc6fezZ7hW3YdkEhFtyCLN5fJEUdnuQLtXRsKErjAYHHb3HwGwb3SPQcyXEczMRFYvE+r3+p7mb2rgbjqIbzH+o27U4BLY/xijXMglwXc6xZi8dX9H1t205YAyR9TL72M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776741175; c=relaxed/simple;
	bh=86NMtgvvIf1QsmdGHWLbGEf5M8FxPvrViUl7dRXEQLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ru35aoSLG9ZdEgsA5zk38Yz8gI1USckB9xPGKhIuXhlPh3j+EyccBGqpxBlf0YIy3F5jR4cPbHlIZ+zoKt/hFlZepAm0U0alkpKcAv9CPwoUERTBv+kct45BmLKgg1k2/uxmS3ZRzJkAU+JSrpxrIkqO4zMf/4vNCEO+4X3swMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=C5BIfemu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MBnCPWh2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=C5BIfemu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MBnCPWh2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="C5BIfemu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MBnCPWh2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="C5BIfemu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MBnCPWh2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 52A3C5BCC7;
	Tue, 21 Apr 2026 03:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776741172;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P50dLEFFrG0AmCXUF4g1r8XA+fPQ0/6fp8sYyvXYcto=;
	b=C5BIfemu12CqXLUPC+o+UJ43yhIzLBqIHCgD0D79tZ5sRAvtyWC95Pxh9KJmCoqCUE9MBm
	V+iEIiGxbtvoPvED5uZti6vqiP0+0NNLvxoIAHuVrXQYa2Tbf1GuP8z1wTqrzAh0/CKzZN
	VlBTCJxTrLPuOcJdkFUZtCGW/P4KIiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776741172;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P50dLEFFrG0AmCXUF4g1r8XA+fPQ0/6fp8sYyvXYcto=;
	b=MBnCPWh2eLXxf7T4htcdDfoCyobzcH/2LQu8wXmVFjDha7eFgoHgTNRvCHKlEPtqR/VKT+
	SqUshBn5msy4OoAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776741172;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P50dLEFFrG0AmCXUF4g1r8XA+fPQ0/6fp8sYyvXYcto=;
	b=C5BIfemu12CqXLUPC+o+UJ43yhIzLBqIHCgD0D79tZ5sRAvtyWC95Pxh9KJmCoqCUE9MBm
	V+iEIiGxbtvoPvED5uZti6vqiP0+0NNLvxoIAHuVrXQYa2Tbf1GuP8z1wTqrzAh0/CKzZN
	VlBTCJxTrLPuOcJdkFUZtCGW/P4KIiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776741172;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P50dLEFFrG0AmCXUF4g1r8XA+fPQ0/6fp8sYyvXYcto=;
	b=MBnCPWh2eLXxf7T4htcdDfoCyobzcH/2LQu8wXmVFjDha7eFgoHgTNRvCHKlEPtqR/VKT+
	SqUshBn5msy4OoAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 35A64593AF;
	Tue, 21 Apr 2026 03:12:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qwp0DDTr5mmBOQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 21 Apr 2026 03:12:52 +0000
Date: Tue, 21 Apr 2026 05:12:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix double-decrement of bytes_may_use in
 submit_one_async_extent()
Message-ID: <20260421031251.GB12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260416174359.262120-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416174359.262120-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Thu, Apr 16, 2026 at 06:43:51PM +0100, Mark Harmstone wrote:
> submit_one_async_extent() calls btrfs_reserve_extent(), which decrements
> bytes_may_use. If the call btrfs_create_io_em() fails, we jump to
> out_free_reserve, which calls extent_clear_unlock_delalloc().
> 
> Because we're specifying EXTENT_DO_ACCOUNTING, i.e.
> EXTENT_CLEAR_META_RESV | EXTENT_CLEAR_DATA_RESV, this decreases
> bytes_may_use again. This can lead to problems later on, as an initial
> write can fail only for the writeback to silently ENOSPC.
> 
> Fix this by replacing EXTENT_DO_ACCOUNTING with EXTENT_CLEAR_META_RESV.
> This parallels a4fe134fc1d8, which is the same fix in cow_one_range().
                 ^^^^^^^^^^^^

Please for first occurence put the full commit reference, the same one
as for the Fixes tag. Fixed in for-next.

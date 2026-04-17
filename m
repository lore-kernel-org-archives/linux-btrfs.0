Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C441EE7C6
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 03:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776397434; cv=none; b=KZ+ugKan3kyDk3DiHbC2RsuGTgYrJh1FVhf9e3yTxXbSFi2/53MrNHLEV8E5y1sv1rp5WwspurmtCqbmfGdQ+Qp0MOiTFTL5Kq9NhTa6jZI6RFp8qIyfIC588N9mZNtEiZyIXoW3gFUbPU5fUGxG55+r+wGXRnDAMEDZR9VyGb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776397434; c=relaxed/simple;
	bh=5ZLPdIQdc5d7F4vfZTuw9jagPiKMw/8ACI22Wj4hqv8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g4MtIX0Sy2SBSlMgNxTSgsmvNt56u/V/vCzpPjgzUVapQbuzuNzER9Zr5K9rLu/b05rpBvAFL9AREzG2Dmj+aMwMDhALMZ9CCOZZLHpXtmgmi8pm097AeL4QBOYs5iAaTUHGI7FHd16qJkii8P7sQz4+jYc3jHeCdrmMsSCWO6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DzezMpxb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oewXNSgL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DzezMpxb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oewXNSgL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DzezMpxb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oewXNSgL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DzezMpxb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oewXNSgL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9DA8B6A951;
	Fri, 17 Apr 2026 03:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776397431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ZLPdIQdc5d7F4vfZTuw9jagPiKMw/8ACI22Wj4hqv8=;
	b=DzezMpxbu6Hez4WQwrPt2rA3f9aJ71gewlaiwm/zjs3KlwI60wHOCyZePALtfodXzvVwOM
	R5T2IfrRjsgqTYIacoNSO+7hSnVrqyDylRoH9wCneRvwqzi4KiFHwxZcgZFCLHR/P+EpRd
	rxww89Ugc++u4jjdWh3I7FPWh+mt1Dw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776397431;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ZLPdIQdc5d7F4vfZTuw9jagPiKMw/8ACI22Wj4hqv8=;
	b=oewXNSgLbIppZHUTDTNn/fTz3d/bW9x6T0Hv7+BSihK8abM8PV5yYrfkw4Ld9jRBFburmP
	fgWZI+I3AuS+dzAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DzezMpxb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oewXNSgL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776397431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ZLPdIQdc5d7F4vfZTuw9jagPiKMw/8ACI22Wj4hqv8=;
	b=DzezMpxbu6Hez4WQwrPt2rA3f9aJ71gewlaiwm/zjs3KlwI60wHOCyZePALtfodXzvVwOM
	R5T2IfrRjsgqTYIacoNSO+7hSnVrqyDylRoH9wCneRvwqzi4KiFHwxZcgZFCLHR/P+EpRd
	rxww89Ugc++u4jjdWh3I7FPWh+mt1Dw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776397431;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ZLPdIQdc5d7F4vfZTuw9jagPiKMw/8ACI22Wj4hqv8=;
	b=oewXNSgLbIppZHUTDTNn/fTz3d/bW9x6T0Hv7+BSihK8abM8PV5yYrfkw4Ld9jRBFburmP
	fgWZI+I3AuS+dzAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F969593AE;
	Fri, 17 Apr 2026 03:43:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qq93BXas4WkILAAAD6G6ig
	(envelope-from <ddiss@suse.de>); Fri, 17 Apr 2026 03:43:50 +0000
Date: Fri, 17 Apr 2026 13:43:29 +1000
From: David Disseldorp <ddiss@suse.de>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS discard crash: failed to run delayed ref for logical
 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2 6.11.2)
Message-ID: <20260417134329.65693165.ddiss@suse.de>
In-Reply-To: <adnBhWfJQ1n3hZC8@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 9DA8B6A951
X-Spam-Flag: NO
X-Spam-Score: -3.51
X-Spam-Level: 

Hi Marc,

Not a btrfs dev, but just wanted to make an observation...

On Fri, 10 Apr 2026 20:35:33 -0700, Marc MERLIN wrote:

> I had btfrs filesystem on top of raid5 with 5 spinning drives.
> I mistakenly enabled discard by mistake which caused a crash when the dis=
card thread tried
> to run (no discard on those drives)

=46rom the look of your block-dev path and loaded modules, the filesystem
is atop a bcache caching layer. This would make it far from a simple
dev topology; bcache would be expected to invalidate discarded cache
regions regardless of underlying HDD discard support.
Are you able to reproduce the bug if you remove the bcache layer?

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBAB552922
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 13:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788873162; cv=none; b=NC+nYyx9blQdUPjrPyK+pnUirV+jfzfUARxJUzwBQg0NiO//up8wHhGi1J6z1gdELzQ7EviOoWaIe0gSEQlz51jzMBjVwd0eII0EvakwGs7YABeA2gkFaUl0DflAijimQJS34zV6gPqhd6wy6S3j9F7AAEnUwfxcvfF8ph8i+oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788873162; c=relaxed/simple;
	bh=9o+r/Qd+psnQXq/tkfLEndBUkmlTbuh3He63sAa4XY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YpXzMAwHcOer3hyQFfrHF7TuF+qH2QTqNdvnwOnLO4BA2h3xDrgmPP65w5K7kf35gAHBBEUSxrTPQS2UAle3wVSJNDP14sBAoRCzfM22gyhvW1dATU9Kk2s/nUlzMosl8idkUnJ0WL/oMMjdITOfggDREkhjQoFycNMaV58xriU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8F432219E9;
	Tue,  8 Sep 2026 13:12:24 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 04F121347F;
	Tue,  8 Sep 2026 13:12:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KBiaALgJoGoWPAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 08 Sep 2026 13:12:24 +0000
Date: Tue, 8 Sep 2026 15:12:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
Subject: Re: [PATCH] btrfs: use kvmalloc() for split_item()
Message-ID: <20260908131214.GB9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <2ab022c5c7e07345a9fc91915836cbd4ab2d25ef.1788819456.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ab022c5c7e07345a9fc91915836cbd4ab2d25ef.1788819456.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 8F432219E9
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

On Tue, Sep 08, 2026 at 07:47:39AM +0930, Qu Wenruo wrote:
> [BUG]
> There is a bug report that the kmalloc() call inside split_item() failed
> with the following call trace, and triggered a transaction abort:
> 
>  kworker/u69:8: page allocation failure: order:4, mode:0x40c40(GFP_NOFS|__GFP_COMP), nodemask=(null)

For order 4 we don't have other options, but using 64k nodesize on 4k
page system is not that great. The space savings of fewer levels or node
count does not overweigh the runtime overhead of scattered pages or more
costly allocations when falling back to vmalloc.

For 4k nodesize on 4k pages there will be no change, but nobody uses
that. For 16k nodesize on 4k page, which is probably the most common
setup, the vmalloc fallback starts using the mappings and it comes with
it's own cost and failure modes.

What plays in favor for us is that the allocations are short lived, only
the allocation overhead potentially increases.

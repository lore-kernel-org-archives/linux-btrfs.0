Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE251B042E
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2026 01:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769651585; cv=none; b=iccZSTEu1AmEtId+CzsRWPdG52CGM64fy409/Gd0PwfdyZ90QTx+I+P05fu11eXcbhaFmYO8R3IiPP9Rt1snlT92vbeGhr7uiRVW0waPemhQiJVyYzbVLR8P2hMqdcppGg9sWHtpPH23Qcl2iqKUlf/JE8ibjw7TonmaxcBKQYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769651585; c=relaxed/simple;
	bh=1qgcoxyUEpPUGpqBDVrzWZpLNb4eesLs++ur3ARwPBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H5NtvunSQcHok7kNjky5VrxGE7g0PMg0NUE7DMjAWZdAIE3fhQzjf4ZgyKChAXzFr63mQUFoiEvGzzebYY8xmZrbJlatWZjywNA0Qg7AbU/Z3jxadcoINbKBAs52LfgykZtYUSw7XUjc3IHHOQuLRqw9ZQS92GNnWpcS3EM8rb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TeOHhjq4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=r3OfVx2y; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TeOHhjq4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=r3OfVx2y; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TeOHhjq4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="r3OfVx2y";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TeOHhjq4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="r3OfVx2y"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5F5135BCD1;
	Thu, 29 Jan 2026 01:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769651582;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MfHFpUFGcrBlOA55bDkIPXB1atkQCFBhD/FNsg4XeEE=;
	b=TeOHhjq4J+Xs3K7BKynDFkK5swbDlTo5UvbkLes+x+lL9jYZHy8m+o9a5oofik3y4brmjT
	01jvyJ/h0xq4lQAvTwOTPvqnflAWACsR/GusbGR4d9Sezw4a0sFB48GsPcRgrp7I8MxfH+
	SAcSfoiVhymVwapzR6QxJFWbpXbHEg8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769651582;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MfHFpUFGcrBlOA55bDkIPXB1atkQCFBhD/FNsg4XeEE=;
	b=r3OfVx2yYxu60KR5U0zEaO4Vs8/rE8Q5F4L1wiyYqKUcf8JBDbZtGdsKbqVxL1edYTo95N
	4G7bXhOCgSxv9tAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769651582;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MfHFpUFGcrBlOA55bDkIPXB1atkQCFBhD/FNsg4XeEE=;
	b=TeOHhjq4J+Xs3K7BKynDFkK5swbDlTo5UvbkLes+x+lL9jYZHy8m+o9a5oofik3y4brmjT
	01jvyJ/h0xq4lQAvTwOTPvqnflAWACsR/GusbGR4d9Sezw4a0sFB48GsPcRgrp7I8MxfH+
	SAcSfoiVhymVwapzR6QxJFWbpXbHEg8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769651582;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MfHFpUFGcrBlOA55bDkIPXB1atkQCFBhD/FNsg4XeEE=;
	b=r3OfVx2yYxu60KR5U0zEaO4Vs8/rE8Q5F4L1wiyYqKUcf8JBDbZtGdsKbqVxL1edYTo95N
	4G7bXhOCgSxv9tAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A83B3EA61;
	Thu, 29 Jan 2026 01:53:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1aMWDn69emkHfgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 29 Jan 2026 01:53:02 +0000
Date: Thu, 29 Jan 2026 02:53:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: Wang Yugui <wangyugui@e16-tech.com>, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: Re: [PATCH v3 3/3] btrfs: forward declare btrfs_fs_info in volumes.h
Message-ID: <20260129015300.GF26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1769447820.git.boris@bur.io>
 <4c839922e88a33145eca264394ff8aab08c0a871.1769447820.git.boris@bur.io>
 <20260127070401.327D.409509F4@e16-tech.com>
 <20260127190259.GB3450664@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260127190259.GB3450664@zen.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On Tue, Jan 27, 2026 at 11:02:59AM -0800, Boris Burkov wrote:
> On Tue, Jan 27, 2026 at 07:04:01AM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > > Fix the build warning:
> > > In file included from fs/btrfs/tests/chunk-allocation-tests.c:8:
> > > fs/btrfs/tests/../volumes.h:721:53: warning: ‘struct btrfs_space_info’ declared inside parameter list will not be visible outside of this definition or declaration
> > >   721 |                                              struct btrfs_space_info *space_info,
> > > 
> > 
> > Could we fold this patch into the patch 2/3 which introduce the file of 
> > chunk-allocation-tests.c?
> 
> I suppose so but I intentionally split it out since it isn't
> fundamentally related to the new unit test, that is just how I happened
> to notice. btrfs_create_chunk() takes a btrfs_space_info pointer but
> it's not forward declared.

It's not that important change to have it separately and as said it's
part touching the newly added file so it belongs there. We don't want to
leave build warnings like that unfixed due to bisection.

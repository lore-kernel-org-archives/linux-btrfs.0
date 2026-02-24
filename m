Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FD023EA83
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2026 17:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771954234; cv=none; b=hvOOq4dt8MTIhOSgv4dCy03OZKCwb+dmtZzvdHy//wPLNhOEKTaPDm/WaC/9u1vyZQ+TeCwmBuot8WzRTeNIwLOSgNfvWp3KIjPZZ5oMcLKs+C6Igm7La+PJw30hKZ3aR4Biq+uDWgELt+HXMzhQF1bgUEWT6YWRl3+A3ncfZXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771954234; c=relaxed/simple;
	bh=G57ALwSGjqXzIVj+4zlJkEpni2xe7ulvqzJwh0VTvDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VX3yQ2hVj2r0UCorCRoD2Lmpx1+TVjoir5WMZge3KLBpVD3Kt0EnBQZK34lFl2oPQ2OYWUooI7HGFDcyXUzTd65oo+HsWjA+g6F20PD3/EXQ1NJpL909GS+pESHgCyu7UGkvuOItD4XYJQ3RJWB4+xArGrouIRE9h7W53l7EY3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=N3jbnIBH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fKg3197w; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p9aAEhfW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+fKGSlOp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="N3jbnIBH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fKg3197w";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p9aAEhfW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+fKGSlOp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B3E285BCF9;
	Tue, 24 Feb 2026 17:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771954231;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5h6XXnax5hD4rKz2lhow2L2IU1bWYYvQtu/6zIrGaTM=;
	b=N3jbnIBHpVBT3TlWv1JB+zh0zJRZ/Hxka9EhPGH0Hx21qF77GiD5JZZ/BFVUenNHNobtv3
	OwsEm/7T5kSs1oJmnKzCYH4A3IMp/o1RHyxub62ir3/wvstbOVswUxgIe7GZzgBDlwGYm+
	Vx5Nnen0I81lCTlsBYhf1+DdseRwryw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771954231;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5h6XXnax5hD4rKz2lhow2L2IU1bWYYvQtu/6zIrGaTM=;
	b=fKg3197wddhKmyWPACkXIPfCHWwVL/fVjwHCU2H7nUut7T1iyVMh5Lg59MTeB47I8rPAey
	Mi82dQwilYWia4Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771954230;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5h6XXnax5hD4rKz2lhow2L2IU1bWYYvQtu/6zIrGaTM=;
	b=p9aAEhfWsjSJG4e6VaAdmovnAIw7u6SU80Q66p5BBI1mPX82jBbz8FGvrrgFB/N6rjywTL
	3qEvLOeMECUobDNA4VMhzPc9K7Pgg40VG5AMXMlipPZiE3nSF2XCa4GFaHXDfGG0HRVKvd
	DJVcNusPYN33xCAnJNIK4U/6LG4zk9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771954230;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5h6XXnax5hD4rKz2lhow2L2IU1bWYYvQtu/6zIrGaTM=;
	b=+fKGSlOp+QvNEy7yuutR1iaU3FyP+NYau1TLY4garN8soF481EQmVWFuUbag0uabxqW0Sz
	gn94WX7xwg/ojkDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9BF9A3EA68;
	Tue, 24 Feb 2026 17:30:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QSLjJTbgnWnJDgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 24 Feb 2026 17:30:30 +0000
Date: Tue, 24 Feb 2026 18:30:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com
Subject: Re: [PATCH] btrfs: fix error message in btrfs_validate_super()
Message-ID: <20260224173029.GC26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260217185335.21013-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217185335.21013-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Tue, Feb 17, 2026 at 06:53:19PM +0000, Mark Harmstone wrote:
> Fix the superblock offset mismatch error message in
> btrfs_validate_super(): we changed it so that it considers all the
> superblocks, but the message still assumes we're only looking at the
> first one.
> 
> The change from %u to %llu is because we're changing from a constant to
> a u64.
> 
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> Fixes: 069ec957c35e ("btrfs: Refactor btrfs_check_super_valid")

FYI I've edited the subjects of the error message fixing patches to be
more specific what is being fixed now that there are a few of them.

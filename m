Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574A41F91D6
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 14:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777300225; cv=none; b=MGdhp14q8QPqGY1snbqnkfjscC3uBeMtRmcdaMTuvvc5i8BezV8SZwBF5ybWvyQ7uVBwMBEFRIMmz1MxAIndmd04m6QzJbG5Ypt3Bs7G3Ae1HnPtjyZUCt6Vj4bnzOx4oZ7OukbqjKIeaNuC+n942fP8PJl3TBtNkaoc2MKvPTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777300225; c=relaxed/simple;
	bh=4tOlp3eO/KpPUs4p9octyAX8yQlM2gSsl8Zf5dj5mM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8a8z7y+ljN5k7UWVkNFyMhd7gPHhkf5cP+afmfFImw7DQx8oV/BM1/xqiIdV5Q6Gv0IU83je35wbmok872NhFktF7jHHVtvdrZ6I/BGd0IPz05vDnlHihTOjdOvXSVCoyc1P6T61kdod1AS2U1iKuprt9uqah6RO21awcBlSMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T2j39IvR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=duyxorPy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T2j39IvR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=duyxorPy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T2j39IvR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="duyxorPy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T2j39IvR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="duyxorPy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9D0685BCFC;
	Mon, 27 Apr 2026 14:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777300222;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LNeg8iLjIjKmjAhE52w6tqRGiijXareWv3vOpW5BpNA=;
	b=T2j39IvRF7VqBEJ9znrDlMq4ZNJmo4gpClnAzwS09VXrgGR5MhRqhWtEF5GJ9OBXF7Ipbe
	Vm1y6JLabRXTr+ZL/c2GiIIlc0J71VQ0QzazG4mHhIAYB5ZC0qUt102QmGnC6Yu3eAxozU
	DovjuDpkglYZ4pGGvCLfmGjZvCNESW4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777300222;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LNeg8iLjIjKmjAhE52w6tqRGiijXareWv3vOpW5BpNA=;
	b=duyxorPySwxFU0CDoOKE3fe7hocOlvzD69qyNTGXqyvtJ0WYBBun/bURCb9gXRxxxX7bRq
	ZlJLUyaHx055p/BA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777300222;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LNeg8iLjIjKmjAhE52w6tqRGiijXareWv3vOpW5BpNA=;
	b=T2j39IvRF7VqBEJ9znrDlMq4ZNJmo4gpClnAzwS09VXrgGR5MhRqhWtEF5GJ9OBXF7Ipbe
	Vm1y6JLabRXTr+ZL/c2GiIIlc0J71VQ0QzazG4mHhIAYB5ZC0qUt102QmGnC6Yu3eAxozU
	DovjuDpkglYZ4pGGvCLfmGjZvCNESW4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777300222;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LNeg8iLjIjKmjAhE52w6tqRGiijXareWv3vOpW5BpNA=;
	b=duyxorPySwxFU0CDoOKE3fe7hocOlvzD69qyNTGXqyvtJ0WYBBun/bURCb9gXRxxxX7bRq
	ZlJLUyaHx055p/BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 85F9B593B0;
	Mon, 27 Apr 2026 14:30:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8n89IP5y72nDFwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 27 Apr 2026 14:30:22 +0000
Date: Mon, 27 Apr 2026 16:30:21 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: make sure report_eb_range() is not inlined
Message-ID: <20260427143021.GO12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5082990dc32613cf128c27ef01086178edcf4e24.1777043747.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5082990dc32613cf128c27ef01086178edcf4e24.1777043747.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:replyto,twin.jikos.cz:mid]
X-Spam-Flag: NO

On Fri, Apr 24, 2026 at 04:17:40PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If report_rb_range() is inlined into its single caller (check_eb_range()),
> we end up with a larger module size, which is undesirable and does not
> provide any advantage since this code is for a cold path which we don't
> expect to ever hit.
> 
> Add the noinline attribute to report_rb_range() and while at it also make
> it return void as it always returns true.

With the 'bool' type the compiler can optimize the code by doing tail
call, in this case also the arguments match. I did a few checks how much
effects it has and there are some, eg. further specializations of
functions depending on the calling context and moving the call/jmp to
report out of the way.

> Before this change (with gcc 14.2.0-19 from Debian):
> 
>   $ size fs/btrfs/btrfs.ko
>      text	   data	    bss	    dec	    hex	filename
>   2018267	 176232	  15592	2210091	 21b92b	fs/btrfs/btrfs.ko
> 
> After this change:
> 
>   $ size fs/btrfs/btrfs.ko
>      text	   data	    bss	    dec	    hex	filename
>   2017835	 176048	  15592	2209475	 21b6c3	fs/btrfs/btrfs.ko
> 
> Also, replacing the noinline with __cold, yields slighty worse results:
> 
>   $ size fs/btrfs/btrfs.ko
>      text	   data	    bss	    dec	    hex	filename
>   2017889	 176048	  15592	2209529	 21b6f9	fs/btrfs/btrfs.ko

In the generated assembly seems that __cold is a bit different than
just the noinline. The __cold annotation also changes the placement of
the function to the cold section.

Out of all the combinations the noinline seems to have biggest effect,
namely on the stack usage. Cold or return value for tail calls is
proably too fine-grained for this function and not worth.

Reviewed-by: David Sterba <dsterba@suse.com>

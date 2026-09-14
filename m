Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859C948EC79
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 15:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789399673; cv=none; b=JCFHEBVOK4Qd3lIp3MeQgzHBR08YUriOPJiqLycI/nYce6jby+Jg25J4NFlKQdUwJR9Ynr3XXPoxuh7hID3LOpuYsCGgbGTSa3J1vFmJxz6HnSblg3YPOFr9yOikw9wVUSZ7/4SLWd3B4YsKpLaemvoIGRGY8s0nWW0ZSzCnVL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789399673; c=relaxed/simple;
	bh=oXGvyzNyfHYY7CyiBD2fD7IAw7vMVOvbyBYX9UKrEVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NkXqiGjqnTETEZ9J0NyTAxm2kx0XFAYcwzrsyYwd5Wa21+AJ2DyQzzWFTjr+VEtgjIXFNh7I7fTYQPe+5rQFlYSkBF6aqmMJ1+S2ywywIHm0RyRMHlcFKuuDGEeg6DrJcQvp97BixghTRFO+UXQfYgU99BTHHlvlKJ68ruL/VCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fS8Igbfj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5V+VLEm8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Gn28e1bh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JnrSeHLQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fS8Igbfj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5V+VLEm8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Gn28e1bh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JnrSeHLQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 33E691FF18;
	Mon, 14 Sep 2026 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789399665;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gjr1wmFi3qJxAQ3XUjREKh1/OAuWy8a4BPv0vJ1lOxo=;
	b=fS8IgbfjHFaF7kPSaALLr2CFTxSgkRmFe1ElKmxp3yjI6TDDZcfwzNcGa0t5kPo4cWuOX6
	XrQUhuK/+oPi3JJ/Qldl1R60In5/gHglQaAiKHY+OfNU06whoeqg53W5CTRycsTqPiwRg5
	Q0wIZ7mLNsUyOzDUY3rRzEB827c5vOg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789399665;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gjr1wmFi3qJxAQ3XUjREKh1/OAuWy8a4BPv0vJ1lOxo=;
	b=5V+VLEm80yf3xF0BCutpjKZ/BdVXyaquVZEj51dZBFq0QbvNO56KNRBBZQ5aA3QN3pLCq4
	N3kaEcdxQN9gbgAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789399661;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gjr1wmFi3qJxAQ3XUjREKh1/OAuWy8a4BPv0vJ1lOxo=;
	b=Gn28e1bhUbDFnLb0N04tucfslhGVdX0U/Bov7L0FiG9nSb3kXlWZADuie8GwAXzaP8ORoC
	Afoi9onaO85r4xGvbtZL53uGEEJhTe128xJwp9pA/NEhz/FN/Jk00hnoRfp18g82Gf29Lx
	bcgb6TvIyGo76yEnbrJXW5NI4oh9V6M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789399661;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gjr1wmFi3qJxAQ3XUjREKh1/OAuWy8a4BPv0vJ1lOxo=;
	b=JnrSeHLQm5P06UHCJ3co5DIJgnkHNFKAQCVR090XLxNPEDXigeGPVYTymaCkKP1hRLnsou
	GF66pjlct/XIF3Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF7DF1368C;
	Mon, 14 Sep 2026 15:27:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aRY4OmwSqGoxaQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 15:27:40 +0000
Date: Mon, 14 Sep 2026 17:27:39 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: cache accessor return value in
 CHECK_FE_ALIGNED()
Message-ID: <20260914152739.GK54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <bfbeb06553e40d94aadfe5490f2749b3e43bc83f.1789143253.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfbeb06553e40d94aadfe5490f2749b3e43bc83f.1789143253.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.cz:replyto,suse.com:email,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.com:email,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]

On Fri, Sep 11, 2026 at 05:15:56PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We are calling an accessor for a file extent item multiple times in the
> CHECK_FE_ALIGNED() macro, even when we don't find a corruption (once in
> the if statement's expression and then once again in the expression for
> the return value). This adds extra runtime overhead (which is critical
> since the tree checker runs against every extent buffer when it's read
> or before persisting it) and increases the module's size.
> 
> So cache the accessor's return value in a variable and use it, reducing
> runtime, object size and making the source code shorter too. Also avoid
> repeating twice the IS_ALIGNED() computation.
> 
> Before:
> 
>   $ size fs/btrfs/btrfs.ko
>      text	   data	    bss	    dec	    hex	filename
>   2073340	 217928	  15624	2306892	 23334c	fs/btrfs/btrfs.ko
> 
> After:
> 
>   $ size fs/btrfs/btrfs.ko
>      text	   data	    bss	    dec	    hex	filename
>   2073076	 217928	  15624	2306628	 233244	fs/btrfs/btrfs.ko
> 
> Also running the following fsstress test and capturing the runtime of
> check_extent_data_item() (the only caller of CHECK_FE_ALIGNED()) in
> nanoseconds (using bpftrace), showed the following runtime improvements:
> 
> Test:
> 
>   mkfs.btrfs -f /dev/nullb0
>   mount /dev/nullb0 /mnt
>   fsstress -w -p 8 -n 5000 -s 12345 -d /mnt
>   umount /mnt
> 
> Before:
> 
>   Count: 2033671
>   Range:  0.000 - 1336060.000; Mean: 679.642; Median: 656.000; Stddev: 2031.323
>   Percentiles:  90th: 850.000; 95th: 909.000; 99th: 1272.000
>      0.000 -    6.647:      11 |
>      6.647 -   28.241:      36 |
>     28.241 -  110.807:     176 |
>    110.807 -  426.512:   38012 #
>    426.512 - 1633.663: 1983372 #####################################################
>   1633.663 - 6249.399:    8315 |
>   6249.399 - 23898.422:   3243 |
>   23898.422 - 91382.340:   153 |
>   91382.340 - 349418.114:   36 |
>   349418.114 - 1336060.000: 11 |

I assume this is generated by some tool, can you please let it align the
values under the decimal point? I've been fixing that in changelogs
manually, it's quick but still a tool can be quicker. Thanks.

     0.000 -       6.647:      11 |
     6.647 -      28.241:      36 |
    28.241 -     110.807:     176 |
   110.807 -     426.512:   38012 #
   426.512 -    1633.663: 1983372 #####################################################
  1633.663 -    6249.399:    8315 |
  6249.399 -   23898.422:    3243 |
 23898.422 -   91382.340:     153 |
 91382.340 -  349418.114:      36 |
349418.114 - 1336060.000:      11 |

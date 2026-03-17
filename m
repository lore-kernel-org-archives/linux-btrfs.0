Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8539734AB17
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 16:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765581; cv=none; b=B6BwIjHuzh3LBwynOzbPkHYK4qSpcg3K4buoo0JqeYOomG2W7AV+3oBya3GNrXLqpfFwzMqO9egfumfw5En6gKOIpVuAHbOXWHKVWtutig0JUrpqbDUdAH2g6cE1W3UImxui5rQs5S7IjXmprbhXrO4JA4XMlM4/7qF5DPfzEFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765581; c=relaxed/simple;
	bh=M2Wd+on+OO97FcHcgiBqi3gwLLOnb+KGyApPctxjUdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u05pr3xUkK1PzLUg2Hk2bpUVFL1jw4rUh2f++0Wrr+ItlD/K5PdqeBPwB9jyHciW9fEBQNjAEa57c+0HZntbGCdwHmQPvCgBAmv+I/xEL6ARy8+g8xNBf6GWdz3eV7rD106/cW7t/iA/Q7/CXkrblnDfN9bwkCRos4gYL1fH+sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yyWI8Zbe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uwTtNabf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yyWI8Zbe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uwTtNabf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yyWI8Zbe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uwTtNabf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yyWI8Zbe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uwTtNabf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CAA124D300;
	Tue, 17 Mar 2026 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773765578;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NuIZek0fdoRq36hFPyteLpFrmJK0cKKq2AqEad6xsyI=;
	b=yyWI8Zbel44GlEqsN+4muSmgKxNbLbCmCtgzFKM8fTgTNT5ZGcvL2o5e/5C132b1QaEqIj
	E4BvjCaXFk5gv413u37lg5sEpHSyBMRvIUxptqYJu2/gXPOrGAe3FNSKGNsYuWKUafVbNM
	Ews50Y4GISB0yXyg04hAhPlke6yEjq8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773765578;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NuIZek0fdoRq36hFPyteLpFrmJK0cKKq2AqEad6xsyI=;
	b=uwTtNabfv3ZmPfTeCJKJ7vaTe2Tqe5Yw6kCz1/cUEuX0tkJ2ez7OHwYKMZCnImHQOoHJS9
	q3qfqptnEi+4i5Ag==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773765578;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NuIZek0fdoRq36hFPyteLpFrmJK0cKKq2AqEad6xsyI=;
	b=yyWI8Zbel44GlEqsN+4muSmgKxNbLbCmCtgzFKM8fTgTNT5ZGcvL2o5e/5C132b1QaEqIj
	E4BvjCaXFk5gv413u37lg5sEpHSyBMRvIUxptqYJu2/gXPOrGAe3FNSKGNsYuWKUafVbNM
	Ews50Y4GISB0yXyg04hAhPlke6yEjq8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773765578;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NuIZek0fdoRq36hFPyteLpFrmJK0cKKq2AqEad6xsyI=;
	b=uwTtNabfv3ZmPfTeCJKJ7vaTe2Tqe5Yw6kCz1/cUEuX0tkJ2ez7OHwYKMZCnImHQOoHJS9
	q3qfqptnEi+4i5Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B14F94273B;
	Tue, 17 Mar 2026 16:39:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kR8jK8qDuWlvCwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 17 Mar 2026 16:39:38 +0000
Date: Tue, 17 Mar 2026 17:39:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: enhance find_option()
Message-ID: <20260317163937.GZ5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1771801832.git.wqu@suse.com>
 <4f0ee51a24d281ae387f01db510e825e9259f73f.1771801832.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f0ee51a24d281ae387f01db510e825e9259f73f.1771801832.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Mon, Feb 23, 2026 at 09:42:58AM +1030, Qu Wenruo wrote:
> There are two minor problems in that function:
> 
> - Latest GCC reports dropped 'const' qualifier
> 
>   The latest GCC (15.2.1) will report the 'const' qualifier is dropped
>   for the strstr() call.
> 
>   It looks like the latest GCC has taken the 'const' qualifier checks
>   one step further, that any pointer that points into a 'const' pointer
>   should also have a 'const' qualifier, to make sure there is no
>   modification into the original pointed memory.
> 
>   In our case, @options parameter has a 'const' qualifier, thus the
>   returned @tmp pointer should also have a 'const' qualifier, or we can
>   modify the @options through @tmp.
> 
> - No error handling if strdup() failed
> 
> Enhance them by:
> 
> - Add the 'const' qualifier for @tmp
>   This also means we can not use @tmp pointer to modify the newly
>   duplicated string.
>   Instead use a new @i index to access the new string.
> 
> - Return NULL if strdup() failed
>   And make the caller check errno for memory allocation failure.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  common/utils.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/common/utils.c b/common/utils.c
> index 23dbd9d16781..f183705edb8f 100644
> --- a/common/utils.c
> +++ b/common/utils.c
> @@ -375,19 +375,27 @@ struct mnt_entry {
>  /*
>   * Find first occurrence of up an option string (as "option=") in @options,
>   * separated by comma. Return allocated string as "option=value"
> + *
> + * If NULL is returned, the caller needs to check errno to make sure it's not
> + * caused by memory allocation failure.
>   */
>  static char *find_option(const char *options, const char *option)
>  {
> -	char *tmp, *ret;
> +	const char *tmp;
> +	char *ret;
> +	int i;
>  
> +	errno = 0;
>  	tmp = strstr(options, option);
>  	if (!tmp)
>  		return NULL;
>  	ret = strdup(tmp);
> -	tmp = ret;
> -	while (*tmp && *tmp != ',')
> -		tmp++;
> -	*tmp = 0;
> +	if (!ret)
> +		return NULL;
> +	i = 0;
> +	while (*(ret + i) && *(ret + i) != ',')

Is there a reason for not using ret[i] ?

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EF33F1646
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 16:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765980; cv=none; b=WvfbMcqwcDpG3i1qTXS69PRu2JCLCTIGX4Su+Ox/CDSj9aPJRDopQSN6qiAsyUxOeFCk53kNQ23+xV1GSyZmGLU0oQG1HEnLQ0auZP2bHzMDX7x6e9qrt/S4G/+/QVEfzxIGDZcEFGHOzByrCc/sMibb1IMmwphJtITQELnvf0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765980; c=relaxed/simple;
	bh=JeEKbLn1HBDAyrTpfjgTSDZnFu94butGqhIViAR1ls0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lrgbhaLbDS5W42w9CfH80z2tD//rCi9LlZVxjF9RtT9EGNxSbiN/xxlRfI5De7K2ZumVcJoGaNZN71f+7E2w5ISkdPryv/OZ5PCujORLAm8UxgVnJ3wQA87fEKx7I7nfcvqwBpDwahZlxAOkl1CpTzwJPfMkZglt2UsaBMSziTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KcGEZ4Ug; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FlfVfOV5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KcGEZ4Ug; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FlfVfOV5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KcGEZ4Ug";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FlfVfOV5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KcGEZ4Ug";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FlfVfOV5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 037A14D391;
	Tue, 17 Mar 2026 16:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773765977;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9xxKBMHnWMBunOmqM5b19eLMNOaJpRJDDFWvSh84cyw=;
	b=KcGEZ4UgYVglzjL2TSlGh3Mylf39hgBRmbKSYFl5wEUkjJv+RTafMeXT6XJAQXG7Ecu2Ou
	fSHiPzTBkT41KsS1r9QN0BJPiQ0noX10TrMDSqW4yRRXJOKeWC1ZxEwP7qIKQd8JZrxeh7
	MH/DEN9xh9lkGZIFeaIi4kIq68e8hfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773765977;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9xxKBMHnWMBunOmqM5b19eLMNOaJpRJDDFWvSh84cyw=;
	b=FlfVfOV5yOBEqzuFnu8sxGLf/6MaoCOmLWnhOksHQdsW1xDzrObcg29CmRp1WBCB5iz/6c
	SxUrf+nWl9kZrJCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773765977;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9xxKBMHnWMBunOmqM5b19eLMNOaJpRJDDFWvSh84cyw=;
	b=KcGEZ4UgYVglzjL2TSlGh3Mylf39hgBRmbKSYFl5wEUkjJv+RTafMeXT6XJAQXG7Ecu2Ou
	fSHiPzTBkT41KsS1r9QN0BJPiQ0noX10TrMDSqW4yRRXJOKeWC1ZxEwP7qIKQd8JZrxeh7
	MH/DEN9xh9lkGZIFeaIi4kIq68e8hfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773765977;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9xxKBMHnWMBunOmqM5b19eLMNOaJpRJDDFWvSh84cyw=;
	b=FlfVfOV5yOBEqzuFnu8sxGLf/6MaoCOmLWnhOksHQdsW1xDzrObcg29CmRp1WBCB5iz/6c
	SxUrf+nWl9kZrJCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E014A4273B;
	Tue, 17 Mar 2026 16:46:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sXWNNliFuWn2EgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 17 Mar 2026 16:46:16 +0000
Date: Tue, 17 Mar 2026 17:46:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: output the directory path for
 missing custom script
Message-ID: <20260317164615.GB5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <bac89ac52147344ab6244beef8c0085552a3aacb.1770438921.git.wqu@suse.com>
 <a0cfce59143cf99e9c89baa0f4b0f189dfe40687.1770337623.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0cfce59143cf99e9c89baa0f4b0f189dfe40687.1770337623.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.com:email,twin.jikos.cz:mid];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Sat, Feb 07, 2026 at 03:05:23PM +1030, Qu Wenruo wrote:
> I hit a mkfs failure locally where I reverted the commit which
> introduced the mkfs/040 test case.
> 
> However that directory didn't got removed as there are local image files
> left due to previous test failure.
> 
> This results a very confusing error message:
> 
>     [TEST/mkfs]   039-zoned-profiles
>  custom test script not found or lacks execution permission
>  make: *** [Makefile:557: test-mkfs] Error 1
> 
> The reality is, the failure is caused by 040 not 039, but the error
> message lacks the proper info on it.
> 
> Add the directory name for every test script, so that now the failure
> will be more readable:
> 
>   TEST     mkfs-tests.sh
>     [TEST/mkfs]   001-basic-profiles
>  custom test script not found or lacks execution permission ("/home/adam/btrfs-progs/tests/mkfs-tests/002-empty-dir-to-fail")
>  make: *** [Makefile:557: test-mkfs] Error 1
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to devel, thanks.

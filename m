Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D81C3B8BAE
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773832838; cv=none; b=gbMdDM5VKItaabFHYLvR4hvDQ1mjBtFNxpS9W7j32YTBqqxC/11QQtdtZ9CfgZZnQQt2y5o2e9K92+9Y5SyeBqpXoS/fyIMLfjjC2T8X0X1AL8Eh+LqRPC8NfS2BQVqRB9iaT4RYodwB61u8ieuI+pSMYJ7g2Uaf3fYAHdgmVhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773832838; c=relaxed/simple;
	bh=ndc3FZipt3OXhzg67PDMSza6GpVNoSLJ+Q5Jrqicb68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdqEolXOUALxAhTjwK9srps3xH58Rqskb9UVrHVWMsyfDDc1mRXtjWokp9sJTguSKj8Uun77bfQ5TvAvxoLakn58Y62CiscDmPBT3x7i4FiUCfSVRA04Ke18Wm+20LPi+f63zin08QBqgvsy96jTZiSsfKoqBeh4L95mWBGJzLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UnUnh7oM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=e6i6OEtW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UnUnh7oM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=e6i6OEtW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UnUnh7oM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="e6i6OEtW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UnUnh7oM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="e6i6OEtW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 177DE4D236;
	Wed, 18 Mar 2026 11:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773832834;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EHvqq53e7PSB/mC++wCPGDR//wwHEq1svzM+s8G1ukc=;
	b=UnUnh7oMRWcBIeihtfd4GfVqKaAVHjwsqwPd1qPuwpYLOBvSw3cPOtfQskcYwZuu8Wn0fd
	nLUu4G391ycYXbWNu5N43n7BvpCfC4WkylngN/zJMmvIixcS3EbeK+y/FJowAZx91Wrg2W
	zKxkT5XsNy45SuxBAR2Gth+r7g1r1jw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773832834;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EHvqq53e7PSB/mC++wCPGDR//wwHEq1svzM+s8G1ukc=;
	b=e6i6OEtWD331wvWXE2ThOEMI6KD2FnIH7+N9uuseObs0XzOrv3I/HL5sjiY8sh4v2adCkD
	8mYN9z0R+qub4/CA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773832834;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EHvqq53e7PSB/mC++wCPGDR//wwHEq1svzM+s8G1ukc=;
	b=UnUnh7oMRWcBIeihtfd4GfVqKaAVHjwsqwPd1qPuwpYLOBvSw3cPOtfQskcYwZuu8Wn0fd
	nLUu4G391ycYXbWNu5N43n7BvpCfC4WkylngN/zJMmvIixcS3EbeK+y/FJowAZx91Wrg2W
	zKxkT5XsNy45SuxBAR2Gth+r7g1r1jw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773832834;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EHvqq53e7PSB/mC++wCPGDR//wwHEq1svzM+s8G1ukc=;
	b=e6i6OEtWD331wvWXE2ThOEMI6KD2FnIH7+N9uuseObs0XzOrv3I/HL5sjiY8sh4v2adCkD
	8mYN9z0R+qub4/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F26FF4273B;
	Wed, 18 Mar 2026 11:20:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ThIDO4GKumlOHQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 18 Mar 2026 11:20:33 +0000
Date: Wed, 18 Mar 2026 12:20:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: fix a crash in the trace event
 btrfs_sync_file()
Message-ID: <20260318112032.GD5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3srimnopvbtufn345f73ahr33w57vryl2fxxn2flp2gyc2lr3o@6glyzvqevghe>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3srimnopvbtufn345f73ahr33w57vryl2fxxn2flp2gyc2lr3o@6glyzvqevghe>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,twin.jikos.cz:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Fri, Mar 13, 2026 at 02:11:39PM -0400, Goldwyn Rodrigues wrote:
> If overlay is used on top of btrfs, dentry->d_sb translates to overlay's
> super block and fsid assignment will lead to a crash.
> 
> Use file_inode(file)->i_sb to always get btrfs_sb.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
> Changes since v2:
> - Use of dget_parent() to get the parent of the inode
> Changes since v1:
> - Changed subject to include trace
> - Use file_inode() to get inode pointer

Added to for-next, thanks.

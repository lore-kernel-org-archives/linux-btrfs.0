Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A1B493628;
	Mon, 21 Sep 2026 12:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993704; cv=none; b=LuxKSmvnUKus8UdnLudUIV0iTXi7SvIozfcc1stEuu3/hunh4cnsVFE4RqX9QLHQVWhMrVObj2GyHzcD7Or7K6rvJXYnZlrPn9RlmvTUHZ5MZQ/ithINOZ/YDxie3Km3OC23HTVcClo1kvXFjcW6dQV5ujPut9RINHFYtdlTKSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993704; c=relaxed/simple;
	bh=mzF3kut7BuGOtbGLwChs1e/ciA2Q0aP0OPgZhYPrkpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCjJVmA81ZMnMeTF1VvCNRpJ3XBT13NkVViLEvBogBepCD3SUfAwog+BaRk9y+fgwJhPqUDRUPugFKvvjoS2dMTI8paoMGPjfrTJmqm49abN/GlwdLTh4RLn0M//so0uymxeClQHhe9l7KU3c6o4fe/Ztf04HJST2WuapIH1ybk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=I4rNbRJ0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WjsajGLH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tG0vyo3S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=a6sFYNSa; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="I4rNbRJ0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WjsajGLH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tG0vyo3S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="a6sFYNSa"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A9D561FC05;
	Mon, 21 Sep 2026 12:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789993696;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i+SrhIDsWSVPmvAV5q1VZ8/ZYTUaSOE6cTEDf8AHQpI=;
	b=I4rNbRJ0cYI3zPVLKbXZ/APNPdf+QOuiOTL0QjjPRVhKhxSg2AwDtNHfViu1v7c8Nz1Ffn
	86HR59rVKhSoO6k27a1z6AX3sJMqjDb+I9WmH+DdyxkmF0KIkDNG4yYXj6kAsrkzH+AGmN
	Nc7b61vHSfxE5boNDvswaEN+hRikrpE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789993696;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i+SrhIDsWSVPmvAV5q1VZ8/ZYTUaSOE6cTEDf8AHQpI=;
	b=WjsajGLHnisJJHDI+xgWQXQGU5lESD3saSH5zaBSTDKZBopd3cgg8E2R0Um7PccwHCYWXp
	/xG6WTtbNxo5luBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789993692;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i+SrhIDsWSVPmvAV5q1VZ8/ZYTUaSOE6cTEDf8AHQpI=;
	b=tG0vyo3SPpdpK05SoMa6iE2ubrKuF+xNaMJcJdS2lS5gIbpCnU5Q+f25xg25KIOZn+AUEo
	RJWZUq/fqynOxz0DTeiccNMZB2Sk2qZ1sY/LaqMnyh/sFGR9EW5uiY+6rFco1allnbJYq2
	0GOQjmEu0xw77nvet2YbshGDMNdCpCM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789993692;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i+SrhIDsWSVPmvAV5q1VZ8/ZYTUaSOE6cTEDf8AHQpI=;
	b=a6sFYNSaY8kTF9WGeHHQZochNtqcO1rtmikTdQk9k9MHzWfJ4D3jhMdPKYCQJ5AUaKYBqw
	FhlNAC8GIzYz0XDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D4CE139DC;
	Mon, 21 Sep 2026 12:28:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QgZ3FtwisWoePwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 21 Sep 2026 12:28:12 +0000
Date: Mon, 21 Sep 2026 14:28:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, list.btrfs@jan-o-sch.net,
	stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix local_root reference leak in
 scrub_print_warning_inode()
Message-ID: <20260921122811.GA54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260916171610.2086918-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916171610.2086918-1-vulab@iscas.ac.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iscas.ac.cn:email,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Sep 16, 2026 at 05:16:10PM +0000, Wentao Liang wrote:
> When paths_from_inode() fails, scrub_print_warning_inode() jumps to
> err without dropping the reference taken by btrfs_get_fs_root(),
> leaking a reference to the root every time path resolution fails while
> printing scrub warnings.  Every other error and success path of the
> function drops the reference.
> 
> Drop the reference on the paths_from_inode() failure path too.
> 
> Fixes: 558540c17771 ("btrfs scrub: print paths of corrupted files")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Added to for-next, thanks.

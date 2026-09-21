Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664763C3F5C;
	Mon, 21 Sep 2026 12:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994988; cv=none; b=i7KmAez+dpM1N7Pu+MkOs/zF2icLg3lvjNX5ga06WpH9xdvJGUtxFrYSe1FfBg+cr4VIG9j3uVLtKVf9xz0WFjXItmOKTKbRKkbauhaZxTye36aKFcpKb33q1k+WLzvnJ6fq+D1L9FJqtQItqIbAbnfGfRncijcyLb0bdW2JujU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994988; c=relaxed/simple;
	bh=GrGJO3m9j49Co+pGdq//2esF7gHhdq16xTas6Rwiprk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBFxA4hg85G0UGYLZZRoPyBe6g/aMm0zluVUlSCERkZYuf7s191i5yZzxGRRDtDDDG2Onv3MdqvP3Qm5Ebx1NE3mCV1t9sTjCPB2OfZv9iIWY/LEa63QjgMNWCmBI4QBTAL4Y1CT3QxyYaoW9ffXTe4UxVNlg2BSyQFxMqMqZmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=my5aeO1U; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HcPl4ODx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BtZLNI8c; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IM+48rP5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="my5aeO1U";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HcPl4ODx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BtZLNI8c";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IM+48rP5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5658D21AA2;
	Mon, 21 Sep 2026 12:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789994981;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D6ydRcSAeF+DH0s85zWIWWyZ8vFTJT74/Uc1TvApogs=;
	b=my5aeO1UQMs5O7m155UzVI1Qhzb3C7CgxTwsL4ysHuQMFBIKjkERf8StfJWVhSp8HuEI39
	F9UBLq2O1vDsMu/UtwUKa5RKUd87SIK5qKXojVCBzXc71th6ZA7jU375XZYU2MMmHl4dQA
	q1+yJkVLmiX3Xtg9PNKQq562ARV3xKA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789994981;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D6ydRcSAeF+DH0s85zWIWWyZ8vFTJT74/Uc1TvApogs=;
	b=HcPl4ODxeYeDNu0ZqosCbobWEFhPFnUYizE5Jl6Q5vTxlfVEf1DVJDlw1EO7+8qRXJgX+o
	gaPkT2G4QCUYd1Cg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BtZLNI8c;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IM+48rP5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789994977;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D6ydRcSAeF+DH0s85zWIWWyZ8vFTJT74/Uc1TvApogs=;
	b=BtZLNI8cnSMBuDBrxGjE1YgxWtpsjgqYrqVSBZoFwSqIaSLC+jQj5tUBUtJjCRrjq3uFj4
	JBhWmcbo8cglD7j9lnU/dm9Gh/YBOlxdjTIWkGbdjtcS0jhvL+j9N7C6EiEjCc/f3xZ0zT
	ZiwI11aHIIdMedrMvsnzfssM25rUG0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789994977;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D6ydRcSAeF+DH0s85zWIWWyZ8vFTJT74/Uc1TvApogs=;
	b=IM+48rP5uK6VMZABDThq+i3PWGUrC57dO1d/JZR2VnCpnx7TWFJjkUwkxU/XlSa0c6rcRx
	Bdgs5E85YgV7U1DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 297871368D;
	Mon, 21 Sep 2026 12:49:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kCruAeEnsWriVQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 21 Sep 2026 12:49:37 +0000
Date: Mon, 21 Sep 2026 14:49:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: clm@fb.com, dsterba@suse.com, quwenruo.btrfs@gmx.com,
	linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 0/5] btrfs: fix io_uring encoded IO cleanup
Message-ID: <20260921124927.GC54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260819025436.1949152-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819025436.1949152-1-yangxiuwei@kylinos.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 5658D21AA2
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmx.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[fb.com,suse.com,gmx.com,vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Wed, Aug 19, 2026 at 10:54:31AM +0800, Yang Xiuwei wrote:
> Hi,
> 
> Fixes for the io_uring ENCODED_READ / ENCODED_WRITE cleanup paths.
> 
> 1. Always return -EIOCBQUEUED after endio so the caller and
>    btrfs_uring_read_finished() do not both clean up.
> 
>    Link: https://lore.kernel.org/linux-btrfs/20260630091609.3414-1-samsun1006219@gmail.com/
> 
> 2. btrfs_uring_read_extent() failure skipped kfree(data->iov).
> 
> 3. Unlock inode/extent in the caller on read-extent failure.
> 
> 4. Do not stash encoded data in the cmd PDU across -EAGAIN.
> 
> 5. Drop the unused REISSUE restore.
> 
> v2 also exported __import_iovec() and passed IO_URING_F_COMPAT.
> That is not a bug with the current io_uring thread setup:
> create_io_thread() copies TS_COMPAT, so import_iovec() already
> sees compat iovecs. Passing the flag explicitly would still be a
> cleanup, but this series does not take it.
> 
> Testing:
> - xfstests btrfs/333 passed.
> - kmemleak after dropping the ring on NONBLOCK encoded write/read:
> 
>   unreferenced object (size 512):
>     comm "btrfs_uring_eag"
>     __kmalloc_cache_noprof+0x38f/0x4a0
>     btrfs_uring_encoded_write+0x78d/0x1790 [btrfs]
>     btrfs_uring_cmd+0x142/0x1d0 [btrfs]
>     io_uring_cmd+0x296/0x5e0
> 
>   unreferenced object (size 512):
>     comm "btrfs_uring_eag"
>     __kmalloc_cache_noprof+0x38f/0x4a0
>     btrfs_uring_encoded_read+0x89a/0x12b0 [btrfs]
>     btrfs_uring_cmd+0x173/0x1d0 [btrfs]
>     io_uring_cmd+0x296/0x5e0
> 
>   After 4/5 the same repro is clean.
> 
> Changes in v3:
> - Drop the __import_iovec / IO_URING_F_COMPAT patches. 
> - 3/5: drop a leftover goto out_fail from v2.

Added to for-next, thanks.

IORING_URING_CMD_REISSUE is now only used in block layer code.

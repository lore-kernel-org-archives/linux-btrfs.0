Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AB6428858
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 15:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777389231; cv=none; b=GegKNyPNeLKiuo3CQjStDQg36XQg51sojv62szq0r5pyR3qSG1TTSLnTjQmP+mXcQTWTHgCAr3o+eazLU8d5YvjGwNlMRl3wr4fQGxX00VVLTEpoHUuOfgpuA4lcx15XSRDrB/K3VgtuBbtwGqOcfa/AJApe5LZaah4d/UWVtiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777389231; c=relaxed/simple;
	bh=xNVvIQad51OCXv9o/uVgRojNZ+62HTWUkimCuRotMIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DIABQS1P6+HmsCOY1Uiqdmlaw/Ls89n4Fhhdlm1xu8a4t5sscB2S4lBY26sbs0oJ2bq3vhR2NGad2kVs+EdemY+rJLLACTBRo32TKRJvetmEblpHGE9XtLOqDnfc4b9ZmL5wdc9aWUTVezqEnPSnO8eocMHCQB7haMwGfJP8hmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1H4a6j37; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=S3XGDnl2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1H4a6j37; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=S3XGDnl2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1H4a6j37";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="S3XGDnl2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1H4a6j37";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="S3XGDnl2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 672816A820;
	Tue, 28 Apr 2026 15:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777389227;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZfGM8sT6+3JF6h/yP70CYGOekkTSp4b9v6WoUSHj9A=;
	b=1H4a6j37rQVsG2xAspLavqb5L5O6FOki1UV127Sp2HL+EB9x7B8+SSVfwXWg18pSeZsUyL
	8NMVOCTsBVFa7NDFzA7l5KOHrW7nR/ueAzPyBLzCc+4EeDcB+41VlIeKv1exrhyOubgrXI
	rzzQctVJDTOUYHw6cCnKmjgPwcBL8C4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777389227;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZfGM8sT6+3JF6h/yP70CYGOekkTSp4b9v6WoUSHj9A=;
	b=S3XGDnl2FW5uZ1G/1M7iWg8oO95PIp18RoBMKc/JiNsw2ikuk8/Pn+pRj5K9FHkMf4Rsw0
	T6x71WV9snO6EABQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1H4a6j37;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S3XGDnl2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777389227;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZfGM8sT6+3JF6h/yP70CYGOekkTSp4b9v6WoUSHj9A=;
	b=1H4a6j37rQVsG2xAspLavqb5L5O6FOki1UV127Sp2HL+EB9x7B8+SSVfwXWg18pSeZsUyL
	8NMVOCTsBVFa7NDFzA7l5KOHrW7nR/ueAzPyBLzCc+4EeDcB+41VlIeKv1exrhyOubgrXI
	rzzQctVJDTOUYHw6cCnKmjgPwcBL8C4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777389227;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZfGM8sT6+3JF6h/yP70CYGOekkTSp4b9v6WoUSHj9A=;
	b=S3XGDnl2FW5uZ1G/1M7iWg8oO95PIp18RoBMKc/JiNsw2ikuk8/Pn+pRj5K9FHkMf4Rsw0
	T6x71WV9snO6EABQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 54F4F593B0;
	Tue, 28 Apr 2026 15:13:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wnWFFKvO8GmiWAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 28 Apr 2026 15:13:47 +0000
Date: Tue, 28 Apr 2026 17:13:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org, josef@toxicpanda.com, boris@bur.io
Subject: Re: [PATCH] btrfs: don't force DIO writes to be serialized
Message-ID: <20260428151342.GF3906171@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260422140339.417238-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422140339.417238-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 672816A820

On Wed, Apr 22, 2026 at 03:03:35PM +0100, Mark Harmstone wrote:
> Before btrfs switched to the new mount API in 2023, we were setting
> SB_NOSEC in btrfs_mount_root(). This flag tells the VFS that the
> filesystem may have files which don't have security xattrs, enabling it
> to do some optimizations.
> 
> Unfortunately this was missed in the transition, meaning that IS_NOSEC
> will always return false for a btrfs inode. This means that
> btrfs_direct_write() calls will always get the inode lock exclusively,
> meaning that DIO writes to the same file will be serialized.
> 
> On my machine, this one-line change results in a ~59% improvement in DIO
> throughput:
> 
> Before patch:
> 
>   test: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=64
>   ...
>   fio-3.39
>   Starting 32 processes
>   test: Laying out IO file (1 file / 1024MiB)
>   Jobs: 32 (f=32): [w(32)][100.0%][w=764MiB/s][w=195k IOPS][eta 00m:00s]
>   test: (groupid=0, jobs=32): err= 0: pid=586: Wed Apr 22 13:03:04 2026
>     write: IOPS=202k, BW=787MiB/s (826MB/s)(46.1GiB/60012msec); 0 zone resets
>      bw (  KiB/s): min=498714, max=1199892, per=100.00%, avg=806659.03, stdev=4229.94, samples=3808
>      iops        : min=124677, max=299971, avg=201661.82, stdev=1057.49, samples=3808
>     cpu          : usr=0.32%, sys=1.27%, ctx=8329204, majf=0, minf=1163
>     IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
>        submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>        complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>        issued rwts: total=0,12094328,0,0 short=0,0,0,0 dropped=0,0,0,0
>        latency   : target=0, window=0, percentile=100.00%, depth=64
> 
>   Run status group 0 (all jobs):
>     WRITE: bw=787MiB/s (826MB/s), 787MiB/s-787MiB/s (826MB/s-826MB/s), io=46.1GiB (49.5GB), run=60012-60012msec
> 
> After patch:
> 
>   test: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=64
>   ...
>   fio-3.39
>   Starting 32 processes
>   test: Laying out IO file (1 file / 1024MiB)
>   Jobs: 32 (f=32): [w(32)][100.0%][w=1255MiB/s][w=321k IOPS][eta 00m:00s]
>   test: (groupid=0, jobs=32): err= 0: pid=572: Wed Apr 22 13:13:46 2026
>     write: IOPS=320k, BW=1250MiB/s (1311MB/s)(73.3GiB/60003msec); 0 zone resets
>      bw (  MiB/s): min=  619, max= 2289, per=100.00%, avg=1251.28, stdev= 9.64, samples=3808
>      iops        : min=158538, max=586025, avg=320320.80, stdev=2468.97, samples=3808
>     cpu          : usr=0.35%, sys=11.50%, ctx=1584847, majf=0, minf=1160
>     IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
>        submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>        complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>        issued rwts: total=0,19203309,0,0 short=0,0,0,0 dropped=0,0,0,0
>        latency   : target=0, window=0, percentile=100.00%, depth=64
> 
>   Run status group 0 (all jobs):
>     WRITE: bw=1250MiB/s (1311MB/s), 1250MiB/s-1250MiB/s (1311MB/s-1311MB/s), io=73.3GiB (78.7GB), run=60003-60003msec
> 
> Fixes: ad21f15b0f79 ("btrfs: switch to the new mount API")
> Signed-off-by: Mark Harmstone <mark@harmstone.com>

I've updated changelog with the fio script and added the patch to
for-next. We want to get this backported to stable trees, ETA 2 weeks so
we get some coverage.

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795804965;
	b=icY05BguTWfFhjFruAC76vNcA8evDvvGP1e2jB6M9tvGsMnaXj1fqLHOFCI4Uc5r//hh
	 L5Iv26AZwCBWr+pG0AMy6i6j62WSfq32Ny9QYEZEAN4qgqJrD5zBRE9XHfruWRxMgQ/Ae
	 641tgZlPWCzNUOb1jtzHvKY8EOfruKm2F9nyg5sCtaHyqKGCwP6pHwDnXI5AY6sKCenmh
	 vbGLcAXEhyr0walWKoYl+hsYRgD5+UHz3ke2h6K4c2YMqfbvIqG37Grjj5Gk4QRnENRhU
	 5u1VSo6rfvzLt8dt2yayaPZElLFBxJ0+vQlyGbs9FIllqc6mbAsqtLz8IZnDiuBLq7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795804965;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:User-Agent:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=PyL9TfGUXnHnBqoxrOJGOqqX5uDceUTJPbMtH4m5nN0=;
	b=m3VWPKMn1sDRVAyKWtQD6jzgDwW1LdY4mxS2biaC9q/qO0u9syEdslKh0ALj7jbrpwin
	 NAlZaqkvcusxadZ2BopIinEBVjeQWQrc6QpCMuBQE/No3XpLkeCv2wyEzRGhNT9ziPBGi
	 lGqWJZ0Sm9V7jgRLdDw3bGHRYx3Ad9xEUDgdfb2NlO4Q2CCZOg7X+j/O+32BqT+7IUFEl
	 GVGSUQYo5uAD67X+JhNi+Z0vGoG92knuIcQREWP6d8frZlg0mCnfbYoK9hdA9j8G2HabH
	 0aYrh1QNVzRFnmQN4FAVt6qpr0u7A5SMqVwoYn/HlYeN8j6BfseSx6NyGiyU5LjkTug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SECrzghM;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yIcauF5L;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SECrzghM;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yIcauF5L;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E8E60A380F
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 18:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1E8E60A380F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SECrzghM;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yIcauF5L;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SECrzghM;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yIcauF5L
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 02C27229B7;
	Fri, 27 Nov 2026 18:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795804963;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PyL9TfGUXnHnBqoxrOJGOqqX5uDceUTJPbMtH4m5nN0=;
	b=SECrzghMgBexK2dkmPUHJuBwMzhaZuiyl1tiF7SSadMru6ZVhkm0UYClMUE947sIq6iMPL
	lKWqvl61c1hQB3xmTNB1dB52S1r9tQZGQ3fZHWIjCoX11wAxO21zj+7e95YkKdrGnV1eO6
	MzECOGsJPNuvImm0n5MfM/I5pD0n+GQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795804963;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PyL9TfGUXnHnBqoxrOJGOqqX5uDceUTJPbMtH4m5nN0=;
	b=yIcauF5L+Q0P9gGAaGbn5XgKa5VVZmySiVNqYUhpAksECGLUqpw9TbuVHL9w/JZW3rNNxT
	+LWgMZHKqrORM/DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795804963;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PyL9TfGUXnHnBqoxrOJGOqqX5uDceUTJPbMtH4m5nN0=;
	b=SECrzghMgBexK2dkmPUHJuBwMzhaZuiyl1tiF7SSadMru6ZVhkm0UYClMUE947sIq6iMPL
	lKWqvl61c1hQB3xmTNB1dB52S1r9tQZGQ3fZHWIjCoX11wAxO21zj+7e95YkKdrGnV1eO6
	MzECOGsJPNuvImm0n5MfM/I5pD0n+GQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795804963;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PyL9TfGUXnHnBqoxrOJGOqqX5uDceUTJPbMtH4m5nN0=;
	b=yIcauF5L+Q0P9gGAaGbn5XgKa5VVZmySiVNqYUhpAksECGLUqpw9TbuVHL9w/JZW3rNNxT
	+LWgMZHKqrORM/DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBE9F13432;
	Fri, 27 Nov 2026 18:42:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LbmkKSLPCWsZVwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 27 Nov 2026 18:42:42 +0000
Date: Fri, 27 Nov 2026 19:42:41 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: reject rename exchange operations with subvolume
 stubs
Message-ID: <20261127184241.GE3245297@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <db82ae780edd7572f150da6b25f2fb73af1e31a9.1795798503.git.fdmanana@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db82ae780edd7572f150da6b25f2fb73af1e31a9.1795798503.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -13.00

On Fri, Nov 27, 2026 at 05:11:14PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Currently we are allowing rename exchange operations when one of the paths
> points to a subvolume stub (created with new_simple_dir(), due to creating
> a snapshot of a subvolume that has subvolumes inside it). This results in
> a transaction abort, turning the filesystem into RO mode, since the stubs
> are mockup dentries that have no underlying inode, so attempting to search
> and delete inode ref items fails during the rename exchange, leading to a
> transaction abort with -ENOENT:
> 
>   $ cat test.sh
>   #!/bin/bash
> 
>   DEV=/dev/sdi
>   MNT=/mnt/sdi
> 
>   mkfs.btrfs -f $DEV
>   mount $DEV $MNT
> 
>   btrfs subvolume create $MNT/subvol
>   btrfs subvolume create $MNT/subvol/inner_subvol
> 
>   touch $MNT/subvol/file
> 
>   btrfs subvolume snapshot $MNT/subvol $MNT/snap
> 
>   mv --exchange -T $MNT/snap/file $MNT/snap/inner_subvol
> 
>   umount $MNT
> 
> Running it:
> 
>   $ ./test.sh
>   (...)
>   Create subvolume '/mnt/sdi/subvol'
>   Create subvolume '/mnt/sdi/subvol/inner_subvol'
>   Create snapshot of '/mnt/sdi/subvol' in '/mnt/sdi/snap'
>   mv: cannot exchange '/mnt/sdi/snap/file' and '/mnt/sdi/snap/inner_subvol': No such file or directory
> 
> And dmesg shows a transaction abort:
> 
>   $ dmesg
>   [277913.996925] BTRFS critical (device sdi): failed to delete reference to inner_subvol, root 258 inode 2 parent 256
>   [277913.996950] ------------[ cut here ]------------
>   [277913.996951] WARNING: fs/btrfs/inode.c:4399 at __btrfs_unlink_inode+0x3a8/0x420 [btrfs], CPU#0: mv/1549646
>   [277914.001156] Modules linked in: btrfs dm_dust loop (...)
>   [277914.016365] CPU: 0 UID: 0 PID: 1549646 Comm: mv Tainted: G        W           7.4.0-rc4-btrfs-next-252+ #1 PREEMPT(full)
>   [277914.018964] Tainted: [W]=WARN
>   [277914.019622] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
>   [277914.021892] RIP: 0010:__btrfs_unlink_inode+0x3a8/0x420 [btrfs]
>   [277914.023185] Code: 85 c0 78 (...)
>   [277914.026865] RSP: 0018:ffffd33e801dfb80 EFLAGS: 00010206
>   [277914.028098] RAX: 00000000fffffffe RBX: ffff8c89cc89e000 RCX: 0000000000000000
>   [277914.030305] RDX: 000000000000001c RSI: 0000000000000001 RDI: ffff8c89c4bb12c0
>   [277914.031978] RBP: ffff8c8f542a9d80 R08: 3fffffffffefffff R09: 0000000000014b83
>   [277914.033448] R10: ffffd33e801df840 R11: 0000000000000002 R12: ffff8c8f543bf838
>   [277914.034891] R13: ffffd33e801dfca8 R14: ffff8c89defee000 R15: ffff8c89e4c31a10
>   [277914.036370] FS:  00007f709e183840(0000) GS:ffff8c913f2ce000(0000) knlGS:0000000000000000
>   [277914.037984] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [277914.039144] CR2: 00007f709e29ba80 CR3: 0000000524f02004 CR4: 0000000000370ef0
>   [277914.040585] Call Trace:
>   [277914.041107]  <TASK>
>   [277914.041584]  btrfs_rename_exchange+0x37b/0xbf0 [btrfs]
>   [277914.042734]  ? inode_set_ctime_current+0x3b/0x220
>   [277914.043690]  btrfs_rename2+0x53/0x60 [btrfs]
>   [277914.044648]  vfs_rename+0x5b4/0xe40
>   [277914.045371]  filename_renameat2+0x222/0x450
>   [277914.046256]  __x64_sys_renameat2+0x4e/0x70
>   [277914.047091]  do_syscall_64+0x8b/0x490
>   [277914.047902]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   [277914.048912] RIP: 0033:0x7f709e29ba8f
>   [277914.049717] Code: 44 00 00 (...)
>   [277914.054201] RSP: 002b:00007fff08b22438 EFLAGS: 00000202 ORIG_RAX: 000000000000013c
>   [277914.055699] RAX: ffffffffffffffda RBX: 00007fff08b242d2 RCX: 00007f709e29ba8f
>   [277914.057110] RDX: 00000000ffffff9c RSI: 00007fff08b242d2 RDI: 00000000ffffff9c
>   [277914.058534] RBP: 00007fff08b242e5 R08: 0000000000000002 R09: 0000000000000001
>   [277914.059942] R10: 00007fff08b242e5 R11: 0000000000000202 R12: 0000000000000002
>   [277914.061336] R13: 00000000ffffff9c R14: 00000000ffffff9c R15: 00007fff08b22a90
>   [277914.062754]  </TASK>
>   [277914.063232] ---[ end trace 0000000000000000 ]---
>   [277914.064191] BTRFS error (device sdi state A): Transaction 10 aborted (-ENOENT)
>   [277914.064195] BTRFS: error (device sdi state A) in __btrfs_unlink_inode:4399: errno=-2 No such entry
>   [277914.064197] BTRFS info (device sdi state EA): forced readonly
>   [277914.064199] BTRFS: error (device sdi state EA) in btrfs_rename_exchange:8458: errno=-2 No such entry
> 
> Fix this by rejecting rename exchange operations against dentries that are
> subvolume stubs.
> 
> Reported-by: Tianyu Chen <chentianyu@microsoft.com>
> Link: https://lore.kernel.org/linux-btrfs/TY8P153MB237624AA8DAAC5323DE20B46DF412@TY8P153MB2376.APCP153.PROD.OUTLOOK.COM/
> Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B34E7262A
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 15:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777561733; cv=none; b=UaPqU/wEVJqaAt/CyyG2f4I5YaOSKgi6ZrN5oXCDpUnZfWHBUediFyaPJyBd2kwXSSfeFzuXirYw3UH+jIHlz2jYh9DM3ZumnfMdkOX7p1xkJJMtdtjzT7P1mqEvvq5IzOm0hxBzZYtZlxKov7f0PE04aU6gvzJ6JI/oXQqCI9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777561733; c=relaxed/simple;
	bh=4fQSAAAH7bBMhTKkXUKLNsXTfBJYzLVf/xUye4+iJ4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAi7SLw2WrT97jGhCGNMT472yqiG+90waHR4uMylXwjVmzZvsbuZGiHyOo1BWDtYaUBUhHBvovFnAxQUR8pWlMc4sEswkqDUxEFjHPMmKRBJl0dNck2MEKl2EV4gHBjG8wvlslVaU3v/1Awqh7GtEK8SKgl8SXuSshPjrK2MZto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=eP+yhRze; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Ue9SSbtK; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="eP+yhRze";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ue9SSbtK"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D41867A0028;
	Thu, 30 Apr 2026 11:08:49 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 30 Apr 2026 11:08:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1777561729; x=1777648129; bh=XuscbQoZiN
	vvWP8D2cQuDQ+uKMih+5kGUIanApPvR4k=; b=eP+yhRzekCPBTvok8hksfw9paz
	Cd13BYPd0JpZwUegkcoB98XSl8gDySMnV/l4qqufJ1VMA0xcJ+dKmXhD9jhmqdmQ
	FsBnLWcrFPZVQxlQUmUHEoV0dbeVvVhV5JA3HNZ8O9MLCuUeB7RysgVcxDOswuwE
	5YUNLDlQ2jWZHg54CJ2xqfI934DSBjRNsTiimp1cwQiytlxR036o968rzql8xgQi
	8L/mprv4QMANJenZR6QqfiYGvyGxShVo2LnDdUBa4S5SYrdB4CVRPRcE/vxYhTfz
	R2jSuU6qSy7Wad+u9Hr7jgYhhn86jp8xPs17qlyM5f8QhloFdKkTnVGhAnaA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1777561729; x=1777648129; bh=XuscbQoZiNvvWP8D2cQuDQ+uKMih+5kGUIa
	nApPvR4k=; b=Ue9SSbtKtXbuGojQ8bUMUZjLFUSVNfnni6I0pDaPxUDQ0ubTsqa
	c9GB8ItPt0IxSNR6shIQCtzy7HpfoIJKpr5g/hsI0/MqSy9eM1r8pKh3WnqTbbGY
	tqGn3kgxByIHP0A7SGBXycds3ofrAPzjW8t7ob10FDrfIuM0owNjUvp+lFsqVb46
	A0Pfz5DoychdyoOnzCdJ97lRfRY0lsfEHkcVX7OqKeUQ+7FcpK0+sQoI+qDnAKwK
	EcXckjEpryv0XzmN5sYZmFFoCk9XoAjHH6IwksHs5Z7MIPTFKaIpYBxDT37tsjlF
	CtUaWpWB5NE43VgmWk7RAlulTSUJqTrNh5Q==
X-ME-Sender: <xms:gXDzab5KDrSh29qrxBshuJrIwDK3aEnIJesLI0sHMUsjsgbdHtzEfw>
    <xme:gXDzaRF9rWDiwR6j8o3DPQKPL3CtVbLyqGKZh_HedF5TGAbOQtRf_yzCHEnu06_ye
    HxTNiyDW1f8x8_njPjttFIWoaydCyYLHXFYuIZSuLj1e51nvWlvVnE>
X-ME-Received: <xmr:gXDzaUTPwTntK6BIHmUGX_Z3K8rzMcJsOFUugREqWDP5tlUkM2PlG4qXRYwvLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekjeeigecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepuefgfe
    etffefgfduvedvvedtfffgudefgfeuffejffehheduueeiudetkeegffehnecuffhomhgr
    ihhnpehqvghmuhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepvddpmhho
    uggvpehsmhhtphhouhhtpdhrtghpthhtohepfhgumhgrnhgrnhgrsehsuhhsvgdrtghomh
    dprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:gXDzaavVMqxB2-OUm0E6OUbrncY7ZvswGyt1oce3oHFpWMXMoWLYhw>
    <xmx:gXDzaTyH2N4afbks67Q7cUftWdJcnrIySOmPRLcqwT_DbPtAo2NOVg>
    <xmx:gXDzaU4vlvrg3q8iqP7UA8i5Dva3epyCQnVSLomPfrgHUZOFvwm3dA>
    <xmx:gXDzadUvLJIXYOdXY4kw4N3cYByUTvNal1TZ5FpCxcEjsIU8oe4_Bg>
    <xmx:gXDzaYpDbQ298kRWvDRMH0L7GR5lyukiLVWQjAHF7w3PGNPgT9L2cJtj>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Apr 2026 11:08:49 -0400 (EDT)
Date: Thu, 30 Apr 2026 08:08:45 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: tracepoints: fix sleep while in atomic context in
 btrfs_sync_file()
Message-ID: <afNwffvf1FG43XAb@devvm12410.ftw0.facebook.com>
References: <d93784745689ea623c8c1156755d0113344a9354.1777392274.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d93784745689ea623c8c1156755d0113344a9354.1777392274.git.fdmanana@suse.com>

On Tue, Apr 28, 2026 at 05:05:43PM +0100, Filipe Manana wrote:
> The trace event btrfs_sync_file() can be called in an atomic context and
> its call to dput(), which is needed due to the call to dget_parent(), can
> sleep, triggering a kernel splat.
> 
> This can be reproduced by enabling the trace event and running btrfs/056
> from fstests for example. The splat shown in dmesg is the following:
> 
>    [84853.995109] BUG: sleeping function called from invalid context at fs/dcache.c:970
>    [84853.996457] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 32773, name: xfs_io
>    [84853.997858] preempt_count: 2, expected: 0
>    [84853.998647] RCU nest depth: 0, expected: 0
>    [84853.999403] Preemption disabled at:
>    [84853.999404] [<0000000000000000>] 0x0
>    [84854.000708] CPU: 0 UID: 0 PID: 32773 Comm: xfs_io Tainted: G        W           7.1.0-rc1-btrfs-next-232+ #1 PREEMPT(full)
>    [84854.000710] Tainted: [W]=WARN
>    [84854.000711] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
>    [84854.000712] Call Trace:
>    [84854.000714]  <TASK>
>    [84854.000716]  dump_stack_lvl+0x56/0x80
>    [84854.000719]  __might_resched.cold+0xd6/0x10f
>    [84854.000722]  dput.part.0+0x24/0x110
>    [84854.000728]  trace_event_raw_event_btrfs_sync_file+0x75/0x140 [btrfs]
>    [84854.000809]  btrfs_sync_file+0x1ed/0x530 [btrfs]
>    [84854.000887]  ? __handle_mm_fault+0x8ae/0xed0
>    [84854.000889]  btrfs_do_write_iter+0x172/0x210 [btrfs]
>    [84854.000951]  vfs_write+0x21f/0x450
>    [84854.000954]  __x64_sys_pwrite64+0x8d/0xc0
>    [84854.000956]  ? do_user_addr_fault+0x20c/0x670
>    [84854.000959]  do_syscall_64+0x60/0xf20
>    [84854.000962]  ? clear_bhb_loop+0x60/0xb0
>    [84854.000964]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> So stop using dget_parent() and dput() and access the parent dentry
> directly as dentry->d_parent. This is also what ext4 is doing in
> its equivalent trace event ext4_sync_file_enter().
> 
> Fixes: a85b46db143f ("btrfs: tracepoints: get correct superblock from dentry in event btrfs_sync_file()")

Looks good, thanks.
Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  include/trace/events/btrfs.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index 8ad7a2d76c1d..ec1df8b94517 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -771,10 +771,8 @@ TRACE_EVENT(btrfs_sync_file,
>  	TP_fast_assign(
>  		struct dentry *dentry = file_dentry(file);
>  		struct inode *inode = file_inode(file);
> -		struct dentry *parent = dget_parent(dentry);
> -		struct inode *parent_inode = d_inode(parent);
> +		struct inode *parent_inode = d_inode(dentry->d_parent);
>  
> -		dput(parent);
>  		TP_fast_assign_fsid(btrfs_sb(inode->i_sb));
>  		__entry->ino		= btrfs_ino(BTRFS_I(inode));
>  		__entry->parent		= btrfs_ino(BTRFS_I(parent_inode));
> -- 
> 2.47.2

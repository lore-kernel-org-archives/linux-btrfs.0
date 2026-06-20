Received: from mail-108-mta55.mxroute.com (mail-108-mta55.mxroute.com [136.175.108.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8F53D76
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Jun 2026 02:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781923907; cv=none; b=CPXqmbNvrLq5l5vhPDx5TgFCWTJwnAtYFeeJyNvtBkN8tj0rTfmdH4487tq5FDrxcKVT2ATOrNapzTnNx+kDfhJ9GzOtwvPGAg8LidtFRUb97j1RhBb/cclOu+giDOjHKm/4tWAo2gxDbl+pc0vXzWyxrxcmnWJmXsJJQGCexnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781923907; c=relaxed/simple;
	bh=lJHjCVeq8TKQttIQ8P08ZluNKcaWZ8GCLqCxth0ydDo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aUzYSjZ9IJz0ITJkKgDm7XozWxCjdebUgQd5BzOOsXPj5K9yc/w81TxvoRmnfAUMFRo4kMKozoha7muz9kLxTc1p8BarYPRd0EXY8KTcaLgph4yUPyUmi9LIDmJ4tVUDj+NOiajHaqajY4tLK+RRDygP7TlbPkB3juBvMpS8cVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=FsWeKg+w; arc=none smtp.client-ip=136.175.108.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="FsWeKg+w"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta55.mxroute.com (ZoneMTA) with ESMTPSA id 19ee2ec2a9c00067f7.003
 for <linux-btrfs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Sat, 20 Jun 2026 02:46:28 +0000
X-Zone-Loop: c0e65196a366ea559ef313fecc25f6e4fb959391507d
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MWmbRiKNtzKm3Scj0loIwf3ilBmV/wn+06j+I1x+66I=; b=FsWeKg+wBG67/S5H/5A+kvxQE1
	WCpGeigo5PyOvxeL+19B8ddMzdo5J+1ay5DHxhJbwEO7aMYidcHa1oHeLlkHQpxxWOw1ZH8p7BnX/
	3wBp2YHJwVtlAu2QDTMDG+7SCCGGfLaVgpiegEl0gAanbQ5Oe9wjwU9u+DD1c/Wp86/Yq90BVbJwu
	namAeArQr587/1W6dsv1O14nPwX7tJzo4L2nZaD3uwKqFhNEAZwFy3jZMi7ixTUwd1CWK2kLSP3ed
	RCfITRsYMvG90qxOAE2EAF/MQ80kXfqU1s3MR3QBPwE+BO/OYv/IHbanBknukkZTR+my6n/3Zb19P
	5lD5hxtg==;
From: Su Yue <l@damenly.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,  Glass Su <glass.su@suse.com>
Subject: Re: [PATCH] btrfs: do not check eb->refs to determine if the eb is
 still held
In-Reply-To: <8b5fd5214014615765dfdc66f89347c4ea8b2654.1781921185.git.wqu@suse.com>
 (Qu
	Wenruo's message of "Sat, 20 Jun 2026 11:37:01 +0930")
References: <8b5fd5214014615765dfdc66f89347c4ea8b2654.1781921185.git.wqu@suse.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Sat, 20 Jun 2026 10:46:21 +0800
Message-ID: <cxxmszcy.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Sat 20 Jun 2026 at 11:37, Qu Wenruo <wqu@suse.com> wrote:

> [FALSE ALERTS]
> There is a bug report that the warning inside
> invalidate_and_check_btree_folios() got triggered duriong 
> btrfs/298:
>
>  BTRFS info (device sdd): first mount of filesystem 
>  f9bf732a-a19b-44b9-99a7-614ddff168e2
>  BTRFS info (device sdd): using crc32c checksum algorithm
>  BTRFS error (device sdd): failed to find fsid 
>  cb2fdb42-b638-4f2f-badd-4127467ba674 when attempting to open 
>  seed devices
>  BTRFS error (device sdd): failed to read chunk tree: -2
>  ------------[ cut here ]------------
>  WARNING: disk-io.c:3342 at 
>  invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs], CPU#4: 
>  mount/125993
>  CPU: 4 UID: 0 PID: 125993 Comm: mount Tainted: G        W  OE 
>  7.1.0-rc7-custom+ #1 PREEMPT(full)
>  Hardware name: QEMU KVM Virtual Machine, BIOS 
>  edk2-20250812-19.fc42 08/12/2025
>  Call trace:
>   invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs] (P)
>   open_ctree+0x1f50/0x23b0 [btrfs]
>   btrfs_get_tree+0x89c/0xc48 [btrfs]
>   vfs_get_tree+0x30/0x110
>   vfs_cmd_create+0x58/0xe8
>   __arm64_sys_fsconfig+0x39c/0x518
>   invoke_syscall.constprop.0+0x48/0x120
>   el0_svc_common.constprop.0+0x40/0xe8
>   do_el0_svc+0x24/0x38
>   el0_svc+0x50/0x310
>   el0t_64_sync_handler+0xa0/0xe8
>   el0t_64_sync+0x198/0x1a0
>  ---[ end trace 0000000000000000 ]---
>  BTRFS warning (device sdd): unable to release extent buffer 
>  365985792 owner 3 gen 17 refs 3 flags 0x5
>
> [CAUSE]
> In that invalidate_and_check_btree_folios() we wait for the eb 
> to finish
> its read, then check if it's only held by us and the btree 
> inode.
>
> If not, then do a warning as it may be still held, and could 
> cause
> problems.
>
> But there is a small window where the check can lead to false 
> alerts:
>
>     Thread A (Read endio)         |        Thread B (Unmount)
> ----------------------------------+-------------------------------------
>  end_bbio_meta_read()             |
>  | The eb has one extra ref held  |
>  | by the reader, and has         |
>  | EXTENT_BUFFER_READING flag set | 
>  invalidate_and_check_btree_folios()
>  |                                | |
>  |- clear_extent_buffer_reading() | |
>  |                                | |- wait_on_bit_io();
>  |                                | |  The EXTENT_BUFFER_READING 
>  flag is
>  |                                | |  cleared
>  |                                | |- if 
>  (refcount_read(eb->refs) > 2)
>  |                                |    The eb is held by the 
>  read, us
>  |                                |    and btree inode, thus it
>  |                                |    will trigger the warning
>  |- free_extent_buffer()          |
>
> [WORKAROUND]
> Unfortunately EXTENT_BUFFER_READING flag clearing is always 
> before
> extent buffer put, thus there is no simple way to make sure the 
> read is
> finished along with eb put.
>
> For now just remove the eb->refs check until a proper protection 
> is
> introduced for clearing EXTENT_BUFFER_READING and updates of 
> eb->refs.
>
> Reported-by: Glass Su <glass.su@suse.com>
>
Reported-by: Su Yue <glass.su@suse.com>

Also for this patch:
Reviewed-by: Su Yue <glass.su@suse.com>


> Link: 
> https://lore.kernel.org/linux-btrfs/DC0C775E-13B3-47D9-9AB2-895BB11C029D@suse.com/
> Fixes: 83f7e52b7ed1 ("btrfs: warn about extent buffer that can 
> not be released")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 0a7d80da9c94..39a389cdbdd4 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3328,10 +3328,14 @@ static void 
> invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
>  			wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
>  				       TASK_UNINTERRUPTIBLE);
>  		/*
> -		 * The refs threshold is 2, one held by us at the 
> beginning
> -		 * of the loop, one for the ownership in the buffer tree.
> +		 * EXTENT_BUFFER_READING is cleared then the eb refs is 
> put during
> +		 * end_bbio_meta_read(), which leaves a window where above 
> wait
> +		 * finished but eb ref is still hold by endio.
> +		 *
> +		 * Thus we can not use eb->refs to determine if the eb is 
> hold
> +		 * by someone else. Just check if the eb is still under 
> IO.
>  		 */
> -		if (unlikely(refcount_read(&eb->refs) > 2 || 
> extent_buffer_under_io(eb))) {
> +		if (unlikely(extent_buffer_under_io(eb))) {
>  			WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
>  			btrfs_warn(fs_info,
>  			"unable to release extent buffer %llu owner %llu gen 
>  %llu refs %u flags 0x%lx",

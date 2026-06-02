Received: from mail-108-mta50.mxroute.com (mail-108-mta50.mxroute.com [136.175.108.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EBE28C854
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 05:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780379059; cv=none; b=tM2J7sZBSP4FQrkZCuM3otKGw8bOd8AJqtpeDCPJHt2TdBCLDsxJkRfxpjc5+QZRiNlJnUI/44QAUvx+/wdiYM/aWtWtHnFgiDDwPzJA1GFl8uKt8DtVf8ZFn5DQULq/EnamHRNVnGkM/jAYuxhyhE94WEHT4ewSSqZ63Oyw5LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780379059; c=relaxed/simple;
	bh=Q8czeBbCNFHXk2Eb772JKWsiksDS1aJDnU9F37IUFIw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jTaV22XO9RwFqbUU/7/xTM6DwbHrGMEJk0dWZpg5JqnyQSkpF2CuGR3hMeKjS7yW78Y3hWfqw1zlNj6TNeLylMOpSlk5Dbqa54KbnHfNYbP0BkVZQDpflpcoT8urLcMYE7znpUdt5xtwNrZNW0D2WIUlH3tqYOOS+DOL30fpmRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=untMkn9y; arc=none smtp.client-ip=136.175.108.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="untMkn9y"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta50.mxroute.com (ZoneMTA) with ESMTPSA id 19e86d7ae7b00067f7.003
 for <linux-btrfs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 02 Jun 2026 05:39:02 +0000
X-Zone-Loop: 15d66a633a72ddbaf4176a28da21a8d90ea6d009bd28
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gq6Io6yH4HVdOBHHH9WjLqZbxjkfbSwQeMywO5rvgTw=; b=untMkn9yBoJtNruiD922epyOLE
	mcpNDt1F7W7XLIkCN/9nbfPN3cbDMkxq1fi3BFs+UApxXJS7cOZ5w5vFVJwNFZyqMkz86UcTeSuWW
	kz1awOwn/24sLOUHAEx1wYwvjBvufLu1dZeblzUoOXTJHmAhTu7abLv7UONj/eCzZwK+3SWA44o5x
	LUZQYlMkwWTifu5gL9M4+d34uKvc5U0BURg9+Gn/SATfWtPTy/Kf3bmOdxDjHPP0sfM7Z461Th7AB
	H0i7IaIcA6lCDb8vSPSxGS/QuYO8xUNYkUvdGR/vSF+tjXmgFCrDvIjfVZ1HamLJBexkoJ2KZcMG6
	cVoV5Uvw==;
From: Su Yue <l@damenly.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,  Su Yue <glass.su@suse.com>,
  stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: do not trim a device which is not writeable
In-Reply-To: <0d25653c3bc93726e259dbb9d01559c4cfdf47ac.1780373081.git.wqu@suse.com>
 (Qu
	Wenruo's message of "Tue, 2 Jun 2026 13:34:46 +0930")
References: <0d25653c3bc93726e259dbb9d01559c4cfdf47ac.1780373081.git.wqu@suse.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Tue, 02 Jun 2026 13:38:48 +0800
Message-ID: <cxy9qz6f.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Tue 02 Jun 2026 at 13:34, Qu Wenruo <wqu@suse.com> wrote:

> [BUG]
> There is a bug report that btrfs/242 can randomly fail with the
> following NULL pointer dereference:
>
>  run fstests btrfs/242 at 2026-06-01 10:25:08
>  BTRFS: device fsid d4d7f234-487c-4787-88e4-47a8b68c9874 devid 1 
>  transid 9 /dev/sdc (8:32) scanned by mount (122609)
>  BTRFS info (device sdc): first mount of filesystem 
>  d4d7f234-487c-4787-88e4-47a8b68c9874
>  BTRFS info (device sdc): using crc32c checksum algorithm
>  BTRFS warning (device sdc): devid 2 uuid 
>  fbe72d72-3272-482d-80fb-ab88ed398192 is missing
>  BTRFS warning (device sdc): devid 2 uuid 
>  fbe72d72-3272-482d-80fb-ab88ed398192 is missing
>  BTRFS info (device sdc): allowing degraded mounts
>  BTRFS info (device sdc): turning on async discard
>  BTRFS info (device sdc): enabling free space tree
>  Unable to handle kernel NULL pointer dereference at virtual 
>  address 0000000000000018
>  user pgtable: 4k pages, 48-bit VAs, pgdp=000000013fd6b000
>  CPU: 4 UID: 0 PID: 122625 Comm: fstrim Not tainted 
>  7.0.10-2-default #1 PREEMPT(full) openSUSE Tumbleweed 
>  e9a5f6b24978fba3bf015a992f865837fdfff3dd
>  Hardware name: QEMU KVM Virtual Machine, BIOS 
>  edk2-20250812-19.fc42 08/12/2025
>  pstate: 01400005 (nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>  pc : btrfs_trim_fs+0x34c/0xa00 [btrfs]
>  lr : btrfs_trim_fs+0x1f0/0xa00 [btrfs]
>  Call trace:
>   btrfs_trim_fs+0x34c/0xa00 [btrfs 
>   f02c1d570ceea621c69d302ba75dd61868083840] (P)
>   btrfs_ioctl_fitrim+0xe8/0x178 [btrfs 
>   f02c1d570ceea621c69d302ba75dd61868083840]
>   btrfs_ioctl+0xdd4/0x2bd8 [btrfs 
>   f02c1d570ceea621c69d302ba75dd61868083840]
>   __arm64_sys_ioctl+0xac/0x108
>   invoke_syscall.constprop.0+0x5c/0xd0
>   el0_svc_common.constprop.0+0x40/0xf0
>   do_el0_svc+0x24/0x40
>   el0_svc+0x40/0x1d0
>   el0t_64_sync_handler+0xa0/0xe8
>   el0t_64_sync+0x1b0/0x1b8
>  Code: 17ffff83 f94017e0 f9002be0 f9402ea0 (f9400c00)
>  ---[ end trace 0000000000000000  ]---
>
> Also the reporter is very kind to test the following ASSERT() 
> added to
> btrfs_trim_free_extents_throttle():
>
> 	ASSERT(device->bdev,
> 	       "devid=%llu path=%s dev_state=0x%lx\n",
> 	       device->devid, btrfs_dev_name(device), 
> device->dev_state);
>
> And it shows the following output:
>
>  assertion failed: device->bdev, in extent-tree.c:6630 (devid=2 
>  path=/dev/sdd dev_state=0x82)
>
> Which means the device->bdev is NULL, and the dev_state is
> BTRFS_DEV_STATE_IN_FS_METADATA | BTRFS_DEV_STATE_ITEM_FOUND, 
> without
> BTRFS_DEV_STATE_WRITEABLE flag set.
>
> [CAUSE]
> The pc points to the following call chain:
>
>  btrfs_trim_fs()
>  |- btrfs_trim_free_extents()
>     |- btrfs_trim_free_extents_throttle()
>        |- bdev_max_discard_sectors(device->bdev)
>
> So the NULL pointer dereference is caused by device->bdev being 
> NULL.
>
> This looks impossible by a quick glance, as just before calling
> btrfs_trim_free_extents_throttle(), we have skipped any device 
> that has
> BTRFS_DEV_STATE_MISSING flag set.
>
> However in this particular case, there is a window where the 
> missing
> device is later re-scanned, causing btrfs to remove the
> BTRFS_DEV_STATE_MISSING flag:
>
>  btrfs_control_ioctl()
>  |- btrfs_scan_one_device()
>     |- device_list_add()
>        |- rcu_assign_pointer(device->name, name);
>        |  This updates the missing device's path to the new good 
>        path.
>        |
>        |- clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)
>           This removes the BTRFS_DEV_STATE_MISSING flag.
>
> This allows the missing device to re-appear and clear the
> BTRFS_DEV_STATE_MISSING flag.
> However the device still does not have the 
> BTRFS_DEV_STATE_WRITEABLE
> flag set, nor is its bdev pointer updated.
>
> The bdev pointer remains NULL, triggering the crash later.
>
> [FIX]
> This is a big de-synchronization between BTRFS_DEV_STATE_MISSING 
> and
> device->bdev pointer, and shows a gap in btrfs's 
> re-appearing-device
> handling.
>
> The proper handling of re-appearing device will need quite some 
> extra
> work, which is out of the context of this small fix.
>
> Thankfully the regular bbio submission path has already handled 
> it well
> by checking if the device->bdev is NULL before submitting.
>
> So here we just fix the crash by checking if the device is 
> writeable and
> has a bdev pointer before calling bdev_max_discard_sectors().
>
> Reported-by: Su Yue <glass.su@suse.com>
> Link: 
> https://lore.kernel.org/linux-btrfs/wlwir19t.fsf@damenly.org/
> Cc: stable@vger.kernel.org # 5.10+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
>

Thanks. No crash happens on my side after applying this patch.

--
Su
> ---
>  fs/btrfs/extent-tree.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6030cdbdb742..f3c3eb508f86 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6624,12 +6624,17 @@ static int 
> btrfs_trim_free_extents_throttle(struct btrfs_device *device,
>
>  	*trimmed = 0;
>
> -	/* Discard not supported = nothing to do. */
> -	if (!bdev_max_discard_sectors(device->bdev))
> +	/*
> +	 * The caller only filters out MISSING devices, but a device 
> that was
> +	 * missing at mount and later rescanned has MISSING cleared 
> while
> +	 * bdev is still NULL and WRITEABLE is still unset. Skip those 
> here.
> +	 */
> +	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) 
> ||
> +	    !device->bdev)
>  		return 0;
>
> -	/* Not writable = nothing to do. */
> -	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
> +	/* Discard not supported = nothing to do. */
> +	if (!bdev_max_discard_sectors(device->bdev))
>  		return 0;
>
>  	/* No free space = nothing to do. */

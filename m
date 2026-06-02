Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DFE3DB30C
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 10:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395136; cv=none; b=QLIcFCMz/3M9NIgTtxbae6tQJ6IAVjVGC0xzBi8KdFWfyRqWR8+DMvoGIY7TdVdfy2djx9VmRZgq6qDwkChz2Mz8Ai69gd8Bw6zESz+vFzwyFmhM/lJQCxe+0YPvu73WlEYvLKw44+k5mlDK4eIkv2Hgvg4Q7iDKq+u/HS/ZF0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395136; c=relaxed/simple;
	bh=z3ty/ZdUawtY5dkPdrb/MMmFZ3eM0oC0peNaIucAUAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kNomy6TkLiY7DD7n8NcOYDg4F2aPIqOxfic/guehoYVRCQgOWCx2V06jRZ5R6Z5Zce/YNHc0VW0fVFrQvZkZdexoHuGqHuKEsgcncXuRuRwJ3SXsimjx3R0DThePgiMXVRw/31v9x9BnNaExg18k/4NX8dI2MO8qeldNAZuday8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QS3wn+1B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QS3wn+1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8440D1F00899
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 10:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395134;
	bh=e/TCg1uIVA8+dNYHPD8jbrJl5eIIsO+os0J5gb+iRFY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QS3wn+1BRxuED9UmM0zeA7ezqFyxRkVDr/wVqlq9r2qf26KPKLJPHQ6wLB/XmiUzf
	 nyNZ4dgZxpc13NGQ1Hbe6i6qg/E9HJTG7pNHIf3+QjBP/ki/dkmD5cdC7oyC5kqqd4
	 9S4rXwWPzsmW/shYrV+pvZCWErd5KI7TwxW9vWW7XHfyTRmWn4i+wKh9htnmE88q+3
	 Py1XfqgGZnbgtOzQDsIzFA+9fU9niwVWzBqsGgkJy6YMi82I4QMmdxzzhupGZx68Xm
	 USo7Dx3Xy4KE13/IvuK0izvDI5A7M8sKbSnzVQNHqtjBK7flImOEni8ySMeHci94TD
	 lkLq8HWTYUJ7A==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-68d23396ed3so4468212a12.1
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 03:12:14 -0700 (PDT)
X-Gm-Message-State: AOJu0YwtoBTUUmWVz80xYh+h73QP78Q/U9cTgdk6qgwJzLV9f/W4bJsJ
	J8iTX/+iquNRnMaOc01kJ7jiX3tyn0VAyFB8QiGAWnaiNBr+Z9BJ9Rw2dA7Iufgdq9e6k/4XwF0
	EhGykexd55r4ce8LOftnv1+G3Ok93Wvs=
X-Received: by 2002:a17:906:630e:b0:bee:f402:5567 with SMTP id
 a640c23a62f3a-beef4025730mr232735766b.41.1780395133086; Tue, 02 Jun 2026
 03:12:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0d25653c3bc93726e259dbb9d01559c4cfdf47ac.1780373081.git.wqu@suse.com>
In-Reply-To: <0d25653c3bc93726e259dbb9d01559c4cfdf47ac.1780373081.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 2 Jun 2026 11:11:35 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4kaY_y749iKN9SyTKSggcfZKg2D=EBvF-Yt-WypAW_kg@mail.gmail.com>
X-Gm-Features: AVHnY4JFcsk5GqVrzwhtEu5nP4-PdU4Xqej5gZZLtjdghnNH4hRU3Y-nH2YcQpg
Message-ID: <CAL3q7H4kaY_y749iKN9SyTKSggcfZKg2D=EBvF-Yt-WypAW_kg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: do not trim a device which is not writeable
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Su Yue <glass.su@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026 at 5:05=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG]
> There is a bug report that btrfs/242 can randomly fail with the
> following NULL pointer dereference:
>
>  run fstests btrfs/242 at 2026-06-01 10:25:08
>  BTRFS: device fsid d4d7f234-487c-4787-88e4-47a8b68c9874 devid 1 transid =
9 /dev/sdc (8:32) scanned by mount (122609)
>  BTRFS info (device sdc): first mount of filesystem d4d7f234-487c-4787-88=
e4-47a8b68c9874
>  BTRFS info (device sdc): using crc32c checksum algorithm
>  BTRFS warning (device sdc): devid 2 uuid fbe72d72-3272-482d-80fb-ab88ed3=
98192 is missing
>  BTRFS warning (device sdc): devid 2 uuid fbe72d72-3272-482d-80fb-ab88ed3=
98192 is missing
>  BTRFS info (device sdc): allowing degraded mounts
>  BTRFS info (device sdc): turning on async discard
>  BTRFS info (device sdc): enabling free space tree
>  Unable to handle kernel NULL pointer dereference at virtual address 0000=
000000000018
>  user pgtable: 4k pages, 48-bit VAs, pgdp=3D000000013fd6b000
>  CPU: 4 UID: 0 PID: 122625 Comm: fstrim Not tainted 7.0.10-2-default #1 P=
REEMPT(full) openSUSE Tumbleweed e9a5f6b24978fba3bf015a992f865837fdfff3dd
>  Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250812-19.fc42 08/1=
2/2025
>  pstate: 01400005 (nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=3D--)
>  pc : btrfs_trim_fs+0x34c/0xa00 [btrfs]
>  lr : btrfs_trim_fs+0x1f0/0xa00 [btrfs]
>  Call trace:
>   btrfs_trim_fs+0x34c/0xa00 [btrfs f02c1d570ceea621c69d302ba75dd618680838=
40] (P)
>   btrfs_ioctl_fitrim+0xe8/0x178 [btrfs f02c1d570ceea621c69d302ba75dd61868=
083840]
>   btrfs_ioctl+0xdd4/0x2bd8 [btrfs f02c1d570ceea621c69d302ba75dd6186808384=
0]
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
> Also the reporter is very kind to test the following ASSERT() added to
> btrfs_trim_free_extents_throttle():
>
>         ASSERT(device->bdev,
>                "devid=3D%llu path=3D%s dev_state=3D0x%lx\n",
>                device->devid, btrfs_dev_name(device), device->dev_state);
>
> And it shows the following output:
>
>  assertion failed: device->bdev, in extent-tree.c:6630 (devid=3D2 path=3D=
/dev/sdd dev_state=3D0x82)
>
> Which means the device->bdev is NULL, and the dev_state is
> BTRFS_DEV_STATE_IN_FS_METADATA | BTRFS_DEV_STATE_ITEM_FOUND, without
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
> So the NULL pointer dereference is caused by device->bdev being NULL.
>
> This looks impossible by a quick glance, as just before calling
> btrfs_trim_free_extents_throttle(), we have skipped any device that has
> BTRFS_DEV_STATE_MISSING flag set.
>
> However in this particular case, there is a window where the missing
> device is later re-scanned, causing btrfs to remove the
> BTRFS_DEV_STATE_MISSING flag:
>
>  btrfs_control_ioctl()
>  |- btrfs_scan_one_device()
>     |- device_list_add()
>        |- rcu_assign_pointer(device->name, name);
>        |  This updates the missing device's path to the new good path.
>        |
>        |- clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)
>           This removes the BTRFS_DEV_STATE_MISSING flag.
>
> This allows the missing device to re-appear and clear the
> BTRFS_DEV_STATE_MISSING flag.
> However the device still does not have the BTRFS_DEV_STATE_WRITEABLE
> flag set, nor is its bdev pointer updated.
>
> The bdev pointer remains NULL, triggering the crash later.
>
> [FIX]
> This is a big de-synchronization between BTRFS_DEV_STATE_MISSING and
> device->bdev pointer, and shows a gap in btrfs's re-appearing-device
> handling.
>
> The proper handling of re-appearing device will need quite some extra
> work, which is out of the context of this small fix.
>
> Thankfully the regular bbio submission path has already handled it well
> by checking if the device->bdev is NULL before submitting.
>
> So here we just fix the crash by checking if the device is writeable and
> has a bdev pointer before calling bdev_max_discard_sectors().
>
> Reported-by: Su Yue <glass.su@suse.com>
> Link: https://lore.kernel.org/linux-btrfs/wlwir19t.fsf@damenly.org/
> Cc: stable@vger.kernel.org # 5.10+

Fixes: 499f377f49f0 ("btrfs: iterate over unused chunk space in FITRIM")

Please always try to include the offending commit to make downstream
work easier.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6030cdbdb742..f3c3eb508f86 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6624,12 +6624,17 @@ static int btrfs_trim_free_extents_throttle(struc=
t btrfs_device *device,
>
>         *trimmed =3D 0;
>
> -       /* Discard not supported =3D nothing to do. */
> -       if (!bdev_max_discard_sectors(device->bdev))
> +       /*
> +        * The caller only filters out MISSING devices, but a device that=
 was
> +        * missing at mount and later rescanned has MISSING cleared while
> +        * bdev is still NULL and WRITEABLE is still unset. Skip those he=
re.
> +        */
> +       if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) ||
> +           !device->bdev)
>                 return 0;
>
> -       /* Not writable =3D nothing to do. */
> -       if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
> +       /* Discard not supported =3D nothing to do. */
> +       if (!bdev_max_discard_sectors(device->bdev))
>                 return 0;
>
>         /* No free space =3D nothing to do. */
> --
> 2.54.0
>
>

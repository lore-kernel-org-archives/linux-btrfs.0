Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FA23B5311
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 05:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450097; cv=none; b=HwQEvOttkVBKt+9iR+Wy7s2WuSxHiGtTeHtz2XHbDi4v59329QEO11gknFChGkZhe9TdfflvV3uUXwD9u64kZCEyLhFhMk3KD68aqlEtt0BsGD8AnmPNK0fUZmiuSWaQSZ68KcKiMjG5ftmq0w8q7il14xXI6erYm333pi864Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450097; c=relaxed/simple;
	bh=ndSQyccY72WLwX2V7r4SEY5er9/arirw7AaqpMaprkg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oB4FdVwUzNQA7wZZgRn8Rrdu5wy5AVxykZcYyYRt2gMj3Gv+9+ACJ1WXCUKlDAvTLgFdKhqssA/YOt8jL2tabI+Zt3DbJ9O4VDAD1G2eDmBBHz2h/tx8cxbm6XQQ08XWuvfb5sTjvEgBu9QD9qqqQk77AwXwulJv1pPHjEtdtGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com; spf=fail smtp.mailfrom=mssola.com; dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b=PSvx+C8Y; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mssola.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b="PSvx+C8Y"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4hkVsk3Q1nzKmY1;
	Tue, 15 Sep 2026 07:28:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mssola.com; s=MBO0001;
	t=1789450090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B6yfv68yxlrcPmgKYE0yQaEEg4rzgZFDo+2bkb86psc=;
	b=PSvx+C8Ym4c7QiUm1kxcFR17gxkJs28+CCY4R0qFVzQBUNnIPsduF0g+rHeY4dDeY8RH/i
	SLRhE1CZa6Qn49DApm/kETJnCBcUnsPXY98f+aOOws2kMLhd/gBB1JBKqmiyjHg/qUivyA
	oxLaOxXep6x7ZDa8e1J684dR9X8JZehUn0wgH5VKPcpSK1jt3DqQmJTIQaIpB8Zy260Tva
	4ub7h/Pm8hqoTNi3BnYAVcDSrd+NLcTB3uLn4uBZSZjsBjT6IQ+lasJ5HVb35o+YR+kcvC
	u1MgqduOTIIJc6Oan0Th7BYS8vm2zbpa/leiqf83NEUfZ2QtCvUXKL4VfuXARw==
From: =?utf-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: docs: add a dedicated multi-device support chapter
In-Reply-To: <cb437e93978784246fab57cbbf04892b1d985a3d.1789425495.git.wqu@suse.com>
References: <cb437e93978784246fab57cbbf04892b1d985a3d.1789425495.git.wqu@suse.com>
Date: Tue, 15 Sep 2026 07:28:05 +0200
Message-ID: <87fqzbozh6.fsf@>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

Hi,

Thanks for documenting this, good to know :) Just a couple of nitpicks.

Qu Wenruo @ 2026-09-15 08:09 +0930:

> Btrfs, like all other multi-device storage solutions, requires proper
> device scan and registration to handle multi-device arrays.
>
> However btrfs has some extra requirements and quirks related to
> multi-device support.
>
> Record those extra into into a new "MULTI-DEVICE SUPPORT" chapter in man
> 5 btrfs. For now it includes:
>
> - Requirement for device scan registration
>
> - Requirement for initramfs if the rootfs has multiple devices
>
> - Quirk related to device path shown in mount point
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  Documentation/btrfs-man5.rst | 44 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/Documentation/btrfs-man5.rst b/Documentation/btrfs-man5.rst
> index ce4021ab84b5..11f6c9327b45 100644
> --- a/Documentation/btrfs-man5.rst
> +++ b/Documentation/btrfs-man5.rst
> @@ -34,6 +34,50 @@ MOUNT OPTIONS
>
>  .. _man-btrfs5-filesystem-features:
>
> +MULTI-DEVICE SUPPORT
> +--------------------
> +
> +Btrfs has built-in multi-device support, and supports several profiles that require
> +multiple devices, including RAID0, RAID1, RAID1C3, RAID1C4, RAID10, RAID5 and RAID6.
> +
> +However the multi-device support has some extra requirements/quirks:
> +
> +- Requires proper device scanning and registration
> +  Like all multi-device storage solutions, btrfs has to scan and register all involved
> +  devices to mount the filesystem.
> +
> +  Normally it's done by udev, but for systems without udev, the end users are responsible
> +  for proper block file creation and scanning.
> +
> +- Initramfs required if the rootfs has multiple devices
> +  Without an initramfs, the kernel boot sequence doesn't create "/dev/" with every
> +  block file, thus it's impossible to register all devices to fulfill the mount, even
> +  with the *device=* mount option.
> +
> +  It's strongly recommended to use an initramfs if btrfs is the rootfs. It's very
> +  easy and fast to add a new device to an existing btrfs, without an initramfs the next
> +  mount will fail to mount the rootfs.
> +
> +- Device path shown in the mount output
> +  Btrfs maintains an internal device path for each device. The device path is recorded
> +  during the initial device scan, and normally doesn't change during the lifespan of that
> +  device.
> +
> +  This can lead to inconvenience if the user space tool doesn't do proper parsing.
> +
> +  For example, creat a block file at "/tmp/block_file", forget all devices, scan and
> +  mount that newly created block file, and then delete "/tmp/block_file".

Typo: "creat" -> "create"

> +
> +  This will make btrfs register the device path using "/tmp/block_file", even if that
> +  file is later deleted.
> +
> +  Tools like *lsblk* can still handle such cases by using device numbers, but a lot of
> +  other tools won't parse the mount point properly, as the device path no longer exists.
> +
> +  Normally this should not be a big deal, as udev is the first program to create those
> +  block files and scan them.

"those" -> "these"

> +
> +
>  FILESYSTEM FEATURES
>  -------------------

Thanks,
Miquel

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJiBAEBCgBMFiEEG6U8esk9yirP39qXlr6Mb9idZWUFAmqo12UbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEhxtc3NvbGFAbXNzb2xhLmNvbQAKCRCWvoxv2J1l
ZTpDEACCjb79rWkFtPvArih5sGFLvVJjx75PhSpaJARRtBC+2nxb8FM0C5qV/Lfz
I7HSk/TAMl5fJPkGUp94M4RNWnqHWpFNiPoxoNJa94Mz4brJIj/aT8GKXvuMT71p
ZF1s4e4KFK/h9O2+xccFsBEj52lQDWQsmLRYvypj+kK06N6rhynwf+OOpoRnQ/3r
7SKjYf3O5iWtVkX0yh2NDzciXLSxPxcqTkLrHldp0iKYp/bbHcEELuCT2N5qjNbp
BW9SC2gd9OsNJ7+wuk+UEhB55EVKUvuvnINthc9LDdwNH+7BWNQ8+hWvVYjDx6Np
DJHBi4D6bcaywOATs1U3cyFiXBK9t5i7Y6v8HX9t4xdpwD5xuMiQeDlAZaosYFgp
/BiygfWfDyoarjI8MSD6sr+QOiCAhzPLzvAEEDNPJkZXu5vnYlbimow8LCQoc9za
dhkjea54DVMzY+cZ7LshQJ2i1ctNiPDKfz/1JDEr5j+QfeyBuTq/EuxHI2g4cqnM
TaRQAYZueaACHFMMFVszTvO+HK1VXkm55Ct7DW7YlkHK6jV1V6ypWtgDNF5/F4OX
+VaZDT7acZShLIYLT/nEl1ntnijUmsufo+4uTHwkTxyLDmwhuh8KTMiw7PhF56p5
DLICx02Z2KC0ktV1PkgjEeEIaD9ZC2fQXk4/Fv89qqiSAGe3jQ==
=eyQh
-----END PGP SIGNATURE-----
--=-=-=--

Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873301ACEDE
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 01:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780365010; cv=none; b=JjAVInPlAKuQha5Nl1tt0nWvTdnm+E2ce8NmcnvAGMAHXzQ3ryKJYkQztxz7zNr2lWZ10Qay4pNBroZ5BhTCFF4aP20XqgzA9uyXeNrNC5zNO/aZyHU8/6jWwPelIzSaMWRe7mrP6y5/NBxjq8w0y7A5r9Pe5MA6AH8YWQZWAOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780365010; c=relaxed/simple;
	bh=Yp6zApLcopAgzZm6NcOB/C//Gm4b3pxlV9vK+LzU4D8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=F5/ESTdXqRhLYHJ/brDTBodPVRX9yCwe1e2s9kJU//zxzt/mqmgGWJ9PUPZxsYI6pgzlodrZFuUZDT9Kd+EOGfmqxDS8thwQZGyv+akrfTYGALqDEQ1eawcnblZkT+5YMoEOntJxxASzzoUkzbwjNriEEZCkf3gl4okk6C5wZUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WtMnhKPN; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WtMnhKPN"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490a76757e5so14736135e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2026 18:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780365007; x=1780969807; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=giYnUsHTxeQNRHLNyTMV8Z5l3vidwvTy9SqPi/y7dKo=;
        b=WtMnhKPNOudgU9wEXXt5G3YdgUNGIjY7Bi7WjxQTOvvo1h9Tf+Z1yYZ0TZjXuycAJS
         Vh1ftisrjdXVAFuuHfqyeR16RzCMckLeB0nPHFVEEeHbckcVFzA7aMk4oBCT838IRrjN
         HLXbcU2waNsu4AGcShT7swVkwLLx7yIzGSU/aoMUnQaJyTOxwwSVD9lASHvfz7qcYS+O
         hI69Ye9hgU63kiZXzClr4O673722V4Bn8mT0wBLOaeemeaRkDJOMwAbc0wseV51t9tll
         H2CxwY2+r/51iJhkrzGvmnwYdfEiVHNQvZBoSJA6PH9Pq5XxX3puVZaigjld+QbegVa7
         md4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780365007; x=1780969807;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=giYnUsHTxeQNRHLNyTMV8Z5l3vidwvTy9SqPi/y7dKo=;
        b=RZYdTHucOjSlPX8KxlhGlBMqPla++WlM6DZlSGxr0VJsfzZdXhphzglqbqrG6BDaU2
         57VyAcWTauz3zMkP82oKZEqXRU4H5Rp8YoHClpMKZbUXjJpQ+myHTeIL0fco1P5TXzk1
         jyKlAqV9G7xs7wyJY8FJ8x9lkHQEyTmqGbXSHeD6R8oa2GmCltWKqZ3GGl1hywVW2jtn
         eh8q4nhJxyfY7bzqKKkjirJtZFvAXKXcUBXHn8vXccu648e5Nzyr8h+RxBPiJfiYtkXu
         s8AWk4RR9N6BFhdXSQ+7MO3NQKM+lvpj9nhFTu5f1XI5kIMzKvX5ccV6tLbTmmYYo5yt
         89gw==
X-Forwarded-Encrypted: i=1; AFNElJ8DsKo/VAqyrRODN0ACdZZ4icKK8r86VKdE01sWFlhU1tJliCWY+FZ8HzgVuvEyXyhLp//MIFvrJisIwg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8L6Ufq2BZwftOEobrVwzjuykCQwoYKvb+LD1s9sq9d3bslf5u
	DfIJTnkkdDPe5j9xLB9UF3XSxusG9bUY0liUtroGe9nuQyWzLFRwYB706A0nuIE0CbjEJMQjU5P
	6ldst1SUOYQ==
X-Gm-Gg: Acq92OGAM6+7DeQqqCFhawumHXbk/gn8xEVgXcOFwPHMFOYGdZ3gdBPMaceOYlgLjNg
	iqpA9TL9fzH1UvkS5PAD7hApizJHuc7tVx6TUV4Qh9tBLjJlJVpKulOym+YEOOIhWPBR8hmerUq
	wvaY9h7T9n/I1ceNdz/ThgACOvpQjuSyMvYO6w4HEb3JrmmnNeFDryWXeXW5xVXcBptga8qxk92
	cHP4hM2ud0Tk7r+2k0ZTsMkKAxv0hKTxTrjW9SxghOlPBqTRe8+oYxEwtlWL2bjCaXQa9Kde0pf
	jIDWykV12+gcFxufdAp+2dKCkly3+GG0KE8Z0q8nNyumrQc+dad/httLXHN9fKVu7FMpCx0ByFo
	GIMR4IAcoRMFHa0xoCK4MaGj/KdNYbVGmx+/oVfa+gEw9QoCRRg1xW9Sr4gL8Eh3yAw96AJ6C+5
	gOM8M8LVYqDWmFb3JU13CqkYXQlkMQywUFitVP
X-Received: by 2002:a05:600c:3acb:b0:490:aef9:aa3b with SMTP id 5b1f17b1804b1-490aef9ab5cmr63984045e9.32.1780365006863;
        Mon, 01 Jun 2026 18:50:06 -0700 (PDT)
Received: from smtpclient.apple ([2605:52c0:2:27d1:8ca3:89ff:fe18:2252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ee0dd8e1sm14296403eec.21.2026.06.01.18.50.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jun 2026 18:50:06 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [BUG report] btrfs/242 triggers kernel NULL pointer dereference
From: Glass Su <glass.su@suse.com>
In-Reply-To: <04af4b51-9039-404f-808d-0011443f8ba6@gmx.com>
Date: Tue, 2 Jun 2026 09:49:49 +0800
Cc: Su Yue <l@damenly.org>,
 linux-btrfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <579CB63E-1C39-4DCD-99D1-DE3E756E75F6@suse.com>
References: <wlwir19t.fsf@damenly.org>
 <7edd1a98-4683-463d-b789-e75f7cb42de1@gmx.com> <ik82qx2i.fsf@damenly.org>
 <04af4b51-9039-404f-808d-0011443f8ba6@gmx.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
X-Mailer: Apple Mail (2.3864.500.181)



> On Jun 2, 2026, at 06:11, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>=20
>=20
>=20
> =E5=9C=A8 2026/6/1 21:42, Su Yue =E5=86=99=E9=81=93:
>> On Mon 01 Jun 2026 at 21:23, Qu Wenruo <quwenruo.btrfs@gmx.com>
>> wrote:
> [...]
>>> Since you can reproduce it on the latest for-next, mind to provide
>>> the for-next call trace along with the faddr2line output for pc
>>> register of the for-next run?
>> Sure.
>> # ./scripts/faddr2line  fs/btrfs/btrfs.ko  btrfs_trim_fs+0x36c/0xa48 =
btrfs_trim_fs+0x36c/0xa48: bdev_max_discard_sectors at /var/lib/
>> btrfs-linux-for-next/./include/ linux/blkdev.h:1449 (discriminator
>> 1) (inlined by) btrfs_trim_free_extents_throttle at /var/lib/btrfs-
>> linux- for-next/fs/btrfs/extent-tree.c:6628 (discriminator 1)
>=20
> Thanks! This is super helpful.
>=20
> However this looks a little weird.
>=20
> The NULL pointer dereference is from bdev_max_discard_sectors(), =
meaning
> the bdev is NULL, most likely the device is missing.
>=20
> However just before we call btrfs_trim_extents_throttle() we have
> already checked the DEV_STATE_MISSING flag of the device and will skip
> any missing device.
>=20
> Furthermore the test case doesn't change the missing device state =
during
> the run.
>=20
> So there seems to be some weird race, or desychronization between
> various bit flags.
>=20
> Mind to test with the following diff?

Here you are:

[  434.761748] BTRFS info (device sdc): enabling free space tree
[  434.785804] assertion failed: device->bdev, in extent-tree.c:6630 =
(devid=3D2 path=3D/dev/sdd dev_state=3D0x82
               )
[  434.785822] ------------[ cut here ]------------
[  434.785823] kernel BUG at extent-tree.c:6630!
[  434.785846] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[  434.785849] Modules linked in: btrfs(OE) xor(E) libblake2b(E) =
raid6_pq(E) dm_mod(E) arm_smccc_trng(E) virtio_balloon(E) virtio_net(E) =
net_failover(E) failover(E) vfat(E) fat(E) fuse(E) drm(E) xfs(E) =
virtio_scsi(E) qemu_fw_cfg(E) virtio_pci(E) virtio_pci_legacy_dev(E) =
virtio_pci_modern_dev(E) virtio_console(E) virtio_rng(E) rng_core(E) =
[last unloaded: xor(E)]
[  434.785860] CPU: 5 UID: 0 PID: 34553 Comm: fstrim Tainted: G          =
 OE       7.1.0-rc6-custom+ #2 PREEMPT(full)
[  434.785862] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
[  434.785863] Hardware name: QEMU KVM Virtual Machine, BIOS =
edk2-20250812-19.fc42 08/12/2025
[  434.785864] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS =
BTYPE=3D--)
[  434.785866] pc : btrfs_trim_fs+0x9f8/0xc48 [btrfs]
[  434.785937] lr : btrfs_trim_fs+0x9f8/0xc48 [btrfs]
[  434.785985] sp : ffff800087103ba0
[  434.785986] x29: ffff800087103c30 x28: ffff0000dcd6cc00 x27: =
ffff800087103c90
[  434.785987] x26: ffff0000dcd6cc00 x25: ffff0000dcd6cca8 x24: =
0000000000000000
[  434.785989] x23: ffff0000de321c70 x22: ffff0000de321c00 x21: =
ffff0000de321cf8
[  434.785990] x20: 0000000000000002 x19: ffff0000c0c77110 x18: =
0000000000000010
[  434.785991] x17: 7020323d64697665 x16: 642820303336363a x15: =
632e656572742d74
[  434.785992] x14: 6e65747865206e69 x13: 290a323878303d65 x12: =
746174735f766564
[  434.785993] x11: 0000000000017fe8 x10: ffffd8425b311620 x9 : =
ffffd84259e2bf3c
[  434.785995] x8 : ffffd8425b4b2ed8 x7 : ffff0000d2108b78 x6 : =
0000000000000000
[  434.785996] x5 : ffff0002019de988 x4 : 0000000000000001 x3 : =
0000000000000000
[  434.785997] x2 : 0000000000000000 x1 : ffff0000d2108040 x0 : =
000000000000005d
[  434.785998] Call trace:
[  434.785999]  btrfs_trim_fs+0x9f8/0xc48 [btrfs] (P)
[  434.786045]  btrfs_ioctl_fitrim+0x138/0x2a0 [btrfs]
[  434.786100]  btrfs_ioctl+0x10d8/0x2910 [btrfs]
[  434.786146]  __arm64_sys_ioctl+0xac/0x108
[  434.786151]  invoke_syscall.constprop.0+0x48/0x120
[  434.786155]  el0_svc_common.constprop.0+0x40/0xe8
[  434.786158]  do_el0_svc+0x24/0x38
[  434.786160]  el0_svc+0x50/0x310
[  434.786164]  el0t_64_sync_handler+0xa0/0xe8
[  434.786166]  el0t_64_sync+0x198/0x1a0
[  434.786168] Code: 911ca021 f00038a0 911b8000 9404ada8 (d4210000)
[  434.786169] ---[ end trace 0000000000000000 ]=E2=80=94

>=20
> Thanks,
> Qu
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6030cdbdb742..94535c90de22 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6624,6 +6624,13 @@ static int =
btrfs_trim_free_extents_throttle(struct btrfs_device *device,
>=20
>        *trimmed =3D 0;
>=20
> +       ASSERT(!test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state),
> +              "devid=3D%llu path=3D%s dev_state=3D0x%lx\n",
> +              device->devid, btrfs_dev_name(device), =
device->dev_state);
> +       ASSERT(device->bdev,
> +              "devid=3D%llu path=3D%s dev_state=3D0x%lx\n",
> +              device->devid, btrfs_dev_name(device), =
device->dev_state);
> +
>        /* Discard not supported =3D nothing to do. */
>        if (!bdev_max_discard_sectors(device->bdev))
>                return 0;


Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A9C14A60F
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 11:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780314810; cv=none; b=m9qXaowcKtEypXijdHxN0ysfQpVicAPS25UaRXjj8TBWGv+JLUGz3AHsTKfDKvMNI1Qj6d7kS+vCewa+Heec9IkqwPrY7Xro88fdXLjFF6GE/w/hZ0YS4iZ/c4r+C8bQmdc/XgQwhcCUUy7lFzRhJQ5XINtzQy0I6VMvhpCU80Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780314810; c=relaxed/simple;
	bh=daSAhcvpAlFyZEYlPnT2gpqCkQNqyFrjpAs4gHK+yLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XhWrWlsZjbwo2Fu85JsiyjnTaBA+IkpR8JfWlNb6wYhWnpxnGmKsm8Wz2haHquCRS/CXcqWuZTy+BecXnaymh+LYf3XVXSsV5Zjx7bdpojVR3qhMkKl0oUJTvmxEfedJOmqaKc5b8dKDXy+3zJtMUXhL+vcKEZ+00bYj+dnqClc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=ENnE4ElF; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="ENnE4ElF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780314803; x=1780919603; i=quwenruo.btrfs@gmx.com;
	bh=daSAhcvpAlFyZEYlPnT2gpqCkQNqyFrjpAs4gHK+yLs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ENnE4ElFXexdCKKsxZaVZtG5ifp0jOJKQThDryJSe6V/kjAFubzhHQhAfIVoHpYV
	 Q2F942ZmVW+4R63DGKXa+H5JboySQpo2icQ2Wa80RlaYoFZUZtG8T+QyvZcrJCbVE
	 IV5jP167Nxxg52DJ1shyQE6xzX7ImQeMQs8yOldJuZtx+4LBsO7S7RQz8tqr/CFhF
	 qrTzas2ZNk4XC1RqO9sGptZ8x1Eci2A3am9zeuhhoQ0Jsgx2GzFtKDa602X13AM55
	 JS5HNXoUDOyIBjkJVX8nX5AoXMulA0ymMdUWgEIO9SHahWkFyYCqA3TmGzmCuCw1b
	 EF8cvGkV7hXXfPgebg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MEm2D-1wWRuC0zwx-0016wI; Mon, 01
 Jun 2026 13:53:23 +0200
Message-ID: <7edd1a98-4683-463d-b789-e75f7cb42de1@gmx.com>
Date: Mon, 1 Jun 2026 21:23:20 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG report] btrfs/242 triggers kernel NULL pointer dereference
To: Su Yue <l@damenly.org>, linux-btrfs@vger.kernel.org,
 Su Yue <glass.su@suse.com>
References: <wlwir19t.fsf@damenly.org>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <wlwir19t.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nr8zPM4BCwAyvsfigsOXgy1eNA67pgttBa6b84DMN9iP7BuZjPj
 u75pHaMJKLTIV/edgGoFTJlA+gIgL04ftu+sHAEajIr8PTSRewuDYZ7evX5jUjBHEAFH2BO
 HyG00Fe/Oi17gUuiTU65OD6JUbNbf8tRlBVbgWnUnf+BfzC4d1ZNBfHgx5BdSDoDM1k42C9
 Us8WyV4dI14iyiqv3WzkA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+eGuRmKuMRE=;IKcluyugZ7yZEXTP1KhkarhOdL/
 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
 =



=E5=9C=A8 2026/6/1 20:11, Su Yue =E5=86=99=E9=81=93:
>=20
> Hi, btrfs folks. Recently I found that fstests/btrfs/242 can trigger
> kernel NULL pointer dereference with for-=20
> next(27a96ee64c0e0d6131160da98a5485adbbe9dd59) and
> openSUSE Tumbleweed kernel(7.0.10-2-default). The probability is within=
=20
> 50 rounds.
>=20
> ENV:
> host: mac mini m1 running Asahi linux
>=20
> VM(new installed):
>=20
> # uname -r
> 7.0.10-2-default
>=20
> # dmesg
> [=C2=A0 312.853073 ] [ T121971 ] run fstests btrfs/242 at 2026-06-01 10:=
25:08
> [=C2=A0 313.417562 ] [ T122570 ] BTRFS: device fsid=20
> d4d7f234-487c-4787-88e4-47a8b68c9874 devid 1 transid 8 /dev/sdc (8:32)=
=20
> scanned by mkfs.btrfs (122570)
> [=C2=A0 313.417698 ] [ T122570 ] BTRFS: device fsid=20
> d4d7f234-487c-4787-88e4-47a8b68c9874 devid 2 transid 8 /dev/sdd (8:48)=
=20
> scanned by mkfs.btrfs (122570)
> [=C2=A0 313.423953 ] [ T122578 ] BTRFS info (device sdc): first mount of=
=20
> filesystem d4d7f234-487c-4787-88e4-47a8b68c9874
> [=C2=A0 313.423967 ] [ T122578 ] BTRFS info (device sdc): using crc32c=
=20
> checksum algorithm
> [=C2=A0 313.428833 ] [ T122578 ] BTRFS info (device sdc): checking UUID =
tree
> [=C2=A0 313.428975 ] [ T122578 ] BTRFS info (device sdc): turning on asy=
nc=20
> discard
> [=C2=A0 313.429097 ] [ T122578 ] BTRFS info (device sdc): enabling free =
space=20
> tree
> [=C2=A0 313.469504 ] [ T122603 ] BTRFS info (device sdc): last unmount o=
f=20
> filesystem d4d7f234-487c-4787-88e4-47a8b68c9874
> [=C2=A0 313.513398 ] [ T122609 ] BTRFS: device fsid=20
> d4d7f234-487c-4787-88e4-47a8b68c9874 devid 1 transid 9 /dev/sdc (8:32)=
=20
> scanned by mount (122609)
> [=C2=A0 313.513820 ] [ T122609 ] BTRFS info (device sdc): first mount of=
=20
> filesystem d4d7f234-487c-4787-88e4-47a8b68c9874
> [=C2=A0 313.513845 ] [ T122609 ] BTRFS info (device sdc): using crc32c=
=20
> checksum algorithm
> [=C2=A0 313.515223 ] [ T122609 ] BTRFS warning (device sdc): devid 2 uui=
d=20
> fbe72d72-3272-482d-80fb-ab88ed398192 is missing
> [=C2=A0 313.515523 ] [ T122609 ] BTRFS warning (device sdc): devid 2 uui=
d=20
> fbe72d72-3272-482d-80fb-ab88ed398192 is missing
> [=C2=A0 313.518615 ] [ T122609 ] BTRFS info (device sdc): allowing degra=
ded=20
> mounts
> [=C2=A0 313.518630 ] [ T122609 ] BTRFS info (device sdc): turning on asy=
nc=20
> discard
> [=C2=A0 313.518635 ] [ T122609 ] BTRFS info (device sdc): enabling free =
space=20
> tree
> [=C2=A0 313.523827 ] [ T122625 ] Unable to handle kernel NULL pointer=20
> dereference at virtual address 0000000000000018
> [=C2=A0 313.523858 ] [ T122625 ] Mem abort info:
> [=C2=A0 313.523865 ] [ T122625 ]=C2=A0=C2=A0 ESR =3D 0x0000000096000004
> [=C2=A0 313.523871 ] [ T122625 ]=C2=A0=C2=A0 EC =3D 0x25: DABT (current =
EL), IL =3D 32 bits
> [=C2=A0 313.523877 ] [ T122625 ]=C2=A0=C2=A0 SET =3D 0, FnV =3D 0
> [=C2=A0 313.523883 ] [ T122625 ]=C2=A0=C2=A0 EA =3D 0, S1PTW =3D 0
> [=C2=A0 313.523889 ] [ T122625 ]=C2=A0=C2=A0 FSC =3D 0x04: level 0 trans=
lation fault
> [=C2=A0 313.523894 ] [ T122625 ] Data abort info:
> [=C2=A0 313.523899 ] [ T122625 ]=C2=A0=C2=A0 ISV =3D 0, ISS =3D 0x000000=
04, ISS2 =3D 0x00000000
> [=C2=A0 313.523905 ] [ T122625 ]=C2=A0=C2=A0 CM =3D 0, WnR =3D 0, TnD =
=3D 0, TagAccess =3D 0
> [=C2=A0 313.523911 ] [ T122625 ]=C2=A0=C2=A0 GCS =3D 0, Overlay =3D 0, D=
irtyBit =3D 0, Xs =3D 0
> [=C2=A0 313.523916 ] [ T122625 ] user pgtable: 4k pages, 48-bit VAs,=20
> pgdp=3D000000013fd6b000
> [=C2=A0 313.523924 ] [ T122625 ] [0000000000000018] pgd=3D00000000000000=
00,=20
> p4d=3D0000000000000000
> [=C2=A0 313.523940 ] [ T122625 ] Internal error: Oops: 0000000096000004 =
[#1] =20
> SMP
> [=C2=A0 313.534094 ] [ T122625 ] Modules linked in: af_packet rfkill dm_=
mod=20
> nls_iso8859_1 nls_cp437 vfat fat binfmt_misc btrfs xor xor_neon=20
> libblake2b virtio_net virtio_balloon net_failover failover button=20
> raid6_pq vsock_loopback vmw_vsock_virtio_transport=20
> vmw_vsock_virtio_transport_common vsock xfs sr_mod cdrom aes_ce_blk=20
> ghash_ce gf128mul virtio_scsi sd_mod sm4 sg scsi_mod scsi_common=20
> xhci_pci virtio_mmio xhci_hcd usbcore usb_common virtio_blk efivarfs=20
> dmi_sysfs qemu_fw_cfg virtiofs fuse virtio_rng
> [=C2=A0 313.540774 ] [ T122625 ] CPU: 4 UID: 0 PID: 122625 Comm: fstrim =
Not=20
> tainted 7.0.10-2-default #1 PREEMPT(full) openSUSE Tumbleweed=20
> e9a5f6b24978fba3bf015a992f865837fdfff3dd
> [=C2=A0 313.544026 ] [ T122625 ] Hardware name: QEMU KVM Virtual Machine=
,=20
> BIOS edk2-20250812-19.fc42 08/12/2025
> [=C2=A0 313.545160 ] [ T122625 ] pstate: 01400005 (nzcv daif +PAN -UAO -=
TCO=20
> +DIT -SSBS BTYPE=3D--)
> [=C2=A0 313.546134 ] [ T122625 ] pc : btrfs_trim_fs+0x34c/0xa00 [btrfs]

Since you can reproduce it on the latest for-next, mind to provide the=20
for-next call trace along with the faddr2line output for pc register of=20
the for-next run?

Thanks,
Qu

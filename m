Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:44158 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLST7o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 14:59:44 -0500
Received: by mail-la0-f49.google.com with SMTP id hs14so1404597lab.22
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 11:59:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54947432.5010107@ubuntu.com>
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>
	<54947432.5010107@ubuntu.com>
Date: Sat, 20 Dec 2014 03:59:42 +0800
Message-ID: <CAN6BF2JoMki_KmpmVYVM-_ECqCg_w-qo9_6P=MiZbabMQyVN_g@mail.gmail.com>
Subject: Re: btrfs is using 25% more disk than it should
From: Daniele Testa <daniele.testa@gmail.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No, I don't have any snapshots or subvolumes. Only that single file.

The file has both checksums and datacow on it. I will do "chattr +C"
on the parent dir and re-create the file to make sure all files are
marked as "nodatacow".

Should I also turn off checksums with the mount-flags if this
filesystem only contain big VM-files? Or is it not needed if I put +C
on the parent dir?

2014-12-20 2:53 GMT+08:00 Phillip Susi <psusi@ubuntu.com>:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 12/18/2014 9:59 AM, Daniele Testa wrote:
>> As seen above, I have a 410GB SSD mounted at "/opt/drives/ssd". On
>> that partition, I have one single starse file, taking 302GB of
>> space (max 315GB). The snapshots directory is completely empty.
>
> So you don't have any snapshots or other subvolumes?
>
>> However, for some weird reason, btrfs seems to think it takes
>> 404GB. The big file is a disk that I use in a virtual server and
>> when I write stuff inside that virtual server, the disk-usage of
>> the btrfs partition on the host keeps increasing even if the
>> sparse-file is constant at 302GB. I even have 100GB of "free"
>> disk-space inside that virtual disk-file. Writing 1GB inside the
>> virtual disk-file seems to increase the usage about 4-5GB on the
>> "outside".
>
> Did you flag the file as nodatacow?
>
>> Does anyone have a clue on what is going on? How can the
>> difference and behaviour be like this when I just have one single
>> file? Is it also normal to have 672MB of metadata for a single
>> file?
>
> You probably have the data checksums enabled and that isn't
> unreasonable for checksums on 302g of data.
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
>
> iQEcBAEBAgAGBQJUlHQyAAoJENRVrw2cjl5RZWEIAKfdDzlNVrD/IYDZ5wzIeg5P
> DR5H8anGGc2QPTAD76vEX/XA7/j1Kg+PbQRHGdz6Iq2+Vq4CGno/yIi46oVVVYaL
> H4XvuH7GvPJyzHJ+XCMHjPGLrSCBxgIm1XSluNXmFNCwqi/FONk8TUhWsw7JchaZ
> yCVe/82YI+MLZhmJdudt48MeNFzW6LYi58dQo/JfYnTGnpZAFutdgBM7vLmnqLY2
> WVLQUNHZsHBa7solttCuRtc4h8ku9FBObfKKYNPAEn1YWfx7bihWgPeBMH/blsza
> yhpMq96OMhIfn2SmIZMSwGh2ys+AxQQfymYR69fyGYTIajHmJEhJUzltuQD9Yg8=
> =Z9/S
> -----END PGP SIGNATURE-----

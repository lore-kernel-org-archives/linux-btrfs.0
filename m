Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:37612 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaLSSx5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 13:53:57 -0500
Received: by mail-qg0-f50.google.com with SMTP id z60so1077726qgd.9
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 10:53:56 -0800 (PST)
Message-ID: <54947432.5010107@ubuntu.com>
Date: Fri, 19 Dec 2014 13:53:38 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Daniele Testa <daniele.testa@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs is using 25% more disk than it should
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>
In-Reply-To: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/18/2014 9:59 AM, Daniele Testa wrote:
> As seen above, I have a 410GB SSD mounted at "/opt/drives/ssd". On 
> that partition, I have one single starse file, taking 302GB of
> space (max 315GB). The snapshots directory is completely empty.

So you don't have any snapshots or other subvolumes?

> However, for some weird reason, btrfs seems to think it takes
> 404GB. The big file is a disk that I use in a virtual server and
> when I write stuff inside that virtual server, the disk-usage of
> the btrfs partition on the host keeps increasing even if the
> sparse-file is constant at 302GB. I even have 100GB of "free"
> disk-space inside that virtual disk-file. Writing 1GB inside the
> virtual disk-file seems to increase the usage about 4-5GB on the
> "outside".

Did you flag the file as nodatacow?

> Does anyone have a clue on what is going on? How can the
> difference and behaviour be like this when I just have one single
> file? Is it also normal to have 672MB of metadata for a single
> file?

You probably have the data checksums enabled and that isn't
unreasonable for checksums on 302g of data.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUlHQyAAoJENRVrw2cjl5RZWEIAKfdDzlNVrD/IYDZ5wzIeg5P
DR5H8anGGc2QPTAD76vEX/XA7/j1Kg+PbQRHGdz6Iq2+Vq4CGno/yIi46oVVVYaL
H4XvuH7GvPJyzHJ+XCMHjPGLrSCBxgIm1XSluNXmFNCwqi/FONk8TUhWsw7JchaZ
yCVe/82YI+MLZhmJdudt48MeNFzW6LYi58dQo/JfYnTGnpZAFutdgBM7vLmnqLY2
WVLQUNHZsHBa7solttCuRtc4h8ku9FBObfKKYNPAEn1YWfx7bihWgPeBMH/blsza
yhpMq96OMhIfn2SmIZMSwGh2ys+AxQQfymYR69fyGYTIajHmJEhJUzltuQD9Yg8=
=Z9/S
-----END PGP SIGNATURE-----

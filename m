Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:37756 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLSUfi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 15:35:38 -0500
Received: by mail-qg0-f41.google.com with SMTP id j5so1195173qga.14
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 12:35:37 -0800 (PST)
Message-ID: <54948C06.6040408@ubuntu.com>
Date: Fri, 19 Dec 2014 15:35:18 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Daniele Testa <daniele.testa@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs is using 25% more disk than it should
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>	<54947432.5010107@ubuntu.com> <CAN6BF2JoMki_KmpmVYVM-_ECqCg_w-qo9_6P=MiZbabMQyVN_g@mail.gmail.com>
In-Reply-To: <CAN6BF2JoMki_KmpmVYVM-_ECqCg_w-qo9_6P=MiZbabMQyVN_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/19/2014 2:59 PM, Daniele Testa wrote:
> No, I don't have any snapshots or subvolumes. Only that single
> file.
> 
> The file has both checksums and datacow on it. I will do "chattr
> +C" on the parent dir and re-create the file to make sure all files
> are marked as "nodatacow".
> 
> Should I also turn off checksums with the mount-flags if this 
> filesystem only contain big VM-files? Or is it not needed if I put
> +C on the parent dir?

If you don't want the overhead of those checksums, then yea.  Also I
would question why you are using btrfs to hold only big vm files in
the first place.  You would be better off using lvm thinp volumes
instead of files, though personally I prefer to just use regular lvm
volumes and manually allocate enough space.  It avoids the
fragmentation you get from thin provisioning ( or qcow2 ) at the cost
of a bit of overallocated space and the need to do some manual
resizing to add more if and when it is needed.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUlIwGAAoJENRVrw2cjl5RlGEH/1OYz07C/OjGBASA9IHTCVMV
NkYHnO3/s2+SOsafQj4ej/RifgX9aG43b8Y6z9XAdosG/X+8z7xRjW9Nic0H5beK
JZRpwP+02Dw02A3/RSPjGqJBeAmS8yi9yTlunnPaCau+m1kPYL4M/vFM8/hqrGeU
Jy+jbffX+XtOedBWptxnDVIyXpYskgVyH8AmQ9d3TGrv52jw/QY1BxkuoVG60hBU
Fk4Q8ed43C9zjCVihmkDOeER6Ygr1roDb1/gFLoeCk4FwVLO9Kusft2Qi2oXyHy1
iTkoVJan8NRzXBhrPtZexxQdewHSw9Z4wyHxlal3b/xIbRf6/DRwPRHfgG5djvM=
=AqC/
-----END PGP SIGNATURE-----

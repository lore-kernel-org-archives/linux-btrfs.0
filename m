Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:40991 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474AbaKRPn1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 10:43:27 -0500
Received: by mail-qc0-f169.google.com with SMTP id w7so4743773qcr.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 07:43:26 -0800 (PST)
Message-ID: <546B68F8.6080008@ubuntu.com>
Date: Tue, 18 Nov 2014 10:42:48 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com> <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net> <54699CC7.1050909@swiftspirit.co.za> <546A46A5.8030603@inwind.it> <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com> <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com> <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
In-Reply-To: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/2014 1:16 AM, Chris Murphy wrote:
> If fstab specifies rootfs as UUID, and there are two volumes with
> the same UUID, it’s now ambiguous which one at boot time is the
> intended rootfs. It’s no different than the days of /dev/sdXY where
> X would change designations between boots = ambiguity and why we
> went to UUID.

He already said he has NOT rebooted, so there is no way that the
snapshot has actually been mounted, even if it were UUID confusion.

> So we kinda need a way to distinguish derivative volumes. Maybe
> XFS and ext4 could easily change the volume UUID, but my vague 
> recollection is this is difficult on Btrfs? So that led me to the 
> idea of a way to create an on-the-fly (but consistent) “virtual 
> volume UUID” maybe based on a hash of both the LVM LV and fs
> volume UUID.

When using LVM, you should be referring to the volume by the LVM name
rather than UUID.  LVM names are stable, and don't have the duplicate
uuid problem.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUa2j4AAoJEI5FoCIzSKrwvywH/3yS25MAIwsGfIwBfCrNN5Qo
NlBttcUcrYgOD/nQHEuulHdilWrvz3q6jGwVL9W8MQsHm0Ah5dMatT5e5zr1DSNC
ZqSEXSE8jsYJu99FUWevxO7wtb94ioKa+OF1u0zsaA5yQUdaj5smPqK3iUfskUhs
jE/vsJmws5iBv0dxnZI/6n3YqOB1Qck4PcMItRj8xvZQ0GjARIVw36pgJnmboGfY
vWRmUXnTeLMu9ilHWhqNUIh3lTTUvRdaYoZtTr6eYh9sIntDCegN71WGmO8FfdjP
vXhikg7Yx7FhkhxAl1X2NzM93d7fUSQDeQfTLYLMDbbTV/n2HwcoZ6G2+IQEJnQ=
=3Lv1
-----END PGP SIGNATURE-----

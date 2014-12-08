Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:55129 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaLHPbu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 10:31:50 -0500
Received: by mail-qg0-f51.google.com with SMTP id e89so2508712qgf.10
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Dec 2014 07:31:50 -0800 (PST)
Message-ID: <5485C432.3030307@ubuntu.com>
Date: Mon, 08 Dec 2014 10:30:58 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Don't use LVM snapshot device
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
In-Reply-To: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/4/2014 1:39 PM, Goffredo Baroncelli wrote:
> LVM snapshots are a problem for the btrfs devices management. BTRFS
> assumes that each device have an unique 'device UUID'. A LVM
> snapshot breaks this assumption.
> 
> This causes a lot of problems if some btrfs device are
> snapshotted: - the set of devices for a btrfs multi-volume
> filesystem may be mixed (i.e. some NON snapshotted device with some
> snapshotted devices) - /proc/mount may returns a wrong device.
> 
> In the mailing list some posts reported these incidents.
> 
> This patch allows btrfs to skip LVM snapshot during the device scan
>  phase.
> 
> But if you need to consider a LVM snapshot you can set the 
> environment variable BTRFS_SKIP_LVM_SNAPSHOT to "no". In this case 
> the old behavior is applied.
> 
> To check if a device is a LVM snapshot, it is checked the 'udev' 
> device property 'DM_UDEV_LOW_PRIORITY_FLAG' . If it is set to 1, 
> the device has to be skipped.
> 
> As consequence, btrfs now depends also by the libudev.

Rather than modify btrfs device scan to link to libudev and ignore the
caller when commanded to scan a snapshot, wouldn't it be
simpler/better to just fix the udev rule to not *call* btrfs device
scan on the snapshot?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUhcQyAAoJENRVrw2cjl5R1YAIAJlCine4apKnM+01Tw6JpofZ
447+FVizi5SjdgkcjcREyU5zu1pa7ioOTdExF1v1irN1xMUrRBL/RJcRjjnjkvjB
dP8JU0x52MEvQABzQP9ANWJnkMqUJ0j+ryPn+3B7wLP/RtAnIn2P9Vh1EhiLkZ9N
TdxZIPtPROWPTFBl9ONTBghOHjWYEtcDMkuTS6ZhwLh5c1LE8d3A9c68ez++oSGz
TbS51ITFZCEUyF7E/r/xWHhrYagoRM+xdYqVACpi5eY8rFKl3oH4R96gBK8hNdiN
AIOilSsNFscXiflORMAaRquW/7tUolfNt+3TfzTYmaVnK4Hv5h0wiJjiKJhNgDY=
=HlmL
-----END PGP SIGNATURE-----

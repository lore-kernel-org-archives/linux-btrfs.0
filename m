Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:58221 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaLBTLx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 14:11:53 -0500
Received: by mail-qc0-f176.google.com with SMTP id i17so9834702qcy.7
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 11:11:53 -0800 (PST)
Message-ID: <547E0EE5.2040504@ubuntu.com>
Date: Tue, 02 Dec 2014 14:11:33 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Anand Jain <Anand.Jain@oracle.com>, kreijack@inwind.it,
        MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Robert White <rwhite@pobox.com>, Chris Mason <clm@fb.com>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>	<547CA4E7.8060209@pobox.com>	<CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>	<547CF8B1.4000303@pobox.com>	<CAE8gLhkxgi8nTab0rzmLNzhsek_v2zs6RxPDL9GU_EAen9+kvA@mail.gmail.com>	<547D6F42.9000009@inwind.it> <CAE8gLhmVqPTArDKxBenbRasUwifGOEoy+askejqneEA9WH-iOQ@mail.gmail.com> <547D9F18.3030400@inwind.it> <547DA86C.4050100@oracle.com> <547DAF2A.7020902@gmail.com>
In-Reply-To: <547DAF2A.7020902@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/2/2014 7:23 AM, Austin S Hemmelgarn wrote:
> Stupid thought, why don't we just add blacklisting based on device
> path like LVM has for pvscan?

That isn't logic that belongs in the kernel, so that is going down the
path of yanking out the device auto probing from btrfs and instead
writing a mount.btrfs helper that can use policies like blacklisting
to auto locate all of the correct devices and pass them all to the
kernel at mount time.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUfg7lAAoJENRVrw2cjl5RAakIAKLsIKgjzUO8J/PBBDTmcCQh
IvkEMlQ6ME+Zi7xCKM9p+J5Skcu22zj8w2Ip0s/zNo3ydGorajxehUqtU983l5Hd
VklKOuNGZ0wrOtwCH8IkRt9HUvT3I7982jByi2Uk9jxpRbL/BruaJ4NF+Z9HnvHO
cmMNavcKvwOkYpPHPPbeyjNwWALe/WRZZ2cgsKqs/vB2nakxFntUc1UOsnIMfLJ7
dMF0l9GudoIoNaqRUNoxV1/Lh9MxKx0p9mBK6Pc+V+wLulUyOUSQ6OkUTsznCabk
iUyzX9IYiF83hWO3g+1vxR+GCeYNVGvC/Rj8ZkLSt9Tpi7JH0kbXnq6wKedSfE0=
=Lxfb
-----END PGP SIGNATURE-----

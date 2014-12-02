Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:39119 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaLBTO3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 14:14:29 -0500
Received: by mail-qg0-f46.google.com with SMTP id z107so9732904qgd.33
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 11:14:28 -0800 (PST)
Message-ID: <547E0F81.70308@ubuntu.com>
Date: Tue, 02 Dec 2014 14:14:09 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, kreijack@inwind.it,
        MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Robert White <rwhite@pobox.com>, Chris Mason <clm@fb.com>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>	<547CA4E7.8060209@pobox.com>	<CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>	<547CF8B1.4000303@pobox.com>	<CAE8gLhkxgi8nTab0rzmLNzhsek_v2zs6RxPDL9GU_EAen9+kvA@mail.gmail.com>	<547D6F42.9000009@inwind.it> <CAE8gLhmVqPTArDKxBenbRasUwifGOEoy+askejqneEA9WH-iOQ@mail.gmail.com> <547D9F18.3030400@inwind.it> <547DA86C.4050100@oracle.com>
In-Reply-To: <547DA86C.4050100@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/2/2014 6:54 AM, Anand Jain wrote:
> we have some fundamentally wrong stuff. My original patch tried to
> fix it. But later discovered that some external entities like 
> systmed and boot process is using that bug as a feature and we had 
> to revert the patch.

If systemd is depending on the kernel lieing about what device it has
mounted then something is *extremely* broken there and that should be
fixed instead of breaking the kernel.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUfg+BAAoJENRVrw2cjl5REm8H/j2MEbF2yeTsGtOGhszl82rZ
ngSvVfEEPq1D+tpi28+oZnSLYxIKEGudqTciyeb8Z1jCTD065D/T0xpGJZyd6pUG
KGahBpnPvhP5xg4RaoSxSzNcFzPPFfz+EIPyV+l3OlHbyeq0whkKj5OAq15Grz6c
RDWViqRFRE+dC2k70fAt6mlxWs7ChCVs9fPuuWVTFW+lXBoCKUZhnZ5Kc2orsKx6
rVTNTo6LxZQX7m+9WzIy5lqH+WgqxtfEacAlM/6jXWwPe09DDT3z0s3ogf+dfO0D
3/efDv1XJ/LwmbyQrGxiS0LQWoPA+d+MX0Od3XRcaeml3d7k/tZjDsrFOY6anIg=
=Rxh6
-----END PGP SIGNATURE-----

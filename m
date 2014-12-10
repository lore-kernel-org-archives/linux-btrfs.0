Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:61355 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbaLJP5D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 10:57:03 -0500
Received: by mail-qg0-f43.google.com with SMTP id i50so2278438qgf.2
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 07:57:03 -0800 (PST)
Message-ID: <54886D4C.50100@ubuntu.com>
Date: Wed, 10 Dec 2014 10:57:00 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: Konstantin <newsbox1026@web.de>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com> <547CE175.6060409@web.de> <547E10BA.6000707@ubuntu.com> <5484F198.3070206@web.de> <5485BCED.1060705@ubuntu.com> <5487B991.9080906@oracle.com>
In-Reply-To: <5487B991.9080906@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/9/2014 10:10 PM, Anand Jain wrote:
> In the test case provided earlier who is triggering the scan ? 
> grub-probe ?

The scan is initiated by udev.  grub-probe only comes into it because
it is looking to /proc/mounts to find out what device is mounted, and
/proc/mounts is lieing.

> But we had to revert, Since btrfs bug become a feature for the
> system boot process and fixing that breaks mount at boot with
> subvol.

How is this?  Also are we talking about updating the cached list of
devices that *can* be mounted, or what device already *is* mounted?  I
can see doing the former, but the latter should never happen.

> if the device is already mounted, just the device path is updated 
> but still the original device will be still in use (bug).

Yep, that is the bug that started all of this.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUiG1MAAoJENRVrw2cjl5Rm0gIAJ6sq72zKSEfCuCjigknx25T
a97wjtMeb+yeaECc5FfwN7Fm454GSSuj6RFCRVjo3sCgJP3sUEH49syJnvW1QiEP
A5ktXfTpz6/zaeP9DbGPDCiVix0RdsJ6bCjP/8InsASueXOENCpxxmblxrbE4Wxj
Mdz8lu9L8G+fc6btbLLb0N4i0clSiImQds90zTQ1cXihJ/4wUIO3qgq+rruSYMqI
A182FS7NTUQrRcJ/rbcha3dCyD/urbCaRTUztMvTnSs3a7hK5p+SBNbfxEORC6ni
HrRMxpOlgHOTMnL3EHw843OuGv0Us3VqVbuPG3K6L4+G4W1sFxgKEAnLvEbjzAI=
=Vpre
-----END PGP SIGNATURE-----

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mehl.schokokeks.org ([46.4.40.247]:35799 "EHLO
	mehl.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaKLFmI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 00:42:08 -0500
Date: Wed, 12 Nov 2014 06:42:01 +0100
From: Florian Bruhin <me@the-compiler.org>
To: Robert White <rwhite@pobox.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: open_ctree failed after ATA errors
Message-ID: <20141112054200.GB5944@lupin>
References: <20141111155153.GZ5944@lupin>
 <5462505D.3000105@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_mehl.schokokeks.org-28696-1415770921-0001-2"
In-Reply-To: <5462505D.3000105@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_mehl.schokokeks.org-28696-1415770921-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

First of all: I noticed was able to mount my partitions when doing
with a different path, which made me investigate my /etc/fstab.

It contained this:

    LABEL=3Ddata1       /mnt/data            btrfs           defaults,noati=
me,nofail,device=3D/dev/disk/by-label/data1,device=3D/dev/disk/by-label/dat=
a2        0 0
    LABEL=3Dsecdata1    /mnt/secdata         btrfs            defaults,noat=
ime,nofail,device=3D/dev/disk/by-label/secdata1,device=3D/dev/disk/by-label=
/secdata2        0 0

I now changed it to:

    /dev/mapper/data1    /mnt/data    btrfs defaults,noatime,nofail 0 0
    /dev/mapper/secdata1 /mnt/secdata btrfs defaults,noatime,nofail 0 0

since my initramfs scans for btrfs devices anyways. Looking at
/dev/disk/by-label, only the second disk respectively shows up:

    lrwxrwxrwx 1 root root 10 Nov 11 19:32 bootfs -> ../../sde1
    lrwxrwxrwx 1 root root 10 Nov 11 19:32 data2 -> ../../dm-3
    lrwxrwxrwx 1 root root 10 Nov 11 19:32 secdata2 -> ../../dm-4

However in /dev/mapper, all of them are listed:

    lrwxrwxrwx 1 root root       7 Nov 11 19:32 data1 -> ../dm-3
    lrwxrwxrwx 1 root root       7 Nov 11 19:32 data2 -> ../dm-1
    lrwxrwxrwx 1 root root       7 Nov 11 19:32 rootfs -> ../dm-0
    lrwxrwxrwx 1 root root       7 Nov 11 19:32 secdata1 -> ../dm-2
    lrwxrwxrwx 1 root root       7 Nov 11 19:32 secdata2 -> ../dm-4

I don't know what's going on there exactly (pointers welcome!) but it
seems the inability to mount is a different issue than the error
messages.

* Robert White <rwhite@pobox.com> [2014-11-11 10:07:25 -0800]:
> Since you just upgraded your kernel I'd check to make sure you have the
> correct chipset and controller card selected. Look at /proc/interrupts and
> see if the controller is sharing an interrupt with some other device that
> could be crossing it up.

I don't really get how to interpret that file I'm afraid. These are
the contents:

               CPU0       CPU1
      0:     754372          0   IO-APIC-edge      timer
      8:          0          1   IO-APIC-edge      rtc0
      9:          0          0   IO-APIC-fasteoi   acpi
     17:        600     114573   IO-APIC  17-fasteoi   ehci_hcd:usb1, ehci_=
hcd:usb2, ehci_hcd:usb3
     18:        521    1240697   IO-APIC  18-fasteoi   ohci_hcd:usb4, ohci_=
hcd:usb5, ohci_hcd:usb6, radeon
     24:          0          0   PCI-MSI-edge      PCIe PME
     25:        667     373771   PCI-MSI-edge      ahci
     26:        408     179898   PCI-MSI-edge      eth0
    NMI:         31         39   Non-maskable interrupts
    LOC:      76628     498768   Local timer interrupts
    SPU:          0          0   Spurious interrupts
    PMI:         31         39   Performance monitoring interrupts
    IWI:          0          2   IRQ work interrupts
    RTR:          0          0   APIC ICR read retries
    RES:     826089     252701   Rescheduling interrupts
    CAL:        270        504   Function call interrupts
    TLB:       5704       5023   TLB shootdowns
    TRM:          0          0   Thermal event interrupts
    THR:          0          0   Threshold APIC interrupts
    MCE:          0          0   Machine check exceptions
    MCP:        129        129   Machine check polls
    THR:          0          0   Hypervisor callback interrupts
    ERR:          0
    MIS:          0

> Play with your MSI/MSI-X settings (if they are in use try disabling them).

I'll try that if the errors show up again in the next few days - maybe
the reboot actually fixed it after all.

> I'd also actvate SMART and get the smart tools (e.g. "smartmontools" in
> gentoo, so probably something similar for your distro) and check the drive
> health.

I already have a monitoring running which also checks SMART, never had
any problems there. But I'll re-check by hand to be sure.

> So the stack is
> Application ->
>  File System ->
>   Device Mapper ->
>    Encryption ->
>     Controller ->
>      Wiring ->
>       Drive
>=20
> You are seeing write failures in the controller->wiring->drive section
> somewhere.

Since it started happening after the upgrade, I can still hope it was
just some temporary issue if it doesn't show up again, right? ;)

> Another possible area is if you ever resized the physical partitions but
> didn't properly resize the cryptsetup layer with "cryptsetup resize", but
> that woudl be unlikly to affect multiple drives (unless the mistake was
> symmetric, e.g. you did it to both drives).

This isn't the case.

Thanks!

Florian

--=20
http://www.the-compiler.org | me@the-compiler.org (Mail/XMPP)
             GPG 0xFD55A072 | http://the-compiler.org/pubkey.asc
         I love long mails! | http://email.is-not-s.ms/

--=_mehl.schokokeks.org-28696-1415770921-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUYvMoAAoJEJFusMj9VaByRTUP/Rrz9y9YzdhCN0K0dFlni4Tc
FTbZCrSdiFx4jGiuGFMwhMVlMXkuiwTbI6L5T0BHMK8MLxkGFGLOfVgC94OHTALk
BPcyojMFh5pub3Jgr1/AOwGyauJ3GMo9nsTefmtrBB0+X9N0STDfHwZ0NYrFxVjv
3kPQJlEoZtHP8e85iGHUXi9Yk5pO9WK1EB5mtk3Vy4lILIAC7MSvFiDyVkQAC79h
ddrm7X74zvVtOuIB04eIwLVtDIX7CB8u4UbtA+KLqrBY4fEvLPBUpqPMC7DLfFOc
ryIBs1lz0fmeTgmubT07pOOnfG23LAolSr3JfpLo8HqFCsqoPWi0FabL11DwHyXN
JBpeW6rHik/H7MfJ38fwNtdYt6tn6RtjxOBPyjsP9BjyNVqToTCZ0WF/G91hyg34
wKjlKGUnse9Btswsw6C2EjgWK0xLpuL1//a3lQ8TZTh4UIrkrxjv3ginn3u8bA1C
3MHbrjSLaOOYHe55PPvw+LBI1n5qsupzJfOZiPwXHN74+gSAy6lJxSt7c0JQCxAY
ERSD8dLsO35hAsDjXQUthjCJgb8Kark9BRP7nr/BfQaSw3HWeFWiVLOQxNsIbZdB
CA6jNMxHAp9rj0tl9DvSQtRJeRmqXNIcUkAZCNu8I1lGHzwdQ3pl2Bg8/tcSqKy2
pxgrQkO9cy9Ma23EFu/A
=+EDY
-----END PGP SIGNATURE-----

--=_mehl.schokokeks.org-28696-1415770921-0001-2--

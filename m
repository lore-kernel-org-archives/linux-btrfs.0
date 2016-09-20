Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47449 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbcITG63 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 02:58:29 -0400
Date: Tue, 20 Sep 2016 06:58:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
Message-ID: <20160920065827.GO7138@carfax.org.uk>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7vLGWvOrvbSM0Ba8"
In-Reply-To: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7vLGWvOrvbSM0Ba8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 20, 2016 at 03:47:14PM +0900, Tomasz Chmielewski wrote:
> How to understand the following "btrfs fi show" output?

This gives a write-up (and worked example) of an answer to your question:

https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_original_tools

   If you've got any follow-up questions after reading it, please do
come back and we can try to improve the FAQ entry. :)

   Hugo.

> # btrfs fi show /var/lib/lxd
> Label: 'btrfs'  uuid: f5f30428-ec5b-4497-82de-6e20065e6f61
>         Total devices 2 FS bytes used 136.18GiB
>         devid    1 size 423.13GiB used 423.13GiB path /dev/sda3
>         devid    2 size 423.13GiB used 423.13GiB path /dev/sdb3
> 
> Why is it "size 423.13GiB used 423.13GiB"? Is it full?
> 
> I had "No space left" on this filesystem just yesterday (running
> kernel 4.7.4). This is btrfs RAID-1 on SSD disks. This filesystem is
> used for 20-30 LXD containers with different roles (mongo, mysql,
> postgres databases, webservers etc.), around 150 read-only
> snapshots, btrfs compression is disabled.
> 
> 
> Both "btrfs fi df" and "df -h" show plenty of space:
> 
> # btrfs fi df /var/lib/lxd
> Data, RAID1: total=417.12GiB, used=131.33GiB
> System, RAID1: total=8.00MiB, used=80.00KiB
> Metadata, RAID1: total=6.00GiB, used=4.86GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 
> # df -h
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda3       424G  137G  286G  33% /var/lib/lxd
> 
> 
> 
> Tomasz Chmielewski
> https://lxadm.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Hugo Mills             | I can resist everything except temptation.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--7vLGWvOrvbSM0Ba8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJX4N4TAAoJEFheFHXiqx3ka6cQALST/1CTOOOWAtZqmMscQMrh
gpo2vOBkAyx/KtuO1z0Mn77dadO0pTw+aKUoHaWf6jOoa1SzV7Wed+FVs9QaJQLS
sXvbgc0mdt2KzpSthcfyqbveTNeS61chXh7AqGNuBZM2dv65jCFk5eeDU2xrAb8f
xpMgXPwWiOJ0hWZTILJ5a0EbFRedm35cGkON/5lMDemfwAcLp0OjLhcUaOa9I1Uj
+3eNsyum3Vp5AC8I+1oXsSLX1orrCOMzGecZLA3cVRqnNnmKQ0uRARGln3MJGpLH
7aYSNQtVwjkErDS5uOwa9/GGzUf2DnDcPHoK5EHDqdvpTR0wNjagjFVKCtTOsKgN
z0dMzIzIoK2/KN/BiufCjT70O8AMHQdN5JxYFALw5rAPvjvLFHHDs2Wqs0zdflri
B0rTccIZFyDeAT47zsJt9BOifEfJHQ3XXsVylN6l6A1Pe6JsR+t9oTZkjDPUKV0g
H2RNAwStX97qmiQjqpqlR4kdlIMzLz652xLXHdkI2lekpX4UY2rh3nCQrPs7HIgF
VKaUkRYDlKxIPulwuODo3s1wrSDBlRD15vVgpLSqVhQ4yMMCUq4R9cqGlozO86cm
TRBkMzbmHBZ3NWYl8Ot4Qla6ZPWM2v3pyKJ+Tf/z5/sT8HwvaDtrAKIkqe7o7JQo
HqOYojIuRdURRpT8It44
=38lh
-----END PGP SIGNATURE-----

--7vLGWvOrvbSM0Ba8--

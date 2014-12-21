Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40572 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaLUXtl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 18:49:41 -0500
Date: Sun, 21 Dec 2014 23:49:40 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tom <tom.ashley@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fwd: Delivery Status Notification (Failure)
Message-ID: <20141221234940.GD25267@carfax.org.uk>
References: <CAEtWy5wo07Yey4d8icCeP51saV2wCaCFh+9dMD23oEJ=nhiSUA@mail.gmail.com>
 <001a11c3dd5e0f76ea050ac2678e@google.com>
 <CAEtWy5z0rayrK3waAN36uL81PJ1VDSew8AO_5J+2WxK_1qAyRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
In-Reply-To: <CAEtWy5z0rayrK3waAN36uL81PJ1VDSew8AO_5J+2WxK_1qAyRw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2014 at 11:41:16PM +0000, Tom wrote:
> Hi,
> 
> My laptop experienced a loss of power that seems to have caused some kind
> of corruption on my /home btrfs partition.
> 
> Upon boot, the partition is mounted rw, but as soon as I start accessing
> data my /home is remounted ro
> 
> uname -a
> Linux jackal 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC 2014
> x86_64 GNU/Linux
> 
> btrfs --version
> Btrfs v3.17.3
> 
> btrfs fi show
> Label: none  uuid: a5ff01bc-dd6c-4d33-95a4-5caca473f4bc
>     Total devices 1 FS bytes used 144.86GiB
>     devid    1 size 250.08GiB used 238.04GiB path /dev/sda4
> 
> Btrfs v3.17.3
> 
> 
> btrfs fi df /home/
> Data, single: total=234.01GiB, used=143.67GiB
> System, DUP: total=8.00MiB, used=32.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=2.00GiB, used=1.19GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=408.00MiB, used=0.00B
> 
> 
> 
> Is there anything obvious in the dmesg that will help me recover this?

   Can't tell from the above -- could you copy the relevant time
period of dmesg to an email so we can see? :)

   Hugo.

> Thanks for any help,
> 
> Tom

-- 
Hugo Mills             | I always felt that as a C programmer, I was becoming
hugo@... carfax.org.uk | typecast.
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUl1yTAAoJEFheFHXiqx3k8jMQAKJiS3Qmpn5T8zqzo38+XqxL
eWCwAOqmOQQTyIYqgopQ3vCHXYoaZXOPtddEBPqAxOeyPUL5nZVnvPu+RdMQbNz/
udKqtMvaj3TE49XLwPt98JlkjAcuhbhd9Tu4he7UZPLg3BEHWWxVWrC559RmoOex
oheRgoS5Vsb8kbOZ3PutloeV+7Mgz1BP3bcm9Zc2lK1iT0S3pMZAdFVfQfIOHY2J
in80c2l8f29AdEn6BaDlEWNS+cPfHeMdd+Hn0pshTYq9Et3KvD5cyP9adObraVLH
l2sqX+7ZcAB80NUB+bLDw/SoAipM+O/roMkntL1SGuFwWqbJPrlCHQVQOfKZUwe/
1WT9ScMEFLgeD0G8GHiMFEUz5Ziee4eEkA2lUx0G0ngoCuARyITh1zLvlSfzRnhz
TkEcIUEHP9AXF4pntuO+BAsnEDfN9EFOBWbhOB+jTB2tN5M3ym99SvGRNbWkj1/l
rMsOFn5BXHmlEkY8uSmC6p64isguTQvGo5Q//7rV+ZI5bF3sHp4Pjaf3p2xev3Rv
Th0KJkrCRL3nL44U5S4ZdV/tDxImUmt3vXI8Dj1seMhGq+sjhFN4JYK0tnWwyfWa
RVZSGe3GjVVbTvGtgUElKEHQGKbfhnDM2wm4mKiXmBr4Zsy0FQ9T6Xn/1Vs/HOm5
8CcS5VnWWgGzARDdItJZ
=JLRc
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--

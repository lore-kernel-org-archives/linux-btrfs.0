Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54761 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3AKSyw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 13:54:52 -0500
Date: Fri, 11 Jan 2013 18:54:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: chris.r.carlin@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Errors not found by btrfsck or scrub
Message-ID: <20130111185449.GU19051@carfax.org.uk>
References: <CAHX0HSbVxW0HvvXi-LXPqGUDu5AZgNRJssMeWRp_MetvVc_gwQ@mail.gmail.com>
 <CAHX0HSZGuE_N1x3DTRPcQZ66B4Sqs7T9sj33=pyVs64wQSWwtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JVdfu60Euw8Ey+/T"
In-Reply-To: <CAHX0HSZGuE_N1x3DTRPcQZ66B4Sqs7T9sj33=pyVs64wQSWwtw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--JVdfu60Euw8Ey+/T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 11, 2013 at 01:13:24PM -0500, Chris Carlin wrote:
> I have a week-old filesystem that is reported clean by btrfsck and
> scrub, but that fails under operations ranging from du to sync and
> umount (but no failures if mounted readonly).
> 
> My problem sounds similar to a few other reports (e.g. TM's in
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/22014 ) that
> seem to hint at problems with full metadata. My df shows:
> 
> # btrfs fi df /mnt/btrfs
> Data, RAID0: total=776.32GB, used=717.56GB
> Data: total=81.00GB, used=29.44GB
> System, DUP: total=8.00MB, used=72.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=512.00MB, used=511.60MB
> Metadata, DUP: total=1.00GB, used=1022.39MB
> 
> That looks suspicious to me, both the 1GB vs 1022MB and that there is

   1GB in this output is 1024 MiB (i.e. it's actually 1 GiB, not 1
GB), so it's not screwed-up accounting, just confusing reporting.

> both DUP and RAID1 metadata. The balance operation I ran after adding
> a second device finished without errors; could it have actually
> failed? At this point balance DOES fail (locks up) every time...

   The balance probably did half the DUP -> RAID-1 conversion of your
metadata and then had its problems. I wouldn't worry about this too
much.

> This computer is Ubuntu, but I've updated to the latest kernel and
> btrfs-tools I could find, and the problems remain.
> 
> Below is what showed up in dmesg during the run of scrub. Most of the
> time the error is "btrfs: block rsv returned -28", but the aborted
> transaction and auto-ro is always there.

   Just for reference, -28 is -ENOSPC.

> Anything I can do to help identify a bug here? Clearly one problem is
> that the filesystem checking tools can't find anything wrong, much
> less fix the filesystem.

> [12208.367199] Pid: 1955, comm: btrfs-transacti Not tainted
> 3.5.7-03050702-generic #201212170935
  ^^^^^ There's significant ENOSPC fixes since this point. A new
kernel (3.7) will probably help some of the way -- see below for some
of the details.

   The other thing I'd like to check is what balance command you're
using. With your current problems, I'd suggest the following:

# btrfs balance start -dusage=5 /mountpoint

   This will attempt to move the data in every data chunk which is
less than 5% full. With a 3.7 kernel (but not 3.5 IIRC(*)), that
should free up most of the 60 GiB of allocated but unused data space
you've got.

   Hugo.

(*) Kernels before 3.5, possibly 3.6 -- I can't recall exactly when it
got fixed -- had a problem where they'd massively overallocate chunks.
With those earlier kernels, you could end up with a situation like
yours which wouldn't be helped by the balance operation.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Two things came out of Berkeley in the 1960s: LSD and Unix. ---   
                       This is not a coincidence.                        

--JVdfu60Euw8Ey+/T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUPBf+b9z9OVl50rAAQKxfg//a+kRPFIhSVUgP03DIj+s/vymkCV6qv+h
AAlBlXlBvHNw3WiwWvVYEZSxolsdWf1g+w1HTWtwzX43mUpgOC98PZFE6MWVNaGr
653KtK389RY2W2dOw5zI+TKudtGvRpxR7lCXI6vkYQtCoQiSDEe9lbIjoUBnGVeg
ZG740gm7KzxC4p+mp3oj6Mhs0jOlCZWSTiCLb00gOw6EJVZPPGvwp1+5u0aXLu64
LzrE1L872t7KPUg/88PyKjrsrRMWi0ZVq8km8zQ0A0jpGtwkAT6G5V7PfxlKEL4G
DMowif16QcPovhQrWsARN4xfQbKBam6Txc1hnC2bSRNhPu3+f+7rInfmfsUglzMZ
+sgebewNx64KWB32hen9WwD0RT3q4EZBtbgk00qHYywjdMW8Ja3FKJW+DT04MHk0
pMBCKj0k9TUFb81804/4k1tHjL4MwmKv8Y4OEmcoAQyXidlSCbsrtCgGA1rFdAHQ
dBMgYwBlXAwS+t76YaH9Ycu7rQ4SfhIThBPgydMtumxvvSRouN+PgnqT4KKqjasm
E84TRxrTV2EuMcupAg7YC+ILnrFgcHxu3PtjA+lk4sXfIEYXkltjv5DIQGjdDdu6
XMZXyhHlxRtUaKWXPkba57e/CCBO5OMDGshtmrZEQR3Mp1OkoyFVXyQHXts1Fezp
Q4nd6+QtLeM=
=gM9j
-----END PGP SIGNATURE-----

--JVdfu60Euw8Ey+/T--

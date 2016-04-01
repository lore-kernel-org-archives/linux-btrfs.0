Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60739 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbcDAKFK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 06:05:10 -0400
Date: Fri, 1 Apr 2016 10:05:07 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Alejandro Vargas <anv@zener.es>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: empty disk reports full
Message-ID: <20160401100507.GP29474@carfax.org.uk>
References: <2879842.8EgedBzSUf@anv.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l7GkBbkEatsaRqBf"
In-Reply-To: <2879842.8EgedBzSUf@anv.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--l7GkBbkEatsaRqBf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 01, 2016 at 11:50:50AM +0200, Alejandro Vargas wrote:
> I am using a 2Tb disk for incremental backups.
> 
> I use rsync for backing up to a subvolume, and each day I creates an snapshot 
> of the lastest snapshot and do rsync in this.
> 
> When the disk becomes nearly full (100Gb or less available) I deletes the 
> oldest subvolume (withbtrfs subvolume delete).
> 
> My problem is that *even removing ALL the subvolumes*, the free space does
> not change. It continues reporting the same size (disk is nearly full).
> 
> I tried "btrfs balance start /mnt/backup" but it takes hours and hours.
> 
> I'm using linux 4.1.15
> btrfs-progs v4.1.2

   Can you show us the output of both "sudo btrfs fi show" and "btrfs
fi df /mnt/backup", please?

   Hugo.

-- 
Hugo Mills             | The Creature from the Black Logon
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--l7GkBbkEatsaRqBf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW/kfTAAoJEFheFHXiqx3kYtAP+gOeEvRMtRKk/FmMIJmHd2wC
Ba4415/P5sDeGVq0O3yfCXtbi2ApxCbkn9BHzP38UkIH1IQQzgxx6bjizwk9Ggdg
qUW9n7wtjuCtL9/6ZOst6gwJMcNPhz/gN6NEYS6IV8jJFPx6HMTkXhg706sAnt1h
fbGCE8zcKmqSp/htcKMENP8+6M0ox1ZMH/l8sCgUqNKFtLnJXBynCLC+pLT0jfLQ
OU/RsM2YKyyH5wQkC/gp8p11OhBg2RgwKFeWO5hK6PXgjbu8m6Rwyge/EB6uBQY3
qpWysjRayCL4yKoLqU8gwx55pYhNfj8trJ5d46lmrPhSyys4G4W8hZeRXP3CYBfJ
FR5sXUWP/t6z3UFnkvWwC9vLQNBp4wTqq71pQhnOKlfXG8P/rr4jv5iTv/HF+i4p
Y+QfMADOJxApqLL5sYY5Nx6PGoVMscR2zA6XvEibtVrnPawj65c3VxG5MPNdecRt
zuvFn62YXbqEHpdTSnjsKkwBTXJ/KES6Ciy3vRuBhkrlR0KD6EObD1YcLKHyBskE
t0TiFe38L0eajwV6yWNSJfpdLIlIcCT2nvP7E/r9gjwI/0K5WsOqWmrcErhUh7Qk
je9+OXZcNwQP78j1mB8exV8JpSWFIDnGCLwuRUIuGX5dnx8WdyTKjJDoah2XtNUW
+AgHtqlQUX4tqgnwjC+V
=/50r
-----END PGP SIGNATURE-----

--l7GkBbkEatsaRqBf--

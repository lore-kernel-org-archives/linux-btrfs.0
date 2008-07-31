From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Kernel oops after compile error
Date: Thu, 31 Jul 2008 09:43:12 -0400
Message-ID: <1217511792.20239.42.camel@think.oraclecorp.com>
References: <1905261913@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Marcel Runte <marcel.runte@web.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1905261913@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-07-31 at 00:44 +0200, Marcel Runte wrote:
> Hello,
>=20
> I fiddled around with btrfs this evening and need some further insigh=
t into this error.
>=20
> During compilation this error occurs:
>=20
> /home/runtema/btrfs_build/kernel-9da425337329/file.c: In Funktion =C2=
=BBbtrfs_file_write=C2=AB:
> /home/runtema/btrfs_build/kernel-9da425337329/file.c:851: Warnung: =C3=
=9Cbergabe des Arguments 1 von =C2=BBremove_suid=C2=AB von inkompatible=
m Zeigertyp
>=20

Btrfs should compile without warnings, in general any warning is a bug.
The incompatible pointer argument warnings are almost always bugs.  In
this case, the ubuntu kernel has a patch that changes the arguments of
the remove_suid call, and btrfs needs to call it differently.

But, recent versions of Btrfs should be doing the right thing.  Which
version are you running?

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

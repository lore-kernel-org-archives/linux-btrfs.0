From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 17:14:25 +0100
Message-ID: <201112171714.25563.Martin@lichtvoll.de>
References: <201112161851.52011.Martin@lichtvoll.de> <201112171300.29833.Martin@lichtvoll.de> <1324125748.22624.14.camel@squire.doc.ic.ac.uk> (sfid-20111217_153900_731895_C5B16D09)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: David McBride <dwm@doc.ic.ac.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1324125748.22624.14.camel@squire.doc.ic.ac.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. Dezember 2011 schrieb David McBride:
> On Sat, 2011-12-17 at 13:00 +0100, Martin Steigerwald wrote:
> > BTW on my ThinkPad T520 I do not perceive performance issues for
> > BTRFS as /. But then thats located on an Intel SSD 320 where seeks
> > should not matter much.
>=20
> Okay, that would be consistent with the slow behaviour observed by
> others on fsync()-heavy workloads.  Presumably this produces much mor=
e
> seeky IO patterns than current common filesystems; I wonder if this i=
s
> a limitation of the current implementation or something that is an
> inherent properties of the data-structures being used?

All I can say is that the ThinkPad T520 doesn=C2=B4t seem the best mach=
ine for=20
testing the performance of software. I have seen nothing thats actually=
=20
been slow on that machine yet. Its not a machine for triggering=20
bottlenecks easily it seems to me.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

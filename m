From: Oystein Viggen <oysteivi@tihlde.org>
Subject: Re: [bug] Reclaim space.
Date: Wed, 10 Feb 2010 14:16:35 +0100
Message-ID: <03zl3hgrik.fsf@msgid.viggen.net>
References: <1265740911.5943.7.camel@pi> <m3iqa62n8t.fsf@pullcord.laptop.org>
	<m3d40e2kdn.fsf@pullcord.laptop.org> <1265757229.5943.13.camel@pi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

* [Ian Kumlien]=20

> Thanks, I do wonder btw, btrfsck always seems to segfault when you ch=
eck
> a filesystem in real use - ie loged in users and daemons running - bu=
t
> not on a normal 'single' user boot. Anything that could be done with
> this? (It doesn't inspire confidence ;))

Online filesystem check isn't yet implemented.  What you're seeing is
btrfsck not actually checking to see if the fs is mounted before
running.  Make sure to always umount before running btrfsck.

(I remember reading something about such a check being added to btrfsck=
,
so it might be better with newer btrfs-tools).

=D8ystein
--=20
Outgoing mail is certified Virus Free.
=2E.of course, the virus would tell you the same thing..

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

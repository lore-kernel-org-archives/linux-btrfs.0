Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:51169 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965359AbbJ0Uyu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 16:54:50 -0400
Received: from thetick.localnet ([93.181.44.4]) by smtp.web.de (mrweb002) with
 ESMTPSA (Nemesis) id 0M40na-1ahDt620SA-00rYIT for
 <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 21:54:46 +0100
From: Marc Joliet <marcec@web.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: random i/o error without error in dmesg
Date: Tue, 27 Oct 2015 21:54:40 +0100
Message-ID: <1844690.p2LsPbdn9l@thetick>
In-Reply-To: <pan$69543$b4766f34$8286648d$3871cb8f@cox.net>
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick> <pan$69543$b4766f34$8286648d$3871cb8f@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1794850.lMSNZVG9dD"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1794850.lMSNZVG9dD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

OK, upgrading to gentoo-sources 4.1.11 didn't help, so I tried these st=
eps. =20
More inline below.

On Tuesday 27 October 2015 06:23:06 Duncan wrote:
>Marc Joliet posted on Mon, 26 Oct 2015 15:23:39 +0100 as excerpted:
>> Occasionally they go away by themselves, but usually I have to reboo=
t to
>> make them go away.  This happens when getmail attempts to fetch mail=
,
>> which fails due to the above error.  After the reboot getmail succee=
ds
>> again.
>
>Just out of curiosity, does a remount,ro, followed by a remount,rw, so=
lve
>the problem?
>
>The ro/rw cycle should force anything in memory to device, so if that
>eliminates the problem, it could well be some sort of sync issue.  If =
it
>doesn't, then it's more likely an in-memory filesystem state issue,
>that's cleared by the reboot.

Didn't try this directly, but...

>And if the ro/rw cycle doesn't clear the problem, what about a full
>unmount/mount cycle, at least of that subvolume?

...this didn't work, after which...

>If you're running multiple subvolumes with root being one of them, you=

>can't of course unmount the entire filesystem, but you could go down t=
o
>emergency mode (systemctl emergency), try unmounting everything but /,=

>mounting / ro, and then switching back to normal mode (from emergency
>mode, simply exiting should return you to normal multi-user or gui
>target, remounting filesystems as necessary, etc).

...I tried most of this.  I unmounted everything except for /var and /,=
=20
neither of which I could mount read-only.  It didn't help, either.

>IOW, does it take a full reboot to clear the problem, or is a simple r=
o/rw
>mount cycle enough, or an unmount/remount?

Seems that a full reboot is needed, but I would expect that it would ha=
ve the=20
same effect if I were to pivot back into the initramfs, unmount / from =
there,=20
then boot back into the system.  Because quite frankly, I can't think o=
f any=20
reason why a power cycle to the SSD should make a difference here.  I v=
aguely=20
remember that systemd can do that, so I'll see if I can find out how.

>Finally, assuming root itself isn't btrfs, if you have btrfs configure=
d
>as a module, you could try unmounting all btrfs and then unloading the=

>module, then reloading and remounting.  That should entirely clear all=
 in-
>memory btrfs state, so if that doesn't solve the problem, while reboot=
ing
>does, then the problem's very possibly outside of btrfs scope.  Of cou=
rse
>if root is btrfs, you can't really check that.

Nope, btrfs is built-in (though it doesn't have to be, what with me usi=
ng an=20
initramfs).

Thanks
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart1794850.lMSNZVG9dD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWL+SVAAoJEL/Q5oYsiHj0ASgP/1g6K/N67a1o+2mHoFjqL9h4
EFN2ocQqHJEVpGxsUe1/IY1ALGxHUxEXctFnUxVKU4zmovV3xZgN7UN+fTq0sva+
hS0d4Uhdc8Mw2iSgPDaUkVbYeNrCDZOF3B16QKU+rf2qOxDABUjUQyOPYwTzSJWH
pw6E7Jr/yKaqZih+rvsyIYRU2oU8RxHo7vn3TPKJWm9f1UW0y3rANTx9H9upSOes
yh1GJ/K6iDA741Zd2XJZy6DVBxfLE9qLSR5OnNdEBGr71p+E0LjMBnacjoUcE4Ko
9RTrcuUeMVin1Ktk01K9mIPgU7+RIAnEyPm6NccHtl77x7BWKcr5QCl3Z1pHyts8
O9e3TpujUo3+G3yAMY5D9oNgHgr2XBQE9y/Qr0q1xYGMraHcddvsBHMOeGJfaRLU
UBdzYbsFx+BsaMu3CXHVFPy5qn1JwkoncfWNdGVZPLuwC7sREY9mzR+bc5nloSK7
57ysTBLCsztVv2MjCupijgDVQZRzazdsLUnOues5s84KKC6BD7gJP5ObSkgtDhE9
BFgMM9C6wB+PQKDJhD+B1V6wVx347LxRUpNTqSayccqHnf7ErIzrcayZq5XQY8jd
ImBtAkydn2M0w4VlBF/snLKcERU4uKt+S8lvfTLJeSrtF7ZCO5pXI952KGp5Y1q5
aNOxER6C6/F+vuRdDfQi
=olgH
-----END PGP SIGNATURE-----

--nextPart1794850.lMSNZVG9dD--


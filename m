Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:56552 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbbJ2VKd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 17:10:33 -0400
Received: from thetick.localnet ([93.181.44.4]) by smtp.web.de (mrweb001) with
 ESMTPSA (Nemesis) id 0Mbhiv-1aAxHf3vAD-00J5nz for
 <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 22:10:31 +0100
From: Marc Joliet <marcec@web.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: random i/o error without error in dmesg
Date: Thu, 29 Oct 2015 22:10:24 +0100
Message-ID: <2085133.yRiO7H1dHn@thetick>
In-Reply-To: <pan$31224$86839f8e$da37e2a5$124e475b@cox.net>
References: <562E0D31.2080003@dblaci.hu> <1844690.p2LsPbdn9l@thetick> <pan$31224$86839f8e$da37e2a5$124e475b@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart37082186.X2DLyVG23U"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart37082186.X2DLyVG23U
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Wednesday 28 October 2015 05:21:13 Duncan wrote:
>Marc Joliet posted on Tue, 27 Oct 2015 21:54:40 +0100 as excerpted:
>>>IOW, does it take a full reboot to clear the problem, or is a simple=

>>>ro/rw mount cycle enough, or an unmount/remount?
>>>
>> Seems that a full reboot is needed, but I would expect that it would=

>> have the same effect if I were to pivot back into the initramfs, unm=
ount
>> / from there,
>> then boot back into the system.  Because quite frankly, I can't thin=
k of
>> any reason why a power cycle to the SSD should make a difference her=
e.
>> I vaguely remember that systemd can do that, so I'll see if I can fi=
nd
>> out how.
>
>Agree with both the systemd returning to the initr* point (which I
>actually had in mind while writing the above but don't remember the
>details either, so chose to omit in the interest of limiting the size =
of
>the reply and research necessary to generate it), and the ssd power-cy=
cle
>point.

I haven't found any single command that lets you do that, but I can try=
 one of=20
the special targets as detailed in bootup(7) (e.g., initrd.target) when=
 I have=20
a chance.

>>>Finally, assuming root itself isn't btrfs, if you have btrfs configu=
red
>>>as a module, you could try unmounting all btrfs and then unloading t=
he
>>>module, then reloading and remounting.  That should entirely clear a=
ll
>>>in-memory btrfs state, so if that doesn't solve the problem, while
>>>rebooting does, then the problem's very possibly outside of btrfs sc=
ope.
>>>
>>> Of course if root is btrfs, you can't really check that.
>>=20
>> Nope, btrfs is built-in (though it doesn't have to be, what with me
>> using an initramfs).
>
>Same here, also gentoo as I guess you know from previous exchanges.  B=
ut
>unfortunately, if your initr* is anything like mine, and your kernel
>monolithic as mine, making btrfs a module with a btrfs root isn't the
>easy thing it might seem to those who run ordinary distro supplied bin=
ary
>kernels with pretty much everything modularized, as doing so involves =
a
>whole new set of research on how to get that module properly included =
in
>the initr* and loaded there, as well as installing and building the wh=
ole
>module-handling infrastructure (modprobe and friends) again, as it's n=
ot
>actually installed on the system at all at this point, because with th=
e
>kernel entirely monolithic, module-handling tools are unnecessary and
>thus just another unnecessary package to have to keep building updates=

>for, if they remain installed.

My kernel is fairly modular, and I use dracut to make my initramfs, so =
I=20
wouldn't be surprised if it works.  For me, personally, I just don't se=
e any=20
point in making btrfs a module.

(And yes, of course I know you run Gentoo ;-) .)

>So I definitely sympathize with the feeling that such a stone is bette=
r
>left unturned, if overturning it is at all a possibility that can be
>avoided, as it is here, this whole exercise being simply one of better=

>pinning the bug down, not yet actually trying to solve it.  And given
>that unturned stone, there are certainly easier ways.
>
>And one of those easier ways is investigating that whole systemd retur=
n
>to initr* idea, since we both remember reading something about it, but=

>aren't familiar with the details.  In addition to addressing the probl=
em
>headon if anyone offers a way to do so, that's the path I'd be looking=
 at
>right now.

Like I said above, I'll try it out when I have a moment where I have a =
more=20
"steady hand" so-to-speak.

[snip deleted files stuff]
>app-admin/lib_users
[snip the rest of the deleted files stuff]

I use that to find processes that need restarting after upgrades, thoug=
h I'll=20
sometimes check to see if it's really a library that's causing it to sh=
ow up,=20
since often a process is listed because of stuff like the font cache, o=
r, in=20
the case of the FISH shell, it's own history file.

But yeah, didn't think of running that, but in rescue mode there were a=
t most=20
a dozen processes running, so there's not much to choose from, anyway. =
 I did=20
have to kill two remaining user processes first (pulseaudio and... I fo=
rgot=20
the other one).  I didn't try the same with / and /var because I was ea=
ger to=20
get back to a normally running system ;-) .

>Of course, if lib_users reports nothing further still holding referenc=
es
>to deleted files, and a remount read-only STILL fails, that's a major
>note of trouble and an important finding in itself.

I don't expect that, but I'll make note of it if I encounter it.

>Meanwhile, as explained in the systemd docs (specifically the systemd =
for
>administrators series, IIRC), systemd dropping back to the initr* is
>actually its way of automatically doing effectively the same thing we
>were using lib_users and all those restarts to do, getting rid of all
>possible still running on root executables, including systemd itself, =
by
>reexecing systemd itself back in the initr*, as a way to help eliminat=
e
>*everything* running on root, so it can not only be remounted read-onl=
y,
>but actually unmounted the same as any other filesystem, as userspace =
is
>now actually running from the initr* once again.  That's a far *FAR*
>safer reboot after upgrade than traditional sysvinit solutions were ab=
le
>to do. =3D:^)

Yeah, the ability to do that is a nice plus of using an initramfs.  Alt=
hough=20
I've never been clear on why it's *safer*.  Is it because the remount m=
ight=20
fail?  Or are there other reasons, too?

[...]

=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart37082186.X2DLyVG23U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWMotFAAoJEL/Q5oYsiHj03NIP/j8+pLCFionHgloipRSndD+V
zsmblvOcfGHRn3PFpLUzsQV6J/lCs/+3HUDrpIFEb0XFCZ8yCCYC5K5rOrKE6bpw
oI0gZXRvFwjdAbOf5fLf4xBofFnlSeeACxb8iFA6OjvnRp02efYJfn3oBQpWR0Xe
opweyoAGfUnyDibodCFnxVyI8gO/FxxmeUB2zlWLNXR8bGPHA+qNioOGUxPKH6Z/
7gJB3hNPYzNrRhunEaVi+21ab2Dqz3+tSu2ERWUmddAmUZyXgQsvi8+t9lZuoX/N
OUdd8ZTAtuWeaNkyOIYLlzH9yXv6hwBoFGCqTONAS6c5yisl1PCtzYH0QhOrPCP4
L3QwFt/m05dfMeXaigG9kewWQxw0oGX7p6JnzMY87SVE79VY9CxDuXQ0gTBQ1p6x
xCqQlbUVgOVxR2UKoWiFpTPb93z/KGrpFPbur4Fa3eWTxUGuGxrTSj1pBC3wYX/l
EZQ7RufMFW2sQ5eYVriGZlpbv4L+GFYZGPwxDOmdKW4s70O9B0e3pkmK6XoQt/dt
IEx0c//TKc7G6a5Klq5AZIO5oAHUYjEu72sJoBOfcvT3JhTn/ZNulRbj99UakyNs
qNrduTUfpAXwIuqAeyYYtWWVC7438XTO8kHU2bS60Isgx/5t9dyaGnoeIBFzyqb5
3SzX9Y7L30RsfGtv1ppT
=2Hm1
-----END PGP SIGNATURE-----

--nextPart37082186.X2DLyVG23U--


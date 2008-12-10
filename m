From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Selective Compression/Encryption
Date: Wed, 10 Dec 2008 08:44:47 -0500
Message-ID: <1228916687.11900.10.camel@think.oraclecorp.com>
References: <20081209145952.GA30494@tux64-03>
	 <f058a9c30812090745v15b5f983u468b560ae791dc37@mail.gmail.com>
	 <200812091722.21567.mail@earthworm.de>	<20081209180951.GA6551@tux64-03>
	 <20081210000512.7be20413@diego-desktop>  <493F043B.50804@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Diego Calleja <diegocg@gmail.com>, Lee Trager <lt73@cs.drexel.edu>,
	Christian Hesse <mail@earthworm.de>, miguel.filipe@gmail.com,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <493F043B.50804@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-12-09 at 18:50 -0500, jim owens wrote:
> Diego Calleja wrote:
> > El Tue, 9 Dec 2008 13:09:51 -0500, "Lee Trager" <lt73@cs.drexel.edu=
> escribi=C3=B3:
> >=20
> >> It does seem that doing it with volumes would limit user control a=
nd add
> >> lots of complexity to such a simple task.
> >=20
> > IMHO, WRT compression it's the contrary. Compression on a per-file =
basis has
> > never been very succesful (just look at how many windows users use =
it)
> > because it implies taking a decision for every file on the system. =
OTOH,
> > volume-level is just a single option to be enabled.
> >=20
> > I'm of course not arguing that file-level compression shouldn't be =
possible,
> > im just saying that is way more difficult to administer and that mo=
st people
> > (including sysadmins) is most likely to use compression in a per-vo=
lume basis.
>=20
> While I have not gotten far enough to prove it is feasible...
>=20
> My idea on controlling features like compression is that
> the default mode is inherited from the parent in the
> directory tree.  Thus you can turn it on/off at whatever
> granularity you want.
>=20

I had planned to make the bits inheritable from the directory inode
flags.  There are two different discussions around xattrs for this.  On=
e
is using xattrs to store the flag, which I'd would rather avoid because
it is checked in some performance critical places.

The second is using xattr programs to set the flag, which I don't reall=
y
have an opinion on.  The idea of having the flags backed up by backup
programs or rsync is really nice, but do any of the backup programs
actually copy out all the xattrs?

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

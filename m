From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: Problems with set-default, home subvolume and snapshot
Date: Mon, 5 Sep 2011 16:07:42 +0300
Message-ID: <20110905130742.GA4756@zambezi.lan>
References: <4E64BE74.7040000@cyberphoria.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: Hugo Mills <hugo@carfax.org.uk>,
	=?utf-8?B?QmrDtnJu?= Kalkbrenner <terminar@cyberphoria.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E64BE74.7040000@cyberphoria.org>
 <20110905103033.GL9907@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 05, 2011 at 11:30:33AM +0100, Hugo Mills wrote:
> On Mon, Sep 05, 2011 at 12:13:25PM +0200, Bj=C3=B6rn Kalkbrenner wrot=
e:
> > 2. why can't i do "mount -o subvolume=3Dhome /dev/mapper/root /home=
"
> > anymore? To be more exact, i can, but why is it empty and why is it
> > working when i enter the subvolume id?
>=20
>    I don't know about this one, sorry.

Well, it's *sort of* expected if you think about it.  When you mounted
after set-default, your /home is no longer a valid subvolume access
point (it was in the default subvolume, until you rebooted).  Inside
your snapshot /home is just an empty directory (there's more to it,
that's why you can't delete it, but that's irrelevant here).

However if you mount with subvolid=3D<objectid>, you point to a subvolu=
me
directly, skipping the lookup (which leads to an empty dir if you are
inside your snapshot).  That's why it works when you use the subvolid.
We should probably tune the lookup to make subvol=3D work in this case.

> > 6. is my btrfs filesystem broken now and should i recreate the whol=
e
> > thing or is it safe to use it?
>=20
>    It sounds like it's all working correctly, and there's nothing
> wrong. (Well, bar the inability to mount with "subvol=3Dhome")

Like Hugo said, the behaviour you described above seems to be correct.


On Mon, Sep 05, 2011 at 02:20:04PM +0200, Bj=C3=B6rn Kalkbrenner wrote:
> Hi!
>=20
> Thank you Hugo for your answers, but i have an update.
>=20
> "It's dead Jim."
>=20
> When i tried to mount subvolid=3D0 to a temporary folder i got a kern=
el
> segfault and a BUG line in btrfs kernel code somewhere (reproducable)=
,
> after a reboot all volumes are broken, can't be mounted anymore...
> btrfsfsck gave me inode errors on subvol 256 (my home).
> mount does nothing but sleep/hang...
>=20
> Now i am trying to restore my system and home from a backup to a new
> harddrive, without btrfs at the moment...
>=20
> I think my question 6 is now answered: it's completely broken.

You say it's reproducable, can you give us a backtrace to look at ?

> Bye
> Bj=C3=B6rn
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

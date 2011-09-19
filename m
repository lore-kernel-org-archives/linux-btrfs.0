From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: Re: kerenl bug after btrfs resize (reduce size)
Date: Mon, 19 Sep 2011 14:55:27 +0200
Message-ID: <CABVOS0-dHR_pRa15uP51-2m27c9nBUCR6oFwBJEecffM0CRvHA@mail.gmail.com>
References: <CABVOS0_vA_BrA8+3mrgKUWRhmhMBA9bJUGwJvto16k3xM92+DQ@mail.gmail.com>
 <20110919123818.GD21530@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>,
	Roman Kapusta <roman.kapusta@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110919123818.GD21530@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2011 at 14:38, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Sep 19, 2011 at 02:24:55PM +0200, Roman Kapusta wrote:
>> After running 'btrfs fi resize' I got following error, fortunately, =
it
>> looks that filesystem is ok.
>> I was changing filesystem size from 256 GB to 192 GB (reducing by
>> 64GB), free space was 110GB.
>
> =C2=A0 I would be careful here -- the FS may be OK in that it's all
> readable, but it may not have shrunk by as much as you requested. In
> other words, don't drop the size of the containing partition until
> you've successfully run a resize without it crashing.
>

I've forgot to mention that Xorg hanged (and all processes accessing
btrfs partition), I have tried to reboot from console, not
successfully.
After hard reset filesystem was not resized and all stored data looks o=
k.

>> My system is Fedora 14. I'm considering upgrade to Fedora 15, is thi=
s
>> already fixed?
> [snip]
>> Not tainted 2.6.35.14-96.fc14.i686 #1 30A2/HP Compaq nx7400
>
> =C2=A0 In btrfs terms, this is a kernel from the Dark Ages. You shoul=
d
> upgrade to something recent *immediately*. There are all kinds of
> nasty bugs in 2.6.35 (and later) that have been fixed. I don't know i=
f
> this particular one is one of them, but running btrfs on 2.6.35 is
> rather like juggling nitrogylcerine: bad things *will* happen, sooner
> or later.
>
> =C2=A0 I would strongly recommend running a 3.0 or 3.1-rc kernel (at =
least
> until 3.1 comes out, then keep following the latest kernel releases).

Ok I'm going to upgrade and then I will try again to resize.

>
> =C2=A0 Hugo.
>
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =C2=A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.=
org.uk
> =C2=A0 --- In the future, terrorists won't be carrying their ID cards=
=2E ---
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 They'l=
l be carrying yours. -- Henry
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 Porter, =C2=A0Suspect Nation
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iD8DBQFOdze5IKyzvlFcI40RAtgQAJ4p/ufc4VYrxRm97AvJ6jYfGr/GJQCglcN6
> g6pHYvPZgdP+kMPopPOLZvI=3D
> =3DvN6B
> -----END PGP SIGNATURE-----
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

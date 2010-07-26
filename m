From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: Configuring default mount options..
Date: Mon, 26 Jul 2010 12:27:35 +0100
Message-ID: <1280143655.3327.22.camel@hardline>
References: <1280105806.3327.4.camel@hardline>
	 <AANLkTikNemTBWO8ChQ-XYdP4gp=1zKt5EMyzdzLrxgWq@mail.gmail.com>
	 <1280107386.3327.8.camel@hardline>
	 <AANLkTimOC0qyDdv3KgY4p_vcW1YQ+f=ToaS4=81VQh4B@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimOC0qyDdv3KgY4p_vcW1YQ+f=ToaS4=81VQh4B@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>=20
> From: Oystein Viggen <oysteivi <at> tihlde.org>
> Subject: Re: Configuring default mount options..
> Newsgroups: gmane.comp.file-systems.btrfs
> Date: 2010-07-26 06:08:54 GMT (5 hours and 4 minutes ago)
>=20
> * ["A. James Lewis"]=20
>=20
> > Maybe there is a way to do this already, but it seems like the
> > filesystem itself should contain preferences for the way it is used
> > under those circumstances.
>=20
> There has been talk of supporting per-file (and I assume recursive
> per-directory default) attributes for raid level.  Things like
> encryption and compression could fit well into such a scheme.
>=20
That's a nice solution, particularly for encryption... especially once =
the GUI file managers are able to indicate the settings.... It would se=
em to be necessary to allow these parameters to be set in the root, but=
 otherwise nice.

I'm not sure if it negates the value of having default "preferences" st=
ored somwhere... certainly it would take longer to implement, but maybe=
 the default parameters for all these settings are simply equivalent to=
 whatever is defined in the root of each filesystem... so really one so=
lution can be a subset of the other.

>=20
> I don't believe the code for this is written yet, however.
>=20
> =C3=98ystein
> --=20
> ssh -c rot13 otherhost
>=20
>=20
A. James Lewis


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

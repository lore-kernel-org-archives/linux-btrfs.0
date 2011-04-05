From: Xavier Nicollet <nicollet@jeru.org>
Subject: Re: btrfs subvolume snapshot syntax too "smart"
Date: Tue, 5 Apr 2011 16:29:58 +0200
Message-ID: <20110405142958.GK18890@jeru.org>
References: <BANLkTikvyUH2Dhm2p=N-GSzy7r4_nj=bNg@mail.gmail.com> <4D9A203E.9090807@libero.it> <BANLkTimbmwM078e-SVcuWPDqjy99_hV+sw@mail.gmail.com>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimbmwM078e-SVcuWPDqjy99_hV+sw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Le 04 avril 2011 =E0 12:57, Freddie Cash a =E9crit:
> Isn't this a situation where supporting a trailing / would help?
>=20
> For example, with the / at the end, means "put the snapshot into the
> folder".  Thus "btrfs subvolume snapshot /ssd/sub1 /ssd/5/" would
> create a "sub1" snapshot inside the 5/ folder.  Running it a second
> time would error out since /ssd/5/sub1/ already exists.  And if the 5=
/
> folder doesn't exist, it would error out.
>=20
> And without the / at the end, means "name the snapshot".  Thus "btrfs
> subvolume snapshot /ssd/sub1 /ssd/5" would create a snapshot named
> "/ssd/5".  Running the command again would error out due to the
> snapshot already existing.  And if the 5/ folder doesn't exist, it's
> created.  And it errors out if the 5/ folder already exists.
>=20
> Or, something along those lines.  Similar to how other apps work
> with/without a trailing /.

I am not an expert, but I think it is the opposite with rsync.

Cheers,

--=20
Xavier Nicollet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

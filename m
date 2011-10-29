From: Jordan Windsor <jordanw2@gmail.com>
Subject: Re: Find RAID level, Change RAID level.
Date: Sun, 30 Oct 2011 00:55:33 +1030
Message-ID: <CACCfv7rRw6NsxAbosbdTVXpcWvc1XO=goSTQoQ5txQPnX=eSyw@mail.gmail.com>
References: <CACCfv7q4HkRDnCa3bXEj+fAJA1kikLQ+3G46VH-2unPgT=1DFA@mail.gmail.com>
	<20111029141303.GN29548@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Jordan Windsor <jordanw2@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111029141303.GN29548@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 30, 2011 at 12:43 AM, Hugo Mills <hugo@carfax.org.uk> wrote=
:
> On Sun, Oct 30, 2011 at 12:28:39AM +1030, Jordan Windsor wrote:
>> Hello,
>> I was wondering is it possible to find the RAID level currently in u=
se
>> by a btrfs volume, also can I change the data & metadata (or either)
>> RAID levels after creation.
>
> =A0 To see the RAID levels, use
>
> btrfs fi df /path/to/filesystem
>
> =A0 To change RAID levels, you will need Ilya Dryomov's restriper
> patches, which were posted to this list back in August.
>
> =A0 Hugo.
>
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org=
=2Euk
> =A0 =A0 =A0 =A0 =A0 =A0 --- Ceci est un travail pour l'Australien. --=
-
>

Thanks, so If it mentions "DUP" on the metadata & system line I'm using=
 RAID1?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

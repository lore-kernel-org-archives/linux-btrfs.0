From: Jordan Windsor <jordanw2@gmail.com>
Subject: Re: Find RAID level, Change RAID level.
Date: Sun, 30 Oct 2011 01:06:49 +1030
Message-ID: <CACCfv7oD=u3dyz38Q32+ehi0gG_-TZes-E6WMD3YVETDexbpNA@mail.gmail.com>
References: <CACCfv7q4HkRDnCa3bXEj+fAJA1kikLQ+3G46VH-2unPgT=1DFA@mail.gmail.com>
	<20111029141303.GN29548@carfax.org.uk>
	<CACCfv7rRw6NsxAbosbdTVXpcWvc1XO=goSTQoQ5txQPnX=eSyw@mail.gmail.com>
	<20111029143410.GO29548@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Jordan Windsor <jordanw2@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111029143410.GO29548@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 30, 2011 at 1:04 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sun, Oct 30, 2011 at 12:55:33AM +1030, Jordan Windsor wrote:
>> On Sun, Oct 30, 2011 at 12:43 AM, Hugo Mills <hugo@carfax.org.uk> wr=
ote:
>> > On Sun, Oct 30, 2011 at 12:28:39AM +1030, Jordan Windsor wrote:
>> >> Hello,
>> >> I was wondering is it possible to find the RAID level currently i=
n use
>> >> by a btrfs volume, also can I change the data & metadata (or eith=
er)
>> >> RAID levels after creation.
>> >
>> > =A0 To see the RAID levels, use
>> >
>> > btrfs fi df /path/to/filesystem
>> >
>> > =A0 To change RAID levels, you will need Ilya Dryomov's restriper
>> > patches, which were posted to this list back in August.
>>
>> Thanks, so If it mentions "DUP" on the metadata & system line I'm us=
ing RAID1?
>
> =A0 No, DUP is two copies of the data (or metadata), but kept on the
> same block device.
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
If the word RAID isn't mentioned, I'm in single mode for both metadata =
& data?
Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

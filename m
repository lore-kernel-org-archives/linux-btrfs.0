From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Raid1 with 3 drives
Date: Fri, 5 Mar 2010 23:27:27 +0100
Message-ID: <201003052327.28202.hka@qbs.com.pl>
References: <013A5A0F-6BB8-4CF0-855F-0A80BEA8B1CC@adtran.com> <b7130efa1003051349p63733275g6b98fab32d6f497c@mail.gmail.com> <93cdabd21003051413m76a8babs2ab5a58c32dd9aee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Bart Noordervliet <bart@noordervliet.net>,
	linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21003051413m76a8babs2ab5a58c32dd9aee@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 05 March 2010 23:13:54 Mike Fedyk wrote:
> On Fri, Mar 5, 2010 at 1:49 PM, Bart Noordervliet <bart@noordervliet.=
net>=20
wrote:
> > Maybe it's worth to consider leaving the burdened raid* terminology
> > behind and name the btrfs redundancy modes more clearly by what the=
y
> > do. For instance "-d double|triple" or "-d 2n|3n". And for raid5/6 =
"-d
> > single-parity|double-parity" or "-d n+1|n+2".
>=20
> +1

Good idea IMHO.

When we will be able to specify the redundancy modes on a file by file =
basis=20
it will make it much less confusig for the users to talk about double, =
triple =20
replication or [single|double]-parity.=20

It's a bit silly to talk about "Arrays of Disks" when we mean groups of=
=20
blocks.

--=20
Hubert Kario
QBS - Quality Business Software
ul. Ksawer=C3=B3w 30/85
02-656 Warszawa
POLAND
tel. +48 (22) 646-61-51, 646-74-24
fax +48 (22) 646-61-50
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

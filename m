From: J G <yoosty_cmn@yahoo.com>
Subject: Re: Adding mirroring to an existing filesystem
Date: Sun, 16 May 2010 08:38:50 -0700 (PDT)
Message-ID: <677718.82116.qm@web112502.mail.gq1.yahoo.com>
References: <AANLkTimKr24mjku0shVSNmUSd9yW6MgeBBIIYuPsE7BN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org, Donald Gordon <don@dis.org.nz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimKr24mjku0shVSNmUSd9yW6MgeBBIIYuPsE7BN@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>



--- On Sun, 5/16/10, Donald Gordon <don@dis.org.nz> wrote:

> From: Donald Gordon <don@dis.org.nz>
> Subject: Adding mirroring to an existing filesystem
> To: linux-btrfs@vger.kernel.org
> Date: Sunday, May 16, 2010, 4:39 AM
> Hi
>=20
> Is there some way I can add an extra disk as a mirror to an
> existing
> btrfs filesystem?=A0 Or must I create a new filesystem
> with RAID1, and
> then copy over all my data?

https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devic=
es#Adding_New_Devices

I would be sure to back my data up before performing this procedure ;)

>=20
> thanks
>=20
> donald
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20


     =20

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

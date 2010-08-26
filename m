From: Xavier Nicollet <nicollet@jeru.org>
Subject: Re: 2.6.36-rc1 btrfs still unstable
Date: Thu, 26 Aug 2010 10:58:01 +0200
Message-ID: <20100826085801.GQ1344@jeru.org>
References: <1281948382.1888.7.camel@chotu> <20100816121658.GT3315@think> <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5BC@mail.corp.imt-systems.com> <201008251857.39585.johannes.hirte@fem.tu-ilmenau.de>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201008251857.39585.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Le 25 ao=FBt 2010 =E0 18:57, Johannes Hirte a =E9crit:
> > the other big question is:
> > Is btrfs with 2.6.36 really rockstable and ready to use in producti=
ve environments?
>=20
> I don't think so. There is at least one checksum bug and ENOSPC probl=
ems are also still present.

I am planning to put 2 dedicated web hosting servers in production
(backuped every day), with 2.6.34.5 vanilla kernel.

I also use btrfs on a 2.6.34 kernel on the backup server (rsync) for
some time.

--=20
Xavier Nicollet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

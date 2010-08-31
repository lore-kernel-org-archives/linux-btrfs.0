From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: Question about specific patch (eMMC)
Date: Tue, 31 Aug 2010 19:27:15 +0200
Message-ID: <20100831172715.GA14509@mother.pipebreaker.pl>
References: <1283255825.3347.4.camel@calladain.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1283255825.3347.4.camel@calladain.research.nokia.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 31, 2010 at 02:57:05PM +0300, Alexander Vdovichev wrote:
> Hello all,
> Is there any patches for btrfs to use enhanced area in eMMC (it will
> allow to boost performance i.e. it very useful to keep metadata withi=
n
> this area) ?
>=20
> If it's exist let me know how to find it and use it.

  I'm not aware of this at the moment.  However, there are data-tempera=
ture
tracking patches.  Their point is to move hot data into faster storage.
I believe they can grow into generic infrastructure to inform filesyste=
ms
about non-homogenous nature of underlaying storage.

--=20
Tomasz Torcz                        To co nierealne -- tutaj jest norma=
lne.
xmpp: zdzichubg@chrome.pl          Ziomale na =BFycie maj=B1 tu patenty=
 specjalne.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

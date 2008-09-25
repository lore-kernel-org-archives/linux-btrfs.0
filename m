From: Xavier Nicollet <nicollet@jeru.org>
Subject: Re: feature request: read/write priorities on multiple devices/raid1
Date: Thu, 25 Sep 2008 17:49:22 +0200
Message-ID: <20080925154922.GL27002@jeru.org>
References: <1553.85.177.90.248.1222334375.squirrel@webmail.schleiser.de> <1222348238.7028.31.camel@think.oraclecorp.com> <f058a9c30809250831r5479c4fcyac4deade9ddfda0e@mail.gmail.com>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30809250831r5479c4fcyac4deade9ddfda0e@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Le 25 septembre 2008 =E0 16:31, Miguel Sousa Filipe a =E9crit:
> On Thu, Sep 25, 2008 at 2:10 PM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> > I don't plan on adding support for non-persistent storage, but ther=
e
> > will be the idea of a fast frontend device that is basically a cach=
e for
> > slower devices.
>=20
> Something like yet another caching/buffer layer between the buffer
> cache and the storage devices?
>=20
> I recall reading something similiar to that in a listing of new
> features of a recent revision of ZFS ?

Reminds me WAFL from netapp.

http://media.netapp.com/documents/wp_3002.pdf

Transactions are written to NVRAM, then flushed every 10 seconds.
If some files are created then imediately deleted, it won't even touch
the disk.

As the server "knows" the underlining RAID structure, it is able to
choose how to flush the data for maximum disk throughput.

I am not a specialist, but this document is worth reading IMHO.

--=20
Xavier Nicollet
http://nicollet.jeru.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

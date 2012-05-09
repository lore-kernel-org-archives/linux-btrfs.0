From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [PATCH v2 1/5] btrfs: add command to zero out superblock
Date: Wed, 09 May 2012 19:23:47 +0200
Message-ID: <5640951.VQCHRfAj9R@k85hala03>
References: <1335876033-12201-1-git-send-email-kario@wit.edu.pl> <1405178.Vd8v8qs4AD@bursa01> <20120509171807.GO19331@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120509171807.GO19331@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 09 of May 2012 19:18:07 David Sterba wrote:
> On Thu, May 03, 2012 at 03:11:45PM +0200, Hubert Kario wrote:
> > nice, didn't know about this. Such functionality would be nice to h=
ave.
> > But then I don't think that a "recreate the array if the parameters=
 are
> > the
> > same" is actually a good idea, lots of space for error. A pair of
> > functions:
> >=20
> > btrfs dev zero-superblock
> > btrfs dev restore-superblock
>=20
> As a user, I'm not sure what can I expect from the restore command. F=
rom
> where does it restore? Eg. a file?
>=20
> As a tester I have use for a temporary clearing of a superblock on a
> device, then mount it with -o degraded, work work, and then undo
> clearing. So, my idea is like
>=20
>   btrfs device zero-superblock --undo
>=20
> with the obvious sanity checks. A regular user would never need to ca=
ll
> this.

Yes, that's a better idea.

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: dynamically remove unused block groups
Date: Tue, 30 Nov 2010 14:01:01 -0500
Message-ID: <20101130190100.GA2577@localhost.localdomain>
References: <1291135590-26775-1-git-send-email-josef@redhat.com> <AANLkTikkU_2SbtVzRuUJbTGO3dQGQc9Jd8FgpGFPF7uE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Josh Berry <des@condordes.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikkU_2SbtVzRuUJbTGO3dQGQc9Jd8FgpGFPF7uE@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 30, 2010 at 09:37:17AM -0800, Josh Berry wrote:
> On Tue, Nov 30, 2010 at 08:46, Josef Bacik <josef@redhat.com> wrote:
> > Btrfs only allocates chunks as we need them, however we do not dele=
te chunks as
> > we stop using them. =A0This patch adds this capability. =A0Whenever=
 we clear the
> > last bit of used space in a block group we try and mark it read onl=
y, and then
> > when the last pinned space is finally removed we queue up the delet=
ion work.
> > I've tested this with xfstests and my enospc tests. =A0When filling=
 up the disk
> > I see that we've allocated the entire disk of chunks, and then when=
 I do rm *
> > there is a bunch of space freed up. =A0Thanks,
>=20
> Stupid user question:
>=20
> I have a btrfs filesystem on a 2.6.36 kernel that used to have ~800GB
> of data on it.  Then I deleted ~500GB of it (moved it elsewhere), but
> my space usage as reported by df and the btrfs tool didn't decrease
> appreciably.  Might this be why?
>=20

So without this patch, with a full fs I do this

[root@test1244 ~]# ./btrfs-progs-unstable/btrfs fi df /mnt/btrfs-test/
Data: total=3D980.25MB, used=3D909.91MB
System, DUP: total=3D16.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D511.88MB, used=3D190.42MB
Metadata: total=3D8.00MB, used=3D0.00

If I removed everything from the fs, you'd still see Data total=3D980.2=
5MB, but
used should be close to 0 (this is assuming no snapshots and such).  Wi=
th this
patch if I rm -rf /mnt/btrfs/* I get this

[root@test1244 ~]# ./btrfs-progs-unstable/btrfs fi df /mnt/btrfs-test/
Data: total=3D204.75MB, used=3D192.00KB
System, DUP: total=3D16.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D307.12MB, used=3D24.00KB
Metadata: total=3D8.00MB, used=3D0.00

So that free'd up ~700mb in data space and ~200mb in metadata space tha=
t can be
allocated to either data/metadata based on your usage patterns.  I hope=
 that
helps explain it.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

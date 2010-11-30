From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: dynamically remove unused block groups
Date: Tue, 30 Nov 2010 14:35:13 -0500
Message-ID: <20101130193512.GB2577@localhost.localdomain>
References: <1291135590-26775-1-git-send-email-josef@redhat.com> <AANLkTikkU_2SbtVzRuUJbTGO3dQGQc9Jd8FgpGFPF7uE@mail.gmail.com> <20101130190100.GA2577@localhost.localdomain> <AANLkTik7ypX9Ed+pngnjHB8CrKDMJK-F+HXhbK3MrhZ0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Josh Berry <des@condordes.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik7ypX9Ed+pngnjHB8CrKDMJK-F+HXhbK3MrhZ0@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 30, 2010 at 11:31:17AM -0800, Josh Berry wrote:
> On Tue, Nov 30, 2010 at 11:01, Josef Bacik <josef@redhat.com> wrote:
> > On Tue, Nov 30, 2010 at 09:37:17AM -0800, Josh Berry wrote:
> >> On Tue, Nov 30, 2010 at 08:46, Josef Bacik <josef@redhat.com> wrot=
e:
> >> > Btrfs only allocates chunks as we need them, however we do not d=
elete chunks as
> >> > we stop using them. =A0This patch adds this capability. =A0Whene=
ver we clear the
> >> > last bit of used space in a block group we try and mark it read =
only, and then
> >> > when the last pinned space is finally removed we queue up the de=
letion work.
> >> > I've tested this with xfstests and my enospc tests. =A0When fill=
ing up the disk
> >> > I see that we've allocated the entire disk of chunks, and then w=
hen I do rm *
> >> > there is a bunch of space freed up. =A0Thanks,
> >>
> >> Stupid user question:
> >>
> >> I have a btrfs filesystem on a 2.6.36 kernel that used to have ~80=
0GB
> >> of data on it. =A0Then I deleted ~500GB of it (moved it elsewhere)=
, but
> >> my space usage as reported by df and the btrfs tool didn't decreas=
e
> >> appreciably. =A0Might this be why?
> >>
> >
> > So without this patch, with a full fs I do this
> >
> > [root@test1244 ~]# ./btrfs-progs-unstable/btrfs fi df /mnt/btrfs-te=
st/
> > Data: total=3D980.25MB, used=3D909.91MB
> > System, DUP: total=3D16.00MB, used=3D4.00KB
> > System: total=3D4.00MB, used=3D0.00
> > Metadata, DUP: total=3D511.88MB, used=3D190.42MB
> > Metadata: total=3D8.00MB, used=3D0.00
> >
> > If I removed everything from the fs, you'd still see Data total=3D9=
80.25MB, but
> > used should be close to 0 (this is assuming no snapshots and such).=
 =A0With this
> > patch if I rm -rf /mnt/btrfs/* I get this
> >
> > [root@test1244 ~]# ./btrfs-progs-unstable/btrfs fi df /mnt/btrfs-te=
st/
> > Data: total=3D204.75MB, used=3D192.00KB
> > System, DUP: total=3D16.00MB, used=3D4.00KB
> > System: total=3D4.00MB, used=3D0.00
> > Metadata, DUP: total=3D307.12MB, used=3D24.00KB
> > Metadata: total=3D8.00MB, used=3D0.00
> >
> > So that free'd up ~700mb in data space and ~200mb in metadata space=
 that can be
> > allocated to either data/metadata based on your usage patterns. =A0=
I hope that
> > helps explain it.
>=20
> That makes sense, thanks.
>=20
> I was still seeing very high data-used, but it turns out there was an
> old snapshot I didn't know I had, so the problem was really
> stupid-user error. :)
>=20

Yeah 2 things to keep in mind, 1 if you have snapshots you are likely t=
o not see
data free'd up the way you expect it.  The other thing is that because
everything is COW we can't allocate the newly free'd space until the tr=
ansaction
commits, so you may have to wait ~30 seconds or run sync to force the
transaction to commit before you see your space actually free'd up.  Th=
anks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

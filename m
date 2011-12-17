From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 12:54:47 +0100
Message-ID: <201112171254.47334.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: Goffredo Baroncelli <kreijack@inwind.it>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. Dezember 2011 schrieben Sie:
> On Friday, 16 December, 2011 20:53:58 Martin Steigerwald wrote:
> > > I found a solution, but requires a bit of setup.
> > >=20
> > >=20
> > >=20
> > > The idea is to avoid do perform sync during the package
> > > installation. In order to avoid data loss in case of failure, I
> > > create a snapshot before the upgrading. If something goes wrong
> > > (i.e. a power failure) I rebooot the system from the snapshot. If
> > > the installation finish without problem, I flush all the data to
> > > the disk and remove the snapshot.
> > >=20
> > >=20
> > >=20
> > > For the detail, see a my old post titled "[RFC] aptitude & BTRFS
> > > slow" (2011-10-19)
> >=20
> > Sounds more like a workaround to me than a solution.
>=20
> Sorry but I strongly disagree.
>=20
> Aptitude was designed for an ordinary filesystem. Where the only way =
to
> have a filesystem consistency is to issue a lot of sync for every
> package. But this doesn't prevent to have an half package
> installed:(think about to an "openoffice" upgrade: in case of power
> failure, you could not have nor the old openoffice, nor the new one.
> Instead with the snapshot you can always have the old system or the n=
ew
> system. No half packages
>=20
> With BTRFS, I can say that the workaround[*] is using the sync and no=
t
> the snapshot
>=20
> The true is that BTRFS is different from ext4 (or ext3, xfs....). You
> can use BTRFS like ext4 and you will find a lot of regression like
> this.
>=20
> BTRFS is very different from an ordinary filesystem, and you have to
> change some behaviour to take advantages with is peculiarities.

This reminds me of the delayed allocation discussion as Ext4 introduced=
=20
that feature.

Ext3/4 developer Theodore T=C2=B4so  said if the applications are not u=
sing=20
fsync() its their fault. But before OTOH applications began to avoid us=
ing=20
fsync() since it has had serious performance drawbacks on ext3 (not ext=
4)=20
with data=3Dordered.=20

Ext4 now has workarounds for the rename and truncate cases, after Linus=
=20
requested boldly to not break existing userspace.

Now applications that use fsync() the way Theodore T=C2=B4so and other =
see it=20
correctly used should now skip the fsync() on a BTRFS?

I find it *highly* problematic when applications are required to adapt=20
their behavior depending of the filesystem being in use.

This just doesn=C2=B4t make sense to me.

If BTRFS has other means to guarantee filesystem consistency that is fa=
ster=20
it might still make fsync() a no-op or just creating a snapshot=20
temporarily automatically.

> Using the snapshot during an upgrade open a lot of possibility which
> are not allowed with EXT4. With snapshot you can always go back if
> during an upgrade if something goes wrong (like strange packages
> dependencies). Or you can have the previous configuration to go back
> in case of trouble.

Adding new possibilities is one thing. And supporting snapshots properl=
y=20
would depend on some support side from the applications. I think that=20
using snapshots for upgrades is a good idea.

But OTOH I think that BTRFS should not break or slow down existing=20
userspace. I think that existing approaches like using fsync() like=20
according to quite some filesystem developers it should be used should=20
continue to work nicely.

Similar goes for the hardlink limit.

> [*] Of course this is due to the fact that the most part of the
> filesystem is like ext4. Supporting BTRFS could be not the highest
> priority.

I do think that a

if fs=3Dext4 then do this

if fs=3Dbtrfs then do this and

if fs=3Dext3 + data=3Dordered then do this

if fs=3Dext3 + data=3Dordered + kernel=3Dwhatnot then do it a tad bit d=
ifferently

if fs=3Dunkown then assume this

in a application is just kind about broken and always thought that one=20
main task of a filesystem would be to lift off the burden on the detail=
s on=20
how data is saved from the application.

Ok, some guidelines might be needed like if you save 10 bytes 1000 time=
s=20
it might be less performant than saving 10000 bytes at once, but aside=20
from that=E2=80=A6

So I think BTRFS should have a fast fsync - that fullfils the consisten=
cy=20
guarentee by whatever compatible way it sees fit - and for the system=20
partition I would even trade in the cow functionality. I didn=C2=B4t ha=
ve it=20
with Ext4 anyway.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

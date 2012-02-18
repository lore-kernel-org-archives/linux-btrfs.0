From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache off?
Date: Sat, 18 Feb 2012 13:49:23 +0100
Message-ID: <201202181349.23385.Martin@lichtvoll.de>
References: <20120130003754.GD4380@merlins.org> <20120213001400.GD31989@merlins.org> <201202181339.24502.Martin@lichtvoll.de> (sfid-20120218_134010_410031_8FF867BA)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Marc MERLIN <marc@merlins.org>, Milan Broz <mbroz@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	jeff@deserettechnology.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201202181339.24502.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 18. Februar 2012 schrieb Martin Steigerwald:
[=E2=80=A6]
> Am Montag, 13. Februar 2012 schrieb Marc MERLIN:
> > On Mon, Feb 13, 2012 at 12:47:54AM +0100, Milan Broz wrote:
> > > On 02/12/2012 11:32 PM, Marc MERLIN wrote:
> > > >Actually I had one more question.
> > > >
> > > >I read this page:
> > > >http://www.redhat.com/archives/dm-devel/2011-July/msg00042.html
> > > >
> > > >I'm not super clear if with 3.2.5 kernel, I need to pass the
> > > >special allow_discards option for brtfs and dm-crypt to be safe
> > > >together, or whether
> > > >they now talk through an API and everything "just works" :)
> > >=20
> > > If you want discards to be supported in dmcrypt, you have to enab=
le
> > > it manually.
> > >=20
> > > The most comfortable way is just use recent cryptsetup and add
> > > --allow-discards option to luksOpen command.
> > >=20
> > > It will be never enabled by default in dmcrypt for security reaso=
ns
> > > http://asalor.blogspot.com/2011/08/trim-dm-crypt-problems.html
> >=20
> > Thanks for the answer.
> > I knew that it created some security problems but I had not yet fou=
nd
> > the page you just gave, which effectively states that TRIM isn't
> > actually that big a win on recent SSDs (I thought it was actually
> > pretty important to use it on them until now).
>=20
> Well I find
>=20
> "On the other side, TRIM is usually overrated. Drive itself should ke=
ep
> good performance even without TRIM, either by using internal garbage
> collecting process or by some area reserved for optimal writes
> handling."
>=20
> a very, very weak statement on the matter, cause it lacks any links t=
o
> any evidence for the statement made. For that I meant to knew up to
> know is that wear leaveling of the SSD can be more effective the more
> space the SSD controller/firmware can use for wear leveling freely.
> Thus when I give space back to the SSD via fstrim it has more space
> for wear leveling which should lead to more evenly distributed write
> pattterns and more evenly distributed write accesses to flash cells
> and thus a longer life time. I do not see any other means on how the
> SSD drive can do that data has been freed again except for it being
> overwritten, then the old write location can be freed of course. But
> then BTRFS does COW and thus when I understand this correctly, the SS=
D
> wouldn=C2=B4t even be told when a file is overwritten, cause actually=
 it
> isn=C2=B4t, but is written to a new location. Thus especially for BTR=
=46S I
> see even more reasons to use fstrim.

Hmmm, even with COW old data is overwritten eventually, cause especiall=
y=20
on SSDs free space might be sparse. So even when when overwriting a fil=
e or=20
some parts of it writes to a new location, at some time in the future=20
BTRFS will likely overwrite the old one.

So seen in that light, an occasional fstrim might just help to make fre=
e=20
space available sooner.

Heck, I find it so difficult to know whats best when SSD / flash is inv=
olved.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

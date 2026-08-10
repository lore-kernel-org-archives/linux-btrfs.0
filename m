Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDF654652
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 00:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=174.142.148.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786323470; cv=none; b=Op1uEqYRx0TFazCcPNoadd5FvN1pFqB1J7tt4QR8tx7pzBoF+nmFfvQWttA7ESEUfdEmy/cItKL1v51Hxr3KicwV/+EyvUWb1V5h3MyHoK2zrtvj/3KI9+iQPre3xovF5oZraIp5Y5D7Zk1KjVBC/FtUSoum49WP34v/sSuC/mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786323470; c=relaxed/simple;
	bh=rfOkD7nXguJivEzJUE0Zh1aJjAc5CE+hGA95xpJRXz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WE8NPAXiJuyRoeHv+OFNse1w5WXzYCbVRjobVGDXsBuMfWFyiepfgFlOb4jtlxz9WG3h0JrCSnH3ge0GQMpLsfBrNBEORXT6H41Y11o1WiomtrrQl8hHB8YM9RzzuK+57I8O6SujRl6krK6kdBfQQzSoeU8xTkIbT+e/wIVkMdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org; spf=pass smtp.mailfrom=drax.hungrycats.org; arc=none smtp.client-ip=174.142.148.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=drax.hungrycats.org
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
	id A5F181B1FB67; Sun, 09 Aug 2026 20:57:47 -0400 (EDT)
Date: Sun, 9 Aug 2026 20:57:47 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <wqu@suse.com>
Cc: koraynilay <koray.fra@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
	clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
Message-ID: <ankiC-Zauoib3KLf@hungrycats.org>
References: <20260808023459.1494928-1-koray.fra@gmail.com>
 <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
 <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
 <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
 <ankKjqr72aD8Ka8w@hungrycats.org>
 <95bab93b-f0c6-447d-8bfb-c81b3d48f7a7@suse.com>
 <ankbNtvLr3ZnFjEk@hungrycats.org>
 <9995da33-3f10-43b6-aec1-0e90eae03c7a@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <9995da33-3f10-43b6-aec1-0e90eae03c7a@suse.com>

On Mon, Aug 10, 2026 at 10:21:11AM +0930, Qu Wenruo wrote:
>=20
>=20
> =E5=9C=A8 2026/8/10 09:58, Zygo Blaxell =E5=86=99=E9=81=93:
> > On Mon, Aug 10, 2026 at 08:50:45AM +0930, Qu Wenruo wrote:
> > >=20
> > >=20
> > > =E5=9C=A8 2026/8/10 08:47, Zygo Blaxell =E5=86=99=E9=81=93:
> > > > On Sun, Aug 09, 2026 at 10:30:45AM +0930, Qu Wenruo wrote:
> > > > >=20
> > > > >=20
> > > > > =E5=9C=A8 2026/8/9 10:05, koraynilay =E5=86=99=E9=81=93:
> > > > > > On Sun Aug 9, 2026 at 2:17 AM CEST, Qu Wenruo wrote:
> > > > > > > I'm not sure if this is the correct behavior in the first pla=
ce.
> > > > > > >=20
> > > > > > > As you already mentioned, zstd and zlib have very different c=
ompression
> > > > > > > level range, using the incorrect level makes no sense (and it=
's being
> > > > > > > clamped anyway).
> > > > > > >=20
> > > > > > > I think we should go the default level when not specified, wh=
ich makes
> > > > > > > more sense, and that would definitely be something worth fixi=
ng.
> > > > > >=20
> > > > > > Yes, I also think that would be best, but my main concern would=
 be it
> > > > > > changing how chattr +c behaves (I'm less concerned about the bt=
rfs prop
> > > > > > set file compression "zstd" case, since IMO that implies the us=
er wants
> > > > > > the default level).
> > > > >=20
> > > > > Mind to explain more about the "chattr +c" problem?
> > > > >=20
> > > > > IIRC "chattr +c" just set the btrfs.compression XATTR to the defa=
ult zlib if
> > > > > no mount option is specified.
> > > >=20
> > > > chattr with _any_ argument resets the btrfs.compression xattr _ever=
y_
> > > > time, even if the caller changes a flag something that doesn't look=
 like
> > > > it would affect compression, e.g. chattr +A or +d.
> > >=20
> > > This is the known problem of chattr.
> > >=20
> > > >=20
> > > > That can lead to surprising results, like changing compress type fr=
om
> > > > zstd to zlib, if the original btrfs.compression attribute doesn't m=
atch
> > > > the mount option.
> > >=20
> > > This doesn't only apply to c, but all other chattr options.
> > >=20
> > > That's why proper chattr should always include the full attrs, not on=
ly the
> > > one to change.
> > >=20
> > > >=20
> > > > > In that case it should be no difference compared to any existing =
XATTR based
> > > > > compression setting.
> > > > >=20
> > > > > Thus it's just the same missing level handling, and IMHO since XA=
TTR
> > > > > compression level is never specified in XATTR, then the behavior =
is never
> > > > > fully determined, and users should not depend on it.
> > > > >=20
> > > > > Even if we changed the behavior to option 3, it should not be a s=
uper huge
> > > > > user affecting change.
> > > > > In the end, it's just compression level, affecting compression ra=
tio and
> > > > > speed, not really a huge behavior change.
> > > > >=20
> > > > > >=20
> > > > > > The options I considered were:
> > > > > > 1) keep the "bug", like I did for now;
> > > > > > 2) keep the "bug", but only if the compress=3D algo is the same
> > > > > >       as the btrfs.compression one, if they aren't, use the def=
ault for the
> > > > > >       btrfs.compression algo (e.g. compress=3Dzstd:15 and btrfs=
=2Ecompression=3Dzlib
> > > > > >       would compress the extent at zlib:3 instead of clamp(zlib=
, 15) =3D 9)
> > > > > >       (suggested by Zygo);
> > > > > > 3) fix the "bug" entirely, which is what I actually accidentall=
y did at
> > > > > >       first, by just setting compress_level =3D inode->prop_com=
press_level
> > > > > >       without any check prior to that (which means that by defa=
ult it would
> > > > > >       use algo:0).
> > > > >=20
> > > > > IHMO both option 2 and 3 are acceptable.
> > > > >=20
> > > > >=20
> > > > > The only extra concern is, if we have a new level field in XATTR,=
 can older
> > > > > kernels handle it?
> > > > >=20
> > > > > And thankfully the existing prop apply handler is checking only t=
he first
> > > > > several bytes for different algos, thus the existing code should =
handle the
> > > > > extra appended ":<level>" correctly by just ignoring the level.
> > > > >=20
> > > > > So either option 2 or 3 would be fine to me. Although I personall=
y prefer
> > > > > option 3 a little more, just because it's much cleaner code wise.
> > > >=20
> > > > Option 2 preserves legacy behavior that is 12 years old now, and it
> > > > costs a single comparison in two 'if' statements.
> > > >=20
> > > > Option 3 makes an already confusing situation worse--it makes the
> > > > underspecified behavior change depending on kernel version.
> > >=20
> > > One should never rely on something not documented in the first place.
> >=20
> > Option 3 prevents existing mount-option compression level specifications
> > from working when the attribute agress with the mount option; otherwise,
> > they would be blocked by a btrfs.compression string that doesn't specify
> > a level.  That's a _regression_.
>=20
> Let me be this clear, the current one nor option 2 is not working either.
>=20
> If the current algo is different from the XATTR algo, it will be whatever
> random number clamped to the XATTR algo for the current code.
>=20
> This applies to the option 2 solution. When mount option changed, the lev=
el
> will suddenly change from whatever previous mount option to the default.
>=20
> It's always broken no matter whatever, I do not want to waste time to use
> another broken behavior to mask a more broken one.

It's not broken during the time when the mount option is the same as
the xattr, and that case seems to be the most common one.  Users don't
change the compression type on the fly or per inode--they use zstd all
the time, and only change the level when it matters.

This stops working with the option 3 proposal (or more specifically, with
my comment on the other patch about when to set compress_level to 0):
it always sets the level to the default, and ignores the mount option,
even when that would make sense and be the intended result.

> > The current behavior is documented all over the place, used in scripts,
> > etc.  The top two from Google:
> >=20
> >      https://wiki.tnonline.net/w/Btrfs/Compression
> >      https://fedoraproject.org/wiki/Changes/BtrfsTransparentCompression=
#Q:_If_I_use_'btrfs_property'_to_set_compression,_what_level_is_used_for_zs=
td?
>=20
> None of them is the official btrfs-progs man page.
>=20
> The first URL doesn't even resolve here.
>=20
> I don't want to repeat myself, all those confusion is from the bug itself.
>=20
> Instead of building everything upon an uncertain basis, do it correctly.
>=20
> And I have repeated it several times, even the behavior change is minimal
> only affecting the level.
>=20
> I see no point why you treat broken behavior so dogmatically.

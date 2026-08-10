Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E750A12C534
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 02:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=174.142.148.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786327581; cv=none; b=o7hHWDfomMg1ApEpYnmh178dp6Kwlu8MJxqblgkPgFNAgvoeuy3n+YKSCn5jqaEr0C295QLxx3bh/39wZ/G/GCutrLIQDLp7iKpmQ5mOkmpDzfqC5EWhTO+TeDNkH4d1olX5jVOg7crWtKFNKSOFpc06tBGik9VQG8zAxkE0wVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786327581; c=relaxed/simple;
	bh=ko32tprWQqiYNtkPA5Oa7thzjZw57EDGrdGoasHYs/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fsAgxHxyvUKBP8xwNMkDrBOw93akZI3BEZNjCkLr9uvaPXRMLpz9Ky7kxy/6fGOax4eMWt0o8OzbIB9u8k6h1Sl07bvuxEZtVWhXmO3bYleLuvBoA5IWrsXKuI/+4jpMV/7fAxyDVCJWkQM4TqWE5j2wYk31HhmK0oQ8/O2TYQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org; spf=pass smtp.mailfrom=drax.hungrycats.org; arc=none smtp.client-ip=174.142.148.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=drax.hungrycats.org
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
	id F1AA01B1FD92; Sun, 09 Aug 2026 22:06:17 -0400 (EDT)
Date: Sun, 9 Aug 2026 22:06:17 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: koraynilay <koray.fra@gmail.com>, Qu Wenruo <wqu@suse.com>, clm@fb.com,
	dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
Message-ID: <ankyGTuFSRGVytJl@hungrycats.org>
References: <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
 <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
 <ankKjqr72aD8Ka8w@hungrycats.org>
 <95bab93b-f0c6-447d-8bfb-c81b3d48f7a7@suse.com>
 <ankbNtvLr3ZnFjEk@hungrycats.org>
 <9995da33-3f10-43b6-aec1-0e90eae03c7a@suse.com>
 <DKKUZT0LUJOI.RE9GG62MU6K3@gmail.com>
 <f4a10cb9-0237-4326-9356-3704939072a7@gmx.com>
 <DKKW2W8COGXT.3GZPRA6TKLCFV@gmail.com>
 <23eb77d0-d4f3-4d9f-ac53-8dbba575a8c5@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <23eb77d0-d4f3-4d9f-ac53-8dbba575a8c5@gmx.com>

On Mon, Aug 10, 2026 at 11:27:49AM +0930, Qu Wenruo wrote:
>=20
>=20
> =E5=9C=A8 2026/8/10 11:27, koraynilay =E5=86=99=E9=81=93:
> > On Mon Aug 10, 2026 at 3:54 AM CEST, Qu Wenruo wrote:
> > >=20
> > >=20
> > > =E5=9C=A8 2026/8/10 10:35, koraynilay =E5=86=99=E9=81=93:
> > > > On Mon Aug 10, 2026 at 2:51 AM CEST, Qu Wenruo wrote:
> > > > > > > > > So either option 2 or 3 would be fine to me. Although I p=
ersonally prefer
> > > > > > > > > option 3 a little more, just because it's much cleaner co=
de wise.
> > > > > > > >=20
> > > > > > > > Option 2 preserves legacy behavior that is 12 years old now=
, and it
> > > > > > > > costs a single comparison in two 'if' statements.
> > > > > > > >=20
> > > > > > > > Option 3 makes an already confusing situation worse--it mak=
es the
> > > > > > > > underspecified behavior change depending on kernel version.
> > > > > > >=20
> > > > > > > One should never rely on something not documented in the firs=
t place.
> > > > > >=20
> > > > > > Option 3 prevents existing mount-option compression level speci=
fications
> > > > > > from working when the attribute agress with the mount option; o=
therwise,
> > > > > > they would be blocked by a btrfs.compression string that doesn'=
t specify
> > > > > > a level.  That's a _regression_.
> > > > >=20
> > > > > Let me be this clear, the current one nor option 2 is not working=
 either.
> > > > >=20
> > > > > If the current algo is different from the XATTR algo, it will be
> > > > > whatever random number clamped to the XATTR algo for the current =
code.
> > > > >=20
> > > > > This applies to the option 2 solution. When mount option changed,=
 the
> > > > > level will suddenly change from whatever previous mount option to=
 the
> > > > > default.
> > > >=20
> > > > TBF, I can see how it could be useful (or rather, how it could be g=
ood
> > > > to have it as an option) to have some files with btrfs.compression=
=3D"zstd"
> > > > and then use -o compress=3D to decide on the fly how much compresse=
d the
> > > > new data added to them should be.
> > > > Both are (read: will be, after the per-inode patch) 1 command away,=
 but
> > > > there *might* be use-cases where mount is more suitable.
> > >=20
> > > To be honest, with the proper XATTR compression level specification, I
> > > think we should even deprecate compress=3D mount option, and make the
> > > XATTR one the only recommended way to specific compression.
> >=20
> > Ah, and in that case, to set compression on the whole fs use btrfs prop=
 to
> > set it on the root?
>=20
> Yep.

I am vehemently opposed to deprecation of a feature that will require
updating _billions_ of inodes per server to get the same effect, when
the filesystem was previously able to handle a 4-level hierarchy of
compression options with "defer to next level" since the beginning.

I will maintain a fork if I have to.  Hard NAK.

We can have clearer documentation about how options are processed,
and clearly what options mean "look up to the next level" vs "use the
default" or "use the locally defined value."

> > > There are already too many corner cases with mount option.
> > >=20
> > > IMHO, a good design should allow and only allow the best way to do a =
thing.
> > >=20
> > > And option 3 matches perfect for the XATTR only compression future. It
> > > still allows old XATTR to work, have a very sane default level, very
> > > explicit and clear independent from whatever stupid mount option there
> > > could be.
>=20
>=20
>=20

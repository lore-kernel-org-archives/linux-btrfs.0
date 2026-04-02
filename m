Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA0337BE67
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 18:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775153924; cv=none; b=UbRIGIppVcNh7APzAA47w4oaAWClQ7xlkhUveSTYUnOkc4zntgPmN3MvVWCVwPDLa1VpU9uuBexJoHJq56245FmOAj47dWiN5kgvIS2PimujyioJFOXTjppLxAcf5+sZmLpb12Tq+M9rmDikEKziIxjvwKoV8JSG7QBsJYkWyIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775153924; c=relaxed/simple;
	bh=cam9wbfebYQz41Hc61UTGlFOnv1y78X+9W94/X0lc+Q=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OyQZY0BQ3ahftnorLRvDSufw8L8rMgbb8/cpYaT6Qs75b+xAfqf9o6BPFf/Wloa0BR/n7RxBvngJn/jO+gy2ipnHn0rMxNEYvavI//1i8Vnxehv9sWOeTNS4BvNJtPhZ17UTfQLQ7NAuR9wgGSoRkbpeu/HwK0Xxq/CGS1LpYiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z2uDbIel; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z2uDbIel"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Transfer-Encoding
	:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description;
	bh=xwr91RgPbc3ggRWvHLxsd0Z1qvrRZiEbOxUGVJ0OdLc=; b=Z2uDbIelrr3Mq4upqAmVDEOUl+
	Fv7FwCwUroLMPbuKIxLOkzfdV2g3a4Ft9dlNhXOxvEfXz0Uj1Kikf8P8kXe7I3N3w0CESSdb/HeSJ
	9rBfMqfWA97VvNT8Oqx6DUom9E6D1VQtrijwehATn6nE2zr3AE15AP3QbcHBveQOdMvKDQ45txEd+
	/0XDzntMkFZpmpI+W4heZqpCd4HxDLL25LTeDEU9ukUWvidCd+pQIdOxLrLkhRq0NrDKHPhGe15Fa
	w0r6FQCQ069Ep4Om75nMT/5ZT8/sYC0KinXzkmOc3Vu83m1LfdPNgWn6GHFhKnrMYr7NbW8BCsZIJ
	5sxnt7RA==;
Received: from [84.233.216.247] (helo=[172.31.28.190])
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w8Mco-000000032Mu-3Dt6;
	Thu, 02 Apr 2026 18:18:38 +0000
Message-ID: <cc26312ada6ced3283bf36d249487ff7604604f9.camel@infradead.org>
Subject: Re: Fixing a corrupted file system
From: Amit Shah <amit@infradead.org>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Date: Thu, 02 Apr 2026 20:18:37 +0200
In-Reply-To: <fc202c52-cb3e-40b2-a80a-6ffda886f76b@suse.com>
References: <8c8e2466574b29ba1da29c325a108824c8373a85.camel@infradead.org>
	 <fc202c52-cb3e-40b2-a80a-6ffda886f76b@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello Qu,


On Thu, 2026-04-02 at 07:51 +1030, Qu Wenruo wrote:
>=20
>=20
> =E5=9C=A8 2026/4/2 02:28, Amit Shah =E5=86=99=E9=81=93:
> > Hello folks,
> >=20
> > I had a msata drive that started showing signs of failure - error
> > reading sectors.=C2=A0 I had a single LUKS partition on it (for
> > encryption)
> > with btrfs as the file system taking up the entire space (1 TB).
> >=20
> > I got all the raw data from the drive via ddrescue, and have dumped
> > it
> > into a second drive.=C2=A0 However, it looks like before I noticed the
> > disk
> > errors, btrfs tried correcting them based on the erroneous reads on
> > the
> > first disk, causing those errors to propagate on the recovered
> > copy:
>=20
> Nope, btrfs will only try extra mirrors, but in your case your
> metadata=20
> doesn't even have extra mirrors.
> Which is not common, as the default btrfs mkfs profiles will go DUP
> for=20
> metadata.

Hm, looks like the functionality for auto-enabling metadata DUP only
landed in 5.15, and perhaps my install was from before that?  I didn't
go out of my way to select non-default entries.

> So you only have one chance and lost that chance.

[...]

> > 1. Can I do anything to fix the metadata for this filesystem, and
> > have
> > it mount, recognize and recover the data on there?
>=20
> Not really. You only have one copy or metadata, and it's corrupted.
>=20
> It may be possible to repair, but it's definitely not reliable and I=20
> won't recommend to do it.
>=20
> All you can do is try to salvage the data, by mounting with=20
> "rescue=3Dall,ro" which should give you some chance to read out some
> data.

Oh this is very useful, thanks.  I tried btrfs-rescue as a separate
command and only could reach a handful files.  Using it as a mount
option does give me a more complete-looking directory tree. As
expected, a few files have errors reading them, but most of them do
open fine.

> > 2. Does it make sense to drop down the filesystem to read-only when
> > the
> > underlying drive starts exhibiting errors?
>=20
> For your case, it makes no difference.

Oh sure.  This isn't a question to fix anything for me now.  This is
just a way of throwing out a suggestion for a future feature - whether
something like that makes sense.

> Your metadata is only SINGLE, and that's your choice, so there is no=20
> repair anyway.
>=20
> Furthermore even with extra mirrors (e.g. DUP or RAID1), btrfs will
> only=20
> write the correct data/metadata into the bad one, thus it should not=20
> make things worse unless your hardware is totally screwed up.

Yea, that's understandable, of course.

Thanks a lot for the mount option hint, it has already helped me poke
around the file system.

		Amit

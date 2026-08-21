Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BF231A56C;
	Fri, 21 Aug 2026 14:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787320977; cv=none; b=u+i0V3uTLf/0jThmK37J2xBTh6YTffYtoBO0+HQhwHRriS3e85eKD9T3zIOEqvpn6eNYmPymnTYsaQ8ZY4mfJrxKKCYxQuJN56FQotmy8H2qYbe+mIk5QS/jjE5FqODdQZ9ZF604lQ+G9J8gMi/aizjbvJ1iQ7kZCuNc9ca9Zeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787320977; c=relaxed/simple;
	bh=/3018jtSnTtIszwd9uVS5rtJ0BbfnvnnX1NFdCxRef0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TgvAtaGmvsBsiGat5sd2hmp4aDGj0yDqQdFy9Bcmii6JImsRRy17JOyCawleczBZ50Zb8mUIQEz0wH40+se3pYPiD9ly3FXJASkbB71TJDaXKBTQ53GPPrIbfTvcLjzxzZw0LheSWWPcr03yTNbeS6DpJGRAcNk6kXn+gK0vR6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TeLDbemW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TeLDbemW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D7A1F000E9;
	Fri, 21 Aug 2026 14:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787320975;
	bh=nmPfDYsrTlElcB+KTOdxpPql90vP1LW3CNSG3IHySF4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=TeLDbemWAKW6HdAQi1+tEDQrpy5IYxnUYoH45ChEp48L1APnmGqIuNF/gyrR9Xq4+
	 eehl1hUyfFI0uOSR8jUuZoH0SU0pFhmAfCbuDa0+T/kg6fw2RtY0hFS0NidZyZTdf/
	 9r0OmmFxWAOzIXMgnnwo5Y++jiUVVN39MiJM8fUdZ1KM1k5IC0HXV3C4dsRvsREdb4
	 yOpbheTZ4u+b70wKf8f78jzXV0hYCSjWCrITNO2WxI35Y2oGuIQ4Pceu0P+0cjkYBk
	 C7SoYml9Xc1on3c0KzLov86VXCXCsZ3RaeHbr925e4AIT4QmuJL6E+kUmUicpATg1K
	 QEeFwuJEGO3aw==
Message-ID: <1c1f4228a7788abfc14b5f45493aa1f28bf0e356.camel@kernel.org>
Subject: Re: [PATCH v3 1/6] btrfs: use an on-stack path in
 btrfs_insert_orphan_item()
From: Jeff Layton <jlayton@kernel.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Qu Wenruo	
 <wqu@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@fb.com
Date: Fri, 21 Aug 2026 10:02:53 -0400
In-Reply-To: <4624cca9-6bca-4358-a29f-63f11224350a@gmx.com>
References: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
	 <20260811-btrfs-enomem-v3-1-46a993fc3fe5@kernel.org>
	 <20260820120428.GA9053@suse.cz>
	 <4624cca9-6bca-4358-a29f-63f11224350a@gmx.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-08-21 at 07:43 +0930, Qu Wenruo wrote:
>=20
> =E5=9C=A8 2026/8/20 21:34, David Sterba =E5=86=99=E9=81=93:
> > On Tue, Aug 11, 2026 at 02:14:54PM -0400, Jeff Layton wrote:
> > > btrfs_insert_orphan_item() allocated a btrfs_path with btrfs_alloc_pa=
th()
> > > which returns -ENOMEM on failure. It is called from btrfs_orphan_add(=
),
> > > so a path allocation failure there turns a recoverable error into a
> > > transaction abort.
> > >=20
> > > btrfs_path is only ~112 bytes, so allocate it on the stack instead.
> >=20
> > 112 is too much for on-stack, we've avoided that for btrfs_path in
> > particular, except some justified cases. This means in general the
> > beginning of call stack like ioctl, syscall handler and such. Otherwise
> > we assume there are other layers in the IO stack, like block device
> > drivers (DM), NFS, encoding layers or networking (iscsi), and obviously
> > the lowest level device drivers.
>=20
> I think you're very inconsistent on on-stack memory usage at least.
>=20
> You were fine when I was adding 128bytes for several call sites for the=
=20
> support of huge pages, and I'd argue all those call sites have a deeper=
=20
> stack, because it's on the writeback path.
>=20
> Furthermore, that huge page support is not widely used, but everyone=20
> will need to pay that on-stack price.
>=20
> On the other hand, you are also very hesitant on my recent patches=20
> removing those 128 bytes usages.
>=20
> So your behavior doesn't seem to match what you said here.
>=20
>=20
> Secondly, your deep-in-the-stack argument doesn't sound solid either.
>=20
> Every block file system can be built upon layer of storage stacks, not=
=20
> only btrfs, but *every* block fs as long as there is a chance to do IO.
> This means you're just saying, there can be almost-infinite lower layers=
=20
> under us, so we should not use any extra on-stack memory.
>=20
> I do not think this is the sane nor really validated.
>=20
> If you want to argue if the extra 112 bytes is good or not, give me some=
=20
> data about the on-stack memory usage.
> With the proof that with enough stacked dm layer, that extra 112 bytes=
=20
> are going to cause problem.
>=20
> Not to mention I believe some dm drivers are queuing the real submission=
=20
> handling into a workqueue, avoiding further increasing the on-stack=20
> memory usage.
>=20
> >=20
> > The trade off with possible allocation failure vs stack consumption
> > needs to be argued in the changelog, "is just 112" is not sufficient.
>=20
> Although I agree that more changelog will help, especially if Jeff has a=
=20
> good call trace showing that this is causing a flip RO in meta's fleet.
>=20
>=20

No. I don't have any evidence of btrfs_orphan_add() failing because of
-ENOMEM. I put those patches in because LLM review flagged it as a
potential issue, and Qu recommended that approach to fix it.

If we're content to leave that problem until we have evidence that it
is one, we can just drop patches 1 and 2. The later patches don't have
any dependencies on them.

Dave, would that resolve your concerns?

-ENOMEM abort analysis from the LLM for anyone interested:
---------------------------8<--------------------------

  btrfs_orphan_add aborts by errno:                                  =20
                                                                           =
                                      =20
  =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90                  =
                  =20
  =E2=94=82   errno    =E2=94=82 events =E2=94=82 hosts =E2=94=82          =
                          =20
  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4                  =
                  =20
  =E2=94=82 -5 EIO     =E2=94=82 131    =E2=94=82 127   =E2=94=82          =
                          =20
  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4                  =
                  =20
  =E2=94=82 -28 ENOSPC =E2=94=82 1      =E2=94=82 1     =E2=94=82          =
                          =20
  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4                  =
                  =20
  =E2=94=82 -12 ENOMEM =E2=94=82 0      =E2=94=82 0     =E2=94=82          =
                          =20
  =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98                  =
                  =20
  Same result with the cascade filter dropped (293 events / 270 hosts, all =
-5).                                  =20
                                                                           =
                                      =20
  Three controls make that a real negative rather than a query artifact:   =
                       =20

  1. ENOMEM aborts exist =E2=80=94 475 events / 471 hosts in the same windo=
w, so the query would find them.
  2. The signature is detectable and the code is live =E2=80=94 the identic=
al abort site in btrfs_orphan_add: fires for 270 hosts with -5. And btrfs_o=
rphan_add() passes ret straight to btrfs_abort_transaction() with no remapp=
ing, so a -12 would print as -12.                    =20
  3. The path is hot =E2=80=94 in the base tree btrfs_orphan_add() is calle=
d from btrfs_unlink() (nlink=E2=86=920), btrfs_rmdir(), btrfs_create_new_in=
ode() (O_TMPFILE), and btrfs_rename() (victim nlink=E2=86=920). That alloca=
tion runs on essentially every file deletion fleet-wide.                =
=20

Where the ENOMEM aborts actually are (hosts/30d): btrfs_rename 147, convert=
_free_space_to_extents 116, btrfs_add_link 67, convert_free_space_to_bitmap=
s 56, btrfs_replace_file_extents 42, btrfs_create_new_inode 16.

--=20
Jeff Layton <jlayton@kernel.org>

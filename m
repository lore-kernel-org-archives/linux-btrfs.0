Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3619E42B736
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2026 11:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787225317; cv=none; b=VN8LsCU70XMU0/6zn7yC7uhcl1/J/vSCpXZd31G+ISDaJ7MIpvSha22hTfWGOsKXgRCaquaKJ0fLG25CqovE5xFX4M5heTxoGqUYWD+gml0ttnnBAh/iOVT4OR9ikn17sPEgIyBEz8yp4NsoS3QVyTM3yO0C5mxFbHxP5b5A648=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787225317; c=relaxed/simple;
	bh=5ZBNfKM9E24BLOOvoh78znY9BmQX1/17kJjbHI19bbA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F+iV80RWaTjYDIOGO8jU+LJrM/aFd1CqVSUBBfaaHa14Gx7W2fpzOBPDN1b6eGQHLy/+brRJ9HJbgRIDSUwkNZ84OgQd6Bm5p2/b2lpbC5nNeDObZYY1n7ROTjeewVauhgz2EbHq4A4a3UwE1icIuxPyMHcgJoGqN/DQlKX9XKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z470777U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z470777U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8428F1F000E9;
	Thu, 20 Aug 2026 11:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787225314;
	bh=zcTN0Vm4uOkZ1i6d/mRxPcGF+1z0Or7LKBNhnYIFsjw=;
	h=Subject:From:To:Date:In-Reply-To:References;
	b=Z470777Uw/4wimdFzKVaCN/gP00XP3PXGDc1cXWVw0qYpnY2CSVlTM200/+MQs/gW
	 ltgpEJfviLa9+0fFn5iWoBJ0OjLHeracjCUn/Ub79fYp/TDLTtKEiLGeElZQOlLDC/
	 KpCeeptrRTTCu31frm+U8i507HiBlCjK9fqjUZPZYTQBKz+vQ5XnNWEs3dcWA1rlF9
	 Gm7UDWYO/khZ5w6qyusMM8bJXwzOmZpq4UDCose4eV/DkxtGVW4+KVlomY8D9QGMoP
	 cg2DXSJYXMZigK51n5g2QvI9V+gN4jzl/XQhS4qa70Mkycp16EIKfBZgEggtbE3wX7
	 8WCVDpwIIRqjg==
Message-ID: <db623f9dde2aa2979e39e84c457ee95e51a8a63a.camel@kernel.org>
Subject: Re: [PATCH v2] btrfs: properly cleanup replace_task when the
 replace failed to start
From: Jeff Layton <jlayton@kernel.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>, 
	linux-btrfs@vger.kernel.org
Date: Thu, 20 Aug 2026 07:28:32 -0400
In-Reply-To: <77d934f5-0dd0-4607-84f9-a95ddf052cf1@gmx.com>
References: 
	<8e4f535ac093c7085ab0641114e2f082788585f5.1786576348.git.wqu@suse.com>
	 <fdb9d5bb8a87126399f328717cd358351ed0f4cd.camel@kernel.org>
	 <77d934f5-0dd0-4607-84f9-a95ddf052cf1@gmx.com>
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

On Thu, 2026-08-20 at 07:44 +0930, Qu Wenruo wrote:
>=20
> =E5=9C=A8 2026/8/19 21:58, Jeff Layton =E5=86=99=E9=81=93:
> > Claude had some more comments on this one:
> >=20
> > This moves the dev_replace->replace_task assignment in
> > btrfs_dev_replace_start() below the replace_state switch, clears it whe=
n
> > btrfs_start_transaction() fails there, and clears it at the top of
> > btrfs_dev_replace_finishing() so every exit from that function drops it=
.
> >=20
> > > In the function btrfs_dev_replace_start(), we have several error path=
s
> > > that assigns replace_task without reverting it back to NULL.
> > >=20
> > > There are two involved error paths:
> > >=20
> > > - There is already a running dev-replace
> > >    Then replace_task is over-written to the current task.
> > >    This is the one with long running effect.
> > >=20
> > > - The btrfs_start_transaction() call failed
> > >    This is much harder to hit though.
> >=20
> > [ ... ]
> >=20
> > > Thankfully this bug is very hard to hit.
> > >=20
> > > As dev-replace is an exclusive operation, thus if there is already
> > > a running replace, a new one will be rejected early without reaching
> > > btrfs_dev_replace_start().
> > >=20
> > > The only remaining case is a suspended replace, which is much harder =
to
> > > hit, e.g. requiring async dev-replace conflicting with another exclus=
ive
> > > operation, then a new replace is started.
> >=20
> > Is "very hard to hit" still accurate now that btrfs_dev_replace_finishi=
ng()
> > is fixed too?
>=20
> That "very hard to hit" was for the old code before the fix, but indeed=
=20
> Claude found an extra path that cancel can always leave that stale=20
> replace_task.
>=20
>=20
> >=20
> > A plain "btrfs replace cancel" leaves replace_task set every time.
> > btrfs_dev_replace_cancel() calls btrfs_scrub_cancel() while replace_sta=
te is
> > BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED, so btrfs_scrub_dev() returns
> > -ECANCELED to btrfs_dev_replace_start(), which passes it straight into
> > btrfs_dev_replace_finishing():
> >=20
> > fs/btrfs/dev-replace.c:btrfs_dev_replace_start() {
> > 	...
> > 	ret =3D btrfs_scrub_dev(fs_info, src_device->devid, 0, ...);
> >=20
> > 	ret =3D btrfs_dev_replace_finishing(fs_info, ret);
> > 	...
> > }
> >=20
> > fs/btrfs/dev-replace.c:btrfs_dev_replace_finishing() {
> > 	...
> > 	} else {
> > 		if (scrub_ret !=3D -ECANCELED)
> > 			btrfs_err(fs_info, ...);
> > error:
> > 		up_write(&dev_replace->rwsem);
> > 		...
> > 		return scrub_ret;
> > 	}
> > 	...
> > }
> >=20
> > That exit never reaches the replace_task =3D NULL at the end of the fun=
ction,
> > so the ioctl returns to userspace with replace_task still pointing at t=
he
> > task that ran it.  Any scrub failure, not only -ECANCELED, lands there =
as
> > well.
> >=20
> > The subject line says "when the replace failed to start", which does no=
t
> > cover the cancel or scrub-error case either.  Could the subject and the
> > changelog describe those paths too?
> >=20
> > > diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> > > index 72cba7fed942..c5e67524b417 100644
> > > --- a/fs/btrfs/dev-replace.c
> > > +++ b/fs/btrfs/dev-replace.c
> >=20
> > [ ... ]
> >=20
> > > @@ -874,18 +875,20 @@ static int btrfs_dev_replace_finishing(struct b=
trfs_fs_info *fs_info,
> > >   	/* don't allow cancel or unmount to disturb the finishing procedur=
e */
> > >   	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
> > >=20
> > > -	down_read(&dev_replace->rwsem);
> > > +	down_write(&dev_replace->rwsem);
> > > +	dev_replace->replace_task =3D NULL;
> > > +
> > >   	/* was the operation canceled, or is it finished? */
> > >   	if (dev_replace->replace_state !=3D
> > >   	    BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED) {
> > > -		up_read(&dev_replace->rwsem);
> > > +		up_write(&dev_replace->rwsem);
> > >   		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
> > >   		return 0;
> > >   	}
> > >=20
> > >   	tgt_device =3D dev_replace->tgtdev;
> > >   	src_device =3D dev_replace->srcdev;
> > > -	up_read(&dev_replace->rwsem);
> > > +	up_write(&dev_replace->rwsem);
> >=20
> > Is clearing replace_task this early intentional?
>=20
> Yes.
>=20
> The real work of dev-replace has all finished.
> >=20
> > At this point replace_state is still BTRFS_IOCTL_DEV_REPLACE_STATE_STAR=
TED,
> > and btrfs_start_delalloc_roots() plus the btrfs_start_transaction() /
> > btrfs_commit_transaction() loop are still ahead.  For all of that windo=
w the
> > replace task goes back to taking the rwsem in btrfs_map_block():
> >=20
> > fs/btrfs/volumes.c:btrfs_map_block() {
> > 	...
> > 	if (dev_replace->replace_task !=3D current)
> > 		down_read(&dev_replace->rwsem);
> >=20
> > 	dev_replace_is_ongoing =3D btrfs_dev_replace_is_ongoing(dev_replace);
> > 	...
> > }
> >=20
> > which is the exemption 8cca35cb29f8 ("btrfs: don't take dev_replace rws=
em on
> > task already holding it") added.
> >=20
> > The down_write() further down already covers both the success exit and =
the
> > error: exit, so clearing replace_task next to the replace_state update =
there,
> > plus the three early returns, would leave the ongoing window unchanged.
>=20
> Alright, I guess the model you're using is digging deeper than opus.
>=20

Actually, this was Opus 5. I find that there is a fair amount of
randomness with these LLMs. Sometimes it just gets lucky!

> It looks like we should not reset replace_task until the replace_state=
=20
> is also updated.
>=20
> Or during the transaction commit, it will lead to the same problem.
>=20
> We rely on btrfs_dev_replace_is_ongoing() to return false to release=20
> rwsem early and avoid the deadlock.
>=20
> So the early reset leaves a window we can deadlock again.
>=20
> Will send an update to this patch.
>=20

Sounds good.

>=20
> >=20
> > The changelog says only:
> >=20
> > >    - Reset replace_task to NULL for all paths of
> > >      btrfs_dev_replace_finishing()
> >=20
> > Could it also mention that the read lock at the head of the function be=
comes
> > a write lock?
> >=20
> >=20
>=20

--=20
Jeff Layton <jlayton@kernel.org>

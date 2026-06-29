Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8093EAC90;
	Mon, 29 Jun 2026 14:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782744970; cv=none; b=qXKaroovqPZkVkfj9hWVr4v+WRl7o/Fs0ZrDyRM5wfcysvr9Z9cCbpxzBrBlhr40Hjegf2gzVw7nDA9EwDVU4spSe0MVLlb+iCHhS/IPb7ZtRRLAz1FybK3wiTydZHrZPRg4v8DEKjt4TLQKkiO0uPp1vbIh2BN8yAgb6g19ZEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782744970; c=relaxed/simple;
	bh=IMDYlYkmjNZwCd98Nzj9Zb+VjSJnlKtJVRbIJ+wWLtw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WIaPi4unLRRk6kSvYA1yPqHaKksCYaQl4reK4egsdRwOdkNxXdIpbQHpkBEG+YMjf9/JmLHI7HCwjfJvrXiYAswuKJd9q8EmcQTGKg4zh0c522eIAfI0A3WfkLXODf9un1YqZnsmO11/l8lAF0nH/IRm84/PF37MEBUxOPnDTwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KrgWKuuo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KrgWKuuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B691F00A3A;
	Mon, 29 Jun 2026 14:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744968;
	bh=pRNh9BtnZCGX1do1vvMu/LN6jH/9U5QYoFoUa0UEtf4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=KrgWKuuojMvGf7r51WDpTkcCVyrcOxmFR/LFWz/vhDp7z5bhd4j6pk/HFAbwmLsPb
	 D2PV860I19iBp/odh9UIqU6fYTG3b4feyh4qiouKOeI5iwZHQfYSAmuJ2hQ5dzfQo6
	 Mw92BMPzfdTVdpbvCz1OSE4sgTHmJo2pMzpPtqoV8Q1gzq3XwJRfeoHV2Wt/xnP9hB
	 9yixtVYZnEE6zhTVSkLmSjt6rUXWEyMaMt+EnObxyEPGwq3N5lZaOQ7dE8R0uuV79M
	 tGWWaOB62zKzx/vUIBFCR4xYDSQpaPV3+SrvgkPXJY7DBH7XfhVUQCogIyr0DK1zOU
	 R2iCXa7dBtH6w==
Message-ID: <5084d9c6b6a7025be156354194cf7d3fffebb0e2.camel@kernel.org>
Subject: Re: [PATCH] btrfs: don't let shrinker touch extent_maps that are
 being logged
From: Jeff Layton <jlayton@kernel.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Filipe Manana
	 <fdmanana@suse.com>, Josef Bacik <josef@toxicpanda.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Jun 2026 10:56:06 -0400
In-Reply-To: <CAL3q7H5o6vKOcQ0G4shQw6q7vCpfZYo8KO6Rg6VdChDoMB+C=g@mail.gmail.com>
References: <20260629-btrfs-skip-logging-v1-1-4e3a28c1acaf@kernel.org>
	 <CAL3q7H5o6vKOcQ0G4shQw6q7vCpfZYo8KO6Rg6VdChDoMB+C=g@mail.gmail.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=mQINBE6V0TwBEADXhJg7s8wFDwBMEvn0qyhAnzFLTOCHooMZyx7XO7dAiIhDSi7G1NPxw
 n8jdFUQMCR/GlpozMFlSFiZXiObE7sef9rTtM68ukUyZM4pJ9l0KjQNgDJ6Fr342Htkjxu/kFV1Wv
 egyjnSsFt7EGoDjdKqr1TS9syJYFjagYtvWk/UfHlW09X+jOh4vYtfX7iYSx/NfqV3W1D7EDi0PqV
 T2h6v8i8YqsATFPwO4nuiTmL6I40ZofxVd+9wdRI4Db8yUNA4ZSP2nqLcLtFjClYRBoJvRWvsv4lm
 0OX6MYPtv76hka8lW4mnRmZqqx3UtfHX/hF/zH24Gj7A6sYKYLCU3YrI2Ogiu7/ksKcl7goQjpvtV
 YrOOI5VGLHge0awt7bhMCTM9KAfPc+xL/ZxAMVWd3NCk5SamL2cE99UWgtvNOIYU8m6EjTLhsj8sn
 VluJH0/RcxEeFbnSaswVChNSGa7mXJrTR22lRL6ZPjdMgS2Km90haWPRc8Wolcz07Y2se0xpGVLEQ
 cDEsvv5IMmeMe1/qLZ6NaVkNuL3WOXvxaVT9USW1+/SGipO2IpKJjeDZfehlB/kpfF24+RrK+seQf
 CBYyUE8QJpvTZyfUHNYldXlrjO6n5MdOempLqWpfOmcGkwnyNRBR46g/jf8KnPRwXs509yAqDB6sE
 LZH+yWr9LQZEwARAQABtCVKZWZmIExheXRvbiA8amxheXRvbkBwb29jaGllcmVkcy5uZXQ+iQI7BB
 MBAgAlAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAUCTpXWPAIZAQAKCRAADmhBGVaCFc65D/4
 gBLNMHopQYgG/9RIM3kgFCCQV0pLv0hcg1cjr+bPI5f1PzJoOVi9s0wBDHwp8+vtHgYhM54yt43uI
 7Htij0RHFL5eFqoVT4TSfAg2qlvNemJEOY0e4daljjmZM7UtmpGs9NN0r9r50W82eb5Kw5bc/r0km
 R/arUS2st+ecRsCnwAOj6HiURwIgfDMHGPtSkoPpu3DDp/cjcYUg3HaOJuTjtGHFH963B+f+hyQ2B
 rQZBBE76ErgTDJ2Db9Ey0kw7VEZ4I2nnVUY9B5dE2pJFVO5HJBMp30fUGKvwaKqYCU2iAKxdmJXRI
 ONb7dSde8LqZahuunPDMZyMA5+mkQl7kpIpR6kVDIiqmxzRuPeiMP7O2FCUlS2DnJnRVrHmCljLkZ
 Wf7ZUA22wJpepBligemtSRSbqCyZ3B48zJ8g5B8xLEntPo/NknSJaYRvfEQqGxgk5kkNWMIMDkfQO
 lDSXZvoxqU9wFH/9jTv1/6p8dHeGM0BsbBLMqQaqnWiVt5mG92E1zkOW69LnoozE6Le+12DsNW7Rj
 iR5K+27MObjXEYIW7FIvNN/TQ6U1EOsdxwB8o//Yfc3p2QqPr5uS93SDDan5ehH59BnHpguTc27Xi
 QQZ9EGiieCUx6Zh2ze3X2UW9YNzE15uKwkkuEIj60NvQRmEDfweYfOfPVOueC+iFifbQgSmVmZiBM
 YXl0b24gPGpsYXl0b25AcmVkaGF0LmNvbT6JAjgEEwECACIFAk6V0q0CGwMGCwkIBwMCBhUIAgkKC
 wQWAgMBAh4BAheAAAoJEAAOaEEZVoIViKUQALpvsacTMWWOd7SlPFzIYy2/fjvKlfB/Xs4YdNcf9q
 LqF+lk2RBUHdR/dGwZpvw/OLmnZ8TryDo2zXVJNWEEUFNc7wQpl3i78r6UU/GUY/RQmOgPhs3epQC
 3PMJj4xFx+VuVcf/MXgDDdBUHaCTT793hyBeDbQuciARDJAW24Q1RCmjcwWIV/pgrlFa4lAXsmhoa
 c8UPc82Ijrs6ivlTweFf16VBc4nSLX5FB3ls7S5noRhm5/Zsd4PGPgIHgCZcPgkAnU1S/A/rSqf3F
 LpU+CbVBDvlVAnOq9gfNF+QiTlOHdZVIe4gEYAU3CUjbleywQqV02BKxPVM0C5/oVjMVx3bri75n1
 TkBYGmqAXy9usCkHIsG5CBHmphv9MHmqMZQVsxvCzfnI5IO1+7MoloeeW/lxuyd0pU88dZsV/riHw
 87i2GJUJtVlMl5IGBNFpqoNUoqmvRfEMeXhy/kUX4Xc03I1coZIgmwLmCSXwx9MaCPFzV/dOOrju2
 xjO+2sYyB5BNtxRqUEyXglpujFZqJxxau7E0eXoYgoY9gtFGsspzFkVNntamVXEWVVgzJJr/EWW0y
 +jNd54MfPRqH+eCGuqlnNLktSAVz1MvVRY1dxUltSlDZT7P2bUoMorIPu8p7ZCg9dyX1+9T6Muc5d
 Hxf/BBP/ir+3e8JTFQBFOiLNdFtB9KZWZmIExheXRvbiA8amxheXRvbkBzYW1iYS5vcmc+iQI4BBM
 BAgAiBQJOldK9AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRAADmhBGVaCFWgWD/0ZRi4h
 N9FK2BdQs9RwNnFZUr7JidAWfCrs37XrA/56olQl3ojn0fQtrP4DbTmCuh0SfMijB24psy1GnkPep
 naQ6VRf7Dxg/Y8muZELSOtsv2CKt3/02J1BBitrkkqmHyni5fLLYYg6fub0T/8Kwo1qGPdu1hx2BQ
 RERYtQ/S5d/T0cACdlzi6w8rs5f09hU9Tu4qV1JLKmBTgUWKN969HPRkxiojLQziHVyM/weR5Reu6
 FZVNuVBGqBD+sfk/c98VJHjsQhYJijcsmgMb1NohAzwrBKcSGKOWJToGEO/1RkIN8tqGnYNp2G+aR
 685D0chgTl1WzPRM6mFG1+n2b2RR95DxumKVpwBwdLPoCkI24JkeDJ7lXSe3uFWISstFGt0HL8Eew
 P8RuGC8s5h7Ct91HMNQTbjgA+Vi1foWUVXpEintAKgoywaIDlJfTZIl6Ew8ETN/7DLy8bXYgq0Xzh
 aKg3CnOUuGQV5/nl4OAX/3jocT5Cz/OtAiNYj5mLPeL5z2ZszjoCAH6caqsF2oLyAnLqRgDgR+wTQ
 T6gMhr2IRsl+cp8gPHBwQ4uZMb+X00c/Amm9VfviT+BI7B66cnC7Zv6Gvmtu2rEjWDGWPqUgccB7h
 dMKnKDthkA227/82tYoFiFMb/NwtgGrn5n2vwJyKN6SEoygGrNt0SI84y6hEVbQlSmVmZiBMYXl0b
 24gPGpsYXl0b25AcHJpbWFyeWRhdGEuY29tPokCOQQTAQIAIwUCU4xmKQIbAwcLCQgHAwIBBhUIAg
 kKCwQWAgMBAh4BAheAAAoJEAAOaEEZVoIV1H0P/j4OUTwFd7BBbpoSp695qb6HqCzWMuExsp8nZjr
 uymMaeZbGr3OWMNEXRI1FWNHMtcMHWLP/RaDqCJil28proO+PQ/yPhsr2QqJcW4nr91tBrv/MqItu
 AXLYlsgXqp4BxLP67bzRJ1Bd2x0bWXurpEXY//VBOLnODqThGEcL7jouwjmnRh9FTKZfBDpFRaEfD
 FOXIfAkMKBa/c9TQwRpx2DPsl3eFWVCNuNGKeGsirLqCxUg5kWTxEorROppz9oU4HPicL6rRH22Ce
 6nOAON2vHvhkUuO3GbffhrcsPD4DaYup4ic+DxWm+DaSSRJ+e1yJvwi6NmQ9P9UAuLG93S2MdNNbo
 sZ9P8k2mTOVKMc+GooI9Ve/vH8unwitwo7ORMVXhJeU6Q0X7zf3SjwDq2lBhn1DSuTsn2DbsNTiDv
 qrAaCvbsTsw+SZRwF85eG67eAwouYk+dnKmp1q57LDKMyzysij2oDKbcBlwB/TeX16p8+LxECv51a
 sjS9TInnipssssUDrHIvoTTXWcz7Y5wIngxDFwT8rPY3EggzLGfK5Zx2Q5S/N0FfmADmKknG/D8qG
 IcJE574D956tiUDKN4I+/g125ORR1v7bP+OIaayAvq17RP+qcAqkxc0x8iCYVCYDouDyNvWPGRhbL
 UO7mlBpjW9jK9e2fvZY9iw3QzIPGKtClKZWZmIExheXRvbiA8amVmZi5sYXl0b25AcHJpbWFyeWRh
 dGEuY29tPokCOQQTAQIAIwUCU4xmUAIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEAAOa
 EEZVoIVzJoQALFCS6n/FHQS+hIzHIb56JbokhK0AFqoLVzLKzrnaeXhE5isWcVg0eoV2oTScIwUSU
 apy94if69tnUo4Q7YNt8/6yFM6hwZAxFjOXR0ciGE3Q+Z1zi49Ox51yjGMQGxlakV9ep4sV/d5a50
 M+LFTmYSAFp6HY23JN9PkjVJC4PUv5DYRbOZ6Y1+TfXKBAewMVqtwT1Y+LPlfmI8dbbbuUX/kKZ5d
 dhV2736fgyfpslvJKYl0YifUOVy4D1G/oSycyHkJG78OvX4JKcf2kKzVvg7/Rnv+AueCfFQ6nGwPn
 0P91I7TEOC4XfZ6a1K3uTp4fPPs1Wn75X7K8lzJP/p8lme40uqwAyBjk+IA5VGd+CVRiyJTpGZwA0
 jwSYLyXboX+Dqm9pSYzmC9+/AE7lIgpWj+3iNisp1SWtHc4pdtQ5EU2SEz8yKvDbD0lNDbv4ljI7e
 flPsvN6vOrxz24mCliEco5DwhpaaSnzWnbAPXhQDWb/lUgs/JNk8dtwmvWnqCwRqElMLVisAbJmC0
 BhZ/Ab4sph3EaiZfdXKhiQqSGdK4La3OTJOJYZphPdGgnkvDV9Pl1QZ0ijXQrVIy3zd6VCNaKYq7B
 AKidn5g/2Q8oio9Tf4XfdZ9dtwcB+bwDJFgvvDYaZ5bI3ln4V3EyW5i2NfXazz/GA/I/ZtbsigCFc
 8ftCBKZWZmIExheXRvbiA8amxheXRvbkBrZXJuZWwub3JnPokCOAQTAQIAIgUCWe8u6AIbAwYLCQg
 HAwIGFQgCCQoLBBYCAwECHgECF4AACgkQAA5oQRlWghUuCg/+Lb/xGxZD2Q1oJVAE37uW308UpVSD
 2tAMJUvFTdDbfe3zKlPDTuVsyNsALBGclPLagJ5ZTP+Vp2irAN9uwBuacBOTtmOdz4ZN2tdvNgozz
 uxp4CHBDVzAslUi2idy+xpsp47DWPxYFIRP3M8QG/aNW052LaPc0cedYxp8+9eiVUNpxF4SiU4i9J
 DfX/sn9XcfoVZIxMpCRE750zvJvcCUz9HojsrMQ1NFc7MFT1z3MOW2/RlzPcog7xvR5ENPH19ojRD
 CHqumUHRry+RF0lH00clzX/W8OrQJZtoBPXv9ahka/Vp7kEulcBJr1cH5Wz/WprhsIM7U9pse1f1g
 Yy9YbXtWctUz8uvDR7shsQxAhX3qO7DilMtuGo1v97I/Kx4gXQ52syh/w6EBny71CZrOgD6kJwPVV
 AaM1LRC28muq91WCFhs/nzHozpbzcheyGtMUI2Ao4K6mnY+3zIuXPygZMFr9KXE6fF7HzKxKuZMJO
 aEZCiDOq0anx6FmOzs5E6Jqdpo/mtI8beK+BE7Va6ni7YrQlnT0i3vaTVMTiCThbqsB20VrbMjlhp
 f8lfK1XVNbRq/R7GZ9zHESlsa35ha60yd/j3pu5hT2xyy8krV8vGhHvnJ1XRMJBAB/UYb6FyC7S+m
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

On Mon, 2026-06-29 at 15:19 +0100, Filipe Manana wrote:
> On Mon, Jun 29, 2026 at 2:41=E2=80=AFPM Jeff Layton <jlayton@kernel.org> =
wrote:
> >=20
> > The extent map shrinker can free an extent map that is still owned by a=
n
> > in-flight fsync and still linked on the inode's modified_extents list,
> > corrupting that list and eventually causing an RCU stall.
> >=20
> > btrfs_scan_inode() currently skips EXTENT_FLAG_PINNED maps, then calls
> > btrfs_remove_extent_mapping() followed by btrfs_free_extent_map():
> >=20
> >         if (em->flags & EXTENT_FLAG_PINNED)
> >                 goto next;
> >         ...
> >         btrfs_remove_extent_mapping(inode, em);
> >         btrfs_free_extent_map(em);
> >=20
> > But btrfs_remove_extent_mapping() deliberately does NOT unlink a map th=
at
> > has EXTENT_FLAG_LOGGING set:
> >=20
> >         if (!(em->flags & EXTENT_FLAG_LOGGING))
> >                 list_del_init(&em->list);
> >         remove_em(inode, em);
> >=20
> > This sets up a UAF situation where a later fsync() can trip over the
> > now-freed extent_map still on the modified_extents() list.
>=20
> I don't see how that can happen, because fsync always takes the
> inode's i_mmap_lock (in write/exclusive mode), and btrfs_scan_inode()
> takes the same lock too (in shared/read mode).
> EXTENT_FLAG_LOGGING is only set and cleared during fsync, so how can
> the shrinker race with fsync?
>=20

...and yet, the vmcore shows that the shrinker hit an extent_map that
had LOGGING set while holding the i_mmap_lock.

I had hoped to add an assertion here that LOGGING couldn't be set on
the em's after taking the i_mmap_lock, but that's not viable:

The problem is that the i_mmap_lock coverage isn't complete. I had
Claude assist me with some analysis so take it with a hefty grain of
salt but the problem is that the em tree can contain em's from other
inodes where the i_mmap_lock is not held:

-----------------------8<---------------------

...that inode is in progress, therefore no em in its tree should have LOGGI=
NG set. Your invariant is the right one.

 But it's violated, because the i_mmap_lock interlock is incomplete. Two fa=
cts:                                                                       =
                                                                 =20
                                                                           =
                                                                           =
                                                                  =20
  1. tree-log.c never takes i_mmap_lock =E2=80=94 grep returns 0 occurrence=
s. Only btrfs_sync_file takes it (file.c:1608/1610), and only              =
                                                                          =
=20
  on the one inode being fsync'd.                                          =
                                                                           =
                                                                  =20
  2. A single fsync logs many other inodes, and each can set LOGGING on its=
 own ems via btrfs_log_changed_extents().                                  =
                                                                  =20
  btrfs_log_inode() is called recursively on conflicting inodes, parent dir=
ectories, and referenced inodes:                                           =
                                                                  =20
  tree-log.c:5982  btrfs_log_inode(di_inode, log_mode)        # dir dentrie=
s                                                                          =
                                                                  =20
  tree-log.c:6339  btrfs_log_inode(inode, LOG_INODE_ALL)      # conflicting=
 inodes                                                                    =
                                                                  =20
  tree-log.c:6900  btrfs_log_inode(di_inode, log_mode)        # new dir den=
tries                                                                      =
                                                                  =20
  tree-log.c:7389  btrfs_log_inode(dir_inode, LOG_INODE_ALL)  # log_all_par=
ents                                                                       =
                                                                  =20
  tree-log.c:7488  btrfs_log_inode(inode, ...)                # referenced =
inodes                                                                     =
                                                                  =20

  2. For all of these, btrfs_sync_file holds i_mmap_lock on the original fs=
ync'd inode =E2=80=94 not on these side inodes. So a side                  =
                                                                          =
=20
  inode X gets LOGGING set on its ems while X's own i_mmap_lock is free.   =
                                                                           =
                                                                  =20
                                                                           =
                                                                           =
                                                                  =20
  So the shrinker can down_read_trylock(X->i_mmap_lock) successfully (nobod=
y holds it) and walk X's tree while X's ems are                            =
                                                                  =20
  LOGGING-flagged =E2=86=92 it removes+frees one =E2=86=92 corruption. The =
interlock only protects the directly-fsync'd inode, not the inodes         =
                                                                           =
       =20
  logged as its dependencies.                                              =
                                                                           =
                                                                  =20


> Also, there should be no () after modified_extents (it's not a function n=
ame).
>=20
>=20

Sorry, early morning typo. Fixed in my local repo.

>=20
> >=20
> > Fix it by having the shrinker skip maps that are being logged, the same
> > way it skips pinned maps. Such a map is owned by the in-flight fsync an=
d
> > will become reclaimable again once logging clears the flag.
> >=20
> > Fixes: 956a17d9d050 ("btrfs: add a shrinker for extent maps")
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> > We've started hitting a number of these problems in our fleet. It
> > seems to mostly happen on ARM64 architecture, but there have been some
> > WARN_ONs that popped on x86_64 too.
> > ---
> >  fs/btrfs/extent_map.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> > index fce9c5cc0122..128f7800e101 100644
> > --- a/fs/btrfs/extent_map.c
> > +++ b/fs/btrfs/extent_map.c
> > @@ -1166,7 +1166,13 @@ static long btrfs_scan_inode(struct btrfs_inode =
*inode, struct btrfs_em_shrink_c
> >                 em =3D rb_entry(node, struct extent_map, rb_node);
> >                 ctx->scanned++;
> >=20
> > -               if (em->flags & EXTENT_FLAG_PINNED)
> > +               /*
> > +                * Skip extent maps that are pinned or are being logged=
. The
> > +                * i_mmap_lock should prevent this from seeing LOGGING =
on extent_maps
> > +                * directly associated with inode, but em may be associ=
ated with
> > +                * other, dependent inodes and their locks are not held=
.
> > +                */
> > +               if (em->flags & (EXTENT_FLAG_PINNED | EXTENT_FLAG_LOGGI=
NG))
> >                         goto next;
> >=20
> >                 /*
> >=20
> > ---
> > base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> > change-id: 20260629-btrfs-skip-logging-3e31701d9647
> >=20
> > Best regards,
> > --
> > Jeff Layton <jlayton@kernel.org>
> >=20
> >=20

--=20
Jeff Layton <jlayton@kernel.org>

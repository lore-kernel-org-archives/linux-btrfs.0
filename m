Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A333AE6E9
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 15:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769009056; cv=none; b=gxBFSFRn4SYOi54Ija/7LZm5tObadx7y2UPCRbjglEPVnDiThFqIPk7cm12g/xFyg8owCwnkq84RjltDcsWMhK4uA8A6LVz5X1zDZEMwI98IGzDQwFhmiXdXr2Vkqu1SXvcGQFhVccW0YJOkHuUnWaWixIT1sA1/4dmDmzOBL/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769009056; c=relaxed/simple;
	bh=lo5LFecirdREP+HDNbkI2hHsGF/+TwYasdb5p00LvEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cmrJ5/+xN/0oLmMUoPxm5Ac8MrKcPwgx5GTdEDJZyhdb4Nod4CQRFqOCZUwubGrh8LlxnJAICg4Zx5iQBRruYvhpsTDTYISj390YkJ+bWxKR6xHpU4Zmvmsk4YsPB4rB4INeYeZv/QKPmYSu1+KwoHg3gI+SQIOFP0b2fmSkuEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btasUmg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btasUmg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D529C116D0
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769009056;
	bh=lo5LFecirdREP+HDNbkI2hHsGF/+TwYasdb5p00LvEQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=btasUmg7yZWP8bBv+xn9yIh49BQSwODOdm2jx3rNC4AAIMAtX2jFbygqz5J0aA3sH
	 s+rGAGMuH5C9/yC0JDk11greHGGn+xId+sBzVBDqf5BpXOx0ASU2RJ2ApuWu62Tdgz
	 SGbtV4UgBeUTA+B7vgJ7MSBp6RDXkw985XZC/2AELt5z/IBel8GbHZTmJX0UXdR09c
	 NAAuPVx2gb8w4lHKlbJCxdRSBU82y2Wl+MhDuDkVoCK4sJbG1n6tAnwHpcMuXTelIF
	 2FImTydeA2zvPb+l5l2SylYY2ZTnGsdQe7RY+ali7mkOLwsSio5hnOXRegYkbPTvCJ
	 LUxGBrEAy7YBQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b87f00ec06aso474578366b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 07:24:16 -0800 (PST)
X-Gm-Message-State: AOJu0YyN1x16zfxN2ePiDQGuUbDqPuopMDBlV2b3Z+JKfyeTQoZVHeHD
	RVpQK+SllZLoW9zI6lMmH4cLqQggvtWnZPzdjYBYCdr2QAeo9qf6hqzEp1Dqj7GouUuRpsd+65O
	QA4ES9JBwUAMtqtSbkpg9K4mkOJbXudM=
X-Received: by 2002:a17:907:1c89:b0:b83:32b7:21b0 with SMTP id
 a640c23a62f3a-b8800260ffemr369665266b.17.1769009054826; Wed, 21 Jan 2026
 07:24:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1768993725.git.fdmanana@suse.com> <9684a687dd031bdc506fd15472be9356369a163c.1768993725.git.fdmanana@suse.com>
 <82b91a4e-095d-4a3e-bb66-a046f3d332f5@wdc.com>
In-Reply-To: <82b91a4e-095d-4a3e-bb66-a046f3d332f5@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 21 Jan 2026 15:23:37 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4fvdyKJbwN-FWM-2FHYKNFsUkX9dBdvLV2fJ_USTePrg@mail.gmail.com>
X-Gm-Features: AZwV_QjMbe234QlhN7bSbkKsWbUinkc4Zt4tctlXxoPR3IfpY8iSsQoBqXQYfGU
Message-ID: <CAL3q7H4fvdyKJbwN-FWM-2FHYKNFsUkX9dBdvLV2fJ_USTePrg@mail.gmail.com>
Subject: Re: [PATCH 03/19] btrfs: remove pointless out labels from send.c
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2026 at 3:04=E2=80=AFPM Johannes Thumshirn
<Johannes.Thumshirn@wdc.com> wrote:
>
> On 1/21/26 12:28 PM, fdmanana@kernel.org wrote:
> >       while (cur_offset < item_size) {
> > +             int ret;
> > +
> >               extref =3D (struct btrfs_inode_extref *)(ptr +
> >                                                      cur_offset);
> >               dirid =3D btrfs_inode_extref_parent(leaf, extref);
> > @@ -7130,8 +7123,7 @@ static int compare_refs(struct send_ctx *sctx, st=
ruct btrfs_path *path,
> >                       break;
> >               last_dirid =3D dirid;
> >       }
> > -out:
> > -     return ret;
> > +     return 0;
>
>
> Doesn't this omit the return from dir_changed?
>
>      while (cur_offset < item_size) {
>          extref =3D (struct btrfs_inode_extref *)(ptr +
>                                 cur_offset);
>          dirid =3D btrfs_inode_extref_parent(leaf, extref);
>          ref_name_len =3D btrfs_inode_extref_name_len(leaf, extref);
>          cur_offset +=3D ref_name_len + sizeof(*extref);
>          if (dirid =3D=3D last_dirid)
>              continue;
>          ret =3D dir_changed(sctx, dirid);
>          if (ret)
>              break;
>          last_dirid =3D dirid;
>      }
> out:
>      return ret;
>
> IIUIC we need to keep 'return ret' here.

The intention was really to return 0 and instead of break do return
ret, but I forgot that last part. Will fix in second version.

>

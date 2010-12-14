From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: do not loop through raid types when looking for free extent
Date: Mon, 13 Dec 2010 20:33:40 -0500
Message-ID: <1292290233-sup-3270@think>
References: <1289942524-29637-1-git-send-email-josef@redhat.com> <AANLkTikXh1di6qoN5EgCdbH+20ZCzSdOD8UcXja-Sn_c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Yan, Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTikXh1di6qoN5EgCdbH+20ZCzSdOD8UcXja-Sn_c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Yan, Zheng's message of 2010-11-16 20:38:23 -0500:
> On Wed, Nov 17, 2010 at 5:22 AM, Josef Bacik <josef@redhat.com> wrote=
:
> > There is a bug in find_free_extent where if we don't find a free ex=
tent in the
> > raid type we are looking for, we loop through to the next raid type=
=2E =C2=A0This is
> > not ok since we need to make sure we honor the raid types we are gi=
ven. =C2=A0So
> > instead kill this check and get the proper index for the raid type =
we want from
> > the allocator. =C2=A0Thanks,
> >
>=20
> Loop through raid types is for handling failure in the middle of raid=
 type
> conversion.

The problem is that nothing prevents it from looping back to a raid0
chunk when we really want raid1 or raid10.  And mkfs leaves behind a
small raid0 chunk (4MB) that is uses as it assembles all the devices.

I confirmed that we often use the small raid0 chunk even in raid1 or
raid10.

Please take a look at this commit:

http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-unstable.git;a=3D=
commit;h=3D83a50de97fe96aca82389e061862ed760ece2283

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

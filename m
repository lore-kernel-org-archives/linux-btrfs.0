From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: do not loop through raid types when looking for
	free extent
Date: Tue, 16 Nov 2010 21:31:39 -0500
Message-ID: <20101117023138.GC5618@dhcp231-156.rdu.redhat.com>
References: <1289942524-29637-1-git-send-email-josef@redhat.com> <AANLkTincj9E6z2fqrc_V5GPXHw+tjgdMa1Wc4-9q+=X8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTincj9E6z2fqrc_V5GPXHw+tjgdMa1Wc4-9q+=X8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 17, 2010 at 09:37:29AM +0800, Yan, Zheng  wrote:
> On Wed, Nov 17, 2010 at 5:22 AM, Josef Bacik <josef@redhat.com> wrote=
:
> > There is a bug in find_free_extent where if we don't find a free ex=
tent in the
> > raid type we are looking for, we loop through to the next raid type=
=2E =A0This is
> > not ok since we need to make sure we honor the raid types we are gi=
ven. =A0So
> > instead kill this check and get the proper index for the raid type =
we want from
> > the allocator. =A0Thanks,
> >
>=20
> Loop through raid types is for handling failure in the middle of raid=
 type
> conversion.
>

We need to figure out a different way to deal with it then, at the mome=
nt we
have users getting all of the different raid types across their disks b=
ecause
it's really easy to exit out of the main loop without an allocation, fo=
r example
when doing the ideal caching stuff, we just look for the best block gro=
up to
cache before even trying to make an allocation, so doing that loop will
automatically make us change the raid type from what we asked for.  Or =
in the
case that the hint doesn't actually point at a compatible block group w=
e'll get
the first index, and if thats metadata we'll end up not using DUP if th=
ats the
allocation policy.

We can deal with raid type conversion later, as it stands this stuff is=
 broken.
Thanks,

Josef=20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

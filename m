From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: allow us to overcommit our enospc reservations
 TEST THIS PLEASE!!!
Date: Tue, 11 Oct 2011 13:43:17 -0400
Message-ID: <20111011174316.GE2293@localhost.localdomain>
References: <1317072155-26792-1-git-send-email-josef@redhat.com>
 <CAKcLGm_oFQOCCeFs69ohGfskkCj1FSbdxL18653ANoTX75n4SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm_oFQOCCeFs69ohGfskkCj1FSbdxL18653ANoTX75n4SQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2011 at 12:33:48PM -0500, Mitch Harder wrote:
> On Mon, Sep 26, 2011 at 4:22 PM, Josef Bacik <josef@redhat.com> wrote=
:
> >
> > go from taking around 45 minutes to 10 seconds on my freshly format=
ted 3 TiB
> > file system. =A0This doesn't seem to break my other enospc tests, b=
ut could really
> > use some more testing as this is a super scary change. =A0Thanks,
> >
>=20
> I've been testing Josef's git.kernel.org testing tree, and I've
> bisected an error down to this commit.
>=20
> I'm triggering the error using a removedirs benchmark in filebench
> with the following profile:
> load removedirs
> set $dir=3D/mnt/benchmark/filebench
> set $ndirs=3D400000
> run
>=20

Ouch.  Does your pull have this patch

Btrfs: wait for ordered extents if we didn't reclaim enough

If not can you repull and retry your test?  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

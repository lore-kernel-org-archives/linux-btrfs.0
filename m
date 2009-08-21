From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch] btrfs: fix inode rbtree corruption
Date: Fri, 21 Aug 2009 08:20:16 +0200
Message-ID: <20090821062015.GS12579@kernel.dk>
References: <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com> <20090818211910.GR12579@kernel.dk> <20090819084530.GD25721@wotan.suse.de> <20090819084658.GT12579@kernel.dk> <20090819085208.GF25721@wotan.suse.de> <20090819085906.GV12579@kernel.dk> <20090820132346.GN25721@wotan.suse.de> <3d0408630908200651i4bfbf0ebk6b18975e1a06da7e@mail.gmail.com> <20090820220736.GQ12579@kernel.dk> <3d0408630908201755x6f59dabay7011775954874d44@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Nick Piggin <npiggin@suse.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630908201755x6f59dabay7011775954874d44@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 21 2009, Yan, Zheng  wrote:
> 2009/8/21 Jens Axboe <jens.axboe@oracle.com>:
> > On Thu, Aug 20 2009, Yan, Zheng =A0wrote:
> >> 2009/8/20 Nick Piggin <npiggin@suse.de>:
> >> > On Wed, Aug 19, 2009 at 10:59:07AM +0200, Jens Axboe wrote:
> >> >> On Wed, Aug 19 2009, Nick Piggin wrote:
> >> >> > On Wed, Aug 19, 2009 at 10:46:59AM +0200, Jens Axboe wrote:
> >> >> > > On Wed, Aug 19 2009, Nick Piggin wrote:
> >> >> > > > See my other reply. It *can* work with key aliases, but t=
his particular
> >> >> > > > code does not.
> >> >> > > >
> >> >> > > > It is pretty easy obviously to put in duplicates because =
the rbtree
> >> >> > > > code doesn't know about keys, but if we do this then it l=
ooks like
> >> >> > > > it might cause the search code to miss some valid inodes =
and instead
> >> >> > > > return freeing inodes -- so you'd also have to look at th=
at and update
> >> >> > > > it which is why I didn't go down this route..
> >> >> > >
> >> >> > > Mine was just a generic statement, I didn't read the btrfs =
code (hence
> >> >> > > my comment about potential lookup bug, if you allow aliases=
 you have to
> >> >> > > be careful).
> >> >> >
> >> >> > Ah ok. Well yeah in this case btrfs is definitely wrong in th=
e way it
> >> >> > tried to insert aliases.
> >> >>
> >> >> I looked at the actual problem now and I agree, it cannot work =
that way.
> >> >> I don't know if Linus is planning another -rc, we should probab=
ly get
> >> >> this upstream sooner rather than later. Chris is away this week=
, so if
> >> >> we can get Yan to agree on this patch as well, I'll submit it.
> >> > I think the first patch I submitted was agreed?
> >> >
> >>
> >> Of course, thank you.
> > Yan, are you sending this upstream?
>=20
> No.  Jens, please submit it. Thanks

Will do. Can I add your acked-by?

--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

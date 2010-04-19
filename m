From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 02/12] Btrfs: Kill allocate_wait in space_info
Date: Mon, 19 Apr 2010 10:48:43 -0400
Message-ID: <20100419144843.GC2352@localhost.localdomain>
References: <4BCC3458.5030600@oracle.com> <20100419135713.GA2352@localhost.localdomain> <s2o3d0408631004190746wcc55e7bdp572e9cce8a36fcd6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: "Yan, Zheng" <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <s2o3d0408631004190746wcc55e7bdp572e9cce8a36fcd6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 19, 2010 at 10:46:12PM +0800, Yan, Zheng wrote:
> On Mon, Apr 19, 2010 at 9:57 PM, Josef Bacik <josef@redhat.com> wrote=
:
> > The purpose of maybe_allocate_chunk was that there is no way to kno=
w if some
> > other CPU is currently trying to allocate a chunk for the given spa=
ce info. =A0We
> > could have two cpu's come inot do_chunk_alloc at relatively the sam=
e time and
> > end up allocating twice the amount of space, which is why I did the=
 waitqueue
> > thing. =A0It seems like this is still a possibility with your patch=
=2E =A0Thanks,
> >
> This is impossible because the very first thing do_chunk_alloc does i=
s
> lock the chunk_mutex.
>=20

Sure, that just means we don't get two things creating chunks at the sa=
me time,
but not from creating them one right after another.  So CPU 0 and 1 com=
e in to
the check free space stuff, realize they need to allocate a chunk, and =
race to
call do_chunk_alloc.  One of them wins, and the other blocks on the chu=
nk_mutex
lock.  When the first finishes the other one is able to continue and do=
 what it
was originally going to do, and then you get two chunks when you really=
 only
wanted one.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

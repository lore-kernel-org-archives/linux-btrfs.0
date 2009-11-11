From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BUG? a possible race due to the absence of memory barrier
Date: Wed, 11 Nov 2009 11:06:43 -0500
Message-ID: <20091111160643.GF5566@think>
References: <2014bcab0911110707i3f2e8782i772603a9b899e353@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: =?utf-8?B?7ZmN7Iug?= shin hong <hongshin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2014bcab0911110707i3f2e8782i772603a9b899e353@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2009 at 12:07:05AM +0900, =ED=99=8D=EC=8B=A0 shin hong =
wrote:
> Hello. I am reporting possible data race
> due to the the absence of memory barriers.
>=20
> I reported a similar issue. Although the previous one turns out to be=
 safe,
> please examine this issue and let me know your opinion.
>=20
> In btrfs_init_new_device(), a btrfs_device object is allocated and in=
itialized
> and then links to &root->fs_info->fs_devcies->alloc_list.
>=20
> It seems that a memory barrier is necessary
> between the initialization and the linking to the list.
>=20
> If these two operations are re-ordered so that executed opposite orde=
rs,
> it may result data race where uninitialized values are read by other =
threads.
>=20
> For btrfs_init_new_device(), i think __btfs_alloc_chunk() is a suspec=
ted
> to be possible to contribute data race by concurrent execution.

Thanks for searching for races in this code, it definitely has a lot of
locks to go through.

In this case, btrfs_init_new_device has the chunk mutex held (from
lock_chunks), and __btrfs_alloc_chunk should always be called by with
the chunk mutex held as well.

In general the btrfs locking tries not to rely on barriers and ordering
unless a given area of the code is very performance sensitive.  It's
very easy for subtle bugs to creep in with barriers only, so I try to
use mutexes and spinlocks everywhere that I can get away with it.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

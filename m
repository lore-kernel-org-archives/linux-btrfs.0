From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BUG? a possible bug for the absence of memory barrier
Date: Thu, 10 Sep 2009 16:38:53 -0400
Message-ID: <20090910203853.GB18366@think>
References: <2014bcab0909090815jf4929efib21cbf52b963e330@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: =?utf-8?B?7ZmN7Iug?= shin hong <hongshin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2014bcab0909090815jf4929efib21cbf52b963e330@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 10, 2009 at 12:15:24AM +0900, =ED=99=8D=EC=8B=A0 shin hong =
wrote:
> Hello. I am reporting possible bugs caused
> by the absence of memory barriers.
>=20
> Please examine this issue and let me know your opinion.
>=20
> In add_async_extent(), an async_extent object is allocated and initia=
lized
> and then links to &cow->extents.

Memory barriers have an impact when there are multiple CPUs accessing
the same data structures at the same time.  In the case of
add_async_extent only one worker thread is working on that list at a
time.

>=20
> However, since there is no memory barrier
> between the initialization and the linking to the list,
> these two operations are executed opposite order.
> And the re-ordering might result race condition.
>=20
> The similar issue is also in join_transaction().

In join_transaction, that list is protected by the trans_mutex.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

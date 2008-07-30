From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] implement memory reclaim for leaf reference cache
Date: Wed, 30 Jul 2008 14:14:34 -0400
Message-ID: <1217441674.20239.16.camel@think.oraclecorp.com>
References: <3d0408630807300852q28b12252g3230cc136c075ce3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630807300852q28b12252g3230cc136c075ce3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-07-30 at 23:52 +0800, Yan Zheng wrote:
> Hello,
>=20
> The memory reclaiming issue happens when snapshot exists. In that
> case, some cache entries may not be used during old snapshot dropping=
,
> so they will remain in the cache until umount. The patch adds a field
> to struct btrfs_leaf_ref to record create time. Besides, the patch
> makes all dead roots of a given snapshot linked together in order of
> create time. After a old snapshot was completely dropped, we check th=
e
> dead root list and remove all cache entries created before the oldest
> dead root in the list.
>=20

Hi Yan,

I think this is missing some hunks, it isn't compiling quite right:

/local/btree/extent-tree.c:1051: warning: passing argument 1 of
=E2=80=98btrfs_alloc_leaf_ref=E2=80=99 makes pointer from integer witho=
ut a cast
/local/btree/extent-tree.c:1051: error: too few arguments to function
=E2=80=98btrfs_alloc_leaf_ref=E2=80=99

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

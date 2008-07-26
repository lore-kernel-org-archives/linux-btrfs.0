From: "Yan Zheng" <zheng.yan@oracle.com>
Subject: Re: [PATCH] initial version of reference cache
Date: Sat, 26 Jul 2008 22:26:09 +0800
Message-ID: <3d0408630807260726h4303fff3k38ecf67c27efcce8@mail.gmail.com>
References: <21782573.1217014155193.JavaMail.oracle@acsmt304.oracle.com>
	 <1217029117.7572.84.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1217029117.7572.84.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/7/26 Chris Mason <chris.mason@oracle.com>:
> I have modified this locally to always cache leaves, even when they
> don't have file extents in them.  That way, walk_down_tree will find the
> cache and won't have to read the leaf (that doesn't have any extents).
>
> So far, it is working very well.  I did a run with fs_mark to create 58
> million files and had very steady numbers.  The unmount took 4 seconds.
> It used to take over an hour.
>
> One question, why not use the block number (byte number) as the key to
> the rbtree instead of the key?
>

When dropping old snapshots, tree leaves are processed in ascending
order of btrfs_key. After a given tree leaf is processed, we remove
the corresponding cache entry and update tree->last to point to next
entry in the tree. Therefore btrfs_lookup_leaf_ref can find the wanted
entry in tree->last in most cases.

Regards
YZ

From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [RFC] Tree fragmentation and prefetching
Date: Wed, 23 Mar 2011 22:26:50 +0300
Message-ID: <AANLkTinFUE0ALLABD0cirkMMAXrmz=m8juz+xEL8UBFJ@mail.gmail.com>
References: <4D89F03A.9050306@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D89F03A.9050306@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2011 at 4:06 PM, Arne Jansen <sensille@gmx.net> wrote:
> While looking into the performance of scrub I noticed that a signific=
ant
> amount of time is being used for loading the extent tree and the csum
> tree. While this is no surprise I did some prototyping on how to impr=
ove
> on it.
> The main idea is to load the tree (or parts of it) top-down, order th=
e
> needed blocks and distribute it over all disks.
> To keep you interested, some results first.
>
> a) by tree enumeration with reada=3D2
> =C2=A0 reading extent tree: 242s
> =C2=A0 reading csum tree: 140s
> =C2=A0 reading both trees: 324s
>
> b) prefetch prototype
> =C2=A0 reading extent tree: 23.5s
> =C2=A0 reading csum tree: 20.4s
> =C2=A0 reading both trees: 25.7s

10x speed-up looks indeed impressive. Just for me to be sure, did I
get you right in that you attribute this effect specifically to
enumerating tree leaves in key address vs. disk addresses when these
two are not aligned?

Regards,
Andrey

>
> The test setup consists of a 7 Seagate ES.2 1TB disks filesystem, fil=
led
> 28%. It is created with the current git tree + the round robin patch =
and
> filled with
>
> fs_mark -D 512 -t 16 -n 4096 -F -S0
>
> The 'normal' read is done by enumerating the leaves by btrfs_next_lea=
f()
> with path->reada=3D2. Both trees are being enumerated one after the o=
ther.
> The prototype currently just uses raw bios, does not make use of the
> page cache and does not enter the read pages into the cache. This wil=
l
> probably add some overhead. It also does not check the crcs.
>
> While it is very promising to implement it for scrub, I think a more
> general interface which can be used for every enumeration would be
> beneficial. Use cases that come to mind are rebalance, reflink, delet=
ion
> of large files, listing of large directories etc..
>
> I'd imagine an interface along the lines of
>
> int btrfs_readahead_init(struct btrfs_reada_ctx *reada);
> int btrfs_readahead_add(struct btrfs_root *root,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0struct btrfs_key *start,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0struct btrfs_key *end,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0struct btrfs_reada_ctx *reada);
> void btrfs_readahead_wait(struct btrfs_reada_ctx *reada);
>
> to trigger the readahead of parts of a tree. Multiple readahead
> requests can be given before waiting. This would enable the very
> beneficial folding seen above for 'reading both trees'.
>
> Also it would be possible to add a cascading readahead, where the
> content of leaves would trigger readaheads in other trees, maybe by
> giving a callback for the decisions what to read instead of the fixed
> start/end range.
>
> For the implementation I'd need an interface which I haven't been abl=
e
> to find yet. Currently I can trigger the read of several pages / tree
> blocks and wait for the completion of each of them. What I'd need wou=
ld
> be an interface that gives me a callback on each completion or a wait=
ing
> function that wakes up on each completion with the information which
> pages just completed.
> One way to achieve this would be to add a hook, but I gladly take any
> implementation hints.
>
> --
> Arne
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

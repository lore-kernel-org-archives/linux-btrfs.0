From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] btrfs: fix inode rbtree corruption
Date: Wed, 19 Aug 2009 11:04:36 +0200
Message-ID: <20090819090436.GG25721@wotan.suse.de>
References: <20090818164542.GB30325@wotan.suse.de> <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com> <20090818211910.GR12579@kernel.dk> <20090819084530.GD25721@wotan.suse.de> <3d0408630908190156r60931de3w637a9e8a4d5f44c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630908190156r60931de3w637a9e8a4d5f44c1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19, 2009 at 04:56:12PM +0800, Yan, Zheng  wrote:
> 2009/8/19 Nick Piggin <npiggin@suse.de>:
> > On Tue, Aug 18, 2009 at 11:19:10PM +0200, Jens Axboe wrote:
> >> On Wed, Aug 19 2009, Yan, Zheng =A0wrote:
> >> > 2009/8/19 Nick Piggin <npiggin@suse.de>:
> >> It can work with key aliases, if it's a problem then it's likely d=
ue to
> >> another problem in related lookup code.
> > See my other reply. It *can* work with key aliases, but this partic=
ular
> > code does not.
> > It is pretty easy obviously to put in duplicates because the rbtree
> > code doesn't know about keys, but if we do this then it looks like
> > it might cause the search code to miss some valid inodes and instea=
d
> > return freeing inodes -- so you'd also have to look at that and upd=
ate
> > it which is why I didn't go down this route..
>=20
> There is no search code. The only place uses the inode tree is
> the relocation code, it traverses the tree and uses igrab to guarante=
e
> freeing inodes are not touched. I'm still confused :(

=46irstly, the insert/delete code is wrong for duplicates and it will c=
rash in
the absense of any search activity. Agree?

Secondly, OK now if we did allow duplicates in the tree as-per my last
patch to Jens, then look what happens with igrab: it will correctly
prevent us from getting a freeing inode, but then it will set the next
inode to search at ino+1 -- ie. it will not correctly traverse duplicat=
es
without modifications. Agree?

So with that in mind -- the fact that you don't want to see freeing
inodes in your search code, then there is no point to handle duplicates
at all; simply remove freeing inodes from the tree.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

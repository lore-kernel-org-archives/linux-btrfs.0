From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [patch] btrfs: fix inode rbtree corruption
Date: Wed, 19 Aug 2009 16:56:12 +0800
Message-ID: <3d0408630908190156r60931de3w637a9e8a4d5f44c1@mail.gmail.com>
References: <20090818164542.GB30325@wotan.suse.de>
	 <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com>
	 <20090818211910.GR12579@kernel.dk>
	 <20090819084530.GD25721@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090819084530.GD25721@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

2009/8/19 Nick Piggin <npiggin@suse.de>:
> On Tue, Aug 18, 2009 at 11:19:10PM +0200, Jens Axboe wrote:
>> On Wed, Aug 19 2009, Yan, Zheng =A0wrote:
>> > 2009/8/19 Nick Piggin <npiggin@suse.de>:
>> > > Hi,
>> > >
>> > > Ran into a problem stress testing my btrfs truncate conversion a=
ttempt...
>> > > Unfortunately it was an existing btrfs problem. Fortunately I th=
ink I
>> > > was able to fix it.
>> > >
>> > > Thanks,
>> > > Nick
>> > >
>> > > --
>> > > btrfs: fix inode rbtree corruption
>> > >
>> > > Node may not be inserted over existing node. This causes inode t=
ree
>> > > corruption and I was seeing crashes in inode_tree_del which I ca=
n not
>> > > reproduce after this patch.
>> > >
>> > > The other way to fix this would be to tie inode lifetime in the =
rbtree
>> > > with inode while not in freeing state. I had a look at this but =
it is
>> > > not so trivial at this point. At least this patch gets things wo=
rking again.
>> > >
>> >
>> > I'm not quite understand this. rbtree allows entries having the sa=
me keys.
>> > I guess your problem is because of some nodes get inserted into th=
e tree
>> > twice. But I have no idea how can it happen.
>>
>> It can work with key aliases, if it's a problem then it's likely due=
 to
>> another problem in related lookup code.
> See my other reply. It *can* work with key aliases, but this particul=
ar
> code does not.
> It is pretty easy obviously to put in duplicates because the rbtree
> code doesn't know about keys, but if we do this then it looks like
> it might cause the search code to miss some valid inodes and instead
> return freeing inodes -- so you'd also have to look at that and updat=
e
> it which is why I didn't go down this route..

There is no search code. The only place uses the inode tree is
the relocation code, it traverses the tree and uses igrab to guarantee
freeing inodes are not touched. I'm still confused :(

Regards
Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

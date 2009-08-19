From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [patch] btrfs: fix inode rbtree corruption
Date: Wed, 19 Aug 2009 17:34:08 +0800
Message-ID: <3d0408630908190234m1effa947yef5b014e21c25fae@mail.gmail.com>
References: <20090818164542.GB30325@wotan.suse.de>
	 <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com>
	 <20090818211910.GR12579@kernel.dk>
	 <20090819084530.GD25721@wotan.suse.de>
	 <3d0408630908190156r60931de3w637a9e8a4d5f44c1@mail.gmail.com>
	 <20090819090436.GG25721@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090819090436.GG25721@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

2009/8/19 Nick Piggin <npiggin@suse.de>:
> On Wed, Aug 19, 2009 at 04:56:12PM +0800, Yan, Zheng =A0wrote:
>> 2009/8/19 Nick Piggin <npiggin@suse.de>:
>> > On Tue, Aug 18, 2009 at 11:19:10PM +0200, Jens Axboe wrote:
>> >> On Wed, Aug 19 2009, Yan, Zheng =A0wrote:
>> >> > 2009/8/19 Nick Piggin <npiggin@suse.de>:
>> >> It can work with key aliases, if it's a problem then it's likely =
due to
>> >> another problem in related lookup code.
>> > See my other reply. It *can* work with key aliases, but this parti=
cular
>> > code does not.
>> > It is pretty easy obviously to put in duplicates because the rbtre=
e
>> > code doesn't know about keys, but if we do this then it looks like
>> > it might cause the search code to miss some valid inodes and inste=
ad
>> > return freeing inodes -- so you'd also have to look at that and up=
date
>> > it which is why I didn't go down this route..
>>
>> There is no search code. The only place uses the inode tree is
>> the relocation code, it traverses the tree and uses igrab to guarant=
ee
>> freeing inodes are not touched. I'm still confused :(
> Firstly, the insert/delete code is wrong for duplicates and it will c=
rash in
> the absense of any search activity. Agree?
> Secondly, OK now if we did allow duplicates in the tree as-per my las=
t
> patch to Jens, then look what happens with igrab: it will correctly
> prevent us from getting a freeing inode, but then it will set the nex=
t
> inode to search at ino+1 -- ie. it will not correctly traverse duplic=
ates
> without modifications. Agree?
> So with that in mind -- the fact that you don't want to see freeing
> inodes in your search code, then there is no point to handle duplicat=
es
> at all; simply remove freeing inodes from the tree.
>

I agree all of this. Thing confuses me is you saw crashes in
inode_tree_del.  It's unlikely you were playing btrfsctl -b when you
encountered the problem. So no search code got involved, only
inode_tree_add/del modified the tree. I don't think the crash was
caused by duplicates in the tree.

I have no objection to take this patch.

Regards
Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

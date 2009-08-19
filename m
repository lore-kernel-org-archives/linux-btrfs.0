From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [patch] btrfs: fix inode rbtree corruption
Date: Wed, 19 Aug 2009 20:00:27 +0800
Message-ID: <3d0408630908190500i41722fccoe3691b9e2b1d8337@mail.gmail.com>
References: <20090818164542.GB30325@wotan.suse.de>
	 <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com>
	 <20090818211910.GR12579@kernel.dk>
	 <20090819084530.GD25721@wotan.suse.de>
	 <3d0408630908190156r60931de3w637a9e8a4d5f44c1@mail.gmail.com>
	 <20090819090436.GG25721@wotan.suse.de>
	 <3d0408630908190234m1effa947yef5b014e21c25fae@mail.gmail.com>
	 <20090819104732.GH25721@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090819104732.GH25721@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

2009/8/19 Nick Piggin <npiggin@suse.de>:
> On Wed, Aug 19, 2009 at 05:34:08PM +0800, Yan, Zheng =A0wrote:
>> 2009/8/19 Nick Piggin <npiggin@suse.de>:
>> > On Wed, Aug 19, 2009 at 04:56:12PM +0800, Yan, Zheng =A0wrote:
>> > Firstly, the insert/delete code is wrong for duplicates and it wil=
l crash in
>> > the absense of any search activity. Agree?
>> > Secondly, OK now if we did allow duplicates in the tree as-per my =
last
>> > patch to Jens, then look what happens with igrab: it will correctl=
y
>> > prevent us from getting a freeing inode, but then it will set the =
next
>> > inode to search at ino+1 -- ie. it will not correctly traverse dup=
licates
>> > without modifications. Agree?
>> > So with that in mind -- the fact that you don't want to see freein=
g
>> > inodes in your search code, then there is no point to handle dupli=
cates
>> > at all; simply remove freeing inodes from the tree.
>> >
>>
>> I agree all of this. Thing confuses me is you saw crashes in
>> inode_tree_del. =A0It's unlikely you were playing btrfsctl -b when y=
ou
>> encountered the problem. So no search code got involved, only
>> inode_tree_add/del modified the tree. I don't think the crash was
>> caused by duplicates in the tree.
>
> Oh, it is because inodes get reclaimed then presumably the inode numb=
er
> gets reused while an inode of the same number is being freed. I'm not
> exactly sure how the inode and inode number lifetimes work in btrfs..=
=2E
>
> Duplicate inodes are definitely being added because I put a message i=
n
> there and it is being triggered. What happens is that the duplicate
> insertion code is wrong, and it kicks the old inode out of the tree
> with the inode still marked as being in the tree. =A0So when you try =
to
> delete that inode, it crashes.
>
> I'm not quite sure how to explain it any better. It is pretty easy to
> reproduce (it is the same workload as I describe in fsx-linux failure=
s
> mail) if you would like to verify what is happening.
>

I finally understand, thank you very much.
I didn't read your reply contains duplicates toleration fix carefully, =
sorry.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

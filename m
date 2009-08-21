From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [patch] btrfs: fix inode rbtree corruption
Date: Fri, 21 Aug 2009 08:55:20 +0800
Message-ID: <3d0408630908201755x6f59dabay7011775954874d44@mail.gmail.com>
References: <20090818164542.GB30325@wotan.suse.de>
	 <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com>
	 <20090818211910.GR12579@kernel.dk>
	 <20090819084530.GD25721@wotan.suse.de>
	 <20090819084658.GT12579@kernel.dk>
	 <20090819085208.GF25721@wotan.suse.de>
	 <20090819085906.GV12579@kernel.dk>
	 <20090820132346.GN25721@wotan.suse.de>
	 <3d0408630908200651i4bfbf0ebk6b18975e1a06da7e@mail.gmail.com>
	 <20090820220736.GQ12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Nick Piggin <npiggin@suse.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090820220736.GQ12579@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

2009/8/21 Jens Axboe <jens.axboe@oracle.com>:
> On Thu, Aug 20 2009, Yan, Zheng =A0wrote:
>> 2009/8/20 Nick Piggin <npiggin@suse.de>:
>> > On Wed, Aug 19, 2009 at 10:59:07AM +0200, Jens Axboe wrote:
>> >> On Wed, Aug 19 2009, Nick Piggin wrote:
>> >> > On Wed, Aug 19, 2009 at 10:46:59AM +0200, Jens Axboe wrote:
>> >> > > On Wed, Aug 19 2009, Nick Piggin wrote:
>> >> > > > See my other reply. It *can* work with key aliases, but thi=
s particular
>> >> > > > code does not.
>> >> > > >
>> >> > > > It is pretty easy obviously to put in duplicates because th=
e rbtree
>> >> > > > code doesn't know about keys, but if we do this then it loo=
ks like
>> >> > > > it might cause the search code to miss some valid inodes an=
d instead
>> >> > > > return freeing inodes -- so you'd also have to look at that=
 and update
>> >> > > > it which is why I didn't go down this route..
>> >> > >
>> >> > > Mine was just a generic statement, I didn't read the btrfs co=
de (hence
>> >> > > my comment about potential lookup bug, if you allow aliases y=
ou have to
>> >> > > be careful).
>> >> >
>> >> > Ah ok. Well yeah in this case btrfs is definitely wrong in the =
way it
>> >> > tried to insert aliases.
>> >>
>> >> I looked at the actual problem now and I agree, it cannot work th=
at way.
>> >> I don't know if Linus is planning another -rc, we should probably=
 get
>> >> this upstream sooner rather than later. Chris is away this week, =
so if
>> >> we can get Yan to agree on this patch as well, I'll submit it.
>> > I think the first patch I submitted was agreed?
>> >
>>
>> Of course, thank you.
> Yan, are you sending this upstream?

No.  Jens, please submit it. Thanks

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

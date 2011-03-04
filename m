From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Fri, 4 Mar 2011 09:33:56 -0600
Message-ID: <AANLkTikFVd3kG4J99BQvVUwb05DRQXLyabsHieeTZCBW@mail.gmail.com>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl>
	<AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com>
	<1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com>
	<1299203447-sup-9359@think>
	<1299241124-sup-3502@think>
	<BAY156-w4980F081E2593ACCC07B2AD2C20@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: chris.mason@oracle.com, xin.zhong@intel.com,
	linux-btrfs@vger.kernel.org
To: Xin Zhong <thierryzhong@hotmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BAY156-w4980F081E2593ACCC07B2AD2C20@phx.gbl>
List-ID: <linux-btrfs.vger.kernel.org>

2011/3/4 Xin Zhong <thierryzhong@hotmail.com>:
>
> It works well for me too.
>
> ----------------------------------------
>> From: chris.mason@oracle.com
>> To: chris.mason@oracle.com
>> CC: xin.zhong@intel.com; mitch.harder@sabayonlinux.org; thierryzhong@hotmail.com; linux-btrfs@vger.kernel.org
>> Subject: RE: [PATCH] btrfs file write debugging patch
>> Date: Fri, 4 Mar 2011 07:19:39 -0500
>>
>> Excerpts from Chris Mason's message of 2011-03-03 20:51:55 -0500:
>> > Excerpts from Zhong, Xin's message of 2011-03-02 05:58:49 -0500:
>> > > It seems that if we give an unaligned address to btrfs write and the buffer reside on more than 2 pages. It will trigger this bug.
>> > > If we give an aligned address to btrfs write, it works well no matter how many pages are given.
>> > >
>> > > I use ftrace to observe it. It seems iov_iter_fault_in_readable do not trigger pagefault handling when the address is not aligned. I do not quite understand the reason behind it. But the solution should be to process the page one by one. And that's also what generic file write routine does.
>> > >
>> > > Any suggestion are welcomed. Thanks!
>> >
>> > Great job guys. I'm using this on top of my debugging patch. It passes
>> > the unaligned test but I'll give it a real run tonight and look for
>> > other problems.
>> >
>> > (This is almost entirely untested, please don't use it quite yet)
>>
>> >
>> > -chris
>> >
>> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> > index 89a6a26..6a44add 100644
>> > --- a/fs/btrfs/file.c
>> > +++ b/fs/btrfs/file.c
>> > @@ -1039,6 +1038,14 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
>> >
>> > copied = btrfs_copy_from_user(pos, num_pages,
>> > write_bytes, pages, &i);
>> > +
>> > + /*
>> > + * if we have trouble faulting in the pages, fall
>> > + * back to one page at a time
>> > + */
>> > + if (copied < write_bytes)
>> > + nrptrs = 1;
>> > +
>> > if (copied == 0)
>> > dirty_pages = 0;
>> > else
>>
>> Ok, this is working well for me. Anyone see any problems with it?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>

I've applied this patch on top of the debugging patch at the head of
the thread, and I'm having trouble building gcc now.

When building gcc-4.4.5, I get errors like the following:

Comparing stages 2 and 3
Bootstrap comparison failure!
./cp/call.o differs
./cp/decl.o differs
./cp/pt.o differs
./cp/class.o differs
./cp/decl2.o differs
<....snip.....>
./matrix-reorg.o differs
./tree-inline.o differs
./gcc.o differs
./gcc-options.o differs
make[2]: *** [compare] Error 1
make[1]: *** [stage3-bubble] Error 2
make: *** [bootstrap-lean] Error 2
emake failed

I've went back and rebuilt my kernel without these two debugging
patches, and gcc-4.4.5 builds without error on that kernel.

I haven't yet tested building gcc-4.4.5 with just the debugging patch
at the head of the thread, so I'll test that, and report back.

But I was wondering if anybody else can replicate this issue.

BTW, I've been doing most of my testing on an x86 system.  My x86_64
systems haven't had as much trouble, but I haven't been robustingly
checking my x86_64 systems for these issues.

I noticed that page fault handling is different by architecture.

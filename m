From: Chris Mason <chris.mason@oracle.com>
Subject: RE: [PATCH] btrfs file write debugging patch
Date: Fri, 04 Mar 2011 07:19:39 -0500
Message-ID: <1299241124-sup-3502@think>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl> <AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com> <1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com> <1299203447-sup-9359@think>
Content-Type: text/plain; charset=UTF-8
Cc: "Zhong, Xin" <xin.zhong@intel.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	Xin Zhong <thierryzhong@hotmail.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1299203447-sup-9359@think>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Mason's message of 2011-03-03 20:51:55 -0500:
> Excerpts from Zhong, Xin's message of 2011-03-02 05:58:49 -0500:
> > It seems that if we give an unaligned address to btrfs write and the buffer reside on more than 2 pages. It will trigger this bug.
> > If we give an aligned address to btrfs write, it works well no matter how many pages are given. 
> > 
> > I use ftrace to observe it. It seems iov_iter_fault_in_readable do not trigger pagefault handling when the address is not aligned. I do not quite understand the reason behind it. But the solution should be to process the page one by one. And that's also what generic file write routine does. 
> > 
> > Any suggestion are welcomed. Thanks!
> 
> Great job guys.  I'm using this on top of my debugging patch.  It passes
> the unaligned test but I'll give it a real run tonight and look for
> other problems.
> 
> (This is almost entirely untested, please don't use it quite yet)

> 
> -chris
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 89a6a26..6a44add 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1039,6 +1038,14 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
>  
>          copied = btrfs_copy_from_user(pos, num_pages,
>                         write_bytes, pages, &i);
> +
> +        /*
> +         * if we have trouble faulting in the pages, fall
> +         * back to one page at a time
> +         */
> +        if (copied < write_bytes)
> +            nrptrs = 1;
> +
>          if (copied == 0)
>              dirty_pages = 0;
>          else

Ok, this is working well for me.  Anyone see any problems with it?

From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: RE: [PATCH] btrfs file write debugging patch
Date: Fri, 4 Mar 2011 10:42:46 +0800
Message-ID: <1865303E0DED764181A9D882DEF65FB6866D256DE2@shsmsx502.ccr.corp.intel.com>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl>
 <AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com>
 <1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com>
 <1299203447-sup-9359@think>
 <20110304023212.GB4558@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	Xin Zhong <thierryzhong@hotmail.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110304023212.GB4558@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Where can I find your patch? Thanks!

-----Original Message-----
From: Josef Bacik [mailto:josef@redhat.com] 
Sent: Friday, March 04, 2011 10:32 AM
To: Chris Mason
Cc: Zhong, Xin; Mitch Harder; Xin Zhong; linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs file write debugging patch

On Thu, Mar 03, 2011 at 08:51:55PM -0500, Chris Mason wrote:
> Excerpts from Zhong, Xin's message of 2011-03-02 05:58:49 -0500:
> > I downloaded openmotif and run the command as Mitch mentioned and was able to recreate the problem locally. And I managed to simplify the command into a very simple program which can capture the problem easily. See below code:
> > 
> > #include <sys/types.h>
> > #include <sys/stat.h>
> > #include <fcntl.h>
> > static char a[4096*3];
> > int main()
> > {
> >     int fd = open("out", O_WRONLY|O_CREAT|O_TRUNC, 0666);
> >     write(fd,a+1, 4096*2);
> >     exit(0);
> > }
> > 
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
>  		copied = btrfs_copy_from_user(pos, num_pages,
>  					   write_bytes, pages, &i);
> +
> +		/*
> +		 * if we have trouble faulting in the pages, fall
> +		 * back to one page at a time
> +		 */
> +		if (copied < write_bytes)
> +			nrptrs = 1;
> +
>  		if (copied == 0)
>  			dirty_pages = 0;
>  		else

Btw this situation is taken care of in my write path rewrite patch, if copied ==
0 we switch to one segment at a time.  Thanks,

Josef

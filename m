From: Xin Zhong <thierryzhong@hotmail.com>
Subject: RE: [PATCH] btrfs file write debugging patch
Date: Wed, 2 Mar 2011 22:00:54 +0800
Message-ID: <BAY156-w32DF71F9D7D9DE389A3EE0D2C00@phx.gbl>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl>,<AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com>,<1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Cc: <linux-btrfs@vger.kernel.org>
To: <xin.zhong@intel.com>, Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>


Sorry, I forgot to mention that you need to undo below commit in btrfs-unstable to recreate the problem:
Btrfs: fix fiemap bugs with delalloc (+224/-42)
Otherwise, it will run into enospc error. I am not sure if it's the same problem.

----------------------------------------
> From: xin.zhong@intel.com
> To: mitch.harder@sabayonlinux.org; thierryzhong@hotmail.com
> CC: linux-btrfs@vger.kernel.org
> Date: Wed, 2 Mar 2011 18:58:49 +0800
> Subject: RE: [PATCH] btrfs file write debugging patch
>
> I downloaded openmotif and run the command as Mitch mentioned and was able to recreate the problem locally. And I managed to simplify the command into a very simple program which can capture the problem easily. See below code:
>
> #include 
> #include 
> #include 
> static char a[4096*3];
> int main()
> {
> int fd = open("out", O_WRONLY|O_CREAT|O_TRUNC, 0666);
> write(fd,a+1, 4096*2);
> exit(0);
> }
>
> It seems that if we give an unaligned address to btrfs write and the buffer reside on more than 2 pages. It will trigger this bug.
> If we give an aligned address to btrfs write, it works well no matter how many pages are given.
>
> I use ftrace to observe it. It seems iov_iter_fault_in_readable do not trigger pagefault handling when the address is not aligned. I do not quite understand the reason behind it. But the solution should be to process the page one by one. And that's also what generic file write routine does.
>
> Any suggestion are welcomed. Thanks!
>
> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Mitch Harder
> Sent: Wednesday, March 02, 2011 5:09 AM
> To: Xin Zhong
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs file write debugging patch
>
> 2011/3/1 Xin Zhong :
> >
> > Hi, Mitch
> > I think you can config ftrace to just trace function calls of btrfs.ko which will save a lot of trace buffer space. See below command:
> > #echo ':mod:btrfs' > /sys/kernel/debug/tracing/set_ftrace_filterAnd please send out the full ftrace log again.
> >
> > Another helpful information might be the strace log of the wmldbcreate process. It will show us the io pattern of this command.
> > Thanks a lot for your help!
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> >
>
> I manually ran an strace around the build command (wmldbcreate) that is causing my problem, and I am attaching the strace for that.
>
> Please note that wmldbcreate does not seem to care when an error is returned, and continues on. So the error is occurring somewhat silently in the middle, and isn't the last item. The error is probably associated with one of the 12288 byte writes.
>
> I have re-run an ftrace following the conditions above, and have hosted that file (~1.1MB compressed) on my local server at:
>
> http://dontpanic.dyndns.org/trace-openmotif-btrfs-v15.gz
>
> Please note I am still using some debugging modifications of my own to file.c.
>
> They server the purpose of:
> (1) Avoiding an infinite loop by identifying when the problem is occuring, and exiting with error after 256 loops.
> (2) Stopping the trace after exiting to keep from flooding the ftrace buffer.
> (3) Provide debugging comments (all prefaced with "TPK:" in the trace).
>
> Let me know if you want me to change any of the conditions.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
 		 	   		  

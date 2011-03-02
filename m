From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: RE: [PATCH] btrfs file write debugging patch
Date: Wed, 2 Mar 2011 18:58:49 +0800
Message-ID: <1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl>
 <AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>,
	Xin Zhong <thierryzhong@hotmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I downloaded openmotif and run the command as Mitch mentioned and was a=
ble to recreate the problem locally. And I managed to simplify the comm=
and into a very simple program which can capture the problem easily. Se=
e below code:

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
static char a[4096*3];
int main()
{
    int fd =3D open("out", O_WRONLY|O_CREAT|O_TRUNC, 0666);
    write(fd,a+1, 4096*2);
    exit(0);
}

It seems that if we give an unaligned address to btrfs write and the bu=
ffer reside on more than 2 pages. It will trigger this bug.
If we give an aligned address to btrfs write, it works well no matter h=
ow many pages are given.=20

I use ftrace to observe it. It seems iov_iter_fault_in_readable do not =
trigger pagefault handling when the address is not aligned. I do not qu=
ite understand the reason behind it. But the solution should be to proc=
ess the page one by one. And that's also what generic file write routin=
e does.=20

Any suggestion are welcomed. Thanks!

-----Original Message-----
=46rom: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vge=
r.kernel.org] On Behalf Of Mitch Harder
Sent: Wednesday, March 02, 2011 5:09 AM
To: Xin Zhong
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs file write debugging patch

2011/3/1 Xin Zhong <thierryzhong@hotmail.com>:
>
> Hi, Mitch
> I think you can config ftrace to just trace function calls of btrfs.k=
o which will save a lot of trace buffer space. See below command:
> #echo ':mod:btrfs' > /sys/kernel/debug/tracing/set_ftrace_filterAnd p=
lease send out the full ftrace log again.
>
> Another helpful information might be the strace log of the wmldbcreat=
e process. It will show us the io pattern of this command.
> Thanks a lot for your help!
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
"=20
> in the body of a message to majordomo@vger.kernel.org More majordomo=20
> info at =A0http://vger.kernel.org/majordomo-info.html
>

I manually ran an strace around the build command (wmldbcreate) that is=
 causing my problem, and I am attaching the strace for that.

Please note that wmldbcreate does not seem to care when an error is ret=
urned, and continues on.  So the error is occurring somewhat silently i=
n the middle, and isn't the last item.  The error is probably associate=
d with one of the 12288 byte writes.

I have re-run an ftrace following the conditions above, and have hosted=
 that file (~1.1MB compressed) on my local server at:

http://dontpanic.dyndns.org/trace-openmotif-btrfs-v15.gz

Please note I am still using some debugging modifications of my own to =
file.c.

They server the purpose of:
(1) Avoiding an infinite loop by identifying when the problem is occuri=
ng, and exiting with error after 256 loops.
(2) Stopping the trace after exiting to keep from flooding the ftrace b=
uffer.
(3) Provide debugging comments (all prefaced with "TPK:" in the trace).

Let me know if you want me to change any of the conditions.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

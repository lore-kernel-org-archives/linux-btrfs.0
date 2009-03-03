From: Josef Bacik <josef@redhat.com>
Subject: Re: Bug at extent-tree.c:3190
Date: Tue, 3 Mar 2009 11:16:14 -0500
Message-ID: <20090303161614.GA5446@unused.rdu.redhat.com>
References: <alpine.LSU.2.00.0903030406580.2311@fbirervta.pbzchgretzou.qr> <20090303154051.GE1239@unused.rdu.redhat.com> <alpine.LSU.2.00.0903031708140.855@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.0903031708140.855@fbirervta.pbzchgretzou.qr>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 03, 2009 at 05:11:06PM +0100, Jan Engelhardt wrote:
> 
> On Tuesday 2009-03-03 16:40, Josef Bacik wrote:
> >> 
> >> The following oops was obtained by doing some copying; it's tainted-P by 
> >> nvidia but maybe it still gives some hints.
> >> The testcase is basically
> >> 
> >> $ rsync -HPSav a/ b/
> >> 
> >> where by a/ is a collection of kernel trees, and b/ is a fresh btrfs.
> >> 
> >> $ ls -l a/
> >> drwxr-xr-x 19 jengelh users 4096 Jan 10 07:32 linux17
> >> drwxr-xr-x 19 jengelh users 4096 Jan 10 07:34 linux18
> >> drwxr-xr-x 19 jengelh users 4096 Jan 10 07:34 linux19
> >> drwxr-xr-x 19 jengelh users 4096 Jan 10 07:34 linux20
> >> drwxr-xr-x 19 jengelh users 4096 Jan 10 07:35 linux21
> >> drwxr-xr-x 19 jengelh users 4096 Jan 10 07:35 linux22
> >> drwxr-xr-x 19 jengelh users 4096 Jan 10 07:35 linux23
> >> drwxr-xr-x 20 jengelh users 4096 Jan 10 07:35 linux24
> >> drwxr-xr-x 21 jengelh users 4096 Jan 10 07:36 linux25
> >> drwxr-xr-x 21 jengelh users 4096 Jan 10 07:36 linux26
> >> drwxr-xr-x 22 jengelh users 4096 Jan 10 07:37 linux27
> >> drwxr-xr-x 22 jengelh users 4096 Jan 10 07:37 linux28
> >
> >ENOSPC, sorry :)
> 
> Ah heh, could be a cause. Even so, there is still "plenty" of
> space (loop1 with btrfs is also 4184064K in size):
> 
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/loop0     xfs     4184064   3676644    507420  88% /lo/kernel

Yeah you ran out of data area, the rest of the space is reserved for metadata
space.  If you use the current git tree with my enospc patch this problem
shouldnt happen (as easily anyway).  Thanks,

Josef

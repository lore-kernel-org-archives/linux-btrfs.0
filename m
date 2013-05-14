Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:60382 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab3ENUmF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 16:42:05 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3C44E7C0681
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 14:42:04 -0600 (MDT)
Date: Tue, 14 May 2013 16:42:01 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Rich Johnston <rjohnston@sgi.com>
CC: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>,
        Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests btrfs/284: shorten duration, fix output
Message-ID: <20130514204201.GC1765@localhost.localdomain>
References: <517ACB41.2030002@redhat.com>
 <51925612.5050002@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51925612.5050002@sgi.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 14, 2013 at 09:19:46AM -0600, Rich Johnston wrote:
> On 04/26/2013 01:45 PM, Eric Sandeen wrote:
> > test 284 had... some issues.
> >
> > First, it took so long nobody ran it; so shorten the extent
> > count by a factor of about 100.
> >
> > Having fixed that, we see failures in 2 cases; when start or
> > len is -1, but the golden output file didn't have error
> > output, as if they should pass.
> >
> > I'm going to argue that these *should* both fail; start = -1
> > has no real meaning.  length = -1 might mean "the rest
> > of the file" but if that's what you really want, just
> > don't specify -l.
> >
> > So add failure output for those cases.
> >
> > Send all command output to $seq.full, in case that changes
> > in the future; just capture the return value.
> >
> > Then remove the return value echo on failure (50?) because
> > who knows when that might change to some other magic value.
> >
> > Ok, then when defrag actually works, old defrag returned
> > "20" (because?) but a recent commit changed it to 0.
> > So accommodate that too.
> >
> > And remove a stray "HAVE_DEFRAG=1" while we're at it.
> > That variable is never used.
> >
> 
> So should I be seeing failures with
> btrfs-progs-0.20-0.2.git91d9eec.el6.x86_64 installed?
> 
> ./check btrfs/284
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 cxfsxe4 3.9.0+
> MKFS_OPTIONS  -- /dev/sdk2
> MOUNT_OPTIONS -- /dev/sdk2 /mnt/scratch
> 
> btrfs/284	 - output mismatch (see 
> /usr/src/rcj/xfstests/results/btrfs/284.out.bad)
>      --- tests/btrfs/284.out	2013-05-14 09:31:35.000000000 -0500
>      +++ /usr/src/rcj/xfstests/results/btrfs/284.out.bad	2013-05-14 
> 10:10:45.000000000 -0500
>      @@ -6,7 +6,6 @@
>       btrfs filesystem defragment failed!
>       a single file | start > file size && 0 < len < file size | off
>       a single file | start = 0 && len < 0 | off (should fail)
>      -btrfs filesystem defragment failed!
>       a single file | start = 0 && len > file size | off
>       a single file | start = 0 && 0 < len < file size | off
>       a directory | default | off
>       ...
>       (Run 'diff -u tests/btrfs/284.out 
> /usr/src/rcj/xfstests/results/btrfs/284.out.bad' to see the entire diff)
> Ran: btrfs/284
> Failures: btrfs/284
> Failed 1 of 1 tests
> 

Yeah defrag used to spit out a return value on success, that has been fixed
recently.  This patch looks good, I just ran it on my box and it ran fine, you
can add

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef

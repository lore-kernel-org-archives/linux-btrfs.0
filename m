Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab2E3VJH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 May 2012 17:09:07 -0400
Date: Wed, 30 May 2012 17:09:05 -0400
From: Josef Bacik <josef@redhat.com>
To: Catalin Iacob <iacobcatalin@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Very slow mount
Message-ID: <20120530210905.GD1887@localhost.localdomain>
References: <CAHg_5go6zYdWUspTxRSWNFTtrxxr1=AZh2OaT3GW_wGwnV1Y7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHg_5go6zYdWUspTxRSWNFTtrxxr1=AZh2OaT3GW_wGwnV1Y7g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 30, 2012 at 10:38:57PM +0200, Catalin Iacob wrote:
> Hi everybody,
> 
> [Resent without big dmesg attachment which vger doesn't seem to like,
> lots of excuses if you get it twice]
> 
> I'm using Btrfs as my root filesystem since November 2011 on openSUSE
> 12.1. It started on openSUSE's 3.1 kernel, then I stared compiling the
> kernel myself and went through 3.2, 3.3 and 3.4. Since the beginning I
> had noatime,compress=lzo as mount options. Over time I've added some
> more so now I'm using:
> noatime,space_cache,inode_cache,autodefrag,compress=lzo.
> 
> Mount has always been slow, around or more than 10 seconds. Initially
> I thought it's just the way things are and Btrfs is slow when mounting
> but then I saw [1] where Calvin Watson says his Btrfs mounts in 0.5
> seconds. I want that as well :).
> 
> My dmesg after hitting Alt-Sysrq-w a few times while waiting for the
> mount command from the initrd on kernel 3.4.0 is at:
> https://gist.github.com/2838536
> It starts mounting at 3.490979 and the next kernel message is at 19.506051.
> 
> openSUSE has snapper which takes snapshots every hour therefore there
> were quite some snapshots made on this filesystem during its lifetime.
> 
> Some more data:
> 
> catalin@linux-vo6z:~/btrfs-progs> sudo ./btrfs fi df /
> Data: total=169.01GB, used=107.23GB
> System, DUP: total=8.00MB, used=28.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=7.12GB, used=3.77GB
> Metadata: total=8.00MB, used=0.00
> 
> catalin@linux-vo6z:~/btrfs-progs> sudo ./btrfs fi show
> root's password:
> failed to read /dev/sr0
> Label: none  uuid: 440b735b-1171-4dd3-a058-d88c89325391
>        Total devices 1 FS bytes used 111.00GB
>        devid    1 size 251.47GB used 183.29GB path /dev/sda8
> 
> Btrfs Btrfs v0.19
> 
> I can test whatever patches you provide or give more information if needed.

Hrm well being on root makes it hard to figure out what is going on.  The mount
stuff is all in reads but who knows whats going on.  Can you do bootchart so I
can see what threads are spawned, maybe the old caching stuff is getting tripped
for some reason.  The next thought is to boot up with a rescue disk and mount
while running latencytop -c (you'll need this patch
http://oss.oracle.com/~mason/latencytop.patch) and post the output somewhere so
we can see it.  Thanks,

Josef 

From: Chris Mason <chris.mason@oracle.com>
Subject: Re: billion file testing of btrfs
Date: Mon, 16 Aug 2010 08:37:35 -0400
Message-ID: <20100816123735.GV3315@think>
References: <4C692F24.5000208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C692F24.5000208@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 16, 2010 at 08:29:24AM -0400, Ric Wheeler wrote:
> 
> I decided to try btrfs on F13 (2.6.33.6-147.2.4.fc13.x86_64 kernel)
> with the following fs_mark command and a 1.5 TB Seagate S-ATA disk:
> 
> # fs_mark -s 0 -S 0 -D 1000 -n 1000000 -L 1000 -d /test/ -l btrfs_log.txt
> 
> btrfs starts off at a fantastic rate - roughly 3-4 times the speed of ext4:
> 
[ log ]

> 
> I will fill this and get some plots, etc to do relative performance
> & then wanted to try the current RC kernel just to refresh.

Thanks Ric, I think this is related to the perf problem delalloc
flushing performance bug.  I'll nail it down shortly.

-chris

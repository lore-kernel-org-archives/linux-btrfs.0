From: Chris Mason <chris.mason@oracle.com>
Subject: Re: What's the benefit of COW without checksum?
Date: Tue, 26 Jan 2010 14:07:05 -0500
Message-ID: <20100126190705.GB2770@think>
References: <977a2be21001252315w36afcb39v4ba130f6d8e53707@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Yan Zheng <zheng.yan@oracle.com>,
	austin.zhang@intel.com, yong.y.wang@intel.com,
	bing.wei.liu@intel.com, Zhu Yanhai <yanhai.zhu@linux.intel.com>
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <977a2be21001252315w36afcb39v4ba130f6d8e53707@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 26, 2010 at 03:15:08PM +0800, Zhu Yanhai wrote:
>    Hi Chris,
>    According to my understanding, COW in Btrfs services for 1) snapshots
>    capacities 2) keeping checksum consistent with FS data,
>    that's why nodatacow implies nodatasum. And COW will still happen for
>    snapshots even under 'nodatacow'.
> 
>    So could you please tell me what can we get from COW if not computing
>    checksum (nodatasum)? That's to say, if some user decides to
>    disable checksum, do you think it's fine for him to just mount with
>    'nodatacow'? Or there's still some reason for him to use bare 'nodatasum'?

COW does have advantages in some workloads, basically where you end up
putting fresh data modifications close to each other.  This is
especially true on some ssds that work best when writing large groups of
contiguous data.

Mail server workloads often benefit from cow as well.  Especially with
the intel crc32c extensions, the checksumming is becoming less and less
expensive on modern hardware.  I don't expect many people to turn it
off.

nodatacow on the other hand has a big impact on database workloads.  The
random over-write performance goes down significantly when cow is on
because the extents become very small and the amount of metadata needed
to track them becomes very large. 

So, nodatacow is likely to be used often, while nodatasum is probably
only going to be used by people trying to figure out how big the impact
of checksumming is on performance.

-chris


From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfsctl -d race with df -h causes hang?
Date: Fri, 20 Nov 2009 10:35:27 -0500
Message-ID: <20091120153527.GW3110@think>
References: <549778BA-0D47-458D-8CE1-022885B2A2BB@ubuntu.com>
 <30183CDB-9359-493D-B400-3312291C968B@ubuntu.com>
 <900EA6DB-EECC-4BA8-B551-1A6831949824@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: John Dong <jdong@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <900EA6DB-EECC-4BA8-B551-1A6831949824@ubuntu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 19, 2009 at 06:18:49PM -0500, John Dong wrote:
> Managed to get some kernel logs this time. Some sort of deadlock?

Ok, if you can still access the machine could you please run sysrq-w and
sysrq-t.  That will print out the stacks of the stuck procs.  We've
probably got a lock inversion hiding in the df handling.

-chris

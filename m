From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix race in worker_loop
Date: Mon, 23 Mar 2009 12:51:25 -0400
Message-ID: <1237827085.17910.0.camel@think.oraclecorp.com>
References: <49C5A161.1000908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Amit Gud <amitgud@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49C5A161.1000908@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2009-03-21 at 19:24 -0700, Amit Gud wrote:
> Hello Chris,
> 
> Experiencing sporadic hangs during umount(2) on UML. Patch below seem to
> fix it if not already fixed. Based on 2.6.29-rc8. Tested with mounting
> and umounting iteratively 100 times. Without the fix, the race is hit
> within 10 tries.

Thanks for finding this one!

-chris



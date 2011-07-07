From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v3 8/8] new ioctls to do logical->inode and inode->path
 resolving
Date: Fri, 08 Jul 2011 00:53:52 +0200
Message-ID: <4E163900.1050205@jan-o-sch.net>
References: <cover.1310053204.git.list.btrfs@jan-o-sch.net> <d7f2eb7de3b6e8bc9f40ad96b9943d9680f88987.1310053204.git.list.btrfs@jan-o-sch.net> <20110707222947.GE4325@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>, chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110707222947.GE4325@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 07/08/2011 12:29 AM, Hugo Mills wrote:
>    Hi, Jan,
> 
> On Thu, Jul 07, 2011 at 05:48:33PM +0200, Jan Schmidt wrote:
>> these ioctls make use of the new functions initially added for scrub. they
>> return all inodes belonging to a logical address (BTRFS_IOC_LOGICAL_INO) and
>> all paths belonging to an inode (BTRFS_IOC_INO_PATHS).
> 
>    I've not read this patch in detail, so I may have missed something,
> but why do we need new ioctls for these functions, when we have
> BTRFS_IOC_TREE_SEARCH, which will allow us to perform the same two
> operations using existing kernel-side infrastructure?
> 
>    Hugo.

Note that those ioctls do a lot more than just one tree search. You are
right, we could implement all this with (quite a few)
BTRFS_IOC_TREE_SEARCH ioctls.

Especially resolving all file system paths for an inode needs really a
lot of searches. I like to have logic requiring deep knowledge of the
internals of btrfs trees in kernel, generally. Not to mention that this
way we are safe to run this on a file system under load and still can
get consistent results.

Last but not least, if we want to use this code for general error
reporting to the kernel log (e.g. by scrub), we need all the resolving
code in kernel anyway. So I'd like to provide that functionality to user
space, too.

-Jan

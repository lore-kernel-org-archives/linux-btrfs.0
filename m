From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs trees for linux-next
Date: Wed, 10 Dec 2008 21:34:56 -0500
Message-ID: <1228962896.21376.11.camel@think.oraclecorp.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au
To: linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1227183484.6161.17.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-11-20 at 07:18 -0500, Chris Mason wrote:
> Hello everyone,
> 
> I've updated the btrfs git trees to 2.6.28-rc5 and tested against
> linux-next.
> 
> We've knocked a bunch of things off the todo list since I last posted,
> including compression (mount -o compress) and the ability to create
> subvols and snapshots anywhere in the FS.
> 
> There are a small number of disk format changes pending, which I put off
> in favor of making compression stable/fast.  We'll hammer these out
> shortly.
> 

Just an update, while I still have a long todo list and plenty of things
to fix in the code, these src trees have been updated with a disk format
I hope to maintain compatibility with from here on.  There are still
format changes planned, but should go in through the compat mechanisms
in the sources now.

The btrfs trees are still at 2.6.28-rc5, but I just tested against
linux-next without problems.

> The btrfs kernel code is here:
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary
> 
> And the utilities are here:
> 
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=summary

-chris



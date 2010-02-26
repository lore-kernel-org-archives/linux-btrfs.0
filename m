From: Diego Calleja <diegocg@gmail.com>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 21:49:14 +0100
Message-ID: <201002262149.14718.diegocg@gmail.com>
References: <20100226175927.GG12841@think> <20100226181157.50F73414B9@viridian.itc.virginia.edu> <20100226190915.GI12841@think>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226190915.GI12841@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Viernes, 26 de Febrero de 2010 20:09:15 Chris Mason escribi=F3:
> My would be the super block, it is updated more often and so more lik=
ely
> to get stuck in the array's cache.

IIRC, this is exactly the same problem that ZFS users have been
hitting. Some users got cheap disks that don't honour barriers
correctly, so their uberblock didn't have the correct data.
They developed an app that tries to rollback transactions to
get the pool into a sane state...I guess that fsck will be able
to do that at some point?

Stupid question from someone who is not a fs dev...it's not possible
to solve this issue by doing some sort of "superblock journaling"?
Since there are several superblock copies you could:
 -Modify a secondary superblock copy to point to the tree root block
  that still has not been written to disk
 -Write whatever tree root block has been COW'ed
 -Modify the primary superblock

So in case of these failures, mount code could look in the secondary
superblock copy before failing. Since barriers are not being honoured,
there's still a possibility that the tree root blocks would be written
before the secondary superblock block that was submitted before, but
that problem would be much harder to hit I guess. But maybe the fs code
can not know where the tree root blocks are going to be written before
writting them, and hence it can't generate a valid superblock?

Sorry if all this has not sense at all, I'm just wondering if there's
a way to solve these drive issues without any kind of recovery tools
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

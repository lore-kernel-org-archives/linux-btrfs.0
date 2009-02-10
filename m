From: Aaron Straus <aaron@merfinllc.com>
Subject: Re: [PATCH] start work on delete snapshot code
Date: Mon, 9 Feb 2009 17:42:37 -0800
Message-ID: <20090210014237.GA31158@merfinllc.com>
References: <1234224453-4227-1-git-send-email-aaron@merfinllc.com> <1234228148.17365.34.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234228148.17365.34.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 09 08:09 PM, Chris Mason wrote:
> Sorry to say that I won't have time to read through this in the morning,
> but this is a pretty hefty task for a first patch.  Thanks for taking it
> on and posting this work!

No worries... I just wanted to learn more about btrfs... so it seemed
like a good project, especially if nobody else is working on it.

I don't think my patch actually works correctly, but I'm hoping someone
who understands both the VFS and btrfs can fix it up or at least use it
as a starting point.

--

Quick question about the root_refs for you or anyone else on the list.

Let's say we have:

  base/s1

where base is a subvolume and s1 is a snapshot.  So base has a root_ref
to s1 and s1 has a back_ref to base in the tree root.

Now let's say we make a snapshot of base so we have:

  base/s1
  base.snap/s1

So we have s1, the same tree root referenced in two separate snapshots.

Now should s1 should now have two back_refs, one to base and one to
base.snap?  Also base.snap show have a root_ref to s1?

That doesn't seem to happen with the current snapshotting code, unless
I'm missing something...  I'm happy to try to add a patch if that is
indeed what should happen...


				Regards,
				=a=



-- 
===================
Aaron Straus
aaron@merfinllc.com

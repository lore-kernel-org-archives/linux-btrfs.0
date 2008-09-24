From: Chris Mason <chris.mason@oracle.com>
Subject: Re: snapshot merging?
Date: Wed, 24 Sep 2008 08:57:40 -0400
Message-ID: <1222261060.7160.168.camel@think.oraclecorp.com>
References: <48D63C8E.2060802@wpkg.org> <48D657DB.7050601@oracle.com>
	 <48D65ACD.7030907@wpkg.org>  <200809232034.21750.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	Zheng Yan <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org
To: Daniel Phillips <phillips@phunq.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200809232034.21750.phillips@phunq.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-09-23 at 20:34 -0700, Daniel Phillips wrote:
> On Sunday 21 September 2008 07:31, Tomasz Chmielewski wrote:
> > > Writeable snapshot has been available in btrfs for a long time.
> > 
> > Writeable snapshots and snapshot merging are two different things.
> 
> I think what Mikulas really means by "snapshot merging" is what we call
> "revert to snapshot" in ddsnap (google Zumastor ddsnap).  The latter is
> more appropriate terminology IMHO.  For a snapshotted volume, this just
> requires copying any blocks that belong to the snapshot and not the
> origin back to the origin.  Similarly, one could revert any snapshot
> "back" (quotes because there is not necessarily any relationship in
> time) to any other.  For a filesystem it will not be nearly so simple,
> because at best only part of the job can be done at the physical block
> level.

In btrfs there's no need to merge.  The original is still there and you
just use it instead of the snapshot.  Both the original and the snapshot
are writable, you can pick whichever one you want to continue forward
with.

Said a different way, the underlying metadata structures and
capabilities of the snapshot and the original are the same.  The only
difference between the two is their starting state.

-chris



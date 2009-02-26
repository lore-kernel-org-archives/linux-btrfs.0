From: Chris Mason <chris.mason@oracle.com>
Subject: experimental branch rebased
Date: Thu, 26 Feb 2009 10:45:45 -0500
Message-ID: <1235663145.4631.11.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've rebased the experimental branch again with my latest performance
fixes.

I took out the delayed unlink code, it wasn't making a big enough
difference in any benchmarks to justify the complexity.

I changed the delayed backref code to do delayed processing for all
extents.  In general it is much faster and uses less stack.

I pulled Josef's enospc work into the master branch and asked Linus to
pull it.

I'm going to hammer on the experimental branch for a few days and ask
Steve to give it another run.

-chris



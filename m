From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New new format branch ready for testing
Date: Tue, 9 Jun 2009 20:45:44 -0400
Message-ID: <20090610004544.GA4964@think>
References: <20090608205848.GB4130@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090608205848.GB4130@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Just a quick note that I've updated the newformat2 kernel branch to
include some fixes for buffered IO stalls and a new mount -o ssd_spread
mount option that should perform better than regular mount -o ssd when
used on lower end SSDs.

The big difference is that mount -o ssd_spread forces allocations to
find fully free areas, where mount -o ssd will find rough groupings of
free blocks that might have allocated blocks mixed in.

Tomorrow I'll add some autodetection for devices that have the
non-rotational flag set, which is a hint the block layer gives us that
we're operating on an SSD.

-chris


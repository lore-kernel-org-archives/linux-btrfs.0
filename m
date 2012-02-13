From: David Sterba <dave@jikos.cz>
Subject: Re: Several unhappy btrfs's after RAID meltdown
Date: Mon, 13 Feb 2012 14:48:50 +0100
Message-ID: <20120213134850.GF15350@twin.jikos.cz>
References: <20120205184128.GC18806@localhost.localdomain> <20120207033945.GA5639@localhost.localdomain> <pan.2012.02.07.09.53.58@cox.net> <20120207140431.GB5639@localhost.localdomain> <CAKcLGm9mLhwc1ZFp=ingR814X77QetX3LOkSqxdbussjj2gykQ@mail.gmail.com> <20120207154225.GD5639@localhost.localdomain> <20120207174645.GE5639@localhost.localdomain> <20120207174907.GF5639@localhost.localdomain> <20120212163134.GA15216@localhost.localdomain>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: nemesis@icequake.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120212163134.GA15216@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 12, 2012 at 10:31:34AM -0600, Ryan C. Underwood wrote:
> So, I examined the below filesystem, the one of the two that I would
> really like to restore.  There is basically nothing but zeros, and
> very occasionally a sparse string of data, until exactly 0x200000
> offset,

This matches start of an allocation cluster.

> ... at which point the data is suddenly very packed and looks like
> usual compressed data should.  Is there a way one could de-LZO the
> data chunkwise and dump to another device so I could even get an idea
> what I am looking at?

If the blocks are in right order, you can decompress the raw data from
the format

[4B total length] [4B compressed chunk length][chunk data] [another chunk]

there is no signature of the compressed extent boundaries, but the
lengths stored are always smaller than 128K, so it's hex values like

23 04 00 00 | 34 01 00 00 | <lzo data...>

and shoud be detectable in the block sequence.

> What about a 'superblock' signature I can scan
> for?

_BHRfS_M at offset 0x40 in a 4kb aligned block


david

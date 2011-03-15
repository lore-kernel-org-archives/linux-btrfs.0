From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] Btrfs: add datacow flag in inode flag
Date: Tue, 15 Mar 2011 21:57:24 +0100
Message-ID: <20110315205724.GB10360@lst.de>
References: <4D6F52DE.5080508@cn.fujitsu.com> <1300220702-sup-5062@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch@lst.de,
	Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1300220702-sup-5062@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2011 at 04:26:50PM -0400, Chris Mason wrote:
> Excerpts from liubo's message of 2011-03-03 03:35:42 -0500:

I'm fine with it.  I'll defer the check for conflicts with extN-specific flags
to Ted, though.


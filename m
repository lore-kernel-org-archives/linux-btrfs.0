From: Theodore Tso <tytso@mit.edu>
Subject: Re: Btrfs v0.16 released
Date: Sat, 16 Aug 2008 15:27:50 -0400
Message-ID: <20080816192749.GA8774@mit.edu>
References: <1218221293.15342.263.camel@think.oraclecorp.com> <1218747656.15342.439.camel@think.oraclecorp.com> <20080814234458.GD13048@mit.edu> <1218762627.15342.447.camel@think.oraclecorp.com> <1218804361.15342.470.camel@think.oraclecorp.com> <20080815134545.GM13048@mit.edu> <1218822772.15342.503.camel@think.oraclecorp.com> <20080815195941.GB22395@mit.edu> <1218832622.19495.14.camel@think.oraclecorp.com> <1218910210.19495.25.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1218910210.19495.25.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 16, 2008 at 02:10:10PM -0400, Chris Mason wrote:
> 
> I tried just the writeback_index patch and got only 4 fragmented files
> on ext4 after a compilebench run.  Then I tried again and got 1200.
> Seems there is something timing dependent in here ;)
> 

Yeah, the patch Aneesh sent to change where we added the inode to the
dirty list was false lead.  The right fix is in the ext4 patch queue
now.  I think we have the problem licked and a quick test showed it
increased the compilebench MB/s by a very tiny amount (enough so that
I wasnt sure whether or not it was measurement error), but it does
avoid the needly fragmentation.

						- Ted

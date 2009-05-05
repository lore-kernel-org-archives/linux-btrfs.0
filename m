From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: BUG at fs/buffer.c:2933 during umount
Date: Tue, 5 May 2009 13:15:27 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0905051304050.6162@bogon.housecafe.de>
References: <alpine.DEB.2.01.0905051212210.6162@bogon.housecafe.de>  <1241551898.7244.99.camel@think.oraclecorp.com>  <alpine.DEB.2.01.0905051246380.6162@bogon.housecafe.de> <1241553533.7244.104.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1241553533.7244.104.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 5 May 2009, Chris Mason wrote:
> For ext3, mount -o barrier=1 and you should see something exciting.  It
> won't BUG because ext3 isn't as serious about telling the users about IO
> problems as we are, but you should at least see messages.

With that option, ext3 gives a waring, yes:

[ 1743.370971] JBD: barrier-based sync failed on xvdc - disabling barriers

Ext4 seems to enable barriers right away and when I actually write to the 
filesystem, it emits a warning indeed:

# umount /mnt/d2
[...]
[ 1409.043735] JBD: barrier-based sync failed on xvdc:8 - disabling barriers
[ 1413.700390] EXT4-fs: mballoc: 1531 blocks 46 reqs (24 success)
[ 1413.700406] EXT4-fs: mballoc: 23 extents scanned, 1 goal hits, 23 2^N hits, 0 breaks, 0 lost
[ 1413.700415] EXT4-fs: mballoc: 2 generated and it took 4884
[ 1413.700421] EXT4-fs: mballoc: 1212 preallocated, 690 discarded

I still find the BUG somehow...misleading. An error message seems to be 
more appropriate.

Christian.
-- 
The universe was created to serve as Bruce Schneier's crib text.

From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.16 released
Date: Mon, 18 Aug 2008 09:52:09 -0400
Message-ID: <1219067529.2137.1.camel@think.oraclecorp.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <877ias66v4.fsf@basil.nowhere.org>
	 <1218221293.15342.263.camel@think.oraclecorp.com>
	 <1218747656.15342.439.camel@think.oraclecorp.com>
	 <20080814211756.GC13814@one.firstfloor.org>
	 <1218763554.15342.460.camel@think.oraclecorp.com>
	 <20080815013934.GE19125@one.firstfloor.org>
	 <1218805256.15342.484.camel@think.oraclecorp.com>
	 <Pine.LNX.4.61.0808162215320.4532@dhcppc2>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0808162215320.4532@dhcppc2>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2008-08-16 at 22:26 +0300, Szabolcs Szakacsits wrote:
> On Fri, 15 Aug 2008, Chris Mason wrote:
> 
> > Ext3 and XFS score somewhere between 10-15MB/s on the same test...
> 
> Interesting (and cool animations). 
> 
> We tried compilebench (-i 30 -r 0) just for fun using kernel 2.6.26, 
> freshly formatted partition, with defaults. Results:
> 
>               MB/s    Runtime (s)
>              -----    -----------
>   ext3       13.24        877
>   btrfs      12.33        793


Thanks for running things.

The code in the btrfs-unstable tree has all my performance fixes.
You'll need it to get good results.  Also, the MB/s number doesn't
include the time to run sync at the end, which is probably why the
runtime for btrfs is shorter but MB/s is lower.

-chris



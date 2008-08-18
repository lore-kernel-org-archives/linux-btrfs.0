From: Szabolcs Szakacsits <szaka@ntfs-3g.com>
Subject: Re: Btrfs v0.16 released
Date: Mon, 18 Aug 2008 20:37:12 +0300 (EEST)
Message-ID: <Pine.LNX.4.62.0808181931220.32726@tamago.serverit.net>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
 <1218100464.8625.9.camel@twins>  <1218105597.15342.189.camel@think.oraclecorp.com>
  <877ias66v4.fsf@basil.nowhere.org>  <1218221293.15342.263.camel@think.oraclecorp.com>
  <1218747656.15342.439.camel@think.oraclecorp.com>  <20080814211756.GC13814@one.firstfloor.org>
  <1218763554.15342.460.camel@think.oraclecorp.com>  <20080815013934.GE19125@one.firstfloor.org>
  <1218805256.15342.484.camel@think.oraclecorp.com>  <Pine.LNX.4.61.0808162215320.4532@dhcppc2>
 <1219067529.2137.1.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1219067529.2137.1.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Mon, 18 Aug 2008, Chris Mason wrote:
> On Sat, 2008-08-16 at 22:26 +0300, Szabolcs Szakacsits wrote:
> > 
> > We tried compilebench (-i 30 -r 0) just for fun using kernel 2.6.26, 
> > freshly formatted partition, with defaults. Results:
> > 
> >               MB/s    Runtime (s)
> >              -----    -----------
> >   ext3       13.24        877
> >   btrfs      12.33        793
> 
> Thanks for running things.
> 
> The code in the btrfs-unstable tree has all my performance fixes.
> You'll need it to get good results.  

The numbers are indeed much better:

                        MB/s    Runtime (s)
                       -----    -----------
   btrfs-unstable      17.09        572

The disk is capable of 40+ MB/s however the test partition was one of the 
last ones and as I figured it out now, it can do only 26 MB/sec. Btrfs bulk 
write easily sustains it. The write speed was 21 MB/s during the benchmark, 
so btrfs is the closest to the possible best write speed in the test 
environment.

	Szaka

--
NTFS-3G:  http://ntfs-3g.org


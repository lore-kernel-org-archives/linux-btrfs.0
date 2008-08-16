From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Subject: Re: Btrfs v0.16 released
Date: Sat, 16 Aug 2008 22:26:04 +0300 (MET DST)
Message-ID: <Pine.LNX.4.61.0808162215320.4532@dhcppc2>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
 <1218100464.8625.9.camel@twins>  <1218105597.15342.189.camel@think.oraclecorp.com>
  <877ias66v4.fsf@basil.nowhere.org>  <1218221293.15342.263.camel@think.oraclecorp.com>
  <1218747656.15342.439.camel@think.oraclecorp.com>  <20080814211756.GC13814@one.firstfloor.org>
  <1218763554.15342.460.camel@think.oraclecorp.com>  <20080815013934.GE19125@one.firstfloor.org>
 <1218805256.15342.484.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218805256.15342.484.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Fri, 15 Aug 2008, Chris Mason wrote:

> Ext3 and XFS score somewhere between 10-15MB/s on the same test...

Interesting (and cool animations). 

We tried compilebench (-i 30 -r 0) just for fun using kernel 2.6.26, 
freshly formatted partition, with defaults. Results:

              MB/s    Runtime (s)
             -----    -----------
  ext3       13.24        877
  btrfs      12.33        793
  ntfs-3g     8.55        865
  reiserfs    8.38        966
  xfs         1.88       3901

Regards,
	    Szaka

-- 
NTFS-3G:  http://ntfs-3g.org

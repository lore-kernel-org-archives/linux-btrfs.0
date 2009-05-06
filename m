From: Sander <sander@humilis.net>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Wed, 6 May 2009 17:16:26 +0200
Message-ID: <20090506151625.GA28614@cumulus>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <20090428173401.GC7217@cip.informatik.uni-erlangen.de> <1240940304.15136.27.camel@think.oraclecorp.com> <200904281945.10274.hjclaes@web.de>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Thomas Glanzmann <thomas@glanzmann.de>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Heinz-Josef Claes <hjclaes@web.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200904281945.10274.hjclaes@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

Heinz-Josef Claes wrote (ao):
> Am Dienstag, 28. April 2009 19:38:24 schrieb Chris Mason:
> > On Tue, 2009-04-28 at 19:34 +0200, Thomas Glanzmann wrote:
> > > Hello,
> > >
> > > > I wouldn't rely on crc32: it is not a strong hash,
> > > > Such deduplication can lead to various problems,
> > > > including security ones.
> > >
> > > sure thing, did you think of replacing crc32 with sha1 or md5, is this
> > > even possible (is there enough space reserved so that the change can be
> > > done without changing the filesystem layout) at the moment with btrfs?
> >
> > It is possible, there's room in the metadata for about about 4k of
> > checksum for each 4k of data.  The initial btrfs code used sha256, but
> > the real limiting factor is the CPU time used.
> >
> > -chris
> >
> It's not only cpu time, it's also memory. You need 32 byte for each 4k block. 
> It needs to be in RAM for performance reason.

Less so with SSD I would assume.

-- 
Humilis IT Services and Solutions
http://www.humilis.net

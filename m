From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 13:38:24 -0400
Message-ID: <1240940304.15136.27.camel@think.oraclecorp.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de>
	 <1240839448.26451.13.camel@think.oraclecorp.com>
	 <20090428155900.GA1722@cip.informatik.uni-erlangen.de>
	 <49F728F6.6030307@wpkg.org> <49F73CEF.4030105@gmail.com>
	 <20090428173401.GC7217@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090428173401.GC7217@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-04-28 at 19:34 +0200, Thomas Glanzmann wrote:
> Hello,
> 
> > I wouldn't rely on crc32: it is not a strong hash,
> > Such deduplication can lead to various problems,
> > including security ones.
> 
> sure thing, did you think of replacing crc32 with sha1 or md5, is this
> even possible (is there enough space reserved so that the change can be
> done without changing the filesystem layout) at the moment with btrfs?

It is possible, there's room in the metadata for about about 4k of
checksum for each 4k of data.  The initial btrfs code used sha256, but
the real limiting factor is the CPU time used.

-chris



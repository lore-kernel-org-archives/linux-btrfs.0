From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Hot topics for the next release
Date: Wed, 06 Aug 2008 16:53:24 -0400
Message-ID: <1218056004.15342.164.camel@think.oraclecorp.com>
References: <1218032511.15342.73.camel@think.oraclecorp.com>
	 <4899C64C.2040107@hp.com> <1218040611.15342.92.camel@think.oraclecorp.com>
	 <489A0B4E.6010809@hp.com> <1218055384.15342.160.camel@think.oraclecorp.com>
	 <489A0E73.8050101@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: jim owens <jowens@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Joe Peterson <lavajoe@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <489A0E73.8050101@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-08-06 at 14:49 -0600, Joe Peterson wrote:
> >> Chris Mason wrote:
> >>
> >>> Josef's allocator fix is on the list because we currently fall over in
> >>> some workloads at 100% cpu time when the FS is 60% full.
> 
> Chris, does it oops, or just get very slow?  Does 0.15 do the same?
> 

Very very slow and v0.15 has the same feature.  This doesn't happen
every time you hit 60% full, it varies with the workload.

-chris



From: Joe Peterson <lavajoe@gentoo.org>
Subject: Re: Hot topics for the next release
Date: Wed, 06 Aug 2008 14:49:55 -0600
Message-ID: <489A0E73.8050101@gentoo.org>
References: <1218032511.15342.73.camel@think.oraclecorp.com>	 <4899C64C.2040107@hp.com> <1218040611.15342.92.camel@think.oraclecorp.com>	 <489A0B4E.6010809@hp.com> <1218055384.15342.160.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: jim owens <jowens@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218055384.15342.160.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

>> Chris Mason wrote:
>>
>>> Josef's allocator fix is on the list because we currently fall over in
>>> some workloads at 100% cpu time when the FS is 60% full.

Chris, does it oops, or just get very slow?  Does 0.15 do the same?

	-Joe

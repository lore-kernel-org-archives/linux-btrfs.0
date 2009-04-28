From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 22:16:19 +0200
Message-ID: <20090428201619.GK7217@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <20090428173401.GC7217@cip.informatik.uni-erlangen.de> <1240940304.15136.27.camel@think.oraclecorp.com> <200904281945.10274.hjclaes@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Heinz-Josef Claes <hjclaes@web.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200904281945.10274.hjclaes@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Heinz,

> It's not only cpu time, it's also memory. You need 32 byte for each 4k
> block.  It needs to be in RAM for performance reason.

exactly and that is not going to scale.

        Thomas

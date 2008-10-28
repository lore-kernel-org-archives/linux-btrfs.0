From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Compressed Filesystem
Date: Tue, 28 Oct 2008 11:47:27 -0400
Message-ID: <1225208847.6448.172.camel@think.oraclecorp.com>
References: <20081027145401.GB10896@tux64-03>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, balajirrao@gmail.com,
	miguel.filipe@gmail.com
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081027145401.GB10896@tux64-03>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-10-27 at 10:54 -0400, Lee Trager wrote:
> I have read on the mailing list that there has been some interest in
> implementing transparent compression on btrfs and I too am thinking about
> trying to implement it. Before I start from scratch I am wondering if
> anyone else has started to work on this and if so how far along have
> they gotten? I would be happy to work on this alone or with someone else
> but currently I am doing some preliminary research.

Compression is working on my machine, I'm just running some long tests
before I push it out to the unstable repo.  The current code uses the
in-kernel zlib implementation.

-chris



From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Compressed Filesystem
Date: Tue, 28 Oct 2008 13:38:37 -0400
Message-ID: <1225215517.6448.176.camel@think.oraclecorp.com>
References: <20081027145401.GB10896@tux64-03>
	 <1225208847.6448.172.camel@think.oraclecorp.com>
	 <20081028163337.GA8488@tux64-02>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, balajirrao@gmail.com,
	miguel.filipe@gmail.com
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081028163337.GA8488@tux64-02>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-10-28 at 12:33 -0400, Lee Trager wrote:
> On Tue, Oct 28, 2008 at 11:47:27AM -0400, Chris Mason wrote:
> > On Mon, 2008-10-27 at 10:54 -0400, Lee Trager wrote:
> > > I have read on the mailing list that there has been some interest in
> > > implementing transparent compression on btrfs and I too am thinking about
> > > trying to implement it. Before I start from scratch I am wondering if
> > > anyone else has started to work on this and if so how far along have
> > > they gotten? I would be happy to work on this alone or with someone else
> > > but currently I am doing some preliminary research.
> > 
> > Compression is working on my machine, I'm just running some long tests
> > before I push it out to the unstable repo.  The current code uses the
> > in-kernel zlib implementation.
> > 
> > -chris
> >
> 
> Thats great I am eager to try it. How long will these tests take? I
> would love to look at the code.  Is compression done for every file by
> default or does a user space program have to set a compression flag on
> the file?

This is a fairly large change, I plan on running it overnight.

Compression is optional and off by default (mount -o compress to enable
it).  When enabled, every file is compressed.

-chris



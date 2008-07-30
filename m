From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Add compability for kernels >=2.6.27-rc1
Date: Wed, 30 Jul 2008 16:43:42 -0400
Message-ID: <1217450622.20239.32.camel@think.oraclecorp.com>
References: <alpine.LNX.1.10.0807302100500.2294@titan.stealer.net>
	 <20080730195628.GP20055@kernel.dk>
	 <1217448700.20239.30.camel@think.oraclecorp.com>
	 <20080730201333.GR20055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Sven Wegener <sven.wegener@stealer.net>,
	linux-btrfs@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080730201333.GR20055@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-07-30 at 22:13 +0200, Jens Axboe wrote:

[ rcu page cache ]

> > > For btrfs's usage, it should be safe with a simple rcu_read_lock(), if
> > > the return is referenced safely.
> > > 
> > 
> > This btrfs code is basically a find_get_page without the get.  It should
> > only be called when I know I already have a reference on the page.
> 
> Then it's definitely safe ;-)
> 

Yeah, I'm testing on the latest git now and it all seems ok.  I'll push
this out, thanks Sven.

-chris



From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Add compability for kernels >=2.6.27-rc1
Date: Thu, 31 Jul 2008 20:52:54 +0100
Message-ID: <1217533974.3454.296.camel@pmac.infradead.org>
References: <alpine.LNX.1.10.0807302100500.2294@titan.stealer.net>
	 <20080730195628.GP20055@kernel.dk>
	 <1217448700.20239.30.camel@think.oraclecorp.com>
	 <20080730201333.GR20055@kernel.dk>
	 <1217450622.20239.32.camel@think.oraclecorp.com>
	 <1217532421.3454.291.camel@pmac.infradead.org>
	 <1217533058.20239.62.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Sven Wegener <sven.wegener@stealer.net>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1217533058.20239.62.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-07-31 at 15:37 -0400, Chris Mason wrote:
> If you can reliably reproduce this, please try with the spin locks
> instead of rcu read locks.  What were you doing at the time?

Just copying a bunch of files into it so that I could test NFS
readdirplus with the following:
	http://git.infradead.org/users/dwmw2/nfsexport-2.6.git
	http://git.infradead.org/users/dwmw2/btrfs-kernel-unstable.git

I'll revert to your version to make 100% sure it wasn't the iget or NFS
patches. And I think I need to update, too.

-- 
dwmw2


From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Wed, 31 Dec 2008 18:19:09 -0500
Message-ID: <1230765549.7538.8.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081231104533.abfb1cf9.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-12-31 at 10:45 -0800, Andrew Morton wrote:
> On Wed, 31 Dec 2008 06:28:55 -0500 Chris Mason <chris.mason@oracle.com> wrote:
> 
> > Hello everyone,
> 
> Hi!
> 
> > I've done some testing against Linus' git tree from last night and the
> > current btrfs trees still work well.
> 
> what's btrfs?  I think I've heard the name before, but I've never
> seen the patches :)

The source is up to around 38k loc, I thought it better to use that http
thing for people who were interested in the code.

There is also a standalone git repo:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable-standalone.git;a=summary

This has only btrfs as a module and would be the fastest way to see
the .c files.  btrfs doesn't have any changes outside of fs/Makefile and
fs/Kconfig

(happy new year ;)

-chris



From: Chris Mason <chris.mason@oracle.com>
Subject: Re: build error on 2.6.27
Date: Mon, 12 Jan 2009 09:35:33 -0500
Message-ID: <1231770933.17356.1.camel@think.oraclecorp.com>
References: <1231752518.6435.205.camel@localhost.localdomain>
	 <200901121131.30372.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: btrfs-devel@oss.oracle.com, Gabor MICSKO <gmicsko@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Christian Hesse <mail@earthworm.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200901121131.30372.mail@earthworm.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-12 at 11:31 +0100, Christian Hesse wrote:
> On Monday 12 January 2009, Gabor MICSKO wrote:
> > Hi,
> >
> > Since commit eecac8a148137ec5c519fc536effce8d6be89ec8
> >
> > ( HEAD is now at eecac8a... Btrfs: drop remaining LINUX_KERNEL_VERSION
> > checks and compat code )
> >
> > btrfs kernel module failed to compile on 2.6.27. Older kernel versions not
> > supported anymore?
> 
> No, older kernel versions are not supported at the moment. This was nessecary 
> for the mainline merge. But as older kernels are planned to be supported down 
> to 2.6.18 (to get btrfs support in Debian Etch and RHEL) there will be a 
> solution soon I think.

That's correct.  I'll be fixing up the standalone repo this week to go
back to 2.6.27.  Older versions will take a little while longer.

-chris



From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Mon, 05 Jan 2009 09:35:53 -0500
Message-ID: <1231166153.4290.38.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <1231057922.6497.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Gabor MICSKO <gabor.micsko@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231057922.6497.30.camel@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-01-04 at 09:32 +0100, Gabor MICSKO wrote:
> Hi Chris,
> 
> 
> Does this means that disk format finalised or at least backward
> compatible?
> 

We're making every effort to avoid new disk format changes now (that are
not backward compatible).  Only a critical bug would result in a disk
format change now.

-chris



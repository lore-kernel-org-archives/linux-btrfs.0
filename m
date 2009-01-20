From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs and swap files on SSD's ?
Date: Tue, 20 Jan 2009 08:02:16 -0500
Message-ID: <1232456536.15042.0.camel@think.oraclecorp.com>
References: <200901171110.22803.chris@csamuel.org>
	 <1232382162.6521.108.camel@think.oraclecorp.com>  <4975AA6C.8@schleiser.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Kaspar Schleiser <kaspar@schleiser.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4975AA6C.8@schleiser.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-20 at 11:41 +0100, Kaspar Schleiser wrote:
> Hey Cris,
> 
> Chris Mason wrote:
> > This doesn't quite play nicely with btrfs and should lead to all kinds
> > of problems....I'm looking into how to disable swapfiles completely.
> Please try to support swapfiles. I know their drawbacks and still use 
> them quite often.

There are patches to support swap over NFS that might make it safe to
use on btrfs. At any rate, it is a fixable problem.

But today, swapfiles on btrfs will corrupt other file data.

-chris



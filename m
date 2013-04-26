Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:42040 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab3DZS1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 14:27:47 -0400
Date: Fri, 26 Apr 2013 11:27:46 -0700
From: Zach Brown <zab@zabbo.net>
To: dsterba@suse.cz, Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: various abort cleanups
Message-ID: <20130426182746.GN25389@lenny.home.zabbo.net>
References: <1366912087-4146-1-git-send-email-jbacik@fusionio.com>
 <20130426130542.GN16427@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130426130542.GN16427@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 26, 2013 at 03:05:42PM +0200, David Sterba wrote:
> On Thu, Apr 25, 2013 at 01:48:07PM -0400, Josef Bacik wrote:
> > +	printk(KERN_ERR "release %Lu for %p\n", trans->bytes_reserved, trans);
> 
> for (i=0; i<100; i++)
> 	say "printing u64 type requires typecast to unsigned long long"

also:

for (i=0; i<100; i++)
	do "build with -m32 before sending"

- z

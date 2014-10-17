Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40521 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaJQIaD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 04:30:03 -0400
Date: Fri, 17 Oct 2014 16:29:36 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Subject: Re: unexplainable corruptions 3.17.0
Message-ID: <20141017082935.GC3604@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20141016091726.GA582640@mother.pipebreaker.pl>
 <20141017080202.GA3604@localhost.localdomain>
 <20141017081009.GC582640@mother.pipebreaker.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141017081009.GC582640@mother.pipebreaker.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 17, 2014 at 10:10:09AM +0200, Tomasz Torcz wrote:
> On Fri, Oct 17, 2014 at 04:02:03PM +0800, Liu Bo wrote:
> > >   Recently I've observed some corruptions to systemd's journal
> > > files which are somewhat puzzling. This is especially worrying
> > > as this is btrfs raid1 setup and I expected auto-healing.
> > > 
> > >   System details: 3.17.0-301.fc21.x86_64
> > > btrfs: raid1 over 2x dm-crypted 6TB HDDs.
> > > mount opts: rw,relatime,seclabel,compress=lzo,space_cache
> > >   Reads with cat, hexdump fails with:
> > > read(4, 0x1001000, 65536)               = -1 EIO (Input/output error)
> > > 
> > Does scrub work for you?
> 
>   As there seem to be no way to scrub individual files, I've started
> scrub of full volume.  It will take some hours to finish.
> 
>   Meanwhile, could you satisfy my curiosity what would scrub do that
> wouldn't be done by just reading the whole file?

(Hugo has answered that in this thread.)

Well..I don't know exactly what's the cause, but as the file is NOCOW, it writes
data in place, have you experienced a hard reboot or something recently?

And any message in dmesg log while getting EIO by reading the file?

thanks,
-liubo

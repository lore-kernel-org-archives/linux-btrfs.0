Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:50328 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab2FZKRT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 06:17:19 -0400
Date: Tue, 26 Jun 2012 12:17:12 +0200
From: David Sterba <dave@jikos.cz>
To: Xavier Nicollet <nicollet@jeru.org>
Cc: Dmitry MiksIr <miksir@maker.ru>, linux-btrfs@vger.kernel.org
Subject: Re: how to cleanup old superblock
Message-ID: <20120626101712.GP28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <jsafma$896$1@dough.gmane.org>
 <20120625224900.GN28144@twin.jikos.cz>
 <20120626085324.GC16957@jeru.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20120626085324.GC16957@jeru.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 10:53:24AM +0200, Xavier Nicollet wrote:
> Le 26 June 2012 ? 00:49, David Sterba a écrit:
> > On Mon, Jun 25, 2012 at 11:54:50PM +0400, Dmitry MiksIr wrote:
> > > Hello!
> > > Long time ago I created btrfs on /dev/sda
> > > After some changes btrfs moved to /dev/sda1 (well, to md, and sda1 is part
> > > of md).
> > > 
> > > As result, <btrfs fi show> show me 2 filesystems: new one and old one.
> > > Probably I need to do some cleaning. Can someone tell me what to do.
> > 
> > quick aid is to run this command:
> > 
> > dd if=/dev/zero of=/dev/sda bs=1k count=4 seek=64
> > 
> > (deletes just the btrfs superblock and will not touch anything
> > else)
> 
> Updated the wiki: 
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_to_clean_up_old_superblock_.3F

Thanks. I redid the calculations and the statement that it 'will not
touch anything else' may not be correct in rare cases.

Depends where the first partition starts. If it's at sector 63, like
fdisk created by default in the past, overwriting the offset 64k
(relative to /dev/sda) is actually

offset = 64*1024 - 63*512 = 33280

relative to /dev/sda1.

If there are metadata (eg. raid, other fs) at this offset, then it can
cause problems. For safety reasons, a btrfs filesystem does not touch
first megabyte for allocations, so this does not clash. I'm not sure
about md-raid, but if the sda:64k block is used, then it would be
overwritten anyway.

Newer fdisks start the first partition at 1M, so it's safe.

Wiki page updated.

For the reference - this feature belongs to progs, discussed here
http://thread.gmane.org/gmane.comp.file-systems.btrfs/17065


david

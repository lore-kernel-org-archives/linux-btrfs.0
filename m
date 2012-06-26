Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from jeru.org ([195.216.214.75]:52862 "EHLO jeru.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab2FZI7O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 04:59:14 -0400
Date: Tue, 26 Jun 2012 10:53:24 +0200
From: Xavier Nicollet <nicollet@jeru.org>
To: Dmitry MiksIr <miksir@maker.ru>, linux-btrfs@vger.kernel.org
Subject: Re: how to cleanup old superblock
Message-ID: <20120626085324.GC16957@jeru.org>
Reply-To: nicollet@jeru.org
References: <jsafma$896$1@dough.gmane.org>
 <20120625224900.GN28144@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <20120625224900.GN28144@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 26 June 2012 ? 00:49, David Sterba a écrit:
> On Mon, Jun 25, 2012 at 11:54:50PM +0400, Dmitry MiksIr wrote:
> > Hello!
> > Long time ago I created btrfs on /dev/sda
> > After some changes btrfs moved to /dev/sda1 (well, to md, and sda1 is part
> > of md).
> > 
> > As result, <btrfs fi show> show me 2 filesystems: new one and old one.
> > Probably I need to do some cleaning. Can someone tell me what to do.
> 
> quick aid is to run this command:
> 
> dd if=/dev/zero of=/dev/sda bs=1k count=4 seek=64
> 
> (deletes just the btrfs superblock and will not touch anything
> else)

Updated the wiki: 
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_to_clean_up_old_superblock_.3F

-- 
Xavier Nicollet

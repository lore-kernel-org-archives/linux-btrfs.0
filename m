Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:48079 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124Ab2GBWsl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 18:48:41 -0400
Date: Mon, 2 Jul 2012 15:48:33 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Ilya Dryomov <idryomov@gmail.com>
cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: no dev_stats entry found / OK on first mount after mkfs
In-Reply-To: <20120702224112.GA9555@zambezi.lan>
Message-ID: <alpine.DEB.2.01.1207021544290.5568@trent.utfs.org>
References: <alpine.DEB.2.01.1207021441450.5568@trent.utfs.org> <20120702224112.GA9555@zambezi.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 3 Jul 2012 at 01:41, Ilya Dryomov wrote:
> > after upgrading from 3.4.0 to 3.5.0-rc5 on this powerpc machine, the 
> > following is printed during bootup:
> > 
> >   [   18.630750] device fsid ce8c9df5-0a93-47c6-adf6-25084f352a4f devid 1 transid 11061 /dev/hda7
> >   [   18.637193] btrfs: disk space caching is enabled
> >   [   18.706423] btrfs: no dev_stats entry found for device /dev/hda7 (devid 1) (OK on first mount after mkfs)
> > 
> > The btrfs on hda7 has been created many months ago and has been mounted 
> > several times since then. Assuming "first mount after mkfs" does not apply 
> > here, is it then NOT OK that no dev_stats entry has been found?
> > 
> > IOW: should I worry about this message?
> 
> No, you should not.  If this is your first mount after upgrading your
> kernel to the one with btrfs dev stats feature, "first mount after mkfs"
> sort of applies.

OK, this is what I'd hoped for :-) Maybe the message should read "OK on 
first mount after mkfs or kernel upgrade" - but then again nobody else got 
worried, so the current message is OK, I guess.

Thanks for replying,
Christian.
-- 
BOFH excuse #332:

suboptimal routing experience

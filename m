Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34739 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab2FRM3D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 08:29:03 -0400
Date: Mon, 18 Jun 2012 14:28:57 +0200
From: David Sterba <dave@jikos.cz>
To: Andrei Popa <ierdnah@gmail.com>
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org, arnd@arndnet.de
Subject: Re: [PATCH] Btrfs: add "nocompress" mount option
Message-ID: <20120618122857.GZ32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1339754209.2212.22.camel@ierdnac-hp>
 <20120615105006.GV32402@twin.jikos.cz>
 <1339770469.24514.22.camel@ierdnac-hp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339770469.24514.22.camel@ierdnac-hp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2012 at 05:27:49PM +0300, Andrei Popa wrote:
> On Fri, 2012-06-15 at 12:50 +0200, David Sterba wrote:
> >   mount -o compress,nocompress /dev /mnt
> > 
> > Is it on or off? Yeah we can document that nocompress has higher
> > priority. But then I can't turn a nocompress option back to compress via
> > remount. This is possible with Arnd's patch.
> 
> This happens for space_cache mount option:
> ierdnac-hp ~ # mount -o remount,space_cache,nospace_cache /mnt/btrfs/
> 
> Also there are mount option that can't be enabled/disabled by remount
> like:
> nobarrier - > "barrier" mount option doesn't exists
> ssd -> "nossd" doesn't exists
> noacl, user_subvol_rm_allowed, autodefrag, inode_cache, check_int,
> check_int_data.

I'm not against having options with a simple 'no' prefix, but it seems
more fit for a "on/off" type of options, like ssd/nossd. The compression
takes more values.

> For some of these(ex: nossd,barrier) I think it would be usefull to have
> the reverse action.
> What do you think ?

The style of mount options seems to

* have sane defaults
* not listed in mount options
* have reverting counterparts (when applicable)

These are more recommendations than some hard rules, as eg. space_cache
is default, but listed in mount options, and I don't find this harmful.


david

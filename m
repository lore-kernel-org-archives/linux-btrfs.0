Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32696 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbaIPOkZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 10:40:25 -0400
Date: Tue, 16 Sep 2014 22:40:12 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BUG_ON spams /var/log/messages with the same msg full
Message-ID: <20140916142810.GA4589@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <5400ECBC.5090301@gmx.de>
 <20140901134124.GA18252@localhost.localdomain>
 <5414577C.2030409@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5414577C.2030409@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 13, 2014 at 04:41:00PM +0200, Toralf Förster wrote:
> On 09/01/2014 03:41 PM, Liu Bo wrote:
> > I believe that this warning of btrfs_evict_inode also comes from a result of
> > lseek, and Chris said that he's prepared a fix for that, so it's queued in the
> > next version.
> > 
> > thanks,
> > -liubo
> 
> So rather fixed in -rc6 because v3.17-rc4-337-gfc486b0 still suffers from this issue ?

Sorry for the trouble.
I think I might misunderstand his words, so I just sent a real fix instead.

thanks,
-liubo

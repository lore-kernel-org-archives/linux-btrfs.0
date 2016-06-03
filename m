Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:32809 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbcFCSmm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 14:42:42 -0400
Received: by mail-io0-f181.google.com with SMTP id t40so83571705ioi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 11:42:41 -0700 (PDT)
Message-ID: <1464979359.1571.25.camel@gmail.com>
Subject: Re: RAID1 vs RAID10 and best way to set up 6 disks
From: Mitchell Fossen <msfossen@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Date: Fri, 03 Jun 2016 13:42:39 -0500
In-Reply-To: <1464977591.6679.13.camel@scientia.net>
References: <1464977432.1571.20.camel@gmail.com>
	 <1464977591.6679.13.camel@scientia.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for pointing that out, so if I'm thinking correctly, with RAID1
it's just that there is a copy of the data somewhere on some other
drive.

With RAID10, there's still only 1 other copy, but the entire "original"
disk is mirrored to another one, right?

On Fri, 2016-06-03 at 20:13 +0200, Christoph Anton Mitterer wrote:
> On Fri, 2016-06-03 at 13:10 -0500, Mitchell Fossen wrote:
> > 
> > Is there any caveats between RAID1 on all 6 vs RAID10?
> Just to be safe: RAID1 in btrfs means not what RAID1 means in any
> other
> terminology about RAID.
> 
> The former has only two duplicates, the later means full mirroring of
> all devices.
> 
> 
> Cheers,
> Chris.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33937 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965602Ab3FUBMb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 21:12:31 -0400
Date: Fri, 21 Jun 2013 09:12:20 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] Btrfs-progs: exhance btrfs-image to restore image
 onto multiple disks
Message-ID: <20130621011219.GA24706@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
 <1371729930-22497-5-git-send-email-bo.li.liu@oracle.com>
 <20130621011024.4477.64844@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130621011024.4477.64844@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 20, 2013 at 09:10:24PM -0400, Chris Mason wrote:
> Quoting Liu Bo (2013-06-20 08:05:30)
> > This adds a 'btrfs-image -m' option, which let us restore an image that
> > is built from a btrfs of multiple disks onto several disks altogether.
> 
> I'd like to pull this in, could you please rebase it against my current
> master?

Yeah, I'll rebase it now.

thanks,
liubo

> 
> Thanks!
> 
> -chris

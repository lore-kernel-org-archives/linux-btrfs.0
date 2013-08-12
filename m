Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18748 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab3HLCqM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Aug 2013 22:46:12 -0400
Date: Mon, 12 Aug 2013 10:45:55 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs-progs: add dedup subcommand
Message-ID: <20130812024554.GA19701@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1375950946-5470-1-git-send-email-bo.li.liu@oracle.com>
 <1375950946-5470-7-git-send-email-bo.li.liu@oracle.com>
 <20130809125134.GJ5284@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130809125134.GJ5284@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 09, 2013 at 02:51:35PM +0200, David Sterba wrote:
> On Thu, Aug 08, 2013 at 04:35:46PM +0800, Liu Bo wrote:
> > This aims to add deduplication subcommand, 'btrfs dedup command <path>',
> > ie. register/unregister'.
> 
> I'm not sure that calling it register/unregister is the right thing, IMO
> it's more enable/disable as you write in the documentation under each
> respective command.
> 

Both of them are easy to be understood, but let's keep it consistent
with the docs as you suggest :)

> Please post a list of the other commands if there are any, and the
> expected usage.
> 

So far only these two commands are needed, thanks for reviewing this.

-liubo

> thanks,
> david
> 
> > +\fBbtrfs dedup register\fP \fI<path>\fP
> > +Enable data deduplication support for a filesystem.
>    ^^^^^
> 
> > +.TP
> > +
> > +\fBbtrfs dedup unregister\fP \fI<path>\fP
> > +Disable data deduplication support for a filesystem.
>    ^^^^^^^
